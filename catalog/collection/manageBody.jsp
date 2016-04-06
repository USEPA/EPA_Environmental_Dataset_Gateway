
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<style>
    .grid td, .grid th{
        line-height: 18px;
    }
</style><link rel="stylesheet" href="<%=request.getContextPath()%>/catalog/js/jquery-ui/css/ui-lightness/jquery-ui.css" />
<%@page import="java.util.Enumeration"%>
<%@page import="com.innovateteam.gpt.innoCollection"%>
<%@page import="com.innovateteam.gpt.innoHelperFunctions"%>
<%@page import="com.innovateteam.gpt.innoPaging"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="java.util.LinkedHashMap"%>
<%
    String contextPath = request.getContextPath();
    innoCollection obj = new innoCollection(RequestContext.extract(request));
    innoHelperFunctions hlpObj = new innoHelperFunctions();
    hlpObj.setGptUsers(request);
    LinkedHashMap grps = hlpObj.listAllMetadataManagementGroups(request);
    HashMap allParameters = new HashMap();
    ArrayList current_user_groups = hlpObj.getCurrentUserGroups(request);

    String key;
    Enumeration postParams = request.getParameterNames();
    while (postParams.hasMoreElements()) {
        key = postParams.nextElement().toString();
        if (request.getParameter(key) != null && request.getParameter(key).toString().trim().length() > 0) {
            allParameters.put(key, request.getParameter(key).toString().trim());
        }
    }
    if (allParameters.containsKey("mmdOwnerAdmin")) {
        if ("-1".equals(allParameters.get("mmdOwnerAdmin").toString())) {
            allParameters.remove("mmdOwnerAdmin");
        }
    }
    if (request.getParameter("setCollection") != null) {
        allParameters.put("frm:col_id", request.getParameter("setCollection"));
    }
    if (!allParameters.containsKey("frm:col_id")) {
        if (session.getAttribute("frm:col_id") == null) {
            //response.sendRedirect just didn't work for me - don't know why
            out.write("<script type=\"text/javascript\">window.location = \"" + contextPath + "/catalog/collection/home.page\";</script>");
        }
        allParameters.put("frm:col_id", session.getAttribute("frm:col_id"));
    }
    session.setAttribute("frm:col_id", allParameters.get("frm:col_id"));

    //check if the collection id is set or else set it from session

    ResultSet rs = null;
    HashMap filter = new HashMap();
    if (request.getParameter("mmdUuid") != null) {
        filter.put("docuuid", (String) request.getParameter("mmdUuid"));
    }
    if (request.getParameter("mmdTitle") != null) {
        filter.put("title_like", (String) request.getParameter("mmdTitle"));
    }
    if (allParameters.containsKey("mmdOwnerAdmin")) {
        filter.put("owner", (String) allParameters.get("mmdOwnerAdmin"));
    }
    if (hlpObj.getSortByField(allParameters) != null) {
        filter.put("sortByField", hlpObj.getSortByField(allParameters));
    }
    if (request.getParameter("mmdCurrentMemebersOnly") != null && request.getParameter("frm:col_id") != null) {
        filter.put("current_members_only", (String) request.getParameter("frm:col_id"));
    }
    if (request.getParameter("setCollection") != null) {
        //inititally set "Only display current members"
        filter.put("current_members_only", "Y");
        allParameters.put("mmdCurrentMemebersOnly", "Y");
    }
    filter.put("approvalstatus", "approved");

    //check if collection was set
    if (allParameters.containsKey("frm:action")) {
        //handle collection change
        if ("search".equals(allParameters.get("frm:action").toString())) {
            String parent = "", child = "", col_id = allParameters.get("frm:col_id").toString();
            ResultSet col = obj.fnListCollectionMember(col_id);
            while (col.next()) {
                if (parent == "") {
                    parent = col.getString("docuuid");
                    if (col.getString("docuuid") == null) {
                        parent = "";
                    }
                }
                if (col.getString("child_docuuid") != null) {
                    child += col.getString("child_docuuid") + ",";
                }
            }
            allParameters.put("frm:parent_docuuid", parent);
            allParameters.put("frm:child_docuuid", child);
        } //add/update collection members
        else if ("save".equals(allParameters.get("frm:action").toString())) {

            HashMap params = new HashMap();
            params.put("docuuid", hlpObj.getValFromMap(allParameters, "frm:parent_docuuid"));
            params.put("child_docuuids", hlpObj.getValFromMap(allParameters, "frm:child_docuuid"));

            params.put("owner", hlpObj.getCurrentUserID(request));
            params.put("col_id", allParameters.get("frm:col_id").toString());
            params.put("role", "parent-child");
            int deleted = obj.fnDeleteCollectionMember(params.get("col_id").toString());
            int success = obj.fnAddCollectionMember(params);
            obj.fnAutoApproveCollection(allParameters.get("frm:col_id").toString(), current_user_groups);
            if (success == -1) {
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"errorMessage\">We encountered an error while performing the operation.</li></ul></span>");
            } else if (success > 0) {
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"successMessage\">Members added/updated successfully.</li></ul></span>");
            } else {
                out.print("<span id=\"cmPlPgpGptMessages\"><ul id=\"cmPlMsgsPageMessages\"><li class=\"successMessage\">No members were added or updated.</li></ul></span>");
            }

            int parentCount = 0, childCount = 0;
            String parent = "", child = "", col_id = allParameters.get("frm:col_id").toString();
            ResultSet col = obj.fnListCollectionMember(col_id);
            while (col.next()) {
                if (parent == "") {
                    parent = col.getString("docuuid");
                    if (parent == "null" || parent == null) {
                        parent = "";
                    } else {
                        parentCount++;
                    }
                }
                if (col.getString("child_docuuid") != null) {
                    child += col.getString("child_docuuid") + ",";
                    childCount++;
                }
            }
            allParameters.put("frm:parent_docuuid", parent);
            allParameters.put("frm:child_docuuid", child);
            allParameters.put("frm:col_id", col_id.trim());
            allParameters.put("frm:parent_count", parentCount);
            allParameters.put("frm:child_count", childCount);

        }
    } else {
        int parentCount = 0, childCount = 0;
        String parent = "", child = "", col_id = allParameters.get("frm:col_id").toString();
        ResultSet col = obj.fnListCollectionMember(col_id);
        while (col.next()) {
            if (parent == "") {
                parent = col.getString("docuuid");
                if (parent == "null" || parent == null) {
                    parent = "";
                } else {
                    parentCount++;
                }
            }
            if (col.getString("child_docuuid") != null) {
                child += col.getString("child_docuuid") + ",";
                childCount++;
            }
        }
        allParameters.put("frm:parent_docuuid", parent);
        allParameters.put("frm:child_docuuid", child);
        allParameters.put("frm:col_id", col_id.trim());
        allParameters.put("frm:parent_count", parentCount);
        allParameters.put("frm:child_count", childCount);
    }



%>
<form method="post" action="<%=contextPath%>/catalog/collection/manage.page" name="collection.manage">
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:parent_count")%>" name="frm:parent_count" id="frm:parent_count" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:child_count")%>" name="frm:child_count" id="frm:child_count" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:col_id")%>" name="frm:col_id" id="frm:col_id" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:parent_docuuid")%>" name="frm:parent_docuuid" id="frm:parent_docuuid" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:child_docuuid")%>" name="frm:child_docuuid" id="frm:child_docuuid" />
    <input type="hidden" value="" name="frm:action" id="frm:action" />
    <input type="hidden" value="1" name="frm:page" id="frm:page" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:sortField")%>" name="frm:sortField" id="frm:sortField" />
    <input type="hidden" value="<%=hlpObj.getValFromMap(allParameters, "frm:sortDirection")%>" name="frm:sortDirection" id="frm:sortDirection" />

    <table border="0">
        <tr>
            <td style="text-align: right;">Document title : </td><td><input type="text" size="50" maxlength="128" value="<%=hlpObj.getValFromMap(allParameters, "mmdTitle")%>" name="mmdTitle" id="mmdTitle" /></td>
        </tr>
        <tr>
            <td style="text-align: right;">Document UUID : </td><td><input type="text" size="50" maxlength="128" value="<%=hlpObj.getValFromMap(allParameters, "mmdUuid")%>" name="mmdUuid" id="mmdUuid"/></td>
        </tr>
        <tr>
            <td style="text-align: right;">Document owner : </td><td>
                <select size="1" name="mmdOwnerAdmin" id="mmdOwnerAdmin" >	
                    <option value="-1">Any</option>
                    <%

                        Set s = grps.keySet();
                        Iterator it = s.iterator();
                        String grpKey = null, selected = "";
                        while (it.hasNext()) {
                            grpKey = it.next().toString();
                            if (hlpObj.getValFromMap(allParameters, "mmdOwnerAdmin").equals(grpKey)) {
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
            <td style="text-align: right;">Only display current members :</td>
            <td><input type="checkbox" name="mmdCurrentMemebersOnly" id="mmdCurrentMemebersOnly" value="Y" <%=(hlpObj.getValFromMap(allParameters, "mmdCurrentMemebersOnly").equals("Y")) ? "checked" : ""%> /><input type="button" name="Search" value="Search" onclick="doSearch();" /></td>
        </tr>
    </table>
    <hr />

    <table border="0">
        <tr>
            <td style="text-align: right;">Compilation : </td>
            <td><%
                rs = null;
                HashMap tmp = new HashMap();
                tmp.put("col_id", allParameters.get("frm:col_id").toString());
                rs = obj.fnListCollection(tmp, null, null);
                while (rs.next()) {
                    out.print(rs.getString("name") + " <img name=\"treeButton\" src=\"" + contextPath + "/catalog/images/chart_organisation.png\" title=\"Compilation visualization\" onclick=\"openTreeChart('" + allParameters.get("frm:col_id").toString() + "');\" style=\"cursor:pointer;\" /> " + allParameters.get("frm:col_id").toString());
                }
                %></td>
        </tr>
        <tr>
            <td style="text-align: right;">Members : </td>
            <td><%
                out.print(allParameters.get("frm:parent_count").toString() + " parent and " + allParameters.get("frm:child_count").toString());
                if (allParameters.get("frm:child_count").toString().equals("0") || allParameters.get("frm:child_count").toString().equals("1")) {
                    out.print(" child");
                } else {
                    out.print(" children");
                }
                %>
            </td>
        </tr>
        <tr>
            <td>Add/Update compilation members : </td>
            <td><input type="button" value="Execute" name="Save" id="Save" onclick="saveCollectionMember();" /></td>
        </tr>
    </table>
    <hr />
</form>
<%

    int count = 0;
    innoPaging paging = new innoPaging();
    paging.setCurrentPage(allParameters.containsKey("frm:page") ? Integer.parseInt(allParameters.get("frm:page").toString()) : 1);
    int offset = paging.getOffset(), limit = paging.getLimit();
    filter.put("col_id", allParameters.get("frm:col_id"));
    filter.put("strictfilter", "1");
    //Added by Baohong
    if (grps.size() != 0) {
            filter.put("owner_in", grps);  
    }
    //filter.put("owner_in", grps);
    paging.setTotalRecords(obj.fnListGptResourceCount(filter));
    out.print(paging.generateLinks());//print paging links

%>
<table class="grid" cellspacing="0" cellpadding="2">
    <tr>
        <th scope="col" style="width:50px;">Parent</th>
        <th scope="col" style="width:60px;"><div style="float:left;"><input type="checkbox" name="select_all_child" onClick="selectAllChild(this);"/></div><div style="display:block; float:left; line-height:20px;">Child</div></th>
<th scope="col" ><a <%=hlpObj.getHeadingClass(allParameters, "title")%> href="#" onClick="sortBy('title');">Title</a></th>
<th scope="col" style="width:60px;"><a <%=hlpObj.getHeadingClass(allParameters, "owner")%> href="#" onClick="sortBy('owner');">Owner</a></th>
<th scope="col" style="width:90px;"><a <%=hlpObj.getHeadingClass(allParameters, "status")%> href="#" onClick="sortBy('status');">Status</a></th>
<th scope="col" style="width:60px;"><a <%=hlpObj.getHeadingClass(allParameters, "access")%> href="#" onClick="sortBy('access');">Access</a></th>
</tr>
<%
    String parentChecked, childChecked;
    rs = null;

    rs = obj.fnListGptResource(filter, offset, limit);
    while (rs.next()) {
        count++;

        parentChecked = rs.getString("docuuid").equals(hlpObj.getValFromMap(allParameters, "frm:parent_docuuid")) ? "checked=\"checked\"" : "";
        childChecked = parentChecked != "" ? "disabled=\"disabled\"" : (hlpObj.getValFromMap(allParameters, "frm:child_docuuid").indexOf(rs.getString("docuuid")) != -1 ? "checked=\"checked\"" : "");

        out.print("<tr class=\"" + ((count % 2 == 1) ? "rowOdd" : "rowEven") + "\">");
        out.print("<td><input type=\"checkbox\" owner=\"" + rs.getString("owner") + "\" name=\"docuuid_" + rs.getString("docuuid") + "\" id=\"docuuid_" + rs.getString("docuuid") + "\" value=\"" + rs.getString("docuuid") + "\" onclick=\"setDocuuid('parent',this);\" " + parentChecked + " class=\"parent_docuuid\"/></td>");
        out.print("<td><input type=\"checkbox\" owner=\"" + rs.getString("owner") + "\" name=\"child_docuuid_" + rs.getString("docuuid") + "\" id=\"child_docuuid_" + rs.getString("docuuid") + "\" value=\"" + rs.getString("docuuid") + "\" onclick=\"setDocuuid('child',this);\" " + childChecked + " class=\"child_docuuid\" /></td>");
        out.print("<td>" + rs.getString("title") + "<img src=\"" + contextPath + "/catalog/images/Help-icon.png\" onclick=\"showDetails('" + rs.getString("docuuid") + "');\" style=\"cursor:pointer;\" ></td>");
        out.print("<td>" + rs.getString("username") + "</td>");
        out.print("<td>" + rs.getString("status") + "</td>");
        out.print("<td>" + rs.getString("access") + "</td>");
        out.print("</tr>");

    }
    if (count == 0) {
        out.print("<tr><td colspan=\"7\" style=\"text-align:center;\">NO DATA FOUND</td></tr>");
    }
%>
</table>
<% out.print(paging.generateLinks());//print paging links
obj.closeConnection();
%>
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
<script type="text/javascript" src="js/manageBody.js"></script>
 <script>
        highlightCollection();
 </script>