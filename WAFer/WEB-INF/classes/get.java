import java.io.IOException;
//import java.lang.reflect.Method;
import javax.management.RuntimeErrorException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContext;

import java.io.*;
import java.net.URLDecoder;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import org.apache.log4j.Logger;



public class get extends HttpServlet {
	/**
	 *	Enumeration for the type of GFE operation requested
	 */
	public enum RequestType {
		SEARCH, RETRIEVE, UNKNOWN
	}

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(get.class);
    protected static ServletContext ctx;
    protected static String baseUrl;
    protected String[] allowIPs = null;
    public static String coreIP = null;
    public static String guidPath = "/WEB-INF/classes/GUID.txt";
    public static String guid = "";
	boolean debug = false;


    @Override
    public void init() {
        coreIP = this.getServletConfig().getServletContext().getInitParameter("CoreGFEIP");
        if ((coreIP != null) && (coreIP.length()>0)) {
            logger.info("coreIP: "+coreIP);
        }
        String allowIPsString = this.getServletConfig().getServletContext().getInitParameter("allowIPs");  // comma separated list of IPs
        if ((allowIPsString != null) && allowIPsString.length()>0) {
            allowIPs = allowIPsString.split(",");
        }
        BufferedReader guidReader = null;
        InputStreamReader guidStreamReader = null;
        InputStream guidStream = this.getServletContext().getResourceAsStream(guidPath);
        try {
            if (guidStream==null) {
                // not there, create it
                UUID uuid = UUID.randomUUID();
                guid = uuid.toString();
                String realGuidPath = this.getServletContext().getRealPath(guidPath);
                File file = new File(realGuidPath);
                BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file)));
                bw.write(guid);
                bw.newLine();
                bw.flush();
                bw.close();
                guidStream = this.getServletContext().getResourceAsStream(guidPath);
            }
            guidReader = new BufferedReader(new InputStreamReader(guidStream));
            guid = guidReader.readLine();
            if (guid == null)
                logger.fatal("Initialization of guid failed.");
             else
                logger.info("Initialization complete.");
            guidReader.close();
        } catch (Exception e) {
            logger.fatal("Initialization failed with exception ",e);
        }
    }
    
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String remoteIP = req.getRemoteAddr();
        logger.info("remoteIP: "+remoteIP);
        // make sure remoteIP is from core or one of allowedIPs
        if ((coreIP != null) && !coreIP.equals(remoteIP)) {
            if (allowIPs != null) {
                boolean allowed = false;
                for (int i=0; i<allowIPs.length; i++) {
                    if (remoteIP.equals(allowIPs[i]))
                        allowed = true;
                }
                if (!allowed) {
                    logger.info("request from "+remoteIP+" ignored");
                    return;
                }
            } else {
                logger.info("request from "+remoteIP+" ignored");
                return;
            }
        }
		try {
			ctx = this.getServletContext();
			baseUrl = getBaseUrl(req);
		    PrintWriter out = null;

		    debug = (req.getQueryString().indexOf("&debug")>=0);

		    Map<String,List<String>> searchRequestMap = getNormalizedUrlMap(req.getParameterMap(), out);

		    logger.info("Running JVM "+System.getProperty("java.version"));
	    	logger.info("getUrl: "+getUrl(req));

		    // Turn debug on if URL hint provided
		    debug = searchRequestMap.containsKey("debug");
			String f = SearchAPI.safeGetFirstString("f", searchRequestMap).trim().toLowerCase();
            String css = SearchAPI.safeGetFirstString("css", searchRequestMap).trim();  //css style sheet
            String xsl = SearchAPI.safeGetFirstString("xsl", searchRequestMap).trim();  //xsl style sheet for custom xform
            String app = SearchAPI.safeGetFirstString("app", searchRequestMap).trim();  //name of app (from GFE.html)that will consume results (ex: googleEarthPlugin)
            String[] cssUrl = {"cssUrl",css};
            String[] xslParm = {"xslParm",xsl};
            String[] baseUrlParm = {"baseUrl",baseUrl};
            String[] appParm = {"app",app};
            ArrayList<String[]> parms = new ArrayList(4);
            parms.add(cssUrl);
            parms.add(xslParm);
            parms.add(baseUrlParm);
            parms.add(appParm);
			RequestType reqType = getRequestType(req);

		    if(!debug) {
		    	// Expire in 1 hours, i.e. cache for that long.
		    	int max_age = 1*60*60;
//		    	int max_age = 1*60*1;  // 1 min for testing
			    resp.setHeader("Cache-Control", "max-age=" + max_age);
			    //resp.setDateHeader("Expires", System.currentTimeMillis(  ) + max_age*1000);
			    //resp.setHeader("Expires", getGMTTimeString(System.currentTimeMillis(  ) + 1*60*60*1000));
		    }

		    SearchAPI sapi = new SearchAPI(req);

		    if(reqType == RequestType.SEARCH) {
		    	String results = sapi.search(searchRequestMap);

		    	resp.setContentType(getMimeTypeForFormat(searchRequestMap));
                out = resp.getWriter();

		    	if (f.equals("kml") || f.equals("bingkml") || f.equals("georss") || f.equals("html") || f.equals("html_static")) {
                    logger.debug("Transforming search results with f = "+f+"   css="+css+"   xsl: "+xsl);
			    	out.println(XMLHelper.substitute(XMLHelper.xform(results, f + ".xsl", parms), "GFELink", getBaseUrl(req), ""));
			    } else
			    	out.println(results);
		    } else if(reqType == RequestType.RETRIEVE) {
		    	String results = "";
                String url = "";
		    	if(searchRequestMap.containsKey("url")) {
                    url = URLDecoder.decode(SearchAPI.safeGetFirstString("url", searchRequestMap),"UTF-8");
                    results = XMLHelper.getUrlContents(SearchAPI.safeGetFirstString("url", searchRequestMap));
                } else
			    	results = sapi.retrieve(searchRequestMap);
                if ((url.length()>0) && "1".equals(SearchAPI.safeGetFirstString("readable", searchRequestMap)) && url.contains("getxml=") && (!url.contains("GFE-0"))) {
                    resp.setContentType("text/html;charset=UTF-8");
                    out = resp.getWriter();
                    out.println(XMLHelper.xform(results, "metadata_to_html_full.xsl", parms));
                } else {
                    resp.setContentType("text/xml;charset=UTF-8");
                    out = resp.getWriter();
                    out.println(results);
                }
		    } else {
		    	out.println("Don't know what to do: " + req.getServletPath());
		    }
		}
		catch (Throwable ex) {
			if (ex instanceof Error) {
				logger.error("Servlet threw throwable: ",ex);
				throw new RuntimeErrorException((Error) ex);
			} else
				logger.error("Servlet threw exception :"+ex.getMessage());
		}
	}


	/*
	 * A parameter map generated from a URL may contain multi-valued keys
	 * e.g. ?SearchServices=MI_GIS,MN_LMIC
	 * as well as repetitions of such keys
	 * e.g. ?SearchServices=MI_GIS,MN_LMIC&SearchServices=MN_DOT
	 * We normalize it such that every entry in the map has an array of individual values
	 * e.g. map entry with key "SearchServices" has value {"MI_GIS", "MN_LMIC", "MN_DOT"}
	 */
	public Map<String,List<String>> getNormalizedUrlMap(Map<String,String[]> origUrlMap, PrintWriter out) {
	    Map<String,List<String>> normUrlMap = new HashMap<String,List<String>>();
	    Iterator<Map.Entry<String,String[]>> iter = origUrlMap.entrySet().iterator();

	    String k;
	    while (iter.hasNext()){
	    	Map.Entry<String,String[]> me = iter.next();
	    	List<String> newList = new ArrayList<String>();
	    	String[] oldArr = me.getValue();
	    	k = me.getKey();
		    if(debug) {
			    out.println("+++++");
			    out.println(k);
			    out.println(oldArr.length);
		    }
	    	for(int i=0; i<oldArr.length; i++) {
	    		String[] valArr = oldArr[i].split(",");
		    	for(int j=0; j<valArr.length; j++) {
		    		newList.add(valArr[j]);
				    if(debug) {
					    out.println("-----");
				    	out.println(valArr[j]);
				    	//out.println(newList.get(newList.size()-1));
				    }
		    	}
	    	}
	    	normUrlMap.put(k, newList);
	    }
	    return(normUrlMap);
	}

	/*
	 * Returns the URL of the request including query parameters
	 */
    public static String getUrl(HttpServletRequest req) {
        return req.getRequestURL() + "?" + req.getQueryString();
    }


	/*
	 * Returns the type of GFE operation requested
	 */
    public static RequestType getRequestType(HttpServletRequest req) {
	    if(req.getServletPath().equalsIgnoreCase("/search/get") || req.getServletPath().equalsIgnoreCase("/gfe.kml"))
	    	return RequestType.SEARCH;
	    if(req.getServletPath().equalsIgnoreCase("/retrieve"))
	    	return RequestType.RETRIEVE;

	    return RequestType.UNKNOWN;
    }


	/*
	 * Returns the URL of the request including query parameters
	 */
    public static String getBaseUrl(HttpServletRequest req) {
        String scheme = req.getScheme();             // http
        String serverName = req.getServerName();     // hostname.com
        int serverPort = req.getServerPort();        // 80
        String contextPath = req.getContextPath();   // /mywebapp

        // Reconstruct original requesting URL
        return scheme + "://" + serverName + ":" + serverPort + contextPath;
    }





    /*
     * Return the Greenwich Mean Time date/time string in the format used by "Expires" HTTP header.
     */
    public static String getGMTTimeString(long milliSeconds) {
    	SimpleDateFormat sdf = new SimpleDateFormat("E, d MMM yyyy HH:mm:ss 'GMT'");
    	return sdf.format(new Date(milliSeconds));
    }

    /*
     * Return the correct mime-type for the given format specification
     */
    public static String getMimeTypeForFormat(Map<String,List<String>> searchRequestMap) {
	String f = SearchAPI.safeGetFirstString("f", searchRequestMap).trim().toLowerCase();
	if(f.equals("kml") || f.equals("bingkml"))
		return("application/vnd.google-earth.kml+xml");
	else if(f.equals("georss"))
		return("application/rss+xml;charset=UTF-8");
	else if(f.startsWith("html"))
		return("text/html;charset=UTF-8");
	// Default to xml output
	return("text/xml;charset=UTF-8");
    }

/*
    private ApplicationListener applistener = new ApplicationListener () {
    	public void onApplicationEvent (ApplicationEvent evt) {
    		if (evt instanceof ContextClosedEvent) {
    			System.err.println ("ctx closed: " + evt);
    			new Throwable().printStackTrace ();
    		}
    	}
    };
*/

}
