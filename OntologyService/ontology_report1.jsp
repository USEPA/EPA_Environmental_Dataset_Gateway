<%@page contentType="text/tab-separated-values" pageEncoding="UTF-8"%><%@ include file="db.jsp" %><%
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment;filename=ontology_report.tsv");
    
    db obj = new db(getServletContext());
    ResultSet rs = obj.executeQuery("SELECT * FROM rpt_report");
    out.print("UUID\tSOURCE\tSOURCE COUNT\tTARGET\tTARGET COUNT\tPATH\n");
    while (rs.next()) {
        out.print(rs.getString("uuid")+"\t");
        out.print(rs.getString("source")+"\t");
        out.print(rs.getString("s_count")+"\t");
        out.print(rs.getString("target")+"\t");
        out.print(rs.getString("t_count")+"\t");
        out.print(rs.getString("path")+"\t");
        out.print("\n");
    }
    
    
%>

