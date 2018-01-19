import java.util.*;
import org.apache.log4j.Logger;
import org.apache.xpath.XPathAPI;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
//import java.io.File;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;

import org.w3c.dom.*;
import org.xml.sax.InputSource;
//import org.apache.xpath.NodeSet;
//import org.apache.xpath.XPathAPI;

//import javax.xml.xpath.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;
import javax.xml.transform.dom.*;

import org.w3c.dom.traversal.DocumentTraversal;
import org.w3c.dom.traversal.NodeFilter;
import org.w3c.dom.traversal.NodeIterator;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;
import org.apache.commons.httpclient.protocol.Protocol;


public class XMLHelper {
    private static final Logger logger = Logger.getLogger(get.class);
    private static int bufSize = 16000;

	public static String getUrlContents(String urlStr) throws Exception {
		URL u;
		URLConnection c = null;
		BufferedReader br = null;
		String content = "";
		String s;

		try {
			u = new URL(urlStr);
			logger.info("Trying to open connection to URL "+urlStr);
			c = u.openConnection();
 			c.connect();
			br = new BufferedReader(new InputStreamReader(c.getInputStream()));
            char[] cbuf = new char[bufSize];
            int cnt = 0;

			while ((cnt = br.read(cbuf,0,bufSize)) != -1)
				content += new String(cbuf,0,cnt);

		} finally {
			try {
				br.close();
			} catch (Exception e) {
				logger.info(e.toString());
			}
		}
		return(content);
	}

    // this version uses httpclient to deal with authentication and unsigned https (uhttps) protocol
    public static String getUrlContents(String urlStr, String user, String pwd, boolean forceAcceptCert) throws Exception {
        HttpMethodBase method = null;
        ByteArrayOutputStream inputBytes = null;
        try {
            logger.debug("Fetching "+urlStr);
            if (forceAcceptCert) {
                Protocol.registerProtocol("uhttps",
                    new Protocol("uhttps", new org.apache.commons.httpclient.contrib.ssl.EasySSLProtocolSocketFactory(), 443));
                int protocolEnd = urlStr.indexOf(':');
                urlStr = "uhttps"+urlStr.substring(protocolEnd);
            }

            HttpClient client = new HttpClient();
            client.setConnectionTimeout(3*1000);	// 3 seconds.

			if(user != null && !user.trim().equals(""))
			{
				client.getParams().setAuthenticationPreemptive(true);
				Credentials defaultcreds = new UsernamePasswordCredentials(user, pwd);
				client.getState().setCredentials(AuthScope.ANY, defaultcreds);
			}

            method = new GetMethod(urlStr);
			int statusCode = client.executeMethod(method);
			if (statusCode != HttpStatus.SC_OK) {
                logger.error("executeMethod returned status code: "+statusCode);
                throw new Exception("Received status code "+statusCode+": "+HttpStatus.getStatusText(statusCode));
            }
            
            inputBytes =  getUrlContentsAsBytes(method);
        } finally {
			if(method != null)
				method.releaseConnection();
            // return bytes
        }
        if (inputBytes != null)
            return inputBytes.toString();
        else
            return "";

    }

	public static ByteArrayOutputStream getUrlContentsAsBytes(HttpMethodBase m) throws Exception {
		BufferedInputStream bIn = null;
        ByteArrayOutputStream bOut = null;

        int thisBufSize = (int) m.getResponseContentLength();
        logger.debug("thisBufSize: "+thisBufSize);
        if (thisBufSize <= 0) {
            thisBufSize = bufSize;
        }
        byte[] buf = new byte[thisBufSize];
        int cnt = 0;

		try {
            InputStream inStream = m.getResponseBodyAsStream();
            logger.debug("inStream: "+inStream);
			bIn = new BufferedInputStream(inStream,thisBufSize);
            bOut = new ByteArrayOutputStream(thisBufSize);

			while ((cnt = bIn.read(buf)) != -1) {
				bOut.write(buf, 0, cnt);
            }
		} finally {
			try {
				bIn.close();
			} catch (Exception e) {}
		}
		return bOut;
	}


	public static List<String> extractSubtrees(String xml, String subtreeNodeName) {
		List<String> records = new ArrayList<String>();
		logger.debug("xml: "+xml);
		boolean done = false;
		int start = 0, stop = 0;
		while(!done) {
			start = xml.indexOf("<"+subtreeNodeName, stop);
			stop = xml.indexOf("</"+subtreeNodeName+">", start);
			logger.debug("start: "+start);
			logger.debug("stop: "+stop);
			if(start>-1 && stop>-1) {
				String subtree = xml.substring(start, stop+("</"+subtreeNodeName+">").length());
				records.add(subtree);
				logger.debug("subtree: "+subtree);
			}
			else
				done = true;
		}
		return(records);
	}

	// This doesn't work due to namespaces....
	public static List<String> extractSubtrees2(String xml, String subtreeNodeName) {
		List<String> records = new ArrayList<String>();
		try {
			Document getRecordsResponseDoc = string2Document(xml);
			Document subtreeDoc;

			DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = domFactory.newDocumentBuilder();

			logger.debug("getRecordsResponseDoc.getChildNodes().item(0): "+getRecordsResponseDoc.getChildNodes().item(0));
			logger.debug("getRecordsResponseDoc.getChildNodes().item(0).getChildNodes().item(2).getNodeName(): "+
					getRecordsResponseDoc.getChildNodes().item(0).getChildNodes().item(2).getNodeName());
			logger.debug("getRecordsResponseDoc.getChildNodes().item(0): "+getRecordsResponseDoc.getChildNodes().item(0));

			NodeList nodes = XPathAPI.eval(getRecordsResponseDoc, "//" + subtreeNodeName).nodelist();
			//NodeList nodes = XPathAPI.eval(getRecordsResponseDoc, "//title", getRecordsResponseDoc.getChildNodes().item(0)).nodelist();
			logger.debug("nodes.getLength(): "+nodes.getLength());
			Node n;
			for (int i=0; i < nodes.getLength(); i++) {
				n = nodes.item(i);
				subtreeDoc = builder.newDocument();
				subtreeDoc.appendChild(subtreeDoc.importNode(n, true));
				records.add(Document2String(subtreeDoc));
			}
		}
		catch(Exception e) {
			logger.error("e: ",e);
		}

		return(records);
	}


	public static List<String> getInfoFromXmlDocByXpath(Document doc, String xp) {
		try {
			logger.debug("xp: "+xp);
			NodeList nodes = XPathAPI.eval(doc, xp + "/text()").nodelist();
			List<String> entries = new ArrayList<String>();
			for (int i=0; i < nodes.getLength(); i++) {
				entries.add(nodes.item(i).getNodeValue().toString());
			}
			return(entries);
		} 
		catch(TransformerException te) {
			logger.error("te: ",te);
			return(null);
		}
	}

	public static String getInfoFromXmlDoc(Document doc, String SearchService, String elt){
		try{
			return((String) getInfoFromXmlDocByXpath(doc, "//SearchService[code='"+SearchService+"']/" + elt).get(0));
		}
		catch (Exception e) {
			logger.error("e: ",e);			
			return(e.toString());
		}
	}

	public static void extractXpathsFromXml(String xml, Map<String,List<String>> xpMap){
		try{
			Document dom = string2Document(xml);
			for (String xp : xpMap.keySet()) {
				xpMap.put(xp, getInfoFromXmlDocByXpath(dom, xp));
			}
		}
		catch (Exception e) {
			logger.error("e: ",e);			
		}
	}


	public static String file2String(String filepathname) throws Exception {
		logger.debug("##### file2String called for: "+filepathname);
		try {
			InputStream file = get.ctx.getResourceAsStream(filepathname);

			byte[] b = new byte[file.available()];
			file.read(b);
			file.close ();
			return(new String (b));
		}
		catch (Exception e) {
			logger.error("e: ",e);			
			throw e;
			//return(e.toString());
		}
	}

	public static Map<String,Map<String,String>> Document2MapMap(Document dom, String itemTagName, String keyTagName){
		try{
			Map<String,Map<String,String>> mapMap = new HashMap<String,Map<String,String>>();
			Map<String,String> map = null;
			DocumentTraversal traversal = (DocumentTraversal) dom;

			NodeIterator iterator = traversal.createNodeIterator(
					dom.getDocumentElement(), NodeFilter.SHOW_ELEMENT, null, false);
			// Skip "root" element
			iterator.nextNode();

			for (Node n = iterator.nextNode(); n != null; n = iterator.nextNode()) {
				//logger.debug("Node: "+n.getNodeName());
				if(n.getNodeName().equalsIgnoreCase(itemTagName)) {
					if(map!=null) {
						mapMap.put(map.get(keyTagName),map);
					}
					map = new HashMap<String,String>();
				}
				else {
					String nodeVal = "";
					if(n.getChildNodes().getLength()>0)
						nodeVal = n.getChildNodes().item(0).getNodeValue();
					map.put(n.getNodeName(), nodeVal);
				}
			}
			if(map!=null) {
				mapMap.put(map.get(keyTagName),map);
			} 
			return(mapMap);
		}
		catch(Exception e){
			logger.error("e: ",e);			
			return(null);
		}
	}

	public static Document string2Document(String xml){
		try{
			DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
			domFactory.setNamespaceAware(false);
			DocumentBuilder builder = domFactory.newDocumentBuilder();
			Document dom = null;
			try {
				dom = builder.parse(new InputSource(new StringReader(xml)));
			} catch(Exception ei) {
				xml = cleanHTMLContamination(xml);
				dom = builder.parse(new InputSource(new StringReader(xml)));
			}
			return(dom);
		}
		catch(Exception e){
			logger.error("e: ",e);			
		}
		return(null);
	}

	public static String cleanHTMLContamination(String xml) {
		xml = xml.replaceAll("<br>", "<br/>");
		xml = xml.replaceAll("</br>", "<br/>");
		xml = xml.replaceAll("<p>", "<br/>");
		xml = xml.replaceAll("</p>", "<br/>");
		return(xml);	
	}

	public static Document file2Document(String filepathname){
		try{
			DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = domFactory.newDocumentBuilder();
			InputStream is = get.ctx.getResourceAsStream(filepathname);
			//InputStream is = new FileInputStream(filepathname);
			Document dom = builder.parse(is);
			return(dom);
		}
		catch(Exception e){
			logger.error("e: ",e);			
			return(null);
		}
	}

	public static Document url2Document(String url){
		try{
			DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = domFactory.newDocumentBuilder();
			Document dom = builder.parse(url);
			return(dom);
		}
		catch(Exception e){
			logger.error("e: ",e);
			return(null);
		}
	}

    public static String Document2String(Document dom){
		try {
			StringWriter sw = new StringWriter();
			StreamResult result = new StreamResult(sw);

			DOMSource source = new DOMSource(dom);

			TransformerFactory tFactory = TransformerFactory.newInstance();
			Transformer transformer = tFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.METHOD, "xml");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			//transformer.setOutputProperty ( "encoding" , "UTF-16" );
			transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
			transformer.transform(source, result);

			return(sw.getBuffer().toString());
		}
		catch (Exception e) {
			logger.error("e: ",e);			
			return(e.toString());
		}
	}


	/**
	 * Using JAXP in implementation independent manner create a document object
	 * using which we create a xml tree in memory
	 */
	public static Document createDocument() {
		Document dom;
		//get an instance of factory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		try {
			//get an instance of builder
			DocumentBuilder db = dbf.newDocumentBuilder();
			//create an instance of DOM
			dom = db.newDocument();
			dom.appendChild(dom.createElement("root"));
			return(dom);
		}catch(ParserConfigurationException pce) {
			logger.error("pce: ",pce);			
			return(null);
		}
	}

	public static void createItem(Document dom, Map<String,String> paramMap){
		Node root = dom.getElementsByTagName("root").item(0);
		Node item = root.appendChild(dom.createElement("item"));
		Iterator<Map.Entry<String,String>> iter = paramMap.entrySet().iterator();
		String k, v;
		while (iter.hasNext()){
			Map.Entry<String,String> me = iter.next();
			k = (String) me.getKey();
			v = (String) me.getValue();
			Node kn = item.appendChild(dom.createElement(k));
			kn.appendChild(dom.createTextNode(v));
		}
		paramMap.clear();
	}

	/**
	 * Pads out a string upto padlen with pad chars
	 * @param Object.toString() to be padded
	 * @param length of pad (+ve = pad on right, -ve pad on left)
	 * @param pad character
	 */
	public static String pad(String str, int padlen, String pad)
	{
		String padding = new String();
		int len = Math.abs(padlen) - str.length();
		if (len < 1)
			return str;
		for (int i = 0 ; i < len ; ++i)
			padding = padding + pad;

		return (padlen < 0 ? padding + str : str + padding);
	}


	public static String listJoin(List<String> lst, String glue) {
		if(lst==null)
			return("");
		StringBuffer buffer = new StringBuffer();
		Iterator<String> iter = lst.iterator();
		if (iter.hasNext()) {
			buffer.append(iter.next());
			while (iter.hasNext()) {
				buffer.append(glue);
				buffer.append(iter.next());
			}
		}
		return buffer.toString();
	}


	public static String list2CsvStr(List<String> lst) {
		return listJoin(lst, ", ");
	}

	public static String substitute(String text, String keyword, String substitution, String wildCard) {
		keyword = "[[" + keyword + "]]";
		//return(text.replace(keyword, wildCard + substitution + wildCard));
		String replacement = myReplace(text, keyword, wildCard + substitution + wildCard);
		logger.debug("text: "+text+"   keyword: "+keyword+"   wildCardSubsWildCard: "+wildCard + substitution + wildCard+"   replacement: "+replacement);
		return replacement;
	}
	
	public static String myReplace(String text, String replace, String with) {
		String result = "";
		int lastEnd = 0;
		int start = 0;
		while ((start=text.indexOf(replace,lastEnd))>=0) {
			result += text.substring(lastEnd,start) + with;
			lastEnd = start+replace.length();
		}
		return result + text.substring(lastEnd);		
	}

    public static Map<String,String> item2Map(String item) {
        Map<String,String> map = new HashMap();
        String tagName = "", tagValue = "";
        int tagNameStart = 0, tagNameEnd = 0, tagValueEnd = 0;
		while((tagNameStart>=0) && (tagNameEnd>=0) && (tagValueEnd>=0)) {
			tagNameStart = item.indexOf("<",tagValueEnd);
            if (tagNameStart>=0) {
                tagNameEnd = item.indexOf(">",tagNameStart);
                if (tagNameEnd>=0) {
                    tagName = item.substring(tagNameStart+1,tagNameEnd);
                    tagValueEnd = item.indexOf("</"+tagName+">", tagNameEnd+1);
                    if (tagValueEnd>=0) {
                        tagValue = item.substring(tagNameEnd+1, tagValueEnd);
                        map.put(tagName, tagValue);
                        tagValueEnd += ("</"+tagName+">").length();
                    }
                }
            }
        }
        return map;
    }
	

	public static String xform(String xmlStr, String xslUrl, ArrayList<String[]> parms)
	throws TransformerException, TransformerConfigurationException, FileNotFoundException, IOException {  
		TransformerFactory tFactory = TransformerFactory.newInstance();
        InputStream xslStream = null;
        URL url = null;
        if (xslUrl.startsWith("http:")) {
            url = new URL(xslUrl);
            xslStream = url.openStream();
        } else
            xslStream = get.ctx.getResourceAsStream(xslUrl);
		Transformer transformer = tFactory.newTransformer(new StreamSource(xslStream));
		transformer.setParameter("contextPath", get.ctx.getContextPath());
        if (parms != null) {
            // set parms from parms arg, String[0]=name, String[1]=value
            for (String[] parm : parms) {
                transformer.setParameter(parm[0], parm[1]);
            }
        }
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(new StreamSource(new StringReader(xmlStr)), new StreamResult(baos));
		return(baos.toString());
	}


}
