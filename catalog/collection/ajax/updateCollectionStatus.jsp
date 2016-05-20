
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.innovateteam.gpt.innoCollection"%>
<%@page import="java.sql.ResultSet"%><%
    //core models
    innoCollection obj = new innoCollection(RequestContext.extract(request));

    String col_id = request.getParameter("col_id").toString();
    int updtCount = obj.fnUpdateCollectionApprovalStatus(col_id);
    
    HashMap filter = new HashMap();
    filter.put("col_id", col_id);
    ResultSet rs = obj.fnListCollection(filter, null, null);
    String approvalStatus="";
    while(rs.next()){
        approvalStatus = rs.getString("approved"); 
        break;        
    }
    out.print(approvalStatus);
    obj.closeConnection();
%>