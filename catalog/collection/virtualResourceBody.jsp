
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.LinkedHashMap"%>
<% String contextPath = request.getContextPath();%>
<%@page import="com.innovateteam.gpt.innoRequestContext"%>
<%@page import="com.esri.gpt.framework.security.principal.User"%>
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="com.innovateteam.gpt.innoCollection"%>
<%@page import="com.innovateteam.gpt.innoHelperFunctions"%>
<%@page import="com.innovateteam.gpt.innoPaging"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>

<style>
    .grid td, .grid th{
        line-height: 18px;
    }
</style><link rel="stylesheet" href="<%=contextPath%>/catalog/js/jquery-ui/css/ui-lightness/jquery-ui.css" />

<%
    //core models
    innoHelperFunctions hlpObj = new innoHelperFunctions();
    innoCollection obj = new innoCollection(RequestContext.extract(request));
    hlpObj.setGptUsers(request);//populates the users from the db to a class var

    //session.setAttribute("user_group", "3");//default user group
    Boolean isAdminUser = hlpObj.isAdminUser(request);
    String currentUserPublisherGrp = hlpObj.getCurrentUserPublisherGroupKey(request);
    LinkedHashMap grps = hlpObj.listAllMetadataManagementGroups(request);
    ArrayList current_user_groups = hlpObj.getCurrentUserGroups(request);
    currentUserPublisherGrp = currentUserPublisherGrp==null?"-1":currentUserPublisherGrp;
    
    HashMap allParameters = new HashMap();
    String key;
    Enumeration postParams = request.getParameterNames();
    while (postParams.hasMoreElements()) {
        key = postParams.nextElement().toString();
        if (request.getParameter(key) != null && request.getParameter(key).toString().trim().length() > 0) {
            allParameters.put(key, (String) request.getParameter(key));
        }
    }
    if (!allParameters.containsKey("owner")) {
            allParameters.put("owner", "-1");
        }
            
    if (allParameters.get("owner").toString().equals("-1")) {
        //when default "ANY" owner is selected then remove it because -1 is just used for checking
        //but not to query against database
        allParameters.remove("owner");
    }

    //if page was refreshed set the parameters from session
    //if ((!(allParameters.containsKey("action") || allParameters.containsKey("added") || allParameters.containsKey("deleted"))) && session.getAttribute("allParameters") != null) {
    //    allParameters = (HashMap) session.getAttribute("allParameters");
    //}
    String cur_page = allParameters.containsKey("frm:page") ? allParameters.get("frm:page").toString() : "1";
    HashMap filter = new HashMap();//set the post filters
    if (allParameters.containsKey("name")) {
        filter.put("title_like", allParameters.get("name"));
    }
    if (allParameters.containsKey("owner")) {
        filter.put("owner", allParameters.get("owner"));
    }
    if (hlpObj.getSortByField(allParameters) != null) {
        filter.put("sortByField", hlpObj.getSortByField(allParameters));
    }
    //handle post request to add a collection
    if (allParameters.containsKey("action")) {
        //add request
        if ("add".equals(allParameters.get("action"))) {
            if (isAdminUser || current_user_groups.contains(allParameters.get("owner"))) {
                innoRequestContext context = new innoRequestContext(request);
                //User user = context.getUser();
                //out.print(user.getKey());
                //user = (User)session.getAttribute("com.esri.gpt.user");
                //out.print(user.getKey());

                String uuid = obj.fnAddInnoVirtualResource(allParameters.get("name").toString(), context, null,allParameters.get("owner").toString());
                if (uuid != "0") {
                    allParameters.remove("action");
                    out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"successMessage\">Placeholder record successfully added.</li></ul></span>");
                } else {
                    out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">Placeholder record could not be added.</li></ul></span>");
                }

                //set the search filters
                if (allParameters.containsKey("name")) {
                    filter.put("name_like", allParameters.get("name"));
                }
                if (allParameters.containsKey("owner")) {
                    filter.put("owner", allParameters.get("owner"));
                }

            }else{
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">You do not have permission to add placeholder record under selected owner.</li></ul></span>");
            }

            cur_page = "1";

        } else if ("delete".equals(allParameters.get("action"))) {
            //delete request
            String docuuid = (String) request.getParameter("docuuid");
            int deleted = obj.fnDeleteInnoVirtualResource(docuuid);

            if (deleted > 0) {
                allParameters.remove("action");
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"successMessage\">Placeholder record successfully deleted.</li></ul></span>");
            } else {
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">Placeholder record could not be deleted.</li></ul></span>");
            }

        } else if ("search".equals(allParameters.get("action"))) {
            if (allParameters.containsKey("name")) {
                filter.put("title_like", allParameters.get("name"));
            }
            if (allParameters.containsKey("owner")) {
                filter.put("owner", allParameters.get("owner"));
            }
            cur_page = "1";
        }


    }

    session.setAttribute("allParameters", allParameters);
    //paging stuff
    HashMap tmp = new HashMap();
    //tmp.put("records_per_page", "5");
    innoPaging paging = new innoPaging(tmp);
    paging.setCurrentPage(cur_page);
    int offset = paging.getOffset(), limit = paging.getLimit();

%>
<form method="post" action="<%=contextPath%>/catalog/collection/placeholderRecord.page" name="collectionForm">
    <input type="hidden" value="0" name="docuuid" id="docuuid" />
    <input type="hidden" value="" name="action" id="action" />
    <input type="hidden" value="" name="frm:page" id="frm:page" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:sortField")%>" name="frm:sortField" id="frm:sortField" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:sortDirection")%>" name="frm:sortDirection" id="frm:sortDirection" />

    <table border="0">
        <tr>
            <td style="text-align: right;">Name : </td><td><input type="text" size="50" maxlength="128" value="<%=hlpObj.getValFromMap(allParameters, "name")%>" name="name" id="name" /></td>
            <td style="text-align: right; padding-left: 20px;">Owner : </td><td>
                <select size="1" name="owner" id="owner">	
                    <option value="-1">Any</option>
                    <%
                        Set s = grps.keySet();
                        Iterator it = s.iterator();
                        String grpKey = null, selected = "";
                        while (it.hasNext()) {
                            grpKey = it.next().toString();
                            if (hlpObj.getValFromMap(allParameters, "owner").equals(grpKey)) {
                                selected = "selected=\"selected\"";
                            } else {
                                selected = "";
                            }
                            out.print("<option value=\"" + grpKey + "\" " + selected + ">" + grps.get(grpKey) + "</option>");
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td></td><td><input type="submit" value="Search" name="Search" id="Search" onclick="this.form.action.value='search';"/> <input type="button" value="Add" name="Add" id="Add" onclick="addResource();" /></td>
        </tr>
    </table>
</form>
<%
    int count = 0;
    paging.setTotalRecords(obj.fnListVirtualResourceCount(filter));
    out.print(paging.generateLinks());//print paging links
%>
<table class="grid" cellspacing="0" cellpadding="2">
    <tr>
        <th scope="col"><a <%=hlpObj.getHeadingClass(allParameters, "title")%> href="#" onClick="sortBy('title');">Name</a></th>
        <th scope="col"><a <%=hlpObj.getHeadingClass(allParameters, "username")%> href="#" onClick="sortBy('username');">Owner</a></th>
        <th scope="col" style="width: 80px;"><a <%=hlpObj.getHeadingClass(allParameters, "resource_role")%> href="#" onClick="sortBy('resource_role');">Role</a></th>
        <th scope="col" style="width: 80px; text-align: center;">Edit</th>
        <th scope="col" style="width: 80px; text-align: center;">Delete</th>
    </tr>
    <%
        String className = "";

        ResultSet rs = obj.fnListVirtualResource(filter, offset, limit);
        while (rs.next()) {
            count++;
            className = (count % 2 == 1) ? "class=\"rowOdd\"" : "class=\"rowEven\"";

            out.print("<tr " + className + ">");
            out.print("<td><div id=\"title_" + rs.getString("docuuid") + "\">" + rs.getString("title") + "</div></td>");
            out.print("<td>" + rs.getString("username") + "</td>");
            out.print("<td><a href=\"#\" onclick=\"openDetails('" + rs.getString("resource_role") + "','" + rs.getString("docuuid") + "')\">" + rs.getString("resource_role") + "</a></td>");
            if (isAdminUser || current_user_groups.contains(rs.getString("owner"))) {
                out.print("<td style=\"width: 80px; text-align: center;\"><img title=\"Edit\" style=\"cursor: pointer;\" owner=\""+rs.getString("owner")+"\" docuuid=\"" + rs.getString("docuuid") + "\" class=\"edit_virtual_resource\" alt=\"Edit\" src=\"" + contextPath + "/catalog/images/mmd_edit.gif\" /></td>");
            } else {
                out.print("<td style=\"width: 80px; text-align: center;\"><img title=\"Edit\" src=\"" + contextPath + "/catalog/images/mmd_edit_off.gif\" /></td>");
            }

            if (isAdminUser || current_user_groups.contains(rs.getString("owner"))) {
                out.print("<td style=\"width: 80px; text-align: center;\"><img title=\"Delete\" style=\"cursor: pointer;\" docuuid=\"" + rs.getString("docuuid") + "\" onclick=\"performAction('delete',this);\" alt=\"Delete\" src=\"" + contextPath + "/catalog/images/mmd_delete.gif\"></td>");
            } else {
                out.print("<td style=\"width: 80px; text-align: center;\"><img title=\"Delete\" alt=\"Delete\" src=\"" + contextPath + "/catalog/images/mmd_delete_off.gif\"></td>");
            }
            out.print("</tr>");
        }
        if (count == 0) {
            out.print("<tr><td colspan=\"5\" style=\"text-align:center;\"> NO DATA FOUND </td></tr>");
        }%>
</table>
<% out.print(paging.generateLinks());
obj.closeConnection();
%>
<div id="dialog-form" title="Update placeholder record">
    <p class="validateTips">All form fields are required.</p>
    <form name="virtual_resource_form">
        <input type="hidden" name="vr_docuuid" value="vr_docuuid" />
        <input type="hidden" name="vr_owner" value="vr_owner" />
        <table>
            <tr><td style="width:50px; text-align: right;">Name :</td><td><input type="text" name="vr_title" id="vr_title" class="text ui-widget-content ui-corner-all" maxlength="128" /></td></tr>
        </table>
        <div id="virtual_resource_form_response" style="font-weight: bold;"></div>
    </form>
</div>
<script>var contextPath = "<%=contextPath%>";</script>
<script type="text/javascript" src="../js/jquery-ui/js/jquery.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/jquery-ui.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.button.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/ui/jquery.effects.core.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="js/virtualResourceBody.js"></script>