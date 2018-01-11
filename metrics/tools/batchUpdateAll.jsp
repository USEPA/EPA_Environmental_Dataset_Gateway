<%@page import="com.innovateteam.gpt.*"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.logging.Handler"%>
<%@page import="java.util.logging.FileHandler"%>
<%@ include file="../jspClasses/commonMethods.jsp" %>
<%
    String useLucene = null;
    Logger logger = null;
    try {
        // Create a file handler that write log record to a file called my.log
        FileHandler handler = new FileHandler(getServletContext().getInitParameter("MetricsFilesPath") + "metrics.log");
        logger = Logger.getLogger("innovateteam");
        logger.addHandler(handler);
    } catch (IOException e) {
    }
    try {
        useLucene = getServletContext().getInitParameter("UseLucene");
    } catch (Exception e) {
        useLucene = null;
    }

    commonMethods objCommon = new commonMethods();
    String[] links = objCommon.getMetaDataLinks(request);
    String resourceLink = links[0];
    batchUpdateAll update;
    jsonServer obj = new jsonServer(1);

    if (useLucene.equalsIgnoreCase("Y")) {
    	out.println("Update using Lucene indexes");
        File file = new File(objCommon.getLuceneIndexDir(request));
        update = new batchUpdateAll(file, logger, obj.getConnection());
    }else{
    	out.println("Update using webservice");
        update = new batchUpdateAll(resourceLink, logger, obj.getConnection());
    }
    update.doUpdate();
    out.print("<h1>UPDATE COMPLETED SUCCESSFULLY, CHECK metrics.log FOR ISSUES.</h1>");
%>
