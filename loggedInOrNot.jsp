<%@ page import="com.esri.gpt.framework.context.RequestContext" %>
<%

RequestContext context = RequestContext.extract(request);

if((context.getUser() == null || context.getUser().getName().trim().equals("")) && request.getUserPrincipal() == null) 
	out.println("not authenticated");
else if(context.getUser()==null)
	out.println("authenticated user: " + request.getUserPrincipal().getName());
else
	out.println("authenticated user: " + context.getUser().getName());

%>