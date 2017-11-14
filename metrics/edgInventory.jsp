<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="jspClasses/commonMethods.jsp" %><%@ include file="jspClasses/login.jsp" %>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="org.apache.http.client.HttpClient"%>
<%@page import="org.apache.http.client.methods.HttpGet"%>
<%@page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.apache.http.HttpResponse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Exception"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
public String getValues(JSONArray inputData,String key,String value,String expectedKey)
{
	//key="username",value="OAR-OAP",expectedKey="pubCbx"
	String filterData = "";
	for (int i = 0; i < inputData.length(); i++) {
		JSONObject item = inputData.getJSONObject(i);
		if(item.getString(key).equals(value)){
			if(filterData.equals("")){
			filterData ="\""+item.getString(expectedKey)+"\"";
			}else{
				filterData = filterData+",\""+item.getString(expectedKey)+"\"";
			}
		}
	}
	//"U.S Env","U.S"
	return filterData;
}

public String getItemsJsonString(String excludeItemType,String excludeItemTypeValue,JSONArray inputData){
	//excludeItemType = "username", excludeItemTypeValue="OAR-OAP",inputData= all items dat
	String jsonStr ="{"; 
	Map<String,String> map = new HashMap<String,String>();//datapath - item checkbox id prefix
	map.put("username","ownerCbx");
	map.put("epapub","epaCbx");
	map.put("publisher","pubCbx");
	map.put("inputdate","inputCbx");
	map.put("updatedate","updateCbx");
	map.put("approvalstatus","appstCbx");
	map.put("pubmethod","pubMthdCbx");
	map.put("schema_key","mtdCbx");
	map.put("acl_opt","edgAccCbx");
	map.put("accesslevel","dataGovAccLvlCbx");
	map.put("content_type","cntTypeCbx");
	map.put("source","srcCbx");
	map.put("licenseurl","licenseUrlCbx");
	map.put("rightsnote","rightsCbx");
	map.put("progressstatus","pgrStatusCbx");
	map.put("cmpparenttitle","cmplCbx");
	map.put("colparenttitle","collCbx");
	Set keySet = map.keySet();
	Iterator it =keySet.iterator();
	//jsonStr={"epaCbx":["U.S. EPA","U.S. EPA"],"pubCbx":["U.S. Environmental Protection Agency","U.S. Environmental Protection Agency"],"content_type":[]}
	while(it.hasNext()){
		String itemType =(String) it.next();
		String value = map.get(itemType);
		//Skip current Item type
		if(itemType != excludeItemType){
			if(jsonStr.equals("{")){
				jsonStr=jsonStr+"\""+value+"\":["+getValues(inputData,excludeItemType,excludeItemTypeValue,itemType)+"]"; //{"pubCbx":["U.s Env,"U.s"]
			}else{
				jsonStr=jsonStr+",\""+value+"\":["+getValues(inputData,excludeItemType,excludeItemTypeValue,itemType)+"]";//{"pubCbx":["U.s Env,"U.s"],"inputCbx:["2018-09-20"]
			}
		}
	}
	
	return jsonStr+"}";//{"pubCbx":["U.s Env,"U.s"],"inputCbx:["2018-09-20"]}
}

public String getAbstractData(String docuuid,String retStr){
	String abstractStr = "";
	jsonServer obj = new jsonServer(1);
	try{
	    if (docuuid != null) {

        String sql = new String();
        sql = "SELECT gres.docuuid,gres.title,gres.owner,gres.inputdate,gres.updatedate,gres.id,coalesce(gres.approvalstatus,'not approved') as approvalstatus,gres.pubmethod,CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN 'unknown' ELSE gres.siteuuid END as siteuuid,gres.sourceuri ";
        sql += ",coalesce(linkage.val,'unknown') as pri_linkage";
        sql += ",metadata.val as abstract";
        sql += ",gres.fileidentifier,gres.acl, coalesce(gres.host_url,'unknown') as host_url,coalesce(gres.protocol_type,'unknown') as protocol_type,coalesce(gres.protocol,'unknown') as protocol,coalesce(gres.frequency,'unknown') as frequency,coalesce(gres.send_notification,'false') as send_notification,coalesce(gres.findable,'unknown') as findable,coalesce(gres.searchable,'unknown') as searchable";
        sql += ",coalesce(substring(gres.acl from 32 for (char_length(gres.acl)-49)),'unknown') as acl_content";
        sql += ",(CASE WHEN gres.pubmethod='upload' THEN ";
        sql += " CASE WHEN (gres.sourceuri IS NULL OR gres.sourceuri='') THEN ";
        sql += " 'Metadata file \"unknown\" uploaded by \"'||gusr.username||'\"' ";
        sql += " ELSE 'Metadata file \"'||substring(gres.sourceuri FROM position('/' in gres.sourceuri)+1)||'\" uploaded by \"'||gusr.username||'\"' ";
        sql += " END";
        sql += " ELSE ";
        sql += " CASE WHEN (gres.sourceuri IS NULL OR gres.sourceuri='') THEN 'unknown' ELSE gres.sourceuri END";
        sql += " END) as sourceuri_str";
        sql += " ,CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END as acl_opt ";
        sql += ",coalesce(gres.synchronizable,'unknown') as synchronizable,gres.lastsyncdate,gusr.userid,gusr.dn,gusr.username";
        sql += ",(CASE WHEN gres.schema_key='bestpractice' THEN 'FGDC best practice' WHEN gres.schema_key='dataGov' THEN 'data.gov' WHEN gres.schema_key='dc' THEN 'Dublin Core' WHEN gres.schema_key='fgdc' THEN 'FGDC' ELSE gres.schema_key END) as schema_key";
        sql += ",coalesce(lower(gres.content_type),'unknown') as content_type";
        sql += ",(CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN 'unknown' ELSE gres1.title||'('||coalesce(gres1.host_url,'unknown')||')' END) as source ";
        sql += ",gres1.title site_title, gres1.host_url site_host_url";
        sql += " FROM gpt_resource gres LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
        sql += " LEFT OUTER JOIN gpt_resource gres1 ON (gres.siteuuid=gres1.docuuid)";
        sql += " LEFT OUTER JOIN (select * FROM metrics_md_summary WHERE xpath LIKE '/dataGov[_]/basic[_]/description[_]' OR xpath LIKE '%dcat:dataset[_]/dct:description%' OR xpath LIKE '/metadata[_]/idinfo[_]/descript[_]/abstract[_]' OR xpath LIKE '%gmd:MD_DataIdentification[_]/gmd:abstract[_]/gco:CharacterString[_]' OR xpath LIKE '/metadata[_]/dataIdInfo[_]/idAbs[_]') metadata ON (gres.docuuid=metadata.uuid)";
        sql += " LEFT OUTER JOIN (select * FROM metrics_md_summary WHERE xpath IN ('/metadata[1]/idinfo[1]/citation[1]/citeinfo[1]/onlink[1]','/dataGov[1]/downloadableFile[1]/accessPoint[1]')) linkage ON (gres.docuuid=linkage.uuid)";
        sql += " WHERE gres.docuuid=? ";
        if (retStr.equalsIgnoreCase("public")) {
            sql += " AND (CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END)='" + retStr.toLowerCase() + "'";
        }
       
        ArrayList params = new ArrayList();
        params.add(docuuid);

            ResultSet rs = obj.executeQuery(sql, params);
			System.out.println("print sql"+sql);
            while (rs.next()) {
				System.out.println("entering while loop"+sql);
                abstractStr=rs.getString("abstract");
				
            }
        
    }
	}catch(Exception exp){
		exp.printStackTrace();
	}
	return abstractStr.substring(0,255);
	
}
%>
<%  String responseBody = "";
    String jsonUrl;
    Calendar today;
	JSONObject filterobj=null;
    today = Calendar.getInstance();
    long now = today.getTimeInMillis();

    jsonUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/json/cached_json/inventory.json?cacheClr=" + now;
	   
	HttpClient httpClient = new DefaultHttpClient();
	HttpGet getRequest = new HttpGet(jsonUrl);
	HttpResponse resp = httpClient.execute(getRequest);

	if (resp.getStatusLine().getStatusCode() != 200) {
			throw new RuntimeException("Failed : HTTP error code : "
			   + resp.getStatusLine().getStatusCode());
		}
		
	BufferedReader rd = new BufferedReader(
	new InputStreamReader(resp.getEntity().getContent()));

StringBuffer result = new StringBuffer();
String line = "";
while ((line = rd.readLine()) != null) {
	result.append(line);
}
System.out.println("print result:"+result);
filterobj = new JSONObject(result.toString());

JSONArray arr = filterobj.getJSONArray("items");

JSONArray ownersArr = new JSONArray();
JSONArray epaNonEpaArr = new JSONArray();
JSONArray publisherArr = new JSONArray();
JSONArray inputDtArr = new JSONArray();
JSONArray updateDtArr = new JSONArray();
JSONArray appStArr = new JSONArray();
JSONArray pubMthdArr = new JSONArray();
JSONArray accLvlArr = new JSONArray();
JSONArray dataGovAccLvlArr = new JSONArray();
JSONArray metadataStdlArr = new JSONArray();
JSONArray cntTypeArr = new JSONArray();
JSONArray srcArr = new JSONArray();
JSONArray licenseUrlArr = new JSONArray();
JSONArray rightsArr = new JSONArray();
JSONArray pgrStatusArr = new JSONArray();
JSONArray cmplArr = new JSONArray();
JSONArray collArr = new JSONArray();

for (int i = 0; i < arr.length(); i++) {
JSONObject item = arr.getJSONObject(i);
				
String owner = item.getString("username");
String epapub = item.getString("epapub");
String publisher = item.getString("publisher");
String inputDt = item.getString("inputdate");
String updateDt = item.getString("updatedate");
String appSt = item.getString("approvalstatus");
String pubMthd = item.getString("pubmethod");
String accessLvl = item.getString("acl_opt");
String dataGovAccLvl = item.getString("accesslevel");
String metadataStd = item.getString("schema_key");
String contentType = item.getString("content_type");
String source = item.getString("source");
String licenseUrl = item.getString("licenseurl");
String rights = item.getString("rightsnote");
String pgrStatus = item.getString("progressstatus");
String cmpl = item.getString("cmpparenttitle");
String coll = item.getString("colparenttitle");

ownersArr.put(owner);
epaNonEpaArr.put(epapub);
publisherArr.put(publisher);
inputDtArr.put(inputDt);
updateDtArr.put(updateDt);
appStArr.put(appSt);
pubMthdArr.put(pubMthd);
accLvlArr.put(accessLvl);
dataGovAccLvlArr.put(dataGovAccLvl);
metadataStdlArr.put(metadataStd);
cntTypeArr.put(contentType);
srcArr.put(source);
licenseUrlArr.put(licenseUrl);
rightsArr.put(rights);
pgrStatusArr.put(pgrStatus);
cmplArr.put(cmpl);
collArr.put(coll);
}
Map<String,Integer> ownersMap = new TreeMap<String,Integer>();
 for (int i = 0; i < ownersArr.length(); i++) {
	String ownerItem = ownersArr.getString(i);
	if(ownersMap.get(ownerItem) != null){
		ownersMap.put(ownerItem,ownersMap.get(ownerItem)+1);
	}else{
		ownersMap.put(ownerItem,1);
	}
 }
Map<String,Integer> epaMap = new TreeMap<String,Integer>();
 for (int i = 0; i < epaNonEpaArr.length(); i++) {
	String epaItem = epaNonEpaArr.getString(i);
	if(epaMap.get(epaItem) != null){
		epaMap.put(epaItem,epaMap.get(epaItem)+1);
	}else{
		epaMap.put(epaItem,1);
	}
 }
 Map<String,Integer> pubMap = new TreeMap<String,Integer>();
 for (int i = 0; i < publisherArr.length(); i++) {
	String publisherItem = publisherArr.getString(i);
	if(pubMap.get(publisherItem) != null){
		pubMap.put(publisherItem,pubMap.get(publisherItem)+1);
	}else{
		pubMap.put(publisherItem,1);
	}
 }
 Map<String,Integer> inputDtMap = new TreeMap<String,Integer>();
 for (int i = 0; i < inputDtArr.length(); i++) {
	String inputDtItem = inputDtArr.getString(i);
	if(inputDtMap.get(inputDtItem) != null){
		inputDtMap.put(inputDtItem,inputDtMap.get(inputDtItem)+1);
	}else{
		inputDtMap.put(inputDtItem,1);
	}
 }
  Map<String,Integer> updateDtMap = new TreeMap<String,Integer>();
 for (int i = 0; i < updateDtArr.length(); i++) {
	String updateDtItem = updateDtArr.getString(i);
	if(updateDtMap.get(updateDtItem) != null){
		updateDtMap.put(updateDtItem,updateDtMap.get(updateDtItem)+1);
	}else{
		updateDtMap.put(updateDtItem,1);
	}
 }
 Map<String,Integer> appStMap = new TreeMap<String,Integer>();
 for (int i = 0; i < appStArr.length(); i++) {
	String appStItem = appStArr.getString(i);
	if(appStMap.get(appStItem) != null){
		appStMap.put(appStItem,appStMap.get(appStItem)+1);
	}else{
		appStMap.put(appStItem,1);
	}
 }
 Map<String,Integer> pubMthdMap = new TreeMap<String,Integer>();
 for (int i = 0; i < pubMthdArr.length(); i++) {
	String pubMthdItem = pubMthdArr.getString(i);
	if(pubMthdMap.get(pubMthdItem) != null){
		pubMthdMap.put(pubMthdItem,pubMthdMap.get(pubMthdItem)+1);
	}else{
		pubMthdMap.put(pubMthdItem,1);
	}
 }
 Map<String,Integer> edgAccMap = new TreeMap<String,Integer>();
 for (int i = 0; i < accLvlArr.length(); i++) {
	String accLvlItem = accLvlArr.getString(i);
	if(edgAccMap.get(accLvlItem) != null){
		edgAccMap.put(accLvlItem,edgAccMap.get(accLvlItem)+1);
	}else{
		edgAccMap.put(accLvlItem,1);
	}
 }
 Map<String,Integer> dataGovAccLvlMap = new TreeMap<String,Integer>();
 for (int i = 0; i < dataGovAccLvlArr.length(); i++) {
	String dataGovAccLvlItem = dataGovAccLvlArr.getString(i);
	if(dataGovAccLvlMap.get(dataGovAccLvlItem) != null){
		dataGovAccLvlMap.put(dataGovAccLvlItem,dataGovAccLvlMap.get(dataGovAccLvlItem)+1);
	}else{
		dataGovAccLvlMap.put(dataGovAccLvlItem,1);
	}
 }
 Map<String,Integer> metadataStdMap = new TreeMap<String,Integer>();
 for (int i = 0; i < metadataStdlArr.length(); i++) {
	String metadataStdItem = metadataStdlArr.getString(i);
	if(metadataStdMap.get(metadataStdItem) != null){
		metadataStdMap.put(metadataStdItem,metadataStdMap.get(metadataStdItem)+1);
	}else{
		metadataStdMap.put(metadataStdItem,1);
	}
 }
 Map<String,Integer> cntTypeMap = new TreeMap<String,Integer>();
 for (int i = 0; i < cntTypeArr.length(); i++) {
	String cntTypeItem = cntTypeArr.getString(i);
	if(cntTypeMap.get(cntTypeItem) != null){
		cntTypeMap.put(cntTypeItem,cntTypeMap.get(cntTypeItem)+1);
	}else{
		cntTypeMap.put(cntTypeItem,1);
	}
 }
 Map<String,Integer> srcMap = new TreeMap<String,Integer>();
 for (int i = 0; i < srcArr.length(); i++) {
	String srcItem = srcArr.getString(i);
	if(srcMap.get(srcItem) != null){
		srcMap.put(srcItem,srcMap.get(srcItem)+1);
	}else{
		srcMap.put(srcItem,1);
	}
 }
 Map<String,Integer> licenseUrlMap = new TreeMap<String,Integer>();
 for (int i = 0; i < licenseUrlArr.length(); i++) {
	String licenseUrlItem = licenseUrlArr.getString(i);
	if(licenseUrlMap.get(licenseUrlItem) != null){
		licenseUrlMap.put(licenseUrlItem,licenseUrlMap.get(licenseUrlItem)+1);
	}else{
		licenseUrlMap.put(licenseUrlItem,1);
	}
 }
 Map<String,Integer> rightsMap = new TreeMap<String,Integer>();
 for (int i = 0; i < rightsArr.length(); i++) {
	String rightsItem = rightsArr.getString(i);
	if(rightsMap.get(rightsItem) != null){
		rightsMap.put(rightsItem,rightsMap.get(rightsItem)+1);
	}else{
		rightsMap.put(rightsItem,1);
	}
 }
 Map<String,Integer> pgrStatusMap = new TreeMap<String,Integer>();
 for (int i = 0; i < pgrStatusArr.length(); i++) {
	String pgrStatusItem = pgrStatusArr.getString(i);
	if(pgrStatusMap.get(pgrStatusItem) != null){
		pgrStatusMap.put(pgrStatusItem,pgrStatusMap.get(pgrStatusItem)+1);
	}else{
		pgrStatusMap.put(pgrStatusItem,1);
	}
 }
 Map<String,Integer> cmplMap = new TreeMap<String,Integer>();
 for (int i = 0; i < cmplArr.length(); i++) {
	String cmplItem = cmplArr.getString(i);
	if(cmplMap.get(cmplItem) != null){
		cmplMap.put(cmplItem,cmplMap.get(cmplItem)+1);
	}else{
		cmplMap.put(cmplItem,1);
	}
 }
 Map<String,Integer> collMap = new TreeMap<String,Integer>();
 for (int i = 0; i < collArr.length(); i++) {
	String collItem = collArr.getString(i);
	if(collMap.get(collItem) != null){
		collMap.put(collItem,collMap.get(collItem)+1);
	}else{
		collMap.put(collItem,1);
	}
 }
 
    commonMethods obj = new commonMethods();
    obj.setHttpServletRequest(request);
    
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(obj.getNoAccessPage(ret));
        out.close();
    }
    
    String resourceLink, metadataLink;
    String[] links = obj.getMetaDataLinks(request);
    resourceLink = links[0];
    metadataLink = links[1];
%>
<html>

<!--[if IEMobile 7]><html class="iem7 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if lt IE 7]><html class="lt-ie9 lt-ie8 lt-ie7 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if (IE 7)&(!IEMobile)]><html class="lt-ie9 lt-ie8 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if IE 8]><html class="lt-ie9 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if (gt IE 8)|(gt IEMobile 7)]><!-->
<html class="no-js not-oldie" lang="en" dir="ltr">
<!--<![endif]-->
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="HandheldFriendly" content="true" />
<link rel="shortcut icon"
	href="https://www.epa.gov/sites/all/themes/epa/favicon.ico"
	type="image/vnd.microsoft.icon" />
<meta name="MobileOptimized" content="width" />
<meta http-equiv="cleartype" content="on" />
<meta http-equiv="ImageToolbar" content="false" />
<meta name="viewport" content="width=device-width" />
<meta name="version" content="20161218" />
<!--googleon: all-->
<meta name="DC.description" content="" />
<meta name="DC.title" content="" />
<title>EDG Inventory</title>
<!--googleoff: snippet-->
<meta name="keywords" content="" />
<link rel="shortlink" href="" />
<link rel="canonical" href="" />
<meta name="DC.creator" content="" />
<meta name="DC.language" content="en" />
<meta name="DC.Subject.epachannel" content="" />
<meta name="DC.type" content="" />
<meta name="DC.date.created" content="" />
<meta name="DC.date.modified" content="" />
<!--googleoff: all-->
<!-- font libs -->
<link rel="stylesheet" href="javaScripts/fakeLoader/fakeLoader.css"/>
 <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="javaScripts/fakeLoader/fakeLoader.min.js"></script>
  <script> 
  console.log("calling...");
  myVar = setInterval(function(){console.log(document.readyState);}, 1000);

  </script>
<link href="http://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css" />
<link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"	rel="stylesheet" />
<link rel="stylesheet" href="javaScripts/bootstrap.min.css">

<!-- demo page styles -->
<link href="javaScripts/dist/css/jplist.demo-pages.min.css"	rel="stylesheet" type="text/css" />

<!-- jPList css files -->
<link href="javaScripts/dist/css/jplist.core.min.css" rel="stylesheet" type="text/css" />
<link href="javaScripts/dist/css/jplist.textbox-filter.min.css"	rel="stylesheet" type="text/css" />
<link href="javaScripts/dist/css/jplist.pagination-bundle.min.css" rel="stylesheet" type="text/css" />
<link href="javaScripts/jquery-ui.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="https://www.epa.gov/sites/all/libraries/template2/s.css" media="all" />
<!-- jQuery lib -->		
<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<!-- jPList core js and css  -->
<link href="javaScripts/dist/css/jplist.core.min.css" rel="stylesheet" type="text/css" />	
<script src="javaScripts/dist/js/jplist.core.min.js"></script>
<!-- jPList toggle bundle -->
<script src="javaScripts/dist/js/jplist.filter-toggle-bundle.min.js"></script>
<link href="javaScripts/dist/css/jplist.filter-toggle-bundle.min.css" rel="stylesheet" type="text/css" />
<!-- filter dropdown bundle -->
<script src="javaScripts/dist/js/jplist.filter-dropdown-bundle.min.js"></script>
<!-- jPList textbox filter control -->
<script src="javaScripts/dist/js/jplist.textbox-filter.min.js"></script>
<link href="javaScripts/dist/css/jplist.textbox-filter.min.css" rel="stylesheet" type="text/css" />
 <!-- jPList autocomplete control -->
    <script src="javaScripts/dist/js/jplist.autocomplete.min.js"></script>

    <link href="javaScripts/dist/css/jplist.autocomplete.min.css" rel="stylesheet" type="text/css" />

<!--[if lt IE 9]><link type="text/css" rel="stylesheet" href="https://www.epa.gov/sites/all/themes/epa/css/ie.css" media="all" /><![endif]-->
<link rel="alternate" type="application/atom+xml"
	title="EPA.gov All Press Releases"
	href="https://www.epa.gov/newsreleases/search/rss" />
<link rel="alternate" type="application/atom+xml"
	title="EPA.gov Headquarters Press Releases"
	href="https://www.epa.gov/newsreleases/search/rss/field_press_office/headquarters" />
<link rel="alternate" type="application/atom+xml"
	title="Greenversations, EPA's Blog"
	href="https://blog.epa.gov/blog/feed/" />
<!--[if lt IE 9]><script src="https://www.epa.gov/sites/all/themes/epa/js/html5.js"></script><![endif]-->


<style>
.demoHeaders {
	margin-top: 2em;
}

#dialog-link {
	padding: .4em 1em .4em 20px;
	text-decoration: none;
	position: relative;
}

#dialog-link span.ui-icon {
	margin: 0 5px 0 0;
	position: absolute;
	left: .2em;
	top: 50%;
	margin-top: -8px;
}

#icons {
	margin: 0;
	padding: 0;
}

#icons li {
	margin: 2px;
	position: relative;
	padding: 4px 0;
	cursor: pointer;
	float: left;
	list-style: none;
}

#icons span.ui-icon {
	float: left;
	margin: 0 4px;
}

.fakewindowcontain .ui-widget-overlay {
	position: absolute;
}

select {
	width: 200px;
}

.title {
	font-size: 12px;
	padding: 4px 14px;
	font-weight: bold;
}

.jplist .title {
	font-size: 16px;
	color: black;
}

.jplist .list .list-item {
	margin-top: -23px;
	float: left;
	/*border-bottom: 6px solid #cccccc;*/
}

.ui-accordion .ui-accordion-header {
	display: block;
	cursor: pointer;
	position: relative;
	margin: 2px 0 0 0; //
	padding: .5em .5em .5em .7em;
	font-size: 12px;
	vertical-align: middle;
	padding: 10px 0px;
	color: #595959;
	background-color: #f8f8f8;
}

*, *:before, *:after {
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
}

body {
	font-size: 12px;
	background-color: #ffffff;
	font-family: "Avenir Next W01", "Avenir Next", "Avenir",
		"Helvetica Neue", "Helvetica", "Arial", sans-serif;
	line-height: 1.66667;
	color: #4c4c4c;
	background-color: #f8f8f8;
	font-weight: 300;
	letter-spacing: .03em;
}

html {
	font-size: 10px;
	-webkit-tap-highlight-color: transparent;
}

.pull-left {
	float: left !important;
}

.jplist-panel {
	color: #27252a;
	margin-left: .6em;
}

.desc {
	padding: 2px;
	font-size: 10px;
	width: 85%;
	margin-left: 20px;
}

.jplist .date {
	float: right;
	color: #440e00;
	padding: 2px;
	font-size: 10px;
	width: 85%;
	margin-left: 20px;
}
.site-name-and-slogan {
    float: left;
}
.site-slogan {
   
    font-family: Arial, sans-serif;
    font-size: 100%;
    font-weight: normal;
    line-height: 1;
    position: relative;
    padding: .5em 0 0;
    display: block;
    white-space: nowrap;
}
accItem{
margin-left: -31px;}
#noofresults {
    padding: 5px 12px 8px 11px;
    border: 1px;
    border-style: solid;
    border-radius: -55px;
    box-shadow: 0 0 1px #fff;
    -ms-box-sizing: border-box;
    -o-box-sizing: border-box;
    box-sizing: border-box;
    border: 1px solid #dbdbdb;
    border-radius: 3px;
    text-shadow: 1px 1px 1px #fff;
    color: #27252a;
    width: 150px;
    text-indent: 6px;
    background: #fff;
}
.ui-widget-content{
   display: block; height: 100%;
}
#menu{
    list-style: none;
}
#menu td{
    display: inline-flex;
    padding: 0 10px;
    border-left: solid 1px black;
}
#menu td:first-child{
    border-left: none;
}
#accordion ul{
	    list-style: none;
}
.table>thead>tr>th, .table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {
    padding: 8px;
    line-height: 1.128571;
    vertical-align: top;
    border-top: 1px solid #ddd;
   
}
.ul>table>thead>tbody>tr>th>li{
	list-style: none;
}
dd, ol, p, ul, .fieldset-description, .form-actions, .form-item, .pane-content > .node, .node-teaser, .view-mode-teaser:not(.file), .view-mode-teaser2, .view-mode-title2, ul.accordion ul {
    margin: 0;
    padding-bottom: 0px;
    word-wrap: break-word;
}
.table>thead>tr>th {
    vertical-align: bottom;
    border-bottom: 0px solid #ddd;
}
td, th {
    border: 1px solid #ccc;
}
input[type='checkbox'] {
  padding: 0;
  position: absolute;
  left: 268px;
  margin-top: -6px;
}
.container {
    width:100%;
    /*border:1px solid #d3d3d3;*/
}
.container div {
    width:100%;
}
.container .header {
    display: block;
    cursor: pointer;
    position: relative;
    margin: 2px 0 0 0;
    font-size: 12px;
    vertical-align: middle;
    padding: 10px 0px;
    color: #595959;
    background-color: #f8f8f8;
	border-top-right-radius: 4px;
	border-top-left-radius: 4px;
	font-weight:bold;
	transition: max-height 0.2s ease-out;
}
.container .content {
    display: none;
    padding : 5px;
}
.container.header:after {
    content: '\002B';
    }
   .container.header.visible:after {
    content: "\2212";
}
button.titleaccordion {
    background-color: #eee;
    color: #444;
    cursor: pointer;
    padding: 13px;
    width: 100%;
	height:100%;
    border: none;
    text-align: left;
    outline: none;
    font-size: 15px;
    transition: 0.4s;
}

button.titleaccordion.active, button.titleaccordion:hover {
    background-color: #ccc;
}

button.titleaccordion:after {
    content: '\002B';
    color: #777;
    font-weight: bold;
    float: right;
    margin-left: 5px;
}

button.titleaccordion.active:after {
    content: "\2212";
}

div.titlepanel {
    padding: 0 18px;
    background-color: white;
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.2s ease-out;
}
</style>

<script>
	$('document').ready(function() {
		
		$('#demo').jplist({
			itemsBox : '.list',
			itemPath : '.list-item',
			panelPath : '.jplist-panel'
		});

	});
</script>

</head>
<!-- NOTE, figure out body classes! -->
<body class="node-type-page resource-directory wide-template" id="bodyId">
<div id="fakeLoader"></div>
	<!-- Google Tag Manager -->
	<noscript>
		<iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB"
			height="0" width="0" style="display: none; visibility: hidden"></iframe>
	</noscript>
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-L8ZB');</script>
	<!-- End Google Tag Manager -->
	<div class="skip-links">
		<a href="#main-content"
			class="skip-link element-invisible element-focusable">Jump to main content</a>
	</div>
	<header class="masthead clearfix" role="banner"> <img
		class="site-logo"
		src="https://www2.epa.gov/sites/all/themes/epa/logo.png" alt="" /> <hgroup
		class="site-name-and-slogan">
	<h1 class="site-name">
		<a href="https://www.epa.gov/" title="Go to the home page" rel="home"><span>US EPA</span></a>
	</h1>
	<div class="site-slogan">United States Environmental Protection	Agency</div>
	</hgroup> </header>

	<section id="main-content" class="main-content clearfix" role="main">

	<div class="main-column clearfix">
		<!--googleon: all-->
		<%-- <h1 class="page-title"></h1> --%>
		<div class="panel-pane pane-node-content">
			<div class="pane-content">
				<div class="node node-page clearfix view-mode-full">

					<div class="box">
						<div class="center">
							<!--<><><><><><><><><><><><><><><><><><><><><><><><><><> DEMO START <><><><><><><><><><><><><><><><><><><><><><><><><><>-->

							<!-- demo -->
							<div id="demo" class="box jplist"
								style="margin: 36px 0 50px 33px;">

								<div class="jplist-ios-button">
									<i class="fa fa-sort"></i> jPList Actions
								</div>



								<div class="jplist-panel box panel-top jplist-group">



									<div
										style="width: 30%; height: 50%; float: left; margin-top: -33px; margin-left: -88px;">
										<!-- Accordion -->


										<div class="text-filter-box"
											style="padding-top: 35px; padding-left: 31px;">

											<i class="fa fa-search jplist-icon"></i>

											<!--[if lt IE 10]>
						   <div class="jplist-label">Search any text in the element:</div>
						   <![endif]-->



											<input style="width: 141px; padding: 10px;" data-path="*"
												id="anytext" type="text" value=""
												placeholder="Search any text in the element"
												data-control-type="textbox" data-control-name="title-filter"
												data-control-action="filter" class="jplist-no-right-border" />
											<i class="fa fa-times-circle jplist-clear" data-type="clear"
												onclick="clearSel()"></i>


										</div>
										<select id="sel" onchange="filterDropdown()"
											class="jplist-select jplist-dd-panel"
											style="margin-left: 223px; width: 75px; margin-top: 0px;">
											<option value="">Filter By</option>
											<option value=".title">Title</option>
											<option value=".username">Owner</option>
											<option value=".publisher">Publisher</option>
											<option value=".docuuid">Document UUID</option>
											<option value=".inputdate">Input Date</option>
											<option value=".updatedate">Update Date</option>
											<option value=".schema_key">Metadata standard</option>
											<option value=".source">Source</option>
										</select> <input type="hidden" data-path=".title" value=""
											placeholder="Filter by Title" data-control-type="textbox"
											data-control-name="title-filter" data-control-action="filter" />
											<!-- Text box hidden datapaths -->
										<input data-path=".username" type="hidden" value=""
											placeholder="Filter by Publisher" data-control-type="textbox"
											data-control-name="title-filter" data-control-action="filter" />
										<input data-path=".epapub" type="hidden" value=""
											placeholder="Filter by Publisher" data-control-type="textbox"
											data-control-name="title-filter" data-control-action="filter" />
										<input data-path=".publisher" type="hidden" value=""
											placeholder="Filter by Publisher" data-control-type="textbox"
											data-control-name="title-filter" data-control-action="filter" />
										<input data-path=".docuuid" type="hidden" value=""
											placeholder="Filter by UUID" data-control-type="textbox"
											data-control-name="title-filter" data-control-action="filter" />
										<input data-path=".inputdate" type="hidden" value=""
											placeholder="Filter by Inputdate" data-control-type="textbox"
											data-control-name="title-filter" data-control-action="filter" />
										<input data-path=".updatedate" type="hidden" value=""
											placeholder="Filter by Update Date"
											data-control-type="textbox" data-control-name="title-filter"
											data-control-action="filter" /> 
										<input data-path=".schema_key" type="hidden" value=""
											placeholder="Filter by Metadata standard"
											data-control-type="textbox" data-control-name="title-filter"
											data-control-action="filter" /> 
										<input data-path=".source"
											type="hidden" value="" placeholder="Filter by Source"
											data-control-type="textbox" data-control-name="title-filter"
											data-control-action="filter" /> 
										<input data-path="*"
											id="chk" type="hidden" value=""
											placeholder="Search any text in the element"
											data-control-type="textbox" data-control-name="title-filter"
											data-control-action="filter"
											class="jplist-no-right-border jplist-group"
											data-mode="advanced" data-not="not" data-and="&&" />
										<div id="accordion" style="margin: 75px 0 50px 33px;">
											<h3 class="title">
												<a href="#" data-toggle="tooltip" data-placement="top"
													title="Name of the account or organization that owns the document in the EDG.">Owner:</a>
											</h3>
											<div>
												<ul>
													<%  
							                              Set<String> ownerKeySet = ownersMap.keySet();
							                              Iterator<String> ownersIterator = ownerKeySet.iterator();
							                              int ownersCounter=0;
							                              while(ownersIterator.hasNext()){	                         
								                          String ownerItem = ownersIterator.next();
								                          Integer count = ownersMap.get(ownerItem);
								                          String ownerJsonStr = getItemsJsonString("username",ownerItem,arr);//{"pubCbx":["U.s Env,"U.s"],"inputCbx:["2018-09-20"],..}
								
							                       %>

													<li><input id="ownerCbx<%=ownersCounter%>"
														onchange="chktofilter('ownerCbx',this)"
														data-ownerCbx='<%=ownerJsonStr%>' type="checkbox"
														value="<%=ownerItem%>" /> <span
														id="ownerCbxSpan<%=ownersCounter%>"> <%=ownerItem%>
															(<%=count%>)
													</span></li>
													<% ownersCounter++;} %>

												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="top"
												title="EPA Dataset that is contributed to Data.gov."
												class="title">EPA/Non-EPA :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> epaKeySet = epaMap.keySet();
							                           Iterator<String> epaIterator = epaKeySet.iterator();
							                           int epaCounter=0;
							                           while(epaIterator.hasNext()){	                         
								                       String epapubItem = epaIterator.next();
								                       Integer count = epaMap.get(epapubItem);
								                       String epaJsonStr = getItemsJsonString("epapub",epapubItem,arr);
							                       %>
													<li><input id="epaCbx<%=epaCounter%>"
														onchange="chktofilter('epaCbx')"
														data-epaCbx='<%=epaJsonStr%>' type="checkbox"
														value="<%=epapubItem%>" /> <span
														id="epaCbxSpan<%=epaCounter%>"> <%=epapubItem%> (<%=count%>)
													</span></li>
													<% epaCounter++;} %>
												</ul>
											</div>


											<h3 data-toggle="tooltip" data-placement="right"
												title="Name of the publisher listed in the document."
												class="title">Publisher:</h3>
											<div>

												<ul>
													<%  
	                                                    Set<String> pubKeySet = pubMap.keySet();
							                            Iterator<String> pubIterator = pubKeySet.iterator();
							                            int pubCounter=0;
							                            while(pubIterator.hasNext()){	                         
								                        String publisherItem = pubIterator.next();
								                        Integer count = pubMap.get(publisherItem);
								                        String pubJsonStr = getItemsJsonString("publisher",publisherItem,arr);
							                       %>
													<li><input id="pubCbx<%=pubCounter%>"
														onchange="chktofilter('pubCbx')"
														data-pubCbx='<%=pubJsonStr%>' type="checkbox"
														value="<%=publisherItem%>" /> <span
														id="pubCbxSpan<%=pubCounter%>"><%=publisherItem%> (<%=count%>)</span></li>
													<% pubCounter++;} %>
												</ul>
											</div>


											<h3 data-toggle="tooltip" data-placement="right"
												title="Data resource was registered." class="title">Input
												Date:</h3>
											<div>

												<ul>
													<%  
	                                                   Set<String> inputDtKeySet = inputDtMap.keySet();
							                          Iterator<String> inputDtIterator = inputDtKeySet.iterator();
							                          int inpDateCounter=0;
							                          while(inputDtIterator.hasNext()){	                         
								                      String inputDtItem = inputDtIterator.next();
								                      Integer count = inputDtMap.get(inputDtItem);
								                      String inputJsonStr = getItemsJsonString("inputdate",inputDtItem,arr);
							                        %>
													<li><input id="inputCbx<%=inpDateCounter%>"
														onchange="chktofilter('inputCbx')"
														data-inputCbx='<%=inputJsonStr%>' type="checkbox"
														value="<%=inputDtItem%>" /> <span
														id="inputCbxSpan<%=inpDateCounter%>"><%=inputDtItem%>
															(<%=count%>)</span></li>
													<% inpDateCounter++;} %>
												</ul>
											</div>


											<h3 data-toggle="tooltip" data-placement="right"
												title="Data resource was last updated." class="title">Update
												Date:</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> updateDtKeySet = updateDtMap.keySet();
							                            Iterator<String> updateDtIterator = updateDtKeySet.iterator();
							                            int updDateCounter=0;
							                            while(updateDtIterator.hasNext()){	                         
								                        String updateDtItem = updateDtIterator.next();
								                        Integer count = updateDtMap.get(updateDtItem);
								                        String outputJsonStr = getItemsJsonString("updatedate",updateDtItem,arr);
							                       %>
													<li><input id="updateCbx<%=updDateCounter%>"
														onchange="chktofilter('updateCbx')"
														data-updateCbx='<%=outputJsonStr%>' type="checkbox"
														value="<%=updateDtItem%>" /> <span
														id="updateCbxSpan<%=updDateCounter%>"><%=updateDtItem%>
															(<%=count%>)</span></li>
													<% updDateCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Indicates if resource is approved (&quot;approved&quot;=approved, &quot;not approved&quot;= not approved, record has any other status)."
												class="title">Approval Status :</h3>
											<div>
												<ul>
													<%  
	                                                     Set<String> appStKeySet = appStMap.keySet();
							                             Iterator<String> appStIterator = appStKeySet.iterator();
							                             int appStCounter=0;
							                             while(appStIterator.hasNext()){	                         
								                         String appStItem = appStIterator.next();
								                         Integer count = appStMap.get(appStItem);
								                         String appStJsonStr = getItemsJsonString("approvalstatus",appStItem,arr);
							                        %>
													<li><input id="appstCbx<%=appStCounter%>"
														onchange="chktofilter('appstCbx')"
														data-appstCbx='<%=appStJsonStr%>' type="checkbox"
														value="<%=appStItem%>" /> <span
														id="appstCbxSpan<%=appStCounter%>"><%=appStItem%> (<%=count%>)</span></li>
													<% appStCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="How the resource was published to the portal (e.g. &quot;upload&quot;, &quot;registration&quot;, &quot;harvester&quot; (synchronization), &quot;batch&quot;, &quot;editor&quot;)."
												class="title">Publication Method :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> pubmethodKeySet = pubMthdMap.keySet();
							                            Iterator<String> pubMthdIterator = pubmethodKeySet.iterator();
							                            int pubMthdCounter=0;
							                            while(pubMthdIterator.hasNext()){	                         
								                        String pubMthdItem = pubMthdIterator.next();
								                        Integer count = pubMthdMap.get(pubMthdItem);
								                        String pubmethodJsonStr = getItemsJsonString("pubmethod",pubMthdItem,arr);
							                         %>
													<li><input id="pubMthdCbx<%=pubMthdCounter%>"
														onchange="chktofilter('pubMthdCbx')"
														data-pubMthdCbx='<%=pubmethodJsonStr%>' type="checkbox"
														value="<%=pubMthdItem%>" /> <span
														id="pubMthdCbxSpan<%=pubMthdCounter%>"><%=pubMthdItem%>
															(<%=count%>)</span></li>
													<% pubMthdCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Indicates whether a user must log in to the EDG to view the record. Restricted records may still be published to Data.gov."
												class="title">EDG Access Level :</h3>
											<div>
												<ul>
													<%  
	                                                     Set<String> edgAccKeySet = edgAccMap.keySet();
							                             Iterator<String> edgAccIterator = edgAccKeySet.iterator();
							                             int edgAccCounter=0;
							                             while(edgAccIterator.hasNext()){	                         
								                         String accLvlItem = edgAccIterator.next();
								                         Integer count = edgAccMap.get(accLvlItem);
								                         String edgAccJsonStr = getItemsJsonString("acl_opt",accLvlItem,arr);
							                        %>
													<li><input id="edgAccCbx<%=edgAccCounter%>"
														onchange="chktofilter('edgAccCbx')"
														data-edgAccCbx='<%=edgAccJsonStr%>' type="checkbox"
														value="<%=accLvlItem%>" /> <span
														id="edgAccCbxSpan<%=edgAccCounter%>"><%=accLvlItem%>
															(<%=count%>)</span></li>
													<% edgAccCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Indicates the restriction policy (if any) on whether the data may be released to the public."
												class="title">Data.gov Access Level :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> dataGovAccLvlKeySet = dataGovAccLvlMap.keySet();
							                            Iterator<String> dataGovAccLvlIterator = dataGovAccLvlKeySet.iterator();
							                            int dataGovAccLvlCounter=0; 
							                            while(dataGovAccLvlIterator.hasNext()){	                         
								                        String dataGovAccLvlItem = dataGovAccLvlIterator.next();
								                        Integer count = dataGovAccLvlMap.get(dataGovAccLvlItem);
								                        String dataGovAccLvlJsonStr = getItemsJsonString("accesslevel",dataGovAccLvlItem,arr);
							                        %>
													<li><input
														id="dataGovAccLvlCbx<%=dataGovAccLvlCounter%>"
														onchange="chktofilter('dataGovAccLvlCbx')"
														data-dataGovAccLvlCbx='<%=dataGovAccLvlJsonStr%>'
														type="checkbox" value="<%=dataGovAccLvlItem%>" /><span
														id="dataGovAccLvlCbxSpan<%=dataGovAccLvlCounter%>"><%=dataGovAccLvlItem%>
															(<%=count%>)</span></li>
													<% dataGovAccLvlCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Name of the metadata format or schema of the record."
												class="title">Metadata standard :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> metadataStdKeySet = metadataStdMap.keySet();
							                            Iterator<String> metadataStdIterator = metadataStdKeySet.iterator();
							                            int mtdStdCOunter=0;
							                            while(metadataStdIterator.hasNext()){	                         
								                        String metadataStdItem = metadataStdIterator.next();
								                        Integer count = metadataStdMap.get(metadataStdItem);
								                        String mtdStdJsonStr = getItemsJsonString("schema_key",metadataStdItem,arr);
							                        %>
													<li><input id="mtdCbx<%=mtdStdCOunter%>"
														onchange="chktofilter('mtdCbx')"
														data-mtdCbx='<%=mtdStdJsonStr%>' type="checkbox"
														value="<%=metadataStdItem%>" /><span
														id="mtdCbxSpan<%=mtdStdCOunter%>"><%=metadataStdItem%>
															(<%=count%>)</span></li>
													<% mtdStdCOunter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Type of resource represented by the metadata document."
												class="title">Content Type :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> cntTypeKeySet = cntTypeMap.keySet();
							                            Iterator<String> cntTypeIterator = cntTypeKeySet.iterator();
							                            int cntTypeCounter=0;
							                            while(cntTypeIterator.hasNext()){	                         
								                        String cntTypeItem = cntTypeIterator.next();
								                        Integer count = metadataStdMap.get(cntTypeItem);
								                        String cntTypeJsonStr = getItemsJsonString("content_type",cntTypeItem,arr);
							                        %>
													<li><input id="cntTypeCbx<%=cntTypeCounter%>"
														onchange="chktofilter('cntTypeCbx')"
														data-cntTypeCbx='<%=cntTypeJsonStr%>' type="checkbox"
														value="<%=cntTypeItem%>" /><span
														id="cntTypeCbxSpan<%=cntTypeCounter%>"><%=cntTypeItem%>
															(<%=count%>)</span></li>
													<% cntTypeCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Repository from which the metadata record was harvested."
												class="title">Harvest Source :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> srcKeySet = srcMap.keySet();
							                            Iterator<String> srcIterator = srcKeySet.iterator();
							                            int srcCounter=0;
							                            while(srcIterator.hasNext()){	                         
								                        String srcItem = srcIterator.next();
								                        Integer count = srcMap.get(srcItem);
								                        String srcJsonStr = getItemsJsonString("source",srcItem,arr);
							                       %>
													<li><input id="srcCbx<%=srcCounter%>"
														onchange="chktofilter('srcCbx')"
														data-srcCbx='<%=srcJsonStr%>' type="checkbox"
														value="<%=srcItem%>" /><span
														id="srcCbxSpan<%=srcCounter%>"><%=srcItem%> (<%=count%>)</span></li>
													<% srcCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="This should be a URL to a page describing the license under which the data is released."
												class="title">License URL :</h3>
											<div>
												<ul>
													<%  
	                                                      Set<String> licenseUrlKeySet = licenseUrlMap.keySet();
							                              Iterator<String> licenseUrlIterator = licenseUrlKeySet.iterator();
							                              int licenseUrlCounter=0;
							                              while(licenseUrlIterator.hasNext()){	                         
								                          String lcnsUrlItem = licenseUrlIterator.next();
								                          Integer count = licenseUrlMap.get(lcnsUrlItem);
								                          String licenseUrlJsonStr = getItemsJsonString("licenseurl",lcnsUrlItem,arr);
							                        %>
													<li><input id="licenseUrlCbx<%=licenseUrlCounter%>"
														onchange="chktofilter('licenseUrlCbx')"
														data-licenseUrlCbx='<%=licenseUrlJsonStr%>'
														type="checkbox" value="<%=lcnsUrlItem%>" /><span
														id="licenseUrlCbxSpan<%=licenseUrlCounter%>"><%=lcnsUrlItem%>
															(<%=count%>)</span></li>
													<% licenseUrlCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="If access to a dataset is restricted because of data sensitivity, this field should list the official CUI category. Otherwise it may be free text."
												class="title">Rights (CUI Statement) :</h3>
											<div>
												<ul>
													<%  
	                                                     Set<String> rightsKeySet = rightsMap.keySet();
							                             Iterator<String> rightsIterator = rightsKeySet.iterator();
							                             int rightsCounter=0;
							                             while(rightsIterator.hasNext()){	                         
								                         String rghtsItem = rightsIterator.next();
								                         Integer count = rightsMap.get(rghtsItem);
								                         String rightsJsonStr = getItemsJsonString("rightsnote",rghtsItem,arr);
							                         %>
													<li><input id="rightsCbx<%=rightsCounter%>"
														onchange="chktofilter('rightsCbx')"
														data-rightsCbx='<%=rightsJsonStr%>' type="checkbox"
														value="<%=rghtsItem%>" /><span
														id="rightsCbxSpan<%=rightsCounter%>"><%=rghtsItem%>
															(<%=count%>)</span></li>
													<% rightsCounter++;} %>
												</ul>
											</div>



											<h3 data-toggle="tooltip" data-placement="right"
												title="Indicates whether the metadata record is part of an EDG compilation."
												class="title">Compilation :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> cmplKeySet = cmplMap.keySet();
							                            Iterator<String> cmplIterator = cmplKeySet.iterator();
							                            int cmplCounter=0;
							                            while(cmplIterator.hasNext()){	                         
								                        String cmplItem = cmplIterator.next();
								                        Integer count = cmplMap.get(cmplItem);
								                        String cmplJsonStr = getItemsJsonString("cmpparenttitle",cmplItem,arr);
							                       %>
													<li><input id="cmplCbx<%=cmplCounter%>"
														onchange="chktofilter('cmplCbx')"
														data-cmplCbx='<%=cmplJsonStr%>' type="checkbox"
														value="<%=cmplItem%>" /><span
														id="cmplCbxSpan<%=cmplCounter%>"><%=cmplItem%> (<%=count%>)</span></li>
													<% cmplCounter++;} %>
												</ul>
											</div>

											<h3 data-toggle="tooltip" data-placement="right"
												title="Indicates whether the metadata record is part of a collection recognized by data.gov."
												class="title">Collection :</h3>
											<div>
												<ul>
													<%  
	                                                    Set<String> collKeySet = collMap.keySet();
							                            Iterator<String> collIterator = collKeySet.iterator();
							                            int collCounter=0;
							                            while(collIterator.hasNext()){	                         
								                        String collItem = collIterator.next();
								                        Integer count = collMap.get(collItem);
								                        String collJsonStr = getItemsJsonString("colparenttitle",collItem,arr);
							                       %>
													<li><input id="collCbx<%=collCounter%>"
														onchange="chktofilter('collCbx')"
														data-collCbx='<%=collJsonStr%>' type="checkbox"
														value="<%=collItem%>" /><span
														id="collCbxSpan<%=collCounter%>"><%=collItem%> (<%=count%>)</span></li>
													<% collCounter++;} %>
												</ul>
											</div>
										</div>
									</div>
									<div
										style="width: 70%; height: 50%; float: right; padding-top: 25px; margin-left: -14px; border-style: ridge; margin-right: -30px;">
										<!-- main content -->
										<div style="margin-left: 14px;">
											<!-- ios button: show/hide panel -->
											<!-- panel -->
											<!-- items per page dropdown -->
											<div class="jplist-drop-down"
												data-control-type="items-per-page-drop-down"
												data-control-name="paging" data-control-action="paging">

												<ul>
													<li><span data-number="3"> 3 per page </span></li>
													<li><span data-number="5"> 5 per page </span></li>
													<li><span data-number="10" data-default="true">
															10 per page </span></li>
													<li><span data-number="all"> View All </span></li>
												</ul>
											</div>

											<!-- sort dropdown -->
											<div class="jplist-drop-down"
												data-control-type="sort-drop-down" data-control-name="sort"
												data-control-action="sort"
												data-datetime-format="{month}/{day}/{year}">
												<!-- {year}, {month}, {day}, {hour}, {min}, {sec} -->

												<ul>
													<li><span data-path="default">Sort by</span></li>
													<li><span data-path=".title" data-order="asc"
														data-type="text">Title A-Z</span></li>
													<li><span data-path=".title" data-order="desc"
														data-type="text">Title Z-A</span></li>
													<li><span data-path=".desc" data-order="asc"
														data-type="text">Description A-Z</span></li>
													<li><span data-path=".desc" data-order="desc"
														data-type="text">Description Z-A</span></li>
													<li><span data-path=".like" data-order="asc"
														data-type="number" data-default="true">Likes asc</span></li>
													<li><span data-path=".like" data-order="desc"
														data-type="number">Likes desc</span></li>
													<li><span data-path=".date" data-order="asc"
														data-type="datetime">Date asc</span></li>
													<li><span data-path=".date" data-order="desc"
														data-type="datetime">Date desc</span></li>
												</ul>
											</div>

											<!-- pagination results -->
											<div class="jplist-label"
												data-type="Page {current} of {pages}"
												data-control-type="pagination-info"
												data-control-name="paging" data-control-action="paging">
											</div>

											<!-- pagination control -->
											<div class="jplist-pagination" data-control-type="pagination"
												data-control-name="paging" data-control-action="paging">
											</div>

											<div class="jplist-label" data-type="{all}"
												data-control-type="pagination-info"
												data-control-name="paging" data-control-action="paging">
											</div>
											<!--<span id="noofresults"><%=arr.length()%> items</span></div>-->


											</br>
											<div class="box jplist-no-results text-shadow align-center">
												<p style="font-weight: bold; font-size: 14px;">No
													results found</p>
											</div>
											<!-- data -->

											<div class="list box text-shadow">
												<%for (int i = 0; i < arr.length(); i++) {
                                            JSONObject item = arr.getJSONObject(i);
                                            String title = item.getString("title");
											String docId = item.getString("docuuid");
											//String abst = getAbstractData(docId,ret[1]); 
											String abst = item.getString("abstract");
											String owner = item.getString("username");
											String publisher = item.getString("publisher");
											String epaNonepa = item.getString("epapub");
											String source = item.getString("source");
											String sourceUri = item.getString("sourceuri");
											String metStd = item.getString("schema_key");
											String accLvl = item.getString("accesslevel");
											String licenseUrl = item.getString("licenseurl");
											String rights = item.getString("rightsnote");
											String inputDt = item.getString("inputdate");
											String updateDt = item.getString("updatedate");
											String pgrStatus = item.getString("progressstatus");
											String embeUUID = item.getString("fileidentifier");
											String cmpl = item.getString("cmpparenttitle");
                                            String coll = item.getString("colparenttitle");
											
                                            %>
												<!-- item 1 -->
												<div class="list-item box">
													<!-- data -->
													<button class="titleaccordion title"><%=title%></button>
													<div class="titlepanel">

														<table class="table">
															<thead class="thead-default">
																<tr>
																	<th title="Metadata Links">Metadata Links (XML/Details)</th>
																	<th colspan="2" title="Abstract">Abstract</th>
																</tr>
															</thead>
															<tbody>

																<tr>
																	<td><a href="javaScript:window.open('<% out.print(resourceLink);%>?id=<%=docId%>&xsl=metadata_to_html_full');">Formatted</a></br>
																		<a href="javaScript:window.open('<% out.print(resourceLink);%>?id=<%=docId%>');">XML</a></br>
																		<a href="javaScript:window.open('<% out.print(metadataLink);%>?uuid=<%=docId%>');">Details</a></td>
																	<td colspan="2"><div class="abstract"><%=abst%></div></td>
																</tr>
															</tbody>
															<thead class="thead-default">
																<tr>
																	<th	title="Name of the account or organization that owns the document in the EDG">Owner</th>
																	<th colspan="2"	title="Name of the publisher listed in the document.">Publisher</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="username"><%=owner%></div></td>
																	<td colspan="2"><div class="publisher"><%=publisher%></div></td>
																</tr>
															</tbody>
															<thead class="thead-default">
																<tr>
																	<th	title="Name of the metadata format or schema of the record.">Metadata Standard</th>
																	<th colspan="2"	title="Repository from which the metadata record was harvested.">Source</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="schema_key"><%=metStd%></div></td>
																	<td colspan="2"><div class="source"><%=source%></div></td>
																</tr>
															</tbody>
															<thead class="thead-default">
																<tr>
																	<th>Progress Status</th>
																	<th	title="User id and originating filename/location of the resource."
																		colspan="2">Source URI</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="progressstatus"><%=pgrStatus%></div></td>
																	<td colspan="2"><div class="sourceuri"><%=sourceUri%></div></td>
																</tr>
															</tbody>
															<thead class="thead-default">
																<tr>
																	<th title="EPA Dataset that is contributed to Data.gov.">EPA/Non-EPA status</th>
																	<th title="This should be a URL to a page describing the license under which the data is released."
																		colspan="2">License URL</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="epapub"><%=epaNonepa%></div></td>
																	<td colspan="2"><div class="licenseurl"><%=licenseUrl%></div></td>
																</tr>
															</tbody>
															<thead class="thead-default">
																<tr>
																	<th	title="Indicates the restriction policy (if any) on whether the data may be released to the public.">Project Open Data Access Level</th>
																	<th title="If access to a dataset is restricted because of data sensitivity, this field should list the official CUI category. Otherwise it may be free text."
																		colspan="2">Rights (CUI Statement)</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="accesslevel"><%=accLvl%></div></td>
																	<td colspan="2"><div class="rightsnote"><%=rights%></div></td>
																</tr>
															</tbody>

															<thead class="thead-default">
																<tr>
																	<th title="Data resource was last updated.">Update Date</th>
																	<th	title="Unique string associated with each resource.">Document UUID</th>
																	<th>Embedded UUID</th>

																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="updatedate"><%=updateDt%></div></td>
																	<td><div class="docuuid"><%=docId%></div></td>
																	<td><div class="fileidentifier"><%=embeUUID%></div></td>
																</tr>

															</tbody>
															<thead class="thead-default">
																<tr>
																	<th title="Data resource was registered.">Input Date</th>
																	<th title="Indicates whether the metadata record is part of an EDG compilation.">Compilation</th>
																	<th title="Indicates whether the metadata record is part of a collection recognized by data.gov.">Collection</th>
																</tr>
															</thead>
															<tbody>
																<tr>
																	<td><div class="inputdate"><%=inputDt%></div></td>
																	<td><div class="cmpparenttitle"><%=cmpl%></div></td>
																	<td><div class="colparenttitle"><%=coll%></div></td>
																</tr>

															</tbody>
														</table>
													</div>
												</div>

												<%}%>
											</div>
											<!--<><><><><><><><><><><><><><><><><><><><><><><><><><> DEMO END <><><><><><><><><><><><><><><><><><><><><><><><><><>-->
										</div>


										<!--googleoff: all-->
									</div>
								</div>
							</div>
						</div>
	</section>
	<nav class="nav simple-nav simple-main-nav" role="navigation">
	<div class="nav__inner">
		<h2 class="element-invisible">Main menu</h2>
		<ul class="menu" role="menu">
			<li class="menu-item" id="menu-lawsregs" role="presentation"><a
				data-toggle="tab"
				title="EDG Inventory."
				class="menu-link" role="menuitem">EDG Inventory</a></li>
		</ul>
	</div>
	</nav>
	<footer class="main-footer clearfix" role="contentinfo">
	<div class="main-footer__inner">
		<div class="region-footer">
			<div class="block block-pane block-pane-epa-global-footer">
				<div class="row cols-3">
					<div class="col size-1of3">
						<div class="col__title">Discover.</div>
						<ul class="menu">
							<li><a href="https://www.epa.gov/accessibility">Accessibility</a></li>
							<li><a
								href="https://www.epa.gov/aboutepa/administrator-gina-mccarthy">EPA
									Administrator</a></li>
							<li><a href="https://www.epa.gov/planandbudget">Budget
									&amp; Performance</a></li>
							<li><a href="https://www.epa.gov/contracts">Contracting</a></li>
							<li><a
								href="https://www.epa.gov/home/grants-and-other-funding-opportunities">Grants</a></li>
							<li><a
								href="https://www.epa.gov/ocr/whistleblower-protections-epa-and-how-they-relate-non-disclosure-agreements-signed-epa-employees">No
									FEAR Act Data</a></li>
							<li><a
								href="https://www.epa.gov/home/privacy-and-security-notice">Privacy
									and Security</a></li>
						</ul>
					</div>
					<div class="col size-1of3">
						<div class="col__title">Connect.</div>
						<ul class="menu">
							<li><a href="https://www.data.gov/">Data.gov</a></li>
							<li><a
								href="https://www.epa.gov/office-inspector-general/about-epas-office-inspector-general">Inspector
									General</a></li>
							<li><a href="https://www.epa.gov/careers">Jobs</a></li>
							<li><a href="https://www.epa.gov/newsroom">Newsroom</a></li>
							<li><a href="https://www.whitehouse.gov/open">Open
									Government</a></li>
							<li><a href="http://www.regulations.gov/">Regulations.gov</a></li>
							<li><a
								href="https://www.epa.gov/newsroom/email-subscriptions">Subscribe</a></li>
							<li><a href="https://www.usa.gov/">USA.gov</a></li>
							<li><a href="https://www.whitehouse.gov/">White House</a></li>
						</ul>
					</div>
					<div class="col size-1of3">
						<div class="col__title">Ask.</div>
						<ul class="menu">
							<li><a href="https://www.epa.gov/home/forms/contact-us">Contact
									Us</a></li>
							<li><a href="https://www.epa.gov/home/epa-hotlines">Hotlines</a></li>
							<li><a href="https://www.epa.gov/foia">FOIA Requests</a></li>
							<li><a
								href="https://www.epa.gov/home/frequent-questions-specific-epa-programstopics">Frequent
									Questions</a></li>
						</ul>
						<div class="col__title">Follow.</div>
						<ul class="social-menu">
							<li><a class="menu-link social-facebook"
								href="https://www.facebook.com/EPA">Facebook</a></li>
							<li><a class="menu-link social-twitter"
								href="https://twitter.com/epa">Twitter</a></li>
							<li><a class="menu-link social-youtube"
								href="https://www.youtube.com/user/USEPAgov">YouTube</a></li>
							<li><a class="menu-link social-flickr"
								href="https://www.flickr.com/photos/usepagov">Flickr</a></li>
							<li><a class="menu-link social-instagram"
								href="https://instagram.com/epagov">Instagram</a></li>
						</ul>
						<p class="last-updated">{LAST UPDATED DATE}</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	</footer>
	<script
		src="https://www.epa.gov/sites/all/libraries/template2/jquery.js"></script>
	<script src="https://www.epa.gov/sites/all/libraries/template2/js.js"></script>
	<script
		src="https://www.epa.gov/sites/all/modules/custom/epa_core/js/alert.js"></script>
	<!--[if lt IE 9]><script src="https://www.epa.gov/sites/all/themes/epa/js/ie.js"></script><![endif]-->
	<!-- REMOVE if not using -->

	<script src="javaScripts/external/jquery/jquery.js"></script>
	<script src="javaScripts/jquery-ui.js"></script>
	<script data-main="javaScripts/app" src="javaScripts/lib/require.js"></script>
	<script>

		function filterDropdown() {
			document.getElementById("anytext").value = "";
			document.getElementById("anytext").setAttribute("data-path",
					document.getElementById("sel").value);
		}
		function clearSel() {
			document.getElementById("sel").value = "";
		}
		//jsonObjArr=[{"appstCbx":["approved","approved"],"cmplCbx":["ssds","wdsd"]},{},{}]
		//key=appstCbx
		//value=abc
		function containsValue(jsonObjArr, key, value) {
			//console.log(valArr);
			//console.log(value);
			var isContains = false;
			for (var s = 0; s < jsonObjArr.length; s++) {
				var valArr = jsonObjArr[s][key];
				for (var k = 0; k < valArr.length; k++) {
					if (valArr[k] == value) {
						isContains = true;
						break;
					}

				}
			}
			//console.log(isContains);
			return isContains;
		}
		//Build array with selected items of custom data atribute(data-*) value
		function getCurrentItemSelectionData(checkboxEleId) {
			//console.log('getCurrentItemSelectionData:::'+checkboxEleId);
			var index = 0;
			var selectionDataArr = [];
			var i = 0;
			while (true) {
				var cbxEle = document.getElementById(checkboxEleId + "" + i);
				//console.log(cbxEle);
				if (cbxEle != null) {
					//console.log(cbxEle.checked+"::::"+checkboxEleId);
					if (cbxEle.checked) {
						//console.log('insidecbx selected');
						selectionDataArr[index] = JSON.parse(cbxEle
								.getAttribute("data-" + checkboxEleId));//string to json
						index++;
					}
					i++;
				} else {
					break;
				}
			}
			return selectionDataArr;//[custom data item objects]
		}
		function filterCheckBoxData(checkboxEleId) {
			var eleIdArr = [ "ownerCbx", "epaCbx", "pubCbx", "inputCbx",
					"updateCbx", "appstCbx", "pubMthdCbx", "edgAccCbx",
					"mtdCbx", "dataGovAccLvlCbx", "cntTypeCbx", "srcCbx",
					"licenseUrlCbx", "rightsCbx", "pgrStatusCbx", "cmplCbx",
					"collCbx" ];
			//var eleIdArr = ["ownerCbx","pubCbx"];
			//{'ownerCbx':['w1','w2']}
			//var idToKeyMappingObj ={"ownerCbx":"owner","epaCbx":"epa","pubCbx":"pub","inputCbx":"input","mtdCbx":"mtd"};

			var jsonArray = getCurrentItemSelectionData(checkboxEleId);
			//console.log(jsonArray);
			//for(var jsonIndex =0;jsonIndex<jsonArray.length;jsonIndex++){
			//var obj = jsonArray[jsonIndex];
			for (var j = 0; j < eleIdArr.length; j++) {
				i = 0;
				if (eleIdArr[j] != checkboxEleId) {

					while (true) {
						var cbxEle = document.getElementById(eleIdArr[j] + ""
								+ i);
						var cbxSpanEle = document.getElementById(eleIdArr[j]
								+ "Span" + i);

						if (cbxEle != null) {
							//cbxEle.checked = false;

							if (containsValue(jsonArray, eleIdArr[j],
									cbxEle.value)) {
								cbxEle.style.display = "block";//show
								cbxSpanEle.style.display = "block";
							} else {
								cbxEle.style.display = "none";//hide
								cbxSpanEle.style.display = "none";
							}
						} else {
							break;
						}

						i++;

					}
				}
			}
		}
		function isAnyEleChecked() {
			var flag = false;
			var i = 0;
			var eleIdArr = [ "ownerCbx", "epaCbx", "pubCbx", "inputCbx",
					"updateCbx", "appstCbx", "pubMthdCbx", "edgAccCbx",
					"mtdCbx", "dataGovAccLvlCbx", "cntTypeCbx", "srcCbx",
					"licenseUrlCbx", "rightsCbx", "pgrStatusCbx", "cmplCbx",
					"collCbx" ];

			for (var j = 0; j < eleIdArr.length; j++) {
				i = 0;

				while (true) {
					var cbxEle = document.getElementById(eleIdArr[j] + "" + i);

					if (cbxEle != null) {
						if (cbxEle.checked && cbxEle.style.display == "block") {
							flag = true;
							break;
						}
					} else {
						break;
					}
					i++;
				}
				if (flag)
					break;
			}
			console.log("isAnyEleChecked::" + flag);
			return flag;
		}
		function restAllCbx() {
			var eleIdArr = [ "ownerCbx", "epaCbx", "pubCbx", "inputCbx",
					"updateCbx", "appstCbx", "pubMthdCbx", "edgAccCbx",
					"mtdCbx", "dataGovAccLvlCbx", "cntTypeCbx", "srcCbx",
					"licenseUrlCbx", "rightsCbx", "pgrStatusCbx", "cmplCbx",
					"collCbx" ];
			var i = 0;
			for (var j = 0; j < eleIdArr.length; j++) {
				i = 0;

				while (true) {
					var cbxEle = document.getElementById(eleIdArr[j] + "" + i);//To hide check box
					var cbxSpanEle = document.getElementById(eleIdArr[j]
							+ "Span" + i);//To hide checkbox text

					if (cbxEle != null) {
						cbxEle.checked = false;
						cbxEle.style.display = "block";//show
						cbxSpanEle.style.display = "block";

					} else {
						break;
					}

					i++;

				}

			}
		}
		/**
		 * @checkboxEleId checkbox id prefix
		 * @datapath 
		 */
		function chktofilter(checkboxEleId, ele) {
			// To filter items (owner1 --> pub1,pub2 and input1,input2) 
			//is any item checkbox checkd

			if (isAnyEleChecked() || ele.checked) {
				//Individual Item filtering
				filterCheckBoxData(checkboxEleId);
			} else {
				restAllCbx();
			}

			var i = 0;
			var eleIdArr = [ "ownerCbx", "epaCbx", "pubCbx", "inputCbx",
					"updateCbx", "appstCbx", "pubMthdCbx", "edgAccCbx",
					"mtdCbx", "dataGovAccLvlCbx", "cntTypeCbx", "srcCbx",
					"licenseUrlCbx", "rightsCbx", "pgrStatusCbx", "cmplCbx",
					"collCbx" ];
			var searchStr = "";
			var isFirstTime = false;
			var isAnyItemSearchStrPrepared = false;
			for (var j = 0; j < eleIdArr.length; j++) {
				i = 0;
				isFirstTime = true; //Flag which indicates First time checked checkbox of items(owner,publisher,..)
				while (true) {
					var cbxEle = document.getElementById(eleIdArr[j] + "" + i);
					//ownerCbx0,ownerCbx1....owner10.

					if (cbxEle != null) {
						if (cbxEle.checked) {

							if (searchStr == "") {
								searchStr = cbxEle.value;//OAR-OAP
							} else {
								if (isAnyItemSearchStrPrepared && isFirstTime) {
									searchStr = searchStr + "&&" + cbxEle.value;//OAR-OAP,Region2&&U.S Env,U.S
									isFirstTime = false;
								} else {
									searchStr = searchStr + "," + cbxEle.value;//OAR-OAP,Region2(OAR-OAP,Region2&&U.S Env,U.S,U.S)
								}
							}
						}
					} else {
						if (searchStr != "")
							isAnyItemSearchStrPrepared = true;
						break;
					}
					i++;
				}
			}

			//Results
			document.getElementById("chk").value = searchStr;
			console.log(searchStr);
			if ("createEvent" in document) {
				var evt = document.createEvent("HTMLEvents");
				evt.initEvent("keyup", false, true);
				document.getElementById("chk").setAttribute("data-path", "*");
				document.getElementById("chk").dispatchEvent(evt);
			} else {
				document.getElementById("chk").setAttribute("data-path", "*");
				document.getElementById("chk").fireEvent("onkeyup");
			}
			document.getElementById("anytext").value = "";
		}
		
		//Left side accordion

		$("#accordion").accordion({
			heightStyle : "content",
			collapsible : true,
			active : false
		});
		
		//Right side results accordion

		var acc = document.getElementsByClassName("titleaccordion");
		var i;

		for (i = 0; i < acc.length; i++) {
			acc[i].onclick = function() {
				this.classList.toggle("active");
				var panel = this.nextElementSibling;
				if (panel.style.maxHeight) {
					panel.style.maxHeight = null;
				} else {
					panel.style.maxHeight = panel.scrollHeight + "px";
				}
			}
		}
	</script>

</body>
</html>