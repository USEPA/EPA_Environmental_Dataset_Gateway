<%@page contentType="text/tab-separated-values" pageEncoding="UTF-8"%><%@ include file="db.jsp" %><%
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment;filename=ontology_summary.tsv");

    db obj = new db(getServletContext());
    ResultSet rs = obj.executeQuery("SELECT uuid,term,count FROM rpt_term_count_per_uuid");
    out.print("UUID\tTERM\tCOUNT\n");
    while (rs.next()) {
        out.print(rs.getString("uuid") + "\t");
        out.print(rs.getString("term") + "\t");
        out.print(rs.getString("count") + "\t");
        out.print("\n");
    }
%>

