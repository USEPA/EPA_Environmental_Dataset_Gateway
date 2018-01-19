/*
 * Servlet to take xml, or a url to xml, and an xsl style sheet, or url to an .xsl style sheet,
 * and xform to html. Various parameters to the style sheet are passed in.
 */


import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;

/**
 *
 * @author John Sievel
 */
public class Xform extends HttpServlet {
    private static final Logger logger = Logger.getLogger(get.class);
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest req, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String xslUrl = req.getParameter("xsl");  //xsl style sheet
            String metadataLinkageUrl = req.getParameter("MetadataLinkage");
            String readableMetadataLinkageUrl = req.getParameter("ReadableMetadataLinkage");
            String title = req.getParameter("Title");
            logger.debug("Entering Xform");
            logger.debug("xslUrl: "+xslUrl+"   metadataLinkage: "+metadataLinkageUrl);
            String[] MetadataParm = {"MetadataParm",req.getParameter("Metadata")};
            String[] metadataLinkageUrlParm = {"metadataLinkageUrlParm",metadataLinkageUrl};
            String[] readableMetadataLinkageUrlParm = {"readableMetadataLinkageUrlParm",readableMetadataLinkageUrl};
            String[] titleParm = {"titleParm",title};
            ArrayList<String[]> parms = new ArrayList<String[]>(3);
            parms.add(MetadataParm);
            parms.add(metadataLinkageUrlParm);
            parms.add(readableMetadataLinkageUrlParm);
            parms.add(titleParm);
            String xmlIn = null;
            if (metadataLinkageUrl.length()==0) {
				xmlIn = req.getParameter("Metadata");
            } else {
                try {
                    xmlIn = XMLHelper.getUrlContents(metadataLinkageUrl);
                } catch (Exception e) {
                    out.println("Exception while trying to get data from metadataLinkage "+metadataLinkageUrl+"<br/><br/>"+e.getMessage());
                    return;
                }
            }
            String htmlOut = "";
            try {
                htmlOut = XMLHelper.xform(xmlIn, xslUrl, parms);
                out.println(htmlOut);
            } catch (Exception e2) {
                    String errMsg = e2.getMessage();
                    out.println("Exception while trying to trnsform your xml into html. <br/>Are you sure you passed the correct url to your .xsl file?<br/>");
                    out.println("The .xsl url you sent is: "+xslUrl+"<br/>");
                    out.println("The error generated is: "+errMsg+"<br/>");
                    out.println("The xml you are trying to transform is:<br/><br/>"+xmlIn);
                    return;
            }
        } finally { 
            out.close();
        }
    } 

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


}
