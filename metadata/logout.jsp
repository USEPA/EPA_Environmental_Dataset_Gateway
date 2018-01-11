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
   
   if(cookies[i].getName().equalsIgnoreCase("ObSSOCookie")) 
   {
response.setContentType("text/html");
cookies[i].setMaxAge(0);  
cookies[i].setValue("");  
cookies[i].setDomain(".epa.gov");
cookies[i].setPath("/"); 
response.addCookie(cookies[i]);
   
   out.println("------------------" );
   }
  }
 }

response.sendRedirect("/metadata"); 
%>
