<%@ page import = "java.io.*"%><%@ page import = "java.sql.*"%><%@ page import = "org.apache.xpath.*"%><%@ page
import = "javax.xml.parsers.*"%><%@ page import = "javax.xml.transform.*"%><%@ page
import = "javax.xml.transform.stream.*"%><%@ page import = "org.w3c.dom.*"%><%@ page
import = "org.apache.commons.lang.*"%><%@ page import = "java.net.*"%><%@ page
import = "org.xml.sax.InputSource"%><%@ page import = "org.apache.commons.httpclient.*"%><%@ page
import = "org.apache.commons.httpclient.auth.*"%><%@ page
import = "org.apache.commons.httpclient.methods.*"%><%@ page import = "org.apache.commons.net.ftp.*"%><%@ page
import = "java.lang.Byte"%><%@ page import = "java.util.ArrayList"%><%@ page import = "java.util.zip.*"%><%@ page
import = "org.apache.commons.codec.binary.Base64"%><% class Utils
       {
       String user = "";
       String pwd = "";
       String enc = "ISO8859_1";
       FTPClient ftp = new FTPClient();

       public Node getFolderConfig(String folderName)
           {
           try
               {
               DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
               domFactory.setNamespaceAware(true);
               DocumentBuilder builder = domFactory.newDocumentBuilder();
               Document doc = builder.parse(internal("wafconfig.xml"));

// AE: 2007/01/23 - We disabled use of javax.xml.xpath due to problematic JAXP configuration on production server.
               /*
                           XPathFactory factory = XPathFactory.newInstance();
                           XPath xpath = factory.newXPath();
                           XPathExpression expr = xpath.compile("//SOURCE[@shortName='"+folderName+"']");
                           NodeList nodes = (NodeList)expr.evaluate(doc, XPathConstants.NODESET);
               */
               // AE: 2007/01/23 - We now use org.apache.xpath directly instead of newer JAXP
               NodeList nodes = XPathAPI.eval(doc, "//SOURCE[@shortName='" + folderName + "']").nodelist();

               if (nodes.getLength() > 0)
                   return nodes.item(0);
               }
           catch (Exception exception)
               {
               System.out.println("Error::getFolderConfig::" + exception.getMessage());
               }
           return null;
           }

       public String xform(String xmlStr,
           String xslUrl) throws TransformerException, TransformerConfigurationException, FileNotFoundException,
           IOException
           {
           // Do nothing if no stylesheet given.
           if (xslUrl.equals(""))
               return xmlStr;

           try
               {
               xslUrl = "webapps/" + contextName + "/" + xslUrl;
               TransformerFactory tFactory = TransformerFactory.newInstance();
               Transformer transformer = tFactory.newTransformer(new StreamSource(xslUrl));
               ByteArrayOutputStream baos = new ByteArrayOutputStream();
               transformer.transform(new StreamSource(new StringReader(xmlStr)), new StreamResult(baos));
               return (baos.toString());
               }
           catch (TransformerException ex)
               {
               System.out.println("Error::xform::" + ex.toString());
               }
           return "XML transformation failed";
           }


       // Return the given xml string with the given stylesheet reference inserted in.
       // TO DO: Override existing reference.
       String applyStylesheet(String xmlStr, String ss)
           {
           // Do nothing if no stylesheet given.
           if (ss.equals(""))
               return xmlStr;

           // Do nothing if we can't find the <metadata> tag.
           // Note: we currently only support CSDGM for applying a stylesheet
           if (xmlStr.indexOf("<metadata>") < 0)
               return xmlStr;

           // Split xml at the end of last processing instruction and beginning of first tag.
           String parts [] = xmlStr.split("\\?>\\s*<(?!\\?)", 3);

           // Do nothing if malformed. We expect two parts of which only the first may be empty.
           if (parts.length == 3 || parts[parts.length - 1].length() == 0)
               return xmlStr;

           // If first part is empty, that means no xml declaration - so insert it
           if (parts[0].length() == 0)
               parts[0] = "<?xml version=\"1.0\" ";

           // If no stylesheet pi, then insert (rather append) it.
           if (parts[0].indexOf("?xml-stylesheet ") < 0)
               parts[0] = parts[0] + "?>\r\n<?xml-stylesheet type=\"text/xsl\" href=\"" + ss + "\"";

           return StringUtils.join(parts, "?>\r\n<");
           }

       public String getUrlContentsWithPostOrig(String targetUrl, String postData) throws Exception
           {
           try
               {
               Boolean doOutput = true;

               if (postData == null || postData.equals(""))
                   doOutput = false;

               // Send data
               URL url = new URL(targetUrl);
               URLConnection conn = url.openConnection();
               conn.setDoOutput(doOutput);
               conn.setConnectTimeout(3 * 1000); // not supported in 1.4.2

               if (doOutput)
                   conn.setRequestProperty("Content-Type", "text/xml");
               conn.connect();

               if (doOutput)
                   {
                   OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
                   wr.write(postData);
                   wr.flush();
                   //wr.close();
                   }

               // Get the response
               BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String response = "";
               String line;

               while ((line = rd.readLine()) != null)
                   {
                   response += line;
                   }
               rd.close();
               return (response);
               }
           catch (Exception e)
               {
               if (e instanceof SocketTimeoutException)
                   System.out.println(
                       "Error::getUrlContentsWithPost::SocketTimeoutException while trying to communicate with URL "
                       + targetUrl);

               else
                   System.out.println("Error::getUrlContentsWithPost::Exception while trying to communicate with URL "
                       + targetUrl);
               }
           return "";
           }

       public String getUrlContentsWithPost(String targetUrl, String postData) throws Exception
           {
           HttpMethodBase method = null;

           try
               {
               Boolean doOutput = true;

               if (postData == null || postData.equals(""))
                   doOutput = false;

               HttpClient client = new HttpClient();
               client.setConnectionTimeout(3 * 1000); // 3 seconds.

               if (user != null && !user.trim().equals(""))
                   {
                   client.getParams().setAuthenticationPreemptive(true);
                   Credentials defaultcreds = new UsernamePasswordCredentials(user, pwd);
                   client.getState().setCredentials(AuthScope.ANY, defaultcreds);
                   }

               if (doOutput)
                   {
                   method = new PostMethod(targetUrl);
                   ((PostMethod)method).setRequestEntity(new StringRequestEntity(postData, "text/xml", null));
                   }

               else
                   method = new GetMethod(targetUrl);

               int statusCode = client.executeMethod(method);

               if (statusCode == HttpStatus.SC_OK)
                   return new String(method.getResponseBody());

               else
                   System.out.println("Method failed: " + method.getStatusLine());
               }
           catch (Exception e)
               {
               if (e instanceof SocketTimeoutException)
                   System.out.println(
                       "Error::getUrlContentsWithPost::SocketTimeoutException while trying to communicate with URL "
                       + targetUrl);

               else
                   System.out.println("Error::getUrlContentsWithPost::Exception while trying to communicate with URL "
                       + targetUrl);
               System.out.println(e.getMessage());
               }
           finally
               {
               if (method != null)
                   method.releaseConnection();
               }
           return "";
           }

       void extractMd(byte bytesOut [], int outLen, byte bytesIn [], int inOffset, int inLen)
           {
           try
               {
               Inflater inf = new Inflater();
               inf.setInput(bytesIn, inOffset, inLen);
               inf.inflate(bytesOut, 0, outLen);

               if (!inf.finished())
                   System.out.println("Error::extractMd::not finished!");
               }
           catch (DataFormatException ex)
               {
               System.out.println("Error::extractMd::" + ex.getMessage());
               }
           }

       int dataLengthFromPackedInt(byte [] bytes)
           {
           return (bytes[0] & 0x3F) + 64 * (bytes[1] & 0x7F) + 8192 * (bytes[2] & 0x7F) + 1048576 * (bytes[3] & 0x7F)
               + 134217728 * (bytes[4] & 0x7F);
           }


       // Reconstruct md stored in ESRI compressed binary format
       String mdFromBinary(byte [] mdBytes)
           {
           String xmlStr = "";

           try
               {

               // Data length is represented as a packed int.
               int dataLen = dataLengthFromPackedInt(mdBytes);
               // Allocate enough space.
               byte [] bytesOut = new byte[dataLen];
               // Expand md out of compressed binary.
               extractMd(bytesOut, dataLen, mdBytes, 8, mdBytes.length - 8);
               xmlStr = (new String(bytesOut, enc)).trim();


               /*
               byte[] b = bytesOut;
               xmlStr = new String(b, "UTF-8");
               int i1 = xmlStr.indexOf("caldate>1905");
                      System.out.println(i1);
               for(int i2=i1; i2<i1+22; i2++)
                      System.out.println("" + (0xFF & b[i2]) + ": " + (char)(0xFF & b[i2]));
               */


               // Special case where original md has been stuffed in a tag in base64 format in processed md.
               int idx1 = xmlStr.indexOf("<Binary><Enclosure><Data");

               if (idx1 >= 0)
                   {
                   idx1 = xmlStr.indexOf(">", idx1 + "<Binary><Enclosure><Data".length()) + 1;
                   int idx2 = xmlStr.indexOf("</Data></Enclosure></Binary>");

                   xmlStr = xmlStr.substring(idx1, idx2).replace("&#13;", "" + (char)13);
                   Base64 un64 = new Base64();
                   xmlStr = new String(un64.decode(xmlStr.getBytes()));
                   }
               }
           catch (Exception ex)
               {
               System.out.println("Error::mdFromBinary::" + ex.getMessage());
               //xmlStr = new String(un64.decode(xmlStr.getBytes()));
               }

           return xmlStr;
           }

       //public void retrieveSdeMetadata(int i, String metadataTable, String jdbcDriver, String jdbcUrl, String user,
       public void retrieveSdeMetadata(String id, String metadataTable, String jdbcDriver, String jdbcUrl, String user,
           String pwd, String xmlReadMethod, String hrefStylesheet, JspWriter writer)
           {
           try
               {
               Class.forName(jdbcDriver);
               Connection connection = DriverManager.getConnection(jdbcUrl, user, pwd);

               PreparedStatement xmlStmt =
                   connection.prepareStatement("select XML from " + metadataTable + " where ID = ?");
               //System.out.println(id);
               //xmlStmt.setInt(1, i);
               xmlStmt.setString(1, id);
               ResultSet rs = xmlStmt.executeQuery();

               while (rs.next())
                   {
                   String xmlStr = "";

                   // Use the right method to read content.
                   if (xmlReadMethod.equals("string"))
                       xmlStr = rs.getString(1);

                   else if (xmlReadMethod.equals("binary"))
                       xmlStr = mdFromBinary(rs.getBytes(1));

                   else
                       xmlStr = new String(rs.getBytes(1));

                   //writer.println(applyStylesheet(xmlStr, hrefStylesheet));
                   xmlStr = removeDOCTYPE(xmlStr);
                   writer.println(xform(xmlStr, hrefStylesheet));
                   }

               if (rs != null)
                   rs.close();

               if (xmlStmt != null)
                   xmlStmt.close();

               if (connection != null)
                   connection.close();

	       //Driver driver = DriverManager.getDriver(jdbcUrl);
	       //DriverManager.deregisterDriver(driver);
               }
           catch (SQLException sqlexception)
               {
               System.out.println("Error::getMetadata::" + sqlexception.getMessage());

               while ((sqlexception = sqlexception.getNextException()) != null)
                   System.out.println("Error::getMetadata::" + sqlexception.getMessage());
               System.out.println("Error::getMetadata::" + sqlexception.getSQLState());
               }
           catch (Exception exception)
               {
               System.out.println("Error::retrieveSdeMetadata::" + exception.getMessage());
               }
           }

       public void retrieveArcimsMetadata(String docid, String serviceUrl, String hrefStylesheet, JspWriter writer)
           {
           try
               {
               String postXml =
                   "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ARCXML><REQUEST><GET_METADATA><GET_METADATA_DOCUMENT docid=\""
                   + docid + "\" /></GET_METADATA></REQUEST></ARCXML>";
               //System.out.println(postXml);
               String responseXml = getUrlContentsWithPost(serviceUrl, postXml);
               //System.out.println(responseXml);

               DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
               domFactory.setNamespaceAware(true);
               DocumentBuilder builder = domFactory.newDocumentBuilder();
               Document doc = builder.parse(new InputSource(new StringReader(responseXml)));

               NodeList nodes = XPathAPI.eval(doc, "//METADATA_DATASET").nodelist();

               for (int i = 0; i < nodes.getLength(); i++)
                   {
                   final String mdUrl = nodes.item(i).getAttributes().getNamedItem("url").getNodeValue();
                   //System.out.println(mdUrl);
                   String md = getUrlContentsWithPost(mdUrl, null);
                   //System.out.println(md);
                   // Returned metadata appear to be in ISO-8859-1 even if metadata says UTF-8, so switch around.
                   md = md.replaceFirst(" encoding=\"UTF-8", " encoding=\"ISO-8859-1");
                   md = removeDOCTYPE(md);
                   writer.println(xform(md, hrefStylesheet));
                   }
               }
           catch (Exception exception)
               {
               System.out.println("Error::retrieveArcimsMetadata::" + exception.getMessage());
               }
           }

       public void retrieveWafMetadata(String docid, String serviceUrl, String hrefStylesheet, JspWriter writer)
           {
           try
               {
               //System.out.println(serviceUrl);
               //System.out.println(docid);

               // If docid contains absolute reference or full url, we need to prep for that
               if (docid.startsWith("/"))
                   {
                   URL url = new URL(serviceUrl);
                   serviceUrl = url.getProtocol() + "://" + url.getHost();

                   if (url.getPort() > 0)
                       serviceUrl += ":" + url.getPort();
                   }

               String responseXml = getUrlContentsWithPost(serviceUrl + docid, null);
               responseXml = removeDOCTYPE(responseXml);
               //System.out.println(responseXml);

               writer.println(xform(responseXml, hrefStylesheet));
               }
           catch (Exception exception)
               {
               System.out.println("Error::retrieveWafMetadata::" + exception.getMessage());
               }
           }

       public void retrieveFtpMetadata(String docid, String serviceUrl, String hrefStylesheet, JspWriter writer)
           {
           try
               {
               System.out.println(serviceUrl);
               System.out.println(docid);

               String responseXml = getFtpUrlContents(serviceUrl + docid);
               responseXml = removeDOCTYPE(responseXml);
               //System.out.println(responseXml);

               writer.println(xform(responseXml, hrefStylesheet));
               }
           catch (Exception exception)
               {
               System.out.println("Error::retrieveFtpMetadata::" + exception.getMessage());
               }
           }

       public String getFtpUrlContents(String fullUrl)
           {
           // return the contents of the file pointed to by fullUrl as a String

           if ((fullUrl == null) || (fullUrl.length() == 0))
               {
               System.out.println("Error: Empty fullUrl");
               return null;
               }

           if (fullUrl.startsWith("ftp://"))
               fullUrl = fullUrl.substring(6);

           // extract server name
           String serverName = "";
           String dirPath = "";

           int frstSlsh = fullUrl.indexOf("/");
           int lastSlsh = fullUrl.lastIndexOf("/");

           if ((frstSlsh == -1) || (lastSlsh == -1))
               {
               System.out.println("Error: Illegal fullUrl - no server name and full path");
               return null;
               }
           String thisServerName = fullUrl.substring(0, frstSlsh);
           String workingDir = "";

           if (frstSlsh != lastSlsh)
               workingDir = fullUrl.substring(frstSlsh, lastSlsh);
           String fname = fullUrl.substring(lastSlsh + 1);

           try
               {
               //System.out.println("@@@@@");
               //System.out.println(thisServerName);
               //System.out.println(workingDir);
               //System.out.println(fname);
               if (!thisServerName.equals(serverName) || !ftp.isConnected())
                   {
                   // connect again
                   if (!connect(thisServerName, user, pwd))
                       return null;
                   }
               boolean changeDirOk = ftp.changeWorkingDirectory(workingDir);

               if (!changeDirOk)
                   {
                   System.out.println("Error: changeWorkingDirectory failed for workingDir " + workingDir);
                   return null;
                   }

               boolean fileTypeChanged = ftp.setFileType(FTP.BINARY_FILE_TYPE);

               if (!fileTypeChanged)
                   {
                   System.out.println("Error: setFileType failed ");
                   return null;
                   }

               ByteArrayOutputStream local = new ByteArrayOutputStream();
               boolean gotOk = ftp.retrieveFile(fname, local);

               if (!gotOk)
                   {
                   System.out.println("Error: retrieveFile failed for fname " + fname);
                   return null;
                   }
               disconnect();
               return local.toString("ISO8859_1");
               }
           catch (Exception e)
               {
               System.out.println("Error: Exception in getFile: " + e.getMessage());
               e.printStackTrace();

               try
                   {
                   ftp.logout();
                   }
               catch (Exception lo)
                   {
                   }

               if (ftp.isConnected())
                   {
                   try
                       {
                       ftp.disconnect();
                       }
                   catch (Exception ioe)
                       {
                       }
                   }
               return null;
               }
           }

       private boolean connect(String serverName, String username, String password) throws Exception
           {

           ftp.connect(serverName);
           int reply = ftp.getReplyCode();

           if (!FTPReply.isPositiveCompletion(reply))
               {
               System.out.println("Error: Bad connection reply");
               ftp.disconnect();
               return false;
               }

           if ((username == null) || (username.length() == 0) || (password == null) || (password.length() == 0))
               {
               username = "anonymous";
               password = "";
               }
           boolean loginOk = ftp.login(username, password);

           if (!loginOk)
               {
               System.out.println("Error: login failed for username " + username + " and password " + password);

               if (ftp.isConnected())
                   {
                   try
                       {
                       ftp.disconnect();
                       }
                   catch (Exception ioe)
                       {
                       }
                   }
               return false;
               }
           ftp.enterLocalPassiveMode();
           return true;
           }

       public void disconnect()
           {
           try
               {
               ftp.logout();
               }
           catch (Exception lo)
               {
               }

           if (ftp.isConnected())
               {
               try
                   {
                   ftp.disconnect();
                   }
               catch (Exception ioe)
                   {
                   }
               }
           }


       // Utility function for getting the filesystem path to an internal file
       public String internal(String fileName)
           {
              return "webapps/" + contextName + "/internal/" + fileName;
           }

       // Utility function for getting the filesystem path to an internal file
       public String internal2(String fileName)
           {
           return "http://localhost:" + 8080 + "/" + contextName + "/internal/" + fileName;
           }

       // Utility function for getting attribute value from the first node in a list
       public String getAttr(Node node, String attrName)
           {
           //return node.getAttributes().getNamedItem(attrName).getNodeValue();
           Node n = node.getAttributes().getNamedItem(attrName);

           if (n != null)
               return n.getNodeValue();

           return "";
           }


       // Utility function for reporting error in XML format
       public Boolean isSafeUrl(String docid, String serviceUrl)
           {
           if (docid.contains("../") || //against url hierarchy up-traversal via ../
           docid.contains(":\\") ||     //against local drive refs like C:\
           docid.startsWith("\\")       //against absolute local refs
           )
               return false;

           if (docid.startsWith("/") && //against absolute refs
           !docid.toLowerCase().startsWith("/metadata/"))
               return false;

           //docid.contains("://") || 	//against http:// ftp://

           return true;
           }


       // Utility function for reporting error in XML format
       public void XmlError(HttpServletResponse response, JspWriter writer, String errStr) throws IOException
           {
           response.setContentType("text/xml");
           writer.println("<?xml version=\"1.0\" ?><ERROR>" + StringEscapeUtils.escapeXml(errStr) + "</ERROR>");
           }

       public String contextName;
       public String serverPort;

       // Utility function to determine WAF folder based on context URI
       public void initContextName(HttpServletRequest request)
           {
           contextName = request.getContextPath().substring(1);
           serverPort = Integer.toString(request.getLocalPort());
           }


       // Utility function for removing DOCTYPE declaration from metadata
       public String removeDOCTYPE(String md)
           {
           int i = md.indexOf("<!--<!DOCTYPE ");

           if (i < 0)
               i = md.indexOf("<!DOCTYPE ");

           if (i < 0)
               return md;
           int j = md.indexOf("<", i + 7);

           if (j < 0)
               return md;
           return md.substring(0, i) + md.substring(j);
           }
       }

   Utils u = new Utils();

   u.initContextName(request);

   String folder = request.getParameter("folder");
   // Normally, the following is a no-op. It will serve to sanitize URL parameter 'folder' if special
   // characters have been inserted.
   folder = StringEscapeUtils.escapeXml(folder);

   if (folder != null)
       {
       Node node = u.getFolderConfig(folder);

       if (node != null)
           {
           try
               {
               // If no stylesheet, default to xml.
               if (u.getAttr(node, "hrefStylesheet").equals(""))
                   response.setContentType("text/xml");

               // Determine character encoding to use.
               u.enc = u.getAttr(node, "characterEncoding");

               if (u.enc.equals(""))
                   u.enc = "ISO8859_1";
               response.setCharacterEncoding(u.enc);

               String docid = request.getParameter("id");
               docid = StringEscapeUtils.unescapeHtml(docid);

               String sourceType = u.getAttr(node, "type");

               u.user = u.getAttr(node, "user");
               u.pwd = u.getAttr(node, "pwd");

               if (sourceType.equalsIgnoreCase("ARCIMS"))
                   {
                   docid = docid.substring(0, docid.indexOf("_"));

                   // Check the id for proper form and to prevent URL engineering
                   if (docid.matches(
                       "\\{([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})}"))
                       {
                       u.retrieveArcimsMetadata(docid, u.getAttr(node, "serviceUrl"), u.getAttr(node, "hrefStylesheet"),
                           out);
                       }

                   else
                       u.XmlError(response, out, "Malformed document identifier!");
                   }

               else if (sourceType.equalsIgnoreCase("WAF"))
                   {
                   String serviceUrl = u.getAttr(node, "serviceUrl");

                   if (docid.contains(".xml"))
                       docid = docid.substring(0, docid.length() - 4);
                   docid = docid.substring(0, docid.lastIndexOf(".xml_") + 4);

                   // Check the id for questionable patterns to prevent URL engineering
                   if (u.isSafeUrl(docid, serviceUrl))
                       {
                       u.retrieveWafMetadata(docid, serviceUrl, u.getAttr(node, "hrefStylesheet"), out);
                       }

                   else
                       u.XmlError(response, out, "Malformed document identifier!");
                   }

               else if (sourceType.equalsIgnoreCase("FTP"))
                   {
                   String serviceUrl = u.getAttr(node, "serviceUrl");

                   if (docid.contains(".xml"))
                       docid = docid.substring(0, docid.length() - 4);
                   docid = docid.substring(0, docid.lastIndexOf(".xml_") + 4);

                   // Check the id for questionable patterns to prevent URL engineering
                   if (u.isSafeUrl(docid, serviceUrl))
                       {
                       u.retrieveFtpMetadata(docid, serviceUrl, u.getAttr(node, "hrefStylesheet"), out);
                       }

                   else
                       u.XmlError(response, out, "Malformed document identifier!");
                   }

               else if (sourceType.equalsIgnoreCase("GEODB"))
                   {
                   docid = docid.substring(0, docid.indexOf("_"));
                   // Casting to int is sure to prevent URL engineering
                   //int docid_int = Integer.parseInt(docid);

		   // Limit id to an integer value (up to 22 digits) or a GUID (with brackets)
		   if(docid.matches("(\\d){1,22}") || docid.matches("(\\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\\}{0,1})"))
                   u.retrieveSdeMetadata(docid, u.getAttr(node, "metadataTable"), u.getAttr(node, "jdbcDriver"),
                       u.getAttr(node, "jdbcUrl"), u.getAttr(node, "user"), u.getAttr(node, "pwd"),
                       u.getAttr(node, "xmlReadMethod"), u.getAttr(node, "hrefStylesheet"), out);
		   else
		   {
			System.out.println("URL parameter 'id' is required to have a valid value! ");
			u.XmlError(response, out, "URL parameter 'id' is required to have a valid value! ");
		   }
                   }
               }
           catch (Exception e)
               {
               u.XmlError(response, out, "Error during processing: " + e.toString());
               }
           }

       else
           u.XmlError(response, out, "Folder " + request.getParameter("folder") + " not found!");
       }

   else
       u.XmlError(response, out, "URL parameter 'folder' is required!");

   /*
   */
   %>

