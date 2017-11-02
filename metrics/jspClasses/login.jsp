<%@page import="java.util.Enumeration,javax.xml.parsers.DocumentBuilderFactory,javax.xml.parsers.DocumentBuilder,org.w3c.dom.Document,org.w3c.dom.NodeList,org.w3c.dom.Node,java.io.File"%><%!
    public class login {

        private String hardWiredFilePath;
        private ServletContext servletContext;
        private JspWriter out;
        /*
         * Class constructor
         * @param : hardWiredFilePath   String  Path to the WEB-INF\EME_files folder   
         */

        public login(ServletContext servletContext) {
            this.servletContext = servletContext;
            this.hardWiredFilePath = getServletContext().getInitParameter("MetricsFilesPath");
            this.out = out;
        }

        public void print(String s) {
            try {
                this.out.println(s);
            } catch (Exception e) {
            }
        }

        /*
         * This function validates the user id provided against all the valid users
         * whose id is stored in the validUsers.xml file
         * @param : user_id   String  Unique idetifier of the user  
         * @return : boolean    true if the given user_id is valid user else false
         */
        public boolean verifyUserID(String user_id) {
            if (user_id == null) {
                return false;
            }
            try {
                String user_id_from_xml;
                File fXmlFile = new File(this.hardWiredFilePath + "validUsers.xml");
                DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                DocumentBuilder dBuilder = null;

                dBuilder = dbFactory.newDocumentBuilder();


                Document doc = dBuilder.parse(fXmlFile);
                doc.getDocumentElement().normalize();

                NodeList nList = doc.getElementsByTagName("valid-user-id");

                for (int temp = 0; temp < nList.getLength(); temp++) {

                    Node nNode = nList.item(temp);
                    NodeList fstNm = nNode.getChildNodes();
                    user_id_from_xml = ((Node) fstNm.item(0)).getNodeValue();
                    if (user_id_from_xml.equalsIgnoreCase(user_id)) {
                        return true;
                    }
                }

                return false;
            } catch (Exception e) {
                System.out.println(e.toString());
                return false;
            }
        }

public String getRedirectUrl(HttpServletRequest req) {
    // https://edg.epa.gov/MyWebApp/PathTo/MyServlet/More/To/Consume?s=lobster
    String contextPath = req.getContextPath();   // /MyWebApp
    String servletPath = req.getServletPath();   // /PathTo/MyServlet
    String pathInfo = req.getPathInfo();         // /More/To/Consume
    String queryString = req.getQueryString();   // s=lobster

    String url = contextPath+servletPath;

    if (pathInfo != null) {
        url += pathInfo;
    }
    if (queryString != null) {
        url += "?"+queryString;
    }
    return url;
}




        public String[] verifyUser(HttpServletRequest request, String headerIndex) {
            String returnVal[] = new String[3];

            if (headerIndex.indexOf(".") != -1) {
                headerIndex = headerIndex.substring(headerIndex.indexOf(".") + 1);
            } else {
                headerIndex = "uid";
            }

            String uid = null;
            boolean uidHeaderExists = false;
            Enumeration headerNames = request.getHeaderNames();

            while (headerNames.hasMoreElements()) {
                String headerName = (String) headerNames.nextElement();
                headerName = headerName.trim();
                if (headerName.equals(headerIndex)) {
                    uidHeaderExists = true;
                    uid = request.getHeader(headerIndex);
                    break;
                }
            }

              returnVal[0] = "true";
              returnVal[1] = "restricted";//users validated by header id can be allowed to access restricted info too
              returnVal[2] = null;
            return returnVal;
            
/*
            if (!uidHeaderExists) {
                returnVal[0] = "false";
		returnVal[1] = "Please <A href=\"/sso/login?sso_redirect="  + getRedirectUrl(request) + "\" >login</A> to view this page.";
                returnVal[2] = "Authorization Failure";
                return returnVal;
                
            } else {
                if (!(this.verifyUserID(uid))) {
                    if (uid.equalsIgnoreCase("OblixAnonymous")) {
                        returnVal[0] = "false";
                        returnVal[1] = "You must <A href=\"/sso/login?sso_redirect="  + getRedirectUrl(request) + "\" >login</A> to EDG to access this content.";
                        returnVal[2] = "Information";
                        return returnVal;
                    }
                    returnVal[0] = "false";
                    returnVal[1] = "Your user id \"" + uid + "\" is not allowed to access this page.";
                    returnVal[2] = "Authorization Failure";
                    return returnVal;
                }
            }
           // returnVal[0] = "true";
           // returnVal[1] = "restricted";//users validated by header id can be allowed to access restricted info too
           // returnVal[2] = null;
            
            return returnVal;
*/
        }

        public String[] verify(HttpServletRequest request) {
            String method = this.servletContext.getInitParameter("authenLoc");
            String[] returnVal = new String[2];

            if (method.substring(0, 6).equalsIgnoreCase("header")) {
                return verifyUser(request, method);
            } else if (method.substring(0, 5).equalsIgnoreCase("fixed")) {
                returnVal[0] = "true";
                returnVal[1] = method.substring(method.indexOf(".") + 1);
                return returnVal;
            }
            returnVal[0] = "false";
            returnVal[1] = "Header missing";
            returnVal[2] = "Authorization Failure";
        
            return returnVal;
        }
    }
%>
