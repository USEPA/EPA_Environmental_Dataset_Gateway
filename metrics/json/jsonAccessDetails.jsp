<%@page contentType="application/json" pageEncoding="ISO-8859-1"%><%@ page import="java.util.*" %><%@ include file="../jspClasses/jsonDataProvider.jsp" %><%@ include file="../jspClasses/login.jsp"%><%
    
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }

    jsonServer obj = new jsonServer(1);

    HashMap params = new HashMap();
    params.put("acl", ret[1]);

    if (request.getParameter("fromDate") != null && request.getParameter("fromDate") != "") {
        params.put("fromDate", request.getParameter("fromDate"));
    }
    if (request.getParameter("toDate") != null && request.getParameter("toDate") != "") {
        params.put("toDate", request.getParameter("toDate"));
    }
    
    jsonDataProvider cdpObj = new jsonDataProvider(obj);
    ResultSet rs = cdpObj.getAccessDetailsData(params, false);

    HashMap hint = new HashMap();
    hint.put("zip_code", "STRING");
    hint.put("uid", "STRING");
    obj.setHint(hint);
    
    if(rs!=null){
        out.write(obj.getJson(rs, true));
    }
%>