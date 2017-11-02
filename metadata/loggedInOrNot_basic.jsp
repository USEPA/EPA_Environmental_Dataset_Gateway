<%
if (request.getUserPrincipal() == null) {
out.println("not authenticated");
}
else {
out.println("authenticated user: " + request.getUserPrincipal().getName());
}
%>