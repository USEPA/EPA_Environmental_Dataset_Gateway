<%@page import="java.io.IOException"%>
<%@page import="java.util.logging.Handler"%>
<%@page import="java.util.logging.FileHandler"%>
<%@page import="com.innovateteam.gpt.*"%>
<%@ include file="/metrics/jspClasses/jsonServer.jsp" %>
<%
    Logger logger=null;
    try {
        // Create a file handler that write log record to a file called my.log
        FileHandler handler = new FileHandler("D:\\Public\\Server\\Apps\\Tomcat6029\\logs\\metrics.log");
        logger = Logger.getLogger("innovateteam");
        logger.addHandler(handler);
    } catch (IOException e) {
    }

    //Handler handler = new FileHandler("test.log");
    jsonServer obj = new jsonServer(1);
    batchUpdateAll update = new batchUpdateAll("https://edg.epa.gov/ESRIRestServlet", logger, obj.getConnection());
    update.doUpdate();


%>

