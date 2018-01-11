<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.util.Enumeration" %>
 
<%  
 out.println("<p>Cookies:");
 Cookie[] cookies = request.getCookies();
 if(cookies != null)
 {
  for (int i = 0; i < cookies.length; i++)
  {
   out.println("<br>Cookie " + i + " name: " + cookies[i].getName());
   out.println("<br>value: " + cookies[i].getValue());
   out.println("<br>domain: " + cookies[i].getDomain());
   out.println("<br>path: " + cookies[i].getPath());
   
   if(cookies[i].getName().equalsIgnoreCase("ObSSOCookie")) 
   {
cookies[i].setMaxAge(0);  
cookies[i].setValue("");  
response.addCookie(cookies[i]);  
   
   }
  }
 }
 
 out.println("<p>Headers:");
 
 Enumeration em = request.getHeaderNames();
 if(em!=null)
 {
  int i = 0;
  while (em.hasMoreElements())
  {
   String s = (String) em.nextElement();
   out.println("<br>Header " + i + " name: " + s);
   out.println("<br>value: " + request.getHeader(s));
   ++i;
  }
 }    
 
%> 

