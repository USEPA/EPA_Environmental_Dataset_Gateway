<%@ page contentType="application/json"%>
<%@ page import="com.esri.gpt.framework.context.RequestContext" %>
<%@ page import="org.json.JSONObject" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    response.setHeader("Access-Control-Allow-Credentials", "true"); 
    response.setHeader("Access-Control-Allow-Methods", "GET"); 
    response.setHeader("Access-Control-Allow-Headers", "application/json"); 

    String oauthToken = request.getParameter("t");
    if ((oauthToken != null) && (oauthToken.length() > 0)) {
        String oauthUsername = request.getParameter("u");
        com.esri.gpt.framework.context.RequestContext ctx = com.esri.gpt.framework.context.RequestContext.extract(request);
        com.esri.gpt.framework.security.identity.IdentityAdapter ia = ctx.newIdentityAdapter();
        if (ia instanceof com.esri.gpt.framework.security.identity.agp.PortalIdentityAdapter) {
            com.esri.gpt.framework.security.identity.agp.PortalIdentityAdapter pa = (com.esri.gpt.framework.security.identity.agp.PortalIdentityAdapter)ia;
            pa.validateOAuthResponseToken(oauthToken,oauthUsername);
        }
    }
    RequestContext context = RequestContext.extract(request);
    
    com.esri.gpt.framework.security.principal.RoleSet roles = context.getUser().getAuthenticationStatus().getAuthenticatedRoles();
    JSONObject resp = new JSONObject();
    resp.put("user", context.getUser().getName());
    JSONObject respRoles = new JSONObject();
    if(roles.hasRole("gptAdministrator")) respRoles.put("gptAdministrator", true);
    if(roles.hasRole("gptPublisher")) respRoles.put("gptPublisher", true);
    if(roles.hasRole("gptRegisteredUser")) respRoles.put("gptRegisteredUser", true);
    resp.put("roles", respRoles);
    out.println(resp.toString(4));
%>
