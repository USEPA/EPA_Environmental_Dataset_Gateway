/*
 * This servlet returns a merged dir listing of permiteed files,
 * or the file directly if a path to it is given and it is permitted
 * for that user.
 */

//package com.innovateteam;
package com.innovateteam;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;
import java.util.logging.Logger;
import java.util.Properties;
import java.util.Enumeration;
import java.net.*;
import java.io.*;
import java.util.logging.Level;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.*;
//import com.esri.gpt.framework.context.RequestContext;

/**
 *
 * @author John Sievel
 */
public class Data extends HttpServlet {
    public static String dataLocContext = "";  // what the dataLoc path starts with
    public final static int BUFSIZE = 1000000;  // used for buffering files
    public static final String htmlHeader = "<html><body>";
    public static final String htmlTrailer = "</body></html>";
    private static final Logger log = Logger.getLogger("data");
    public static String dataLoc;
    public static String authenLoc;
    public static String anonymousUser;
    private static int defaultBufSize = 16000;
    public static final String illegalChars = "[\000\002]";
    public static Properties resources = new Properties();

    @Override
    public void init() {
        log.setLevel(Level.FINER);
        dataLoc = getServletConfig().getInitParameter("dataLoc");
        if ((dataLoc != null) && (dataLoc.length()>0))
            log.info("dataLoc: "+dataLoc);
        else {
            log.severe("Init failed, no dataLoc");
            return;
        }
        if (!dataLoc.endsWith("/"))
            dataLoc += "/";
        
        int protocolEnd = dataLoc.indexOf("://");
        int contextStart = dataLoc.indexOf("/",protocolEnd+3);
        int contextEnd = dataLoc.indexOf("/", contextStart+1);
        if (contextStart>=0) {
            dataLocContext = dataLoc.substring(contextStart, contextEnd+1);
        }
        log.info("dataLocContext: "+dataLocContext);
        
        authenLoc = getServletConfig().getInitParameter("authenLoc");
        if ((authenLoc != null) && (authenLoc.length()>0))
            log.info("authenLoc: "+authenLoc);
        else {
            log.severe("Init failed, no authenLoc");
            return;
        }
        if (!authenLoc.startsWith("header.") &&
                !authenLoc.equals("fixed.public") && !authenLoc.equals("fixed.restricted")) {
            log.severe("Init failed, illegal value for authenLoc");
            return;
        }
        // make sure have real header name after .
        if (authenLoc.startsWith("header.") && (authenLoc.length() < 8)) {
            log.severe("Init failed, no header name after 'header.' parameter.");
            return;
        }
        anonymousUser = getServletConfig().getInitParameter("anonymousUser");
        if ((anonymousUser != null) && (anonymousUser.length()>0))
            log.info("anonymousUser: "+anonymousUser);
        else {
            log.severe("Init failed, no anonymousUser");
            return;
        }
        try {
            resources.load(this.getServletContext().getResourceAsStream("/WEB-INF/classes/resources.properties"));
        } catch (IOException e) {
            log.severe("Init failed, no /WEB-INF/classes/resources.properties");
            return;
        }

    }
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        try {
            
            boolean authenticated = getAuthenticatedStatus(request);
            //boolean authenticated=true;
            String reqPath = request.getPathInfo();
            if (reqPath.startsWith("/"))
                reqPath = reqPath.substring(1);
            reqPath = reqPath.toUpperCase();
            log.info("reqPath1: "+reqPath);
             
            
            boolean isFile = (reqPath.lastIndexOf('.') > reqPath.lastIndexOf('/'));
            if (!authenticated && reqPath.startsWith("RESTRICTED")) {
                if (isFile) {
                    String makeLoginOk = "/message/message.html?msg="+
                            URLEncoder.encode(resources.getProperty("msg.ok.login"),"UTF-8");
                    String loginHref = "/sso/login?sso_redirect="+URLEncoder.encode(makeLoginOk,"UTF-8");
                    String makeNotAuth = "/message/message.html?msg="+
                            resources.getProperty("msg.err.fileNotAuthorized").replace("XXXX",loginHref);
                    log.info("Not authenticated for dir, redirect to: "+makeNotAuth);
                    response.sendRedirect(makeNotAuth);
                } else {
                    // is dir, so send back to app page to handle.
                    response.setStatus(HttpStatus.SC_FORBIDDEN);
                }
                return;
            }
            
            
            // determine if req for specific file, or dir
            if (isFile) {// a file
                int rc = getUrlContents(dataLoc + reqPath, response);
                 PrintWriter out = response.getWriter();
 
             
                //int rc = HttpStatus.SC_FORBIDDEN;
                if (rc == HttpStatus.SC_NOT_FOUND) {
                    String redirTo = "/message/message.html?msg="+resources.getProperty("msg.err.fileNotFound");
                    log.info("SC_NOT_FOUND, redirect to: "+redirTo);
                    response.sendRedirect(redirTo);
                    return;
                } else if (rc == HttpStatus.SC_FORBIDDEN){
                    String makeLoginOk = "/message/message.html?msg="+
                            URLEncoder.encode(resources.getProperty("msg.ok.login"),"UTF-8");
                    String loginHref = "/sso/login?sso_redirect="+URLEncoder.encode(makeLoginOk,"UTF-8");
                    String makeNotAuth = "/message/message.html?msg="+resources.getProperty("msg.err.fileNotAuthorized").replace("XXXX",loginHref);
                    log.info("Not authenticated for file, redirect to: "+makeNotAuth);
                    response.sendRedirect(makeNotAuth);
                } else {
                    response.setStatus(rc);
                }
            } 
            
            else {
                // dir, show special entry page
                if (reqPath.length()==0) {
                    generateEntryPage(request,response, authenticated);
                } else {
                    String suppressHeader = request.getParameter("suppressHeader");
                    String urlStr = dataLoc + reqPath;
                    getDir(urlStr,response,suppressHeader);
//                      getDir("http://192.168.49.211/ftpdata/" + reqPath,response,suppressHeader);
                }
            }
            
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            log.severe(sw.toString());
            response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
        }
        
    }

    private void generateEntryPage(HttpServletRequest req, HttpServletResponse resp, boolean authenticated) throws Exception {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        StringBuffer xml = new StringBuffer();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<dir>");
        generateLoginInfo(req,xml,authenticated);
        generateResources(xml);
        xml.append("<entry type=\"dir\">\n<A HREF=\"/data/Public/\">Public</A>\n</entry>");
        if (authenticated)
            xml.append("<entry type=\"dir\">\n<A HREF=\"/data/Restricted/\">Restricted</A>\n</entry>");
        xml.append("</dir>");
        out.print(xform(xml.toString(),"/xformDir.xsl"));
        //out.print(xml.toString());

    }

    private void generateLoginInfo(HttpServletRequest req, StringBuffer xml, boolean authenticated) {
        xml.append("<loginInfo ");
        xml.append("authenLoc=\"");
        xml.append(authenLoc);
        xml.append("\" authenticated=\"");
        xml.append(authenticated);
        xml.append("\" user=\"");
        String headerName = authenLoc.substring(authenLoc.indexOf(".")+1);
        String uid = req.getHeader(headerName);
        //String uid = "fake";
        xml.append(uid);
        xml.append("\"></loginInfo>\n");
    }
    
    private void generateResources(StringBuffer xml) {
        Enumeration rscNamesEnum = resources.propertyNames();
        while (rscNamesEnum.hasMoreElements()) {
            String name = (String) rscNamesEnum.nextElement();
            String value = (String) resources.get(name);
            xml.append("<resource ");
            xml.append("id=\"");
            xml.append(name);
            xml.append("\">\n");
            xml.append(value);
            xml.append("</resource>");
        }
    }
    
    public boolean getAuthenticatedStatus(HttpServletRequest req) {
        //if (true) return true;
        if (authenLoc.equals("fixed.restricted"))
            return true;
        if (authenLoc.equals("fixed.public"))
            return false;
        // must be header
        String headerName = authenLoc.substring(authenLoc.indexOf(".")+1);
        String uid = req.getHeader(headerName);
        log.fine("headerName: "+headerName+"  uid: "+uid);
        if ((uid == null) || (uid.length()==0) || uid.equalsIgnoreCase(anonymousUser))
             return false;
        return true;
    }

    public int getUrlContents(String urlStr, HttpServletResponse response) throws Exception {
        HttpMethodBase method = null;
        ByteArrayOutputStream inputBytes = null;
        ServletOutputStream outStream = null;
        try {
            log.info("Fetching "+urlStr);
            HttpClient client = new HttpClient();
            client.setConnectionTimeout(3*1000);	// 3 seconds.
            urlStr = URLDecoder.decode(urlStr, "UTF-8");
            urlStr = urlStr.replace(" ", "%20");
            log.finer("urlStr: "+urlStr);
            method = new GetMethod(urlStr);
	    int statusCode = client.executeMethod(method);
	    if (statusCode != HttpStatus.SC_OK) {
                if ((statusCode == HttpStatus.SC_NOT_FOUND) || (statusCode == HttpStatus.SC_FORBIDDEN))
                    log.info("executeMethod returned status code: "+statusCode);
                return statusCode;
            }
            copyHeadersToResponse(method, response);

            // copy contents to out
            BufferedInputStream in = new BufferedInputStream(method.getResponseBodyAsStream());
            outStream = response.getOutputStream();
            int cnt;
            byte[] buffer = new byte[BUFSIZE];
            while ((cnt = in.read(buffer)) != -1) {
                outStream.write(buffer, 0, cnt);
            }
            return statusCode;
        } finally {
            if(method != null)
                    method.releaseConnection();
            // return bytes
        }
    }

    public static void copyHeadersToResponse(HttpMethodBase method, HttpServletResponse response) {
        log.finer("in copyHeadersToResponse");
        Header[] headers = method.getResponseHeaders();
        for (Header header:headers) {
            log.finer("header name: "+header.getName()+"   value: "+header.getValue());
            response.setHeader(header.getName(), header.getValue());
        }
    }

   /**
     * Read and parse the dir listing, and convert to xml in dom
     * @param dirUrl
     * @param resp
     */
    private void getDir(String dirUrl, HttpServletResponse resp, String suppressHeader) {
        BufferedReader br = null;
        StringBuffer sb = new StringBuffer();
        StringBuffer xml;
        HttpURLConnection urlConn = null;
        String html = "";
        PrintWriter out = null;
        try {
            resp.setContentType("text/html");
            //resp.setContentType("text/xml");
            out = resp.getWriter();
            URL url = new URL(dirUrl);
            urlConn = (HttpURLConnection) url.openConnection();
            urlConn.connect();
            int rc = urlConn.getResponseCode();
            log.fine("rc: "+rc);
            br = new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
            char[] cbuf = new char[defaultBufSize];
            int cnt = 0;
            //log.finer("Starting to read page.");
            while ((cnt = br.read(cbuf,0,defaultBufSize)) != -1)
                    sb.append(cbuf);
            html = sb.toString();
            xml = parseDir(html,suppressHeader);
            out.print(xform(xml.toString(),"/xformDir.xsl"));
        } catch (FileNotFoundException nf) {
            log.info("Exception, not found "+nf.getMessage());
            resp.setStatus(resp.SC_NOT_FOUND);
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            log.severe(sw.toString());
            resp.setStatus(resp.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Convert the html dir listing to xml as follows:
     * <dir>
     *   <entry type={backLink,dir,file}
     *      <date>nn/nn/nnnn</date>
     *      <time>hh:mm AM/PM</time>
     *      <a href="...">text</a>
     *   </entry>
     * </dir>
     *
     * @param html - input html
     * @param suppressHeader - if true, don't produce full page, just html snippet for dir
     * @return xml in StringBuffer
     */
    private StringBuffer parseDir(String html, String suppressHeader) {
        String upHtml = html.toUpperCase();
        StringBuffer xml = new StringBuffer();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        if (suppressHeader != null)
            xml.append("<dir suppressHeader=\""+suppressHeader+"\">\n");
        else
            xml.append("<dir>\n");
        // assume entries start and end with <pre>
        int entryStart = upHtml.indexOf("<PRE>");
        if (entryStart >= 0)
            entryStart += 5;
        int entryEnd = 0;
        int entriesEnd = upHtml.indexOf("</PRE>");
        while (entryStart>=0) {
            entryEnd = upHtml.indexOf("<BR>", entryStart);
            if ((entryEnd >= 0) && (entryEnd < entriesEnd)) {
                parseLine(html,upHtml,entryStart,entryEnd,xml);
                entryStart = entryEnd+4;
            } else
                entryStart = -1;
        }
        xml.append("</dir>");
        
        
        return xml;
    }

    /**
     * Look for and parse into xml the time, date, anchor, and type of entry
     * @param html
     * @param upHtml
     * @param start
     * @param end
     */
    private void parseLine(String html, String upHtml, int start, int end, StringBuffer fullXml) {
        if (start==end)
            return;
        log.finer("line: "+html.substring(start,end));
        StringBuffer xml = new StringBuffer();
        String href = "";
        String link = "";
        String date = "";
        String time = "";
        String fileSize = "";
        boolean isDir = false;
        int aStart = upHtml.indexOf("<A",start);
        if (aStart >= 0) {
            int aStartEnd = upHtml.indexOf('>', aStart);
            if (aStartEnd >= 0) {
                int aEnd = upHtml.indexOf("</A>",aStartEnd+1);
                //log.finer("aStart: "+aStart+"   aStartEnd: "+aStartEnd+"  aEnd: "+aEnd);
                if (aEnd>=0) {
                    int hrefLoc = upHtml.indexOf("HREF=",aStart);
                    if ((hrefLoc>=0) && (hrefLoc<aStartEnd)) {
                        //log.finer("hrefLoc: "+hrefLoc);
                        int delim = html.charAt(hrefLoc+5);
                        int hrefEnd = html.indexOf(delim, hrefLoc+6);
                        if (hrefEnd>=0)
                            href = html.substring(hrefLoc+6, hrefEnd);
                        href = href.replace(dataLocContext, "/data/");
                        log.fine("href: "+href);
                        link = html.substring(aStartEnd+1, aEnd);
                        String[] dateTimeDir = upHtml.substring(start, aStart).split("[ \t\n\f\r]");
                        for (int i=0; i<dateTimeDir.length;i++) {
                            log.fine("dateTimeDir["+i+"]: "+dateTimeDir[i]+"   length: "+dateTimeDir[i].length());
                            if (dateTimeDir[i].contains("/")) {
                                date = dateTimeDir[i];
                                dateTimeDir[i] = "";
                            }
                            if (dateTimeDir[i].contains(":")) {
                                time = dateTimeDir[i];
                                dateTimeDir[i] = "";
                                if ((i+1)<dateTimeDir.length &&
                                        (dateTimeDir[i+1].equals("AM") || dateTimeDir[i+1].equals("PM"))) {
                                    time += " "+dateTimeDir[i+1];
                                    dateTimeDir[i+1] = "";
                                }
                            }
                            if (i==dateTimeDir.length-1) {
                                // file size is last
                                try {
                                    Integer.parseInt(dateTimeDir[i]);
                                    fileSize = dateTimeDir[i];
                                    dateTimeDir[i] = "";
                                } catch (NumberFormatException nfe) {}
                            }
                           
                            if (dateTimeDir[i].contains("&LT;DIR&GT;")) {
                                isDir = true;
                                dateTimeDir[i] = "";
                            }
                        }
                        // handle other date format if no date
                        if (date.length()==0) {
                            for (int i=0; i<dateTimeDir.length; i++) {
                                date += dateTimeDir[i]+" ";
                            }
                        }
                        // output xml
                        xml.append("<entry type=\"");
                        if (link.equalsIgnoreCase("[To Parent Directory]"))
                            xml.append("backLink");
                        else if (isDir)
                            xml.append("dir");
                        else
                            xml.append("file");
                        xml.append("\">\n");
                        
                        if (date.length()>0)
                            xml.append("<date>"+filter(date)+"</date>");
                        if (time.length()>0)
                            xml.append("<time>"+filter(time)+"</time>");
                        if (fileSize.length()>0)
                            xml.append("<fileSize>"+filter(fileSize)+"</fileSize>");
                        xml.append("<A HREF=\""+filter(href)+"\">"+filter(link)+"</A>");
                        xml.append("</entry>\n");
                        log.finer("xml: "+xml.toString());
                        fullXml.append(xml);
                    }
                }
            }
        }
    }

    public String filter(String in) {
        // filter out illegal chars, and excape chars for xml
        String out = in.trim().replaceAll(illegalChars, "");
        return out.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    public String xform(String xmlStr, String xslUrl) {
        try {
            TransformerFactory tFactory = TransformerFactory.newInstance();
            InputStream xslStream = null;
            URL url = null;
            if (xslUrl == null)
                    return "";
            if (xslUrl.startsWith("http://")) {
                url = new URL(xslUrl);
                xslStream = url.openStream();
            } else
                xslStream = this.getServletContext().getResourceAsStream(xslUrl);
            log.finer("xslUrl: "+xslUrl+"   xslStream: "+xslStream);
            Transformer transformer = tFactory.newTransformer(new StreamSource(xslStream));
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            transformer.transform(new StreamSource(new StringReader(xmlStr)), new StreamResult(baos));
            return(baos.toString());
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            log.severe(sw.toString());
            return "";
        }
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Returns dir listing of permitted data, or the data itself.";
    }// </editor-fold>

}
