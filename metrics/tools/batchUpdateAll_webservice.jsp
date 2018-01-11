<%@page import="java.io.IOException"%>
<%@page import="java.util.logging.Handler"%>
<%@page import="java.util.logging.FileHandler"%>
<%@page import="com.innovateteam.gpt.*"%>
<%@ include file="../jspClasses/commonMethods.jsp" %>
<%
    Logger logger=null;
    try {
        // Create a file handler that write log record to a file called my.log
        FileHandler handler = new FileHandler(getServletContext().getInitParameter("MetricsFilesPath")+"metrics.log");
        logger = Logger.getLogger("innovateteam");
        logger.addHandler(handler);
    } catch (IOException e) {
    }
    
    commonMethods objCommon = new commonMethods();
    String[] links = objCommon.getMetaDataLinks(request);
    String resourceLink = links[0];
    
    jsonServer obj = new jsonServer(1);
    batchUpdateAll update = new batchUpdateAll(resourceLink, logger, obj.getConnection());
    update.doUpdate();
    
    out.print("<h1>UPDATE COMPLETED SUCCESSFULLY, CHECK metrics.log FOR ISSUES.</h1>");
%>