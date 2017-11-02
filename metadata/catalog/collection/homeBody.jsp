
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="com.esri.gpt.framework.security.principal.Group"%>
<%@page import="com.esri.gpt.framework.security.principal.Groups"%>
<%@page import="com.esri.gpt.framework.security.identity.IdentityConfiguration"%>
<style>
    .grid td, .grid th{
        line-height: 18px;
    }
    #infovis {
        margin: auto;
        overflow: hidden;
        position: relative;

    }

</style><link rel="stylesheet" href="<%=request.getContextPath()%>/catalog/js/jquery-ui/css/ui-lightness/jquery-ui.css" />
<%@page import="com.innovateteam.gpt.innoCollection"%>
<%@page import="com.innovateteam.gpt.innoHelperFunctions"%>
<%@page import="com.innovateteam.gpt.innoPaging"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%
    String contextPath = request.getContextPath();
    //core models
    innoHelperFunctions hlpObj = new innoHelperFunctions();
    hlpObj.setGptUsers(request);//populates the users from the db to a class var

    innoCollection obj = new innoCollection(RequestContext.extract(request));

    ArrayList current_user_groups = hlpObj.getCurrentUserGroups(request);
    Boolean isAdminUser = hlpObj.isAdminUser(request);
    LinkedHashMap grps = hlpObj.listAllMetadataManagementGroups(request);
    String currentUserPublisherGrp = hlpObj.getCurrentUserPublisherGroupKey(request);
    currentUserPublisherGrp = currentUserPublisherGrp == null ? "-1" : currentUserPublisherGrp;

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
    
    String cur_page = allParameters.containsKey("frm:page") ? allParameters.get("frm:page").toString() : "1";
    HashMap filter = new HashMap();//set the post filters
    if (allParameters.containsKey("name")) {
        filter.put("name_like", allParameters.get("name"));
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
            HashMap data = new HashMap();

            if (allParameters.containsKey("name")) {
                data.put("name", (String) allParameters.get("name"));
            }
            data.put("owner", allParameters.get("owner"));
            data.put("approved", "N");

            if (isAdminUser || current_user_groups.contains(allParameters.get("owner"))) {
                String added = obj.fnAddCollection(data);
                if (added != null) {
                    allParameters.remove("action");
                    out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"successMessage\">Compilation successfully added.</li></ul></span>");
                } else {
                    out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">Compilation could not be added.</li></ul></span>");
                }
                
                 allParameters.put("name", "");
                //set the search filters
                if (allParameters.containsKey("name")) {
                    filter.put("name_like", allParameters.get("name"));
                }
                if (allParameters.containsKey("owner")) {
                    filter.put("owner", allParameters.get("owner"));
                }
            } else {
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">You do not have permission to add Compilation under selected owner.</li></ul></span>");
            }
            cur_page = "1";

        } else if ("delete".equals(allParameters.get("action"))) {
            //delete request
            //check permission first
            String col_id = (String) request.getParameter("col_id");
            Boolean hasDeletePermission = false;

            if (isAdminUser) {
                hasDeletePermission = true;
            }
            if (!hasDeletePermission) {
                HashMap tmp = new HashMap();
                tmp.put("col_id", col_id);
                ResultSet rs = obj.fnListCollection(tmp, null, null);
                if (rs.next()) {
                    hasDeletePermission = current_user_groups.contains(rs.getString("owner"));
                }
            }

            if (hasDeletePermission) {
                String delete_orphaned_virtual_resource = allParameters.get("delete_orphaned_virtual_resource").toString();
                int deleted = obj.fnDeleteCollection(col_id, delete_orphaned_virtual_resource.equals("Y"));
                if (deleted == 1) {
                    allParameters.remove("action");
                    out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"successMessage\">Compilation successfully deleted.</li></ul></span>");
                } else {
                    out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">Compilation could not be deleted.</li></ul></span>");
                }

            } else {
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">You donot have permission to delete this Compilation.</li></ul></span>");
            }

        } else if ("search".equals(allParameters.get("action"))) {

            if (allParameters.containsKey("name")) {
                filter.put("name_like", allParameters.get("name"));
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
<form method="post" action="<%=contextPath%>/catalog/collection/home.page" name="collectionForm">
    <input type="hidden" value="0" name="col_id" id="col_id" />
    <input type="hidden" value="" name="action" id="action" />
    <input type="hidden" value="" name="delete_orphaned_virtual_resource" id="delete_orphaned_virtual_resource" />
    <input type="hidden" value="" name="frm:page" id="frm:page" />
    <input type="hidden" name="frm:focus_field" id="frm:focus_field" value="<%=hlpObj.getValFromMap(allParameters, "frm:focus_field")%>"/>
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:sortField")%>" name="frm:sortField" id="frm:sortField" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:sortDirection")%>" name="frm:sortDirection" id="frm:sortDirection" />
    <table border="0">
        <tr>
            <td style="text-align: right;">Name : </td><td><input type="text" size="50" maxlength="128" value="<%=hlpObj.getValFromMap(allParameters, "name")%>" name="name" id="name" /></td>
            <td style="text-align: right; padding-left: 20px;">Owner : </td><td>
                <select size="1" name="owner" id="owner" <!--onchange="observeChange(this)"-->>	
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
            <td></td><td><input type="button" value="Search" name="Search" id="Search" onclick="doSearch();"/> <input type="button" value="Add" name="Add" id="Add" onclick="addCollection();" /></td>
        </tr>
    </table>
</form>
<%
    int count = 0;


    paging.setTotalRecords(obj.fnListCollectionCount(filter));
    out.print(paging.generateLinks());//print paging links
%>
<table class="grid" cellspacing="0" cellpadding="2">
    <tr>
        <th scope="col"><a <%=hlpObj.getHeadingClass(allParameters, "name")%> href="#" onClick="sortBy('name');">Name</a></th>
        <th scope="col"><a <%=hlpObj.getHeadingClass(allParameters, "owner")%> href="#" onClick="sortBy('owner');">Owner</a></th>
        <th scope="col" style="width: 180px; text-align: center;">Placeholder Record</th>
        <th scope="col" style="width: 60px; text-align: center;"><a <%=hlpObj.getHeadingClass(allParameters, "approved")%> href="#" onClick="sortBy('approved');">Approved</a></th>
        <th scope="col" style="width: 60px; text-align: center;">Manage</th>
        <th scope="col" style="width: 60px; text-align: center;">Edit</th>
        <th scope="col" style="width: 60px; text-align: center;">Delete</th>
    </tr>
    <%
        String className = "";
        ResultSet rs = obj.fnListCollection(filter, offset, limit);

        while (rs.next()) {
            count++;
            if (count % 2 == 1) {
                className = "class=\"rowOdd\"";
            } else {
                className = "class=\"rowEven\"";
            }

            out.print("<tr " + className + ">");
            
            out.print("<td><span id=\"colname_" + rs.getString("col_id") + "\">" + rs.getString("name") + "  </span><img name=\"treeButton\" src=\"" + contextPath + "/catalog/images/chart_organisation.png\" title=\"Compilation visualization\" onclick=\"openTreeChart('" + rs.getString("col_id") + "');\" style=\"cursor:pointer;\" /></td>");
//            out.print("<td>" + rs.getString("name") + " <img name=\"treeButton\" src=\"" + contextPath + "/catalog/images/chart_organisation.png\" title=\"Compilation visualization\" onclick=\"openTreeChart('" + rs.getString("col_id") + "');\" style=\"cursor:pointer;\" /></td>");
            out.print("<td>" + rs.getString("username") + "</td>");
            if (isAdminUser || current_user_groups.contains(rs.getString("owner"))) {
                out.print("<td style=\"text-align: center;\"><button class=\"add_virtual_resource\" col_id=\"" + rs.getString("col_id") + "\">Add</button></td>");
            } else {
                out.print("<td style=\"text-align: center;\"><button class=\"add_virtual_resource\" col_id=\"" + rs.getString("col_id") + "\" disabled=\"disabled\">Add</button></td>");
            }
            if (isAdminUser) {
                out.print("<td style=\"text-align: center;\"><a href=\"#\" onclick=\"changeStatus('" + rs.getString("col_id") + "',this);\">" + rs.getString("approved") + "</a></td>");
            } else {
                out.print("<td style=\"text-align: center;\">" + rs.getString("approved") + "</td>");
            }
            if (isAdminUser || current_user_groups.contains(rs.getString("owner"))) {
                out.print("<td style=\"text-align: center;\"><img title=\"Manage Compilation members\" style=\"cursor: pointer;\" col_id=\"" + rs.getString("col_id") + "\" onclick=\"performAction('manage',this);\" alt=\"Manage\" src=\"" + contextPath + "/catalog/images/members.png\" /></td>");
            } else {
                out.print("<td style=\"text-align: center;\"><img title=\"Manage Compilation members\" col_id=\"" + rs.getString("col_id") + "\" src=\"" + contextPath + "/catalog/images/members_off.png\" /></td>");
            }
            //Added by Netty for editing collection
            if (isAdminUser || current_user_groups.contains(rs.getString("owner"))) {
                out.print("<td style=\"width: 80px; text-align: center;\"><img title=\"Edit\" style=\"cursor: pointer;\" owner=\""+rs.getString("owner")+"\" col_id=\"" + rs.getString("col_id") + "\" class=\"edit_virtual_resource\" alt=\"Edit\" src=\"" + contextPath + "/catalog/images/mmd_edit.gif\" /></td>");
            } else {
                out.print("<td style=\"width: 80px; text-align: center;\"><img title=\"Edit\" src=\"" + contextPath + "/catalog/images/mmd_edit_off.gif\" /></td>");
            }
            if (isAdminUser || current_user_groups.contains(rs.getString("owner"))) {
                out.print("<td style=\"text-align: center;\"><img id=\"delete_" + rs.getString("col_id") + "\" title=\"Delete\" style=\"cursor: pointer;\" col_name=\"" + rs.getString("name") + "\" col_id=\"" + rs.getString("col_id") + "\" onclick=\"performAction('delete',this);\" alt=\"Delete\" src=\"" + contextPath + "/catalog/images/mmd_delete.gif\"></td>");
            } else {
                out.print("<td style=\"text-align: center;\"><img title=\"Delete\" alt=\"Delete\" src=\"" + contextPath + "/catalog/images/mmd_delete_off.gif\"></td>");
            }
            out.print("</tr>");
        }
        if (count == 0) {
    %>
    <tr>
        <td colspan="5" style="text-align:center;"> NO DATA FOUND </td>
    </tr>
    <% }%>
</table>
<%
    out.print(paging.generateLinks());
    obj.closeConnection();
%>

<div id="dialog-form" title="Create new placeholder record">
    <p class="validateTips">All form fields are required.</p>
    <form name="virtual_resource_form">
        <input type="hidden" name="vr_col_id" value="vr_col_id" />
        <input type="hidden" name="vr_owner" value="vr_owner" />
        <table>
            <tr><td style="width:120px; text-align: right;">Resource Name :</td><td><input type="text" name="vr_title" id="vr_title" class="text ui-widget-content ui-corner-all" maxlength="128" /></td></tr>
            <tr><td style="width:120px; text-align: right;">Parent Resource :</td><td><input type="checkbox" checked name="vr_is_parent" id="vr_is_parent" class="text ui-widget-content ui-corner-all" /></td></tr>
        </table>
        <div id="virtual_resource_form_response" style="font-weight: bold;"></div>
    </form>
</div>
<!--Added by Netty-->
<div id="dialog-form-edit" title="Update Compilation">
    <p class="validateEditTips">All form fields are required.</p>
    <form name="virtual_resource_edit_form">
        <input type="hidden" name="vr_col_id" value="vr_col_id" />
        <input type="hidden" name="vr_owner" value="vr_owner" />
        <table>
            <tr><td style="width:50px; text-align: right;">Name :</td><td><input type="text" name="vr_title_name" id="vr_title_name" class="text ui-widget-content ui-corner-all" maxlength="128" /></td></tr>
        </table>
        <div id="virtual_resource_edit_response" style="font-weight: bold;"></div>
    </form>
</div>
<div id="dialog-form-delete" title="Delete Compilation">
    <form name="virtual_resource_delete_form">
        <input type="hidden" name="vr_col_id" value="vr_col_id" />
        <input type="hidden" name="del_virtual_resource" id="del_virtual_resource" value="Y"/>
        <div>Are you sure you want to delete the '<span id="collection-name"></span>' compilation and associated membership information?</div>
        <div>The metadata records will not be deleted.</div>
    </form>
</div>
<div id="dialog-form-member-tree" title="Compilation members">
    <div style="font-weight: bold;">Please pan around if you are unable to see all members of the compilation.</div>
    <div style="clear:both;"></div>
    <div id="infovis"></div>
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
<!--[if IE]><script language="javascript" type="text/javascript" src="../js/Jit/Extras/excanvas.js"></script><![endif]-->
<script type="text/javascript" src="../js/Jit/jit-yc.js"></script>
<script type="text/javascript" src="js/homeBody.js"></script>
 <script>
        highlightCollection();
 </script>
