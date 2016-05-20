<%@ page import="com.esri.gpt.framework.context.RequestContext" %>
<%

 RequestContext context = RequestContext.extract(request);


if (context.getUser() == null) {
out.println("not authenticated");
}
else {
out.println("authenticated user: " + context.getUser().getName());
}
%>