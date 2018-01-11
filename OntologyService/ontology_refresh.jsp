
<%@page contentType="text/html" pageEncoding="UTF-8"%><%@ include file="db.jsp" %><%
    //SELECT * FROM pg_proc WHERE proname = 'gen_ontology_rpt'
    db obj = new db(getServletContext());

    //check if function exists
    boolean reportExists = false;
    boolean reportRunning = false;
    String sql = "SELECT count(*) as cnt FROM pg_proc WHERE proname = 'gen_ontology_rpt'";
    ResultSet rs = obj.executeQuery(sql);
    while (rs.next()) {
        if (rs.getInt("cnt") == 1) {
            reportExists = true;
        }
    }
    if (reportExists) {
        rs = obj.executeQuery("SELECT gen_ontology_rpt()");
        out.print("REPORT REFRESHED SUCCESSFULLY.");
    } else {
        out.print("FUNCTION 'gen_ontology_rpt' IS MISSING!");
    }

%>

