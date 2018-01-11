
<%@page import="java.util.ArrayList"%>
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="com.innovateteam.gpt.innoRequestContext"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.innovateteam.gpt.innoHelperFunctions"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.innovateteam.gpt.innoCollection"%><%
    String docuuid = request.getParameter("docuuid").toString();
    String title = request.getParameter("title").toString();

    innoCollection obj = new innoCollection(RequestContext.extract(request));
    innoHelperFunctions hlpObj = new innoHelperFunctions();
    hlpObj.setGptUsers(request);
    ArrayList current_user_groups = hlpObj.getCurrentUserGroups(request);

    //fetch current record
    String previousTitle = null, owner = null;
    HashMap filter = new HashMap();
    filter.put("docuuid", docuuid);
    ResultSet rs = obj.fnListVirtualResource(filter, null, null);
    while (rs.next()) {
        previousTitle = rs.getString("title");
        owner = rs.getInt("owner") + "";
    }

    //previous data should exist to update the record first
    if (previousTitle != null) {

        //check permission before updating
        Boolean isAdminUser = hlpObj.isAdminUser(request);
        if (isAdminUser || current_user_groups.contains(owner)) {
            innoRequestContext context = new innoRequestContext(request);
            String uuid = obj.fnAddInnoVirtualResource(title, context, docuuid, owner);

            if (uuid == "0") {
                out.print(previousTitle);
            } else {
                out.print(title);
            }
        } else {
            out.print(previousTitle);
        }
    }
    obj.closeConnection();
%>