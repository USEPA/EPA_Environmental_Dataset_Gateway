<%@ page import="java.util.*" %><%@ include file="../jspClasses/jsonServer.jsp" %><%

    jsonServer obj = new jsonServer(1);
    ArrayList params = new ArrayList();
    ArrayList paramTypes = new ArrayList();
    String sql = new String();
    sql = "SELECT gres.docuuid,gres.title||'/'||gusr.username as label,gres.owner,gres.updatedate,coalesce(LEAD(updatedate) OVER (ORDER BY updatedate ASC),clock_timestamp()) as update_to,gres.id";
    sql += " ,gusr.username,gres.title ";
    sql += " FROM gpt_resource gres LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
    sql += " ORDER BY gres.updatedate";
    
    ResultSet rs = obj.executeQuery(sql);
    out.write(obj.getJson(rs, true));
%>