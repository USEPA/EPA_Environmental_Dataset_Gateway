<%@ page import="java.util.*" %><%@ include file="../jspClasses/jsonDataProvider.jsp" %><%@ include file="../jspClasses/login.jsp"%><%
    /*
     *This JSP file creates a json resource that is used by inventory page
     */
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }
    
    jsonServer obj = new jsonServer(1);
    HashMap params = new HashMap();
    params.put("acl",ret[1]);
    jsonDataProvider cdpObj = new jsonDataProvider(obj);
    ResultSet rs = cdpObj.getInventoryData(params,false);
    
    obj.writeJson(rs, true, "inventory");
    out.print("Done");
%>