<%@ page contentType = "text/html" %>
<%@ page import = "java.io.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "java.text.*"%>
<%@ page import = "org.apache.xpath.*"%>
<%@ page import = "javax.xml.parsers.*"%>
<%@ page import = "javax.xml.transform.*"%>
<%@ page import = "javax.xml.transform.stream.*"%>
<%@ page import = "org.w3c.dom.*"%>
<%@ page import = "org.xml.sax.InputSource"%>
<%@ page import = "java.io.*"%>
<%@ page import = "org.htmlcleaner.*"%>
<%@ page import = "org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import = "org.apache.commons.httpclient.*"%>
<%@ page import = "org.apache.commons.httpclient.auth.*"%>
<%@ page import = "org.apache.commons.httpclient.methods.*"%>
<%@ page import = "org.apache.commons.net.ftp.*"%>
<%@ page import = "java.util.logging.Logger"%>
<HTML>
    <HEAD>
        <title>EPA Metadata Browser</title>
    </HEAD>

    <style type = "text/css">
        body
            {
            color: #524123;
            background: #c5e894;
            }

        error
            {
            background-color: #FF3300;
            color: #FFFFFF;
            }
    </style>

    <BODY>
	    <%


	    class Utils
            {
            String user = "";
            String pwd = "";
            Boolean usePreemptiveAuth = true;
            String cookies = "";
            FTPClient ftp = new FTPClient();
            private Logger log = Logger.getLogger("com.esri.gpt");

            public Node getFolderConfig(String folderName)
                {
                try
                    {
                    System.out.println("Baohong:: inside index.getFolderConfig" + folderName);
                    DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
                    domFactory.setNamespaceAware(true);
                    DocumentBuilder builder = domFactory.newDocumentBuilder();
                    Document doc = builder.parse(internal2("wafconfig.xml"));//on my local should be internal2

                    // AE: 2007/01/23 - We disabled use of javax.xml.xpath due to problematic JAXP
                    // configuration on production server.
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


            // return text wrapped in CDATA safe for xml
            public String wrapForXml(String txt)
                {
                return "<![CDATA[" + txt + "]]>";
                }

            public List availableSdeLayers(String folder, String metadataTable, String jdbcDriver, String jdbcUrl,
                String user, String pwd, String longName)
                {
                List<List<String> > layers = new ArrayList();

                try
                    {
                    Class.forName(jdbcDriver);
                    Connection connection = DriverManager.getConnection(jdbcUrl, user, pwd);

                    // gets driver info:
                    System.out.println("JDBC driver version is " + connection.getMetaData().getDriverVersion());

                    Statement statement = connection.createStatement();
                    ResultSet resultset =
                        statement.executeQuery("select id, name from " + metadataTable + "  order by name");

                    for (;resultset.next(); )
                        {
                        final String id = resultset.getString(1);
                        final String name = resultset.getString(2);
                        layers.add(new ArrayList<String> ()
                            {
                            {
                                add(id);
                            add(name);
                            }
                            });
                        }

                    if (resultset != null)
                        resultset.close();

                    if (statement != null)
                        statement.close();

                    if (connection != null)
                        connection.close();
                    }
                catch (SQLException sqlexception)
                    {
                    System.out.println("Error::availableSdeLayers::" + sqlexception.getMessage());

                    while ((sqlexception = sqlexception.getNextException()) != null)
                        System.out.println("Error::availableSdeLayers::" + sqlexception.getMessage());
                    }
                catch (Exception exception)
                    {
                    System.out.println("Error::availableSdeLayers::" + exception.getMessage());
                    }
                return layers;
                }

            public List availableArcimsLayers(String folder, String serviceUrl, String longName)
                {
                List<List<String> > layers = new ArrayList();

                try
                    {
                    String postXml =
                        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ARCXML><REQUEST><GET_METADATA><SEARCH_METADATA foldermask=\"4\" fulloutput=\"false\" thumbnail=\"false\"></SEARCH_METADATA></GET_METADATA></REQUEST></ARCXML>";
                    String responseXml = getUrlContentsWithPost(serviceUrl, postXml);
                    //System.out.println(postXml);
                    //System.out.println(responseXml);

                    DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
                    domFactory.setNamespaceAware(true);
                    DocumentBuilder builder = domFactory.newDocumentBuilder();
                    Document doc = builder.parse(new InputSource(new StringReader(responseXml)));

                    NodeList nodes = XPathAPI.eval(doc, "//METADATA_DATASET").nodelist();

                    for (int i = 0; i < nodes.getLength(); i++)
                        {
                        //System.out.println(">"+i);
                        final String id = nodes.item(i).getAttributes().getNamedItem("docid").getNodeValue();
                        String tmpName = nodes.item(i).getAttributes().getNamedItem("name").getNodeValue();
                        final String name = tmpName;
                        layers.add(new ArrayList<String> ()
                            {
                            {
                                add(java.net.URLEncoder.encode(id));
                            add(name);
                            }
                            });
                        }
                    }
                catch (Exception exception)
                    {
                    System.out.println("Error::availableArcimsLayers::" + exception.getMessage());
                    }
                return layers;
                }


            // Return the base part of the url http://www.xyz.com:8080/test?a=1  =>  http://www.xyz.com:8080
            public String getBase(String urlStr)
                {
                try
                    {
                    System.out.println("Baohong:: inside index.getBase" + urlStr);
                    if (urlStr.startsWith("/"))
                        return "";

                    URL url = new URL(urlStr);
                    urlStr = url.getProtocol() + "://" + url.getHost();

                    if (url.getPort() > 0)
                        urlStr += ":" + url.getPort();
                    return urlStr;
                    }
                catch (Exception exception)
                    {
                    System.out.println("Error::getBase::" + exception.getMessage());
                    }
                return "";
                }


            // Return a url with parts joined (dealing with the slash in between as necessary)
            public String joinUrl(String urlStart, String urlEnd)
                {
                if (urlStart.endsWith("/"))
                    if (urlEnd.startsWith("/"))
                        return urlStart + urlEnd.substring(1);

                    else
                        return urlStart + urlEnd;

                else if (urlEnd.startsWith("/"))
                    return urlStart + urlEnd;

                else
                    return urlStart + "/" + urlEnd;
                }


// Return the fully qualified form of the given url using the given base url
// /public/metadata/FRS , http://www.mymetadata.com:8080/public =>  http://www.mymetadata.com:8080/public/metadata/FRS
// metadata/FRS , http://www.mymetadata.com:8080/public =>  http://www.mymetadata.com:8080/public/metadata/FRS
            public String fullyQualifyUrl(String urlStr, String baseUrl)
                {
                try
                    {
                    // Case where url is absolute
                    System.out.println("Baohong:: inside index.fullyQualifyUrl" + urlStr);
                    if (urlStr.startsWith("/"))
                        {
                        String baseUrlBase = getBase(baseUrl);
                        String baseUrlRest = baseUrl.substring(baseUrlBase.length());

                        // If given url is absolute yet it does not match relevant component of the service url
                        // then there is a problem.
                        if (!urlStr.startsWith(baseUrlRest))
                            return null;

                        return joinUrl(baseUrlBase, urlStr);
                        }

                    // Case where url is fully qualified
                    else if (urlStr.contains("://"))
                        {
                        // Make sure fully qualified url matches up with the base url
                        if (!urlStr.startsWith(baseUrl))
                            return null;

                        return urlStr;
                        }

                    // Case where url is relative
                    else
                        {
                        return joinUrl(baseUrl, urlStr);
                        }
                    }
                catch (Exception exception)
                    {
                    System.out.println("Error::getBase::" + exception.getMessage());
                    }
                return null;
                }

            public void processDir(String currentDir, List<String> dirs, List<String> processedDirs,
                List<List<String> > layers, String serviceUrl)
                {
                final HtmlCleaner cleaner = new HtmlCleaner();
                final int cropLength = serviceUrl.length();

                try
                    {
                        System.out.println("Baohong:: inside index.processDir" );

                    TagNode node = cleaner.clean(getUrlContentsWithPost(currentDir, null));
                    //		TagNode node = cleaner.clean(new URL(currentDir));
                    Object [] nodes = node.evaluateXPath("//A");

                    //System.out.println("Found " + nodes.length + " HREFs");
                    for (int i = 0; i < nodes.length; i++)
                        {
                        TagNode currentNode = (TagNode)nodes[i];
                        final String id = fullyQualifyUrl(currentNode.getAttributeByName("href"), serviceUrl);

                        //System.out.println(id);
                        if (id == null)
                            continue;

                        String tmpName = currentNode.getText().toString();

                        if (tmpName.endsWith("..&gt;"))
                            tmpName = tmpName.substring(0, tmpName.length() - 6);
                        final String name = tmpName;

                        //System.out.println(name);
                        if (id.toLowerCase().endsWith(".xml"))
                            {
                            layers.add(new ArrayList<String> ()
                                {
                                {
                                    add(java.net.URLEncoder.encode(id.substring(cropLength)));
                                add(name);
                                }
                                });
                            }

                        else if (id.endsWith("/"))
                            {
                            // If this is a dir that we have not seen before, then add for processing.
                            if (!dirs.contains(id) && !processedDirs.contains(id))
                                {
                                //System.out.println("Adding dir: " + id);
                                dirs.add(id);
                                }
                            }

                        else
                            {
                            //System.out.println("Not sure what to do with dir: " + id);
                            }
                        }
                    }
                catch (Exception e)
                    {
                    System.out.println("Error::processDir::" + e.getMessage());
                    }
                }

            public List availableWafLayers(String folder, String serviceUrl, String longName)
                {
                List<List<String> > layers = new ArrayList();
                List<String> dirs = new ArrayList();
                List<String> processedDirs = new ArrayList();
                dirs.add(serviceUrl);

                try
                    {
                    while (dirs.size() > 0)
                        {
                        String currentDir = dirs.remove(0);

                        //System.out.println("Processing::" + currentDir);
                        if (getBase(currentDir).equals(""))
                            currentDir = getBase(serviceUrl) + currentDir;
                        processedDirs.add(currentDir);
                        processDir(currentDir, dirs, processedDirs, layers, serviceUrl);
                        }
                    }
                catch (Exception exception)
                    {
                    System.out.println("Error::availableWafLayers::" + exception.getMessage());
                    }
                return layers;
                }

            String makeLengthLimitedName(String id, String name)
                {
                int limit = 160;

                if (id.length() + name.length() > limit)
                    if (id.length() < limit)
                        name = name.substring(0, limit - id.length());

                    else
                        name = ""; //Can't cut down more than this...

                if (!name.endsWith(".xml"))
                    name += ".xml";

                return name;
                }

            public String layers2Xml(List<List<String> > layers, String folder, String longName)
                {
                StringBuffer sb = new StringBuffer();

                try
                    {
		    //SimpleDateFormat df = new SimpleDateFormat();
                    sb.append("<datalayers folder=\"" + folder + "\" longName=\"" + longName + "\" >");

                    for (int i = 0; i < layers.size(); i++)
                        {
                        List<String> layer = layers.get(i);
                        String id = StringEscapeUtils.escapeXml(layer.get(0));
                        String name = layer.get(1);

                        if (!name.endsWith(".xml"))
                            name += ".xml";

                        sb.append("<datalayer>");
                        sb.append("<datasetid>");
                        sb.append(id);
                        sb.append("</datasetid><layername encoded=\""
			+ makeLengthLimitedName(id, java.net.URLEncoder.encode(name)) + "\" >");
                        sb.append(wrapForXml(name));
                        sb.append("</layername>");
                        sb.append("<metadatadate>");
			    sb.append(DateFormat.getDateTimeInstance().format(new java.util.Date()));
                        sb.append("</metadatadate>");
                        sb.append("</datalayer>");
                        }
                    sb.append("</datalayers>");
                    }
                catch (Exception exception)
                    {
                    System.out.println("Error::layers2Xml::" + exception.getMessage());
                    }
                //System.out.println(sb.toString());
                return sb.toString();
                }

            public String getUrlContentsWithPost_Orig(String targetUrl, String postData) throws Exception
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
                        System.out.println(
                            "Error::getUrlContentsWithPost::Exception while trying to communicate with URL "
                            + targetUrl);
                    System.out.println(e.getMessage());
                    }
                return "";
                }

            public String getUrlContentsWithPost(String targetUrl, String postData) throws Exception
                {
                HttpMethodBase method = null;

                try
                    {
                        System.out.println("Baohong:: inside index.getUrlContentsWithPost" );
                    Boolean doOutput = true;

                    if (postData == null || postData.equals(""))
                        doOutput = false;

                    HttpClient client = new HttpClient();
                    client.setConnectionTimeout(3 * 1000); // 3 seconds.

                    if (user != null && !user.trim().equals(""))
                        {
                        client.getParams().setAuthenticationPreemptive(usePreemptiveAuth);
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

                    if (!cookies.equals(""))
                        {
                        System.out.println("Sending cookies:\n" + cookies);
                        method.setRequestHeader("Cookie", cookies);
                        }

                    else
                        System.out.println("No cookies stored!\n" + cookies);
                    int statusCode = client.executeMethod(method);

                    if (statusCode == HttpStatus.SC_OK)
                        {
                        Header h = method.getResponseHeader("Set-Cookie");

                        if (h != null)
                            {
                            cookies = h.toExternalForm();
                            System.out.println("cookies:\n" + cookies);
                            int beg = cookies.indexOf(": ");
                            int end = cookies.indexOf(";");

                            if (end > beg && beg > -1)
                                cookies = cookies.substring(beg + 2, end);

                            else
                                cookies = "";
                            //System.out.println("cookies:\n" + cookies);
                            }
                        System.out.println("Header:\n" + h);
                        return new String(method.getResponseBody());
                        }

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
                        System.out.println(
                            "Error::getUrlContentsWithPost::Exception while trying to communicate with URL "
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


            // Utility function for getting the filesystem path to an internal file
            public String internal(String fileName)
                {
                    System.out.println("Baohong:: inside index.internal" );
                    log.info("Baohong  inside index.internal: " + "webapps/" + contextName + "/internal/" + fileName);
                return "webapps/" + contextName + "/internal/" + fileName;
                }


            // Utility function for getting the filesystem path to an internal file
            public String internal2(String fileName)
                {
                    log.info("Baohong  inside index.internal2: " + "http://localhost:" + 8080 + "/" + contextName + "/internal/" + fileName);
                return "http://localhost:" + 8080 + "/" + contextName + "/internal/" + fileName;
                }

            // Utility function for getting attribute value from the first node in a list
            public String getAttr(Node node, String attrName)
                {
                try
                    {
                    return node.getAttributes().getNamedItem(attrName).getNodeValue();
                    }
                catch (Exception ex)
                    {
                    return null;
                    }
                }

            // Utility function for outputting the result of an xsl transform
            public void transformAndOutput(Source xmlSource, Source xsltSource, JspWriter writer)
                {
                try
                    {
		    //System.out.println(xmlSource.getSystemId());
                        log.info("Baohong inside transformAndOutput");
                    TransformerFactory transFact = TransformerFactory.newInstance();
                    log.info("Baohong before transFact.newTransformer");
                    log.info("Baohong xsltSource: "+ xsltSource);
                    Transformer trans = transFact.newTransformer(xsltSource);
                    log.info("Baohong after transFact.newTransformer");
                    log.info("Baohong trans = " + trans);
                    trans.transform(xmlSource, new StreamResult(writer));
                    }
                catch (TransformerException exception)
                    {
                    System.out.println("Error::transformAndOutput::" + exception.getMessage());
                    log.info("Baohong Error transformAndOutput" + exception.getMessage());
                    
                    }
                }

            // Utility function to determine WAF folder based on context URI
            public String getFolder(String uri)
                {
                    System.out.println("Baohong:: inside index.getFolder" );
                    log.info("Baohong  inside index.getFolder :" + uri);
                String [] sa = uri.split("/");
                String folder = sa[sa.length - 1];
                
                /*
                System.out.println(contextName);
                System.out.println(uri);
                System.out.println(folder);
                */
                if (folder.equals(contextName))
                {
                    log.info("Baohong  inside index.getFolder null");
                    return null;
                }

                else
                {
                    log.info("Baohong  inside index.getFolder :" + folder);
                    return folder;
                }
            }

            public String contextName;
            public String serverPort;

            // Utility function to determine WAF folder based on context URI
            public void initContextName(HttpServletRequest request)
                {
                    System.out.println("Baohong:: inside initContextName.getFolder" );
                contextName = request.getContextPath().substring(1);
                serverPort = Integer.toString(request.getLocalPort());
                }


            // FTP support starts here...
            //

            public List<List<String> > availableFtpLayers(String folder, String serviceUrl, String recurse,
                String longName) throws Exception
                {
                List<List<String> > layers = new ArrayList<List<String> > ();

                if ((serviceUrl == null) || (serviceUrl.length() == 0) || !serviceUrl.startsWith("ftp://"))
                    {
                    System.out.println("Error: Bad serviceUrl");
                    return null;
                    }
                //if (serviceUrl.endsWith("/"))
                //	serviceUrl = serviceUrl.substring(0, serviceUrl.length()-1);
                //serviceUrl = serviceUrl + "/";

                String dirPath = "";
                String serverName = "";
                // extract server name
                int slsh = serviceUrl.indexOf("/", 6);

                if (slsh != -1)
                    {
                    dirPath = serviceUrl.substring(slsh + 1);

                    if (dirPath.endsWith("/"))
                        dirPath = dirPath.substring(0, dirPath.length() - 1);
                    serverName = serviceUrl.substring(6, slsh);

                    //System.out.println(serverName);

                    if (connect(serverName, user, pwd))
                        {
                        for (String name: processFtpLayers(serverName, dirPath, recurse))
                            {
                            List<String> entry = new ArrayList<String> ();
                            entry.add(java.net.URLEncoder.encode(pathAfter(name, dirPath + "/")));
                            entry.add(name);
                            layers.add(entry);
                            //System.out.println(name);
                            }
                        ftpDisconnect();
                        }

                    else
                        System.out.println("Can not connect to: " + serverName);
                    }

                return layers;
                }

            public List<String> processFtpLayers(String serverName, String dirPath, String recurse)
                {
// return a list of xml urls, or null if problems. If recurse is true, search any dirs found in the serviceUrl.
                try
                    {
                    boolean changeDirOk = ftp.changeWorkingDirectory("/" + dirPath);

                    if (!changeDirOk)
                        {
                        System.out.println("Error: changeWorkingDirectory failed for dirPath " + dirPath);
                        return null;
                        }

                    FTPFile [] files = ftp.listFiles();

                    if (files == null)
                        {
                        System.out.println("Error: listfiles failed for dirPath " + dirPath);
                        return null;
                        }
                    // get dirs and files in this dir
                    ArrayList<String> dirs = new ArrayList();
                    ArrayList<String> names = new ArrayList();

                    for (FTPFile file: files)
                        {
                        String name = file.getName();

                        if (file.isFile())
                            {
                            if (name.toUpperCase().endsWith(".XML"))
                                names.add(dirPath + "/" + name);
                            //System.out.println(">>>>>>");
                            //System.out.println(name);
                            }

                        else
                            {
                            if (file.isDirectory())
                                {
                                dirs.add(dirPath + "/" + name);
                                //System.out.println("######");
                                //System.out.println(name);
                                }
                            }
                        }
                    ArrayList<String> allFileNames = new ArrayList();
                    allFileNames.addAll(names);

                    // recursively process all dir names in this dir
                    if (recurse.equals("1"))
                        {
                        for (String thisDir: dirs)
                            {
                            List<String> theDirNames = processFtpLayers(serverName, thisDir, recurse);

                            if (theDirNames != null)
                                {
                                allFileNames.addAll(theDirNames);
                                }
                            }
                        }
                    return allFileNames;
                    }
                catch (Exception e)
                    {
                    System.out.println("Error: Exception in availableFtpLayers: " + e.getMessage());
                    e.printStackTrace();
                    return null;
                    }
                }

            // Return the part of path after the given prefix
            private String pathAfter(String path, String pathPrefix)
                {
                int i = path.indexOf(pathPrefix);

                if (i < 0)
                    return "";

                return path.substring(i + pathPrefix.length());
                }

            private boolean connect(String serverName, String username, String password) throws Exception
                {
                System.out.println("Baohong:: inside initContextName.connect" );
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
                    System.out.println("Error: login failed for username " + username);

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

            public void ftpDisconnect()
                {
                try
                    {
                        System.out.println("Baohong:: inside initContextName.ftpDisconnect" );
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
            }

        Utils u = new Utils();
        System.out.println("Baohong: after Utils");
        out.println("<P class=\"error\">Baohong: after Utils</P>");
        u.initContextName(request);
        out.println("<P class=\"error\">Baohong: before getFolder: request.getRequestURI():"  + request.getRequestURI() + " </P>");
        String folder = u.getFolder(request.getRequestURI());
        // Normally, the following is a no-op. It will serve to sanitize URL parameter 'folder' if special
        // characters have been inserted.
        out.println("<P class=\"error\">Baohong: before check folder: "  + folder + " </P>");
        folder = StringEscapeUtils.escapeXml(folder);
        System.out.println("Baohong: after check folder");
 
        out.println("<P class=\"error\">Baohong: after check folder: "  + folder + " </P>");
        if (folder != null)
            {
                 out.println("<P class=\"error\">Baohong: folder != null </P>");
            Node node = u.getFolderConfig(folder);
            out.println("<P class=\"error\">Baohong: after u.getFolderConfig(folder) </P>");
            if (node != null)
                {
                    out.println("<P class=\"error\">Baohong: node != null </P>");
                // If a folder specified and found in config, present list of its metadata.
                // How we do that depends on the type of source we're connecting to.
                String sourceType = u.getAttr(node, "type");

                u.user = u.getAttr(node, "user");
                u.pwd = u.getAttr(node, "pwd");

                List<List<String> > layers = null;
                if (sourceType.equalsIgnoreCase("ARCIMS"))
                    {
                    layers = u.availableArcimsLayers(folder, u.getAttr(node, "serviceUrl"),
                        u.getAttr(node, "longName"));
                    }

                else if (sourceType.equalsIgnoreCase("WAF"))
                    {
                    layers = u.availableWafLayers(folder, u.getAttr(node, "serviceUrl"), u.getAttr(node, "longName"));
                    }

                else if (sourceType.equalsIgnoreCase("GEODB"))
                    {
                    layers = u.availableSdeLayers(folder, u.getAttr(node, "metadataTable"),
                        u.getAttr(node, "jdbcDriver"), u.getAttr(node, "jdbcUrl"), u.getAttr(node, "user"),
                        u.getAttr(node, "pwd"), u.getAttr(node, "longName"));
                    }

                else if (sourceType.equalsIgnoreCase("FTP"))
                    {
                    layers = u.availableFtpLayers(folder, u.getAttr(node, "serviceUrl"), u.getAttr(node, "recurse"),
                        u.getAttr(node, "longName"));
                    }

                if (layers != null)
                    {
                    String output = "";
                    output = u.layers2Xml(layers, folder, u.getAttr(node, "longName"));

                    //out.println("Baohong: " + u.internal("waf.xsl"));
                    // Output html formatted list of metadata
                    u.transformAndOutput(new StreamSource(new StringReader(output)),
                        new StreamSource(u.internal2("waf.xsl")), out);
                    }
                }

            else
                {
                out.println("<P class=\"error\">Folder " + folder + " not found!</P>");
                }
            }

        else
            {
            // If no folder specified, present list of WAF folders.
                out.println("<P class=\"error\">Baohong: before  u.transformAndOutput  </P>");
            u.transformAndOutput(new StreamSource(u.internal2("wafconfig.xml")),
                new StreamSource(u.internal2("waflist.xsl")), out);
            out.println("Baohong: " + u.internal("waflist.xsl"));
            out.println("<P class=\"error\">Baohong: after  u.transformAndOutput  </P>");
            }%>
    </BODY>
</HTML>

