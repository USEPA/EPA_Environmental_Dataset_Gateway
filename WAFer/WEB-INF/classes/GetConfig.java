/*
 * Servlet running on a state node to get and return the config file
 * from the core node. This will usually be mapped to url:
 *     /SearchServices.xml
 *
 * The CoreGFEUrl servlet init param must point to the server where a GetConfig is running.
 * If it is empty or not there, the path portion of the request after the context must point
 * to a file on the server that this is running on, and that file will be returned.
 * Ex: http://dev.innovateteam.com/GFE/SearchServices.xml
 *     will return SearchServices.xml if GetConfig is mapped to url pattern:
 *     /SearchServices.xml
 * in web.xml.
 */


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContext;
import java.net.URL;
import java.io.*;
import org.apache.log4j.Logger;

/**
 *
 * @author johnsievel
 */
public class GetConfig extends HttpServlet {
    private static final Logger logger = Logger.getLogger(get.class);
    public static String coreUrl = null;
    public static String handling = null;
    public static ServletContext getConfigCtx = null;
   
    @Override
    public void init() {
        coreUrl = this.getServletContext().getInitParameter("CoreGFEUrl");
        handling = getInitParameter("handling");
        logger.info("coreUrl "+coreUrl+"   handling "+handling);
        if ((coreUrl != null) && (coreUrl.length()>0)) {
            if (!coreUrl.endsWith("/"))
                coreUrl += "/";
            coreUrl += "GiveConfig?handling="+handling;
            getConfigCtx = this.getServletContext();
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
        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        String errorReturn =
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<SearchServices>\n<SearchService>\n<code>ERROR</code>\n"+
                    "<displayName>XXX</displayName>\n</SearchService>\n</SearchServices>";
        try {
            if ("wafer".equals(handling.toLowerCase())) {
                // restrict to localhost
                URL requestUrl = new URL(request.getRequestURL().toString());
                if (!"localhost".equals(requestUrl.getHost()))
                    return;  // only allow this from inside the server
            }
            if ((coreUrl == null) || (coreUrl.length()==0)) {
                // read from file system
                String ctxPath = request.getContextPath();
                String reqUrl = request.getRequestURL().toString();
                String filePath = reqUrl.substring(reqUrl.indexOf(ctxPath)+ctxPath.length());
                logger.info("reqUrl: "+reqUrl);
                InputStreamReader inp = new InputStreamReader(this.getServletContext().getResourceAsStream(filePath));
                BufferedReader reader = new BufferedReader(inp);
            char[] cbuf = new char[10000];
            int cnt = 0;
            String content = "";
			while ((cnt = reader.read(cbuf,0,10000)) != -1)
				content += new String(cbuf,0,cnt);
            reader.close();
            out.print(content);

            } else {
                String config = XMLHelper.getUrlContents(coreUrl);
                out.print(config);
            }
        } catch (Exception e) {
            logger.error("GetConfig thru exception: ",e);
            String errMsg1 = "ERROR - Could not get config from core. ";
            String errMsg2 = " Is the core url in web.xml correct?";
            logger.error(errMsg1+errMsg2);
            out.println(errorReturn.replace("XXX", errMsg1));
            } finally {
            out.close();
        }
    }
    
    public String getCoreUrl() {
        return coreUrl;
        
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
        return "Get SearchServices.xml from GFECore";
    }// </editor-fold>

}
