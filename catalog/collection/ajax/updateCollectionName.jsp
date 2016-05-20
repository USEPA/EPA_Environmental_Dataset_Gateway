
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.innovateteam.gpt.innoCollection"%>
<%@page import="java.sql.ResultSet"%><%
    //core models
    innoCollection obj = new innoCollection(RequestContext.extract(request));

    String col_id = request.getParameter("col_id").toString();
    String col_name = request.getParameter("title").toString();

    int updtCount = obj.fnUpdateCollectionName(col_name, col_id);

    if (updtCount == 1) {
        HashMap filter = new HashMap();
        filter.put("col_id", col_id);
        ResultSet rs = obj.fnListCollection(filter, null, null);
        String approvalStatus = "";
        while (rs.next()) {
            approvalStatus = rs.getString("name");
            break;
        }
        out.print(approvalStatus);
    }else{
        out.print("");
    }


    obj.closeConnection();
%>