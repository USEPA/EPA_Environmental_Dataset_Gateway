<%@page import="java.io.IOException"%>
<%@page import="org.apache.commons.httpclient.*"%>
<%@page import="org.apache.commons.httpclient.methods.*"%>
<%@page import="org.apache.commons.httpclient.params.HttpMethodParams"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../jspClasses/jsonServer.jsp" %>
<%@ include file="../jspClasses/commonMethods.jsp" %>
<%@ include file="../jspClasses/login.jsp"%>
<%!    public String[] getContentType(String url, String docuuid, Matcher matcher, Pattern p_content_type, PostMethod method, HttpClient client, Logger logger) {

        String[] returnContent = new String[2];
        String urlToLook = url + "?f=html&id=" + docuuid;
        method = new PostMethod();
        client = new HttpClient();

        returnContent[0] = null;
        returnContent[1] = null;
        try {
            method.setURI(new URI(urlToLook, false));
            method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(3, false));


            if (client.executeMethod(method) != HttpStatus.SC_OK) {
                return null;
            } else {
                returnContent[0] = new String(method.getResponseBody());
                matcher = p_content_type.matcher(returnContent[0]);
                if (matcher.find()) {
                    returnContent[1] = matcher.group(3).toString();
                    return returnContent;
                }
            }

        } catch (URIException ex) {
            returnContent[0] = ex.toString();
            return returnContent;
        } catch (NullPointerException ex) {
            returnContent[0] = ex.toString();
            return returnContent;
        } catch (IOException ex) {
            returnContent[0] = ex.toString();
            return returnContent;
        }
        return returnContent;
    }
%>
<%
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }

    jsonServer obj = new jsonServer(1);
    commonMethods commonMethodsObj = new commonMethods();

    String docuuid, selectSQL, insertSQL, resourceLink, contentType[];

    String[] links = commonMethodsObj.getMetaDataLinks(request);
    resourceLink = links[0];

    int hit = 0, miss = 0, total = 0;
    ResultSet rs;
    HttpClient client = null;
    PostMethod method = null;
    Matcher m = null;

    out.print("<h1>Updating content_type in \"gpt_resource\".</h1>");
    insertSQL = "UPDATE gpt_resource SET content_type=? WHERE docuuid = ?";
    PreparedStatement ps = obj.getPrepareStatement(insertSQL);

    selectSQL = "SELECT docuuid FROM gpt_resource";
    rs = obj.executeQuery(selectSQL);
    Pattern p = Pattern.compile("<img src=\"((.)+)\" alt=\"((.)+)\" title=\"((.)+)\"/>");

    while (rs.next()) {
        total++;
        docuuid = rs.getString(1);
        contentType = getContentType(resourceLink, docuuid, m, p, method, client, Logger.getLogger("insertContentType"));

        out.print("<div>" + total + ") docuuid :" + docuuid + "</div>");
        out.print("<div>URL :" + resourceLink + "?f=html&id=" + docuuid + "</div>");
        if (contentType[1] != null) {
            out.print("<div>Contet Type :" + contentType + "</div>");
            ps.setString(1, contentType[1]);
            ps.setString(2, docuuid);
            ps.executeUpdate();
            hit++;
        } else {
            out.print("<div>Contet Type : not found</div>");
            out.print("<div>Flusing content returned from rest service :</div>");
            out.print("<div>" + contentType[0].replaceAll("<", "&lt;").replaceAll(">", "&gt;") + "</div>");
            miss++;
            ps.setString(1, null);
            ps.setString(2, docuuid);
            ps.executeUpdate();
        }
        out.print("<hr />");
    }

    out.print("<h1>COMPLETE.</h1>");
    out.print("<h1>" + total + " records were read.");
    out.print("<h1>" + hit + " records updated, " + miss + " records didnot return valid content type.</h1>");
%>