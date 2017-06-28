<% // homeBody.jsp - Home page (JSF body) %>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="java.util.Random" %>
<%@page import="com.esri.gpt.framework.http.HttpClientRequest" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt"%>
<%@page import="com.esri.gpt.framework.util.Val"%>  
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%> 
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%!
public String getThumbnail(String uuid)
{
	Map<String, String> imgObject = new HashMap<String, String>();
        imgObject.put("climate", "ac");
		imgObject.put("biophysical", "br");
		imgObject.put("trees", "br");
		imgObject.put("climatologymeteorologyatmosphere", "ac");
		imgObject.put("environment", "ps");
		imgObject.put("health", "hh");
		imgObject.put("human well-being", "hh");
		imgObject.put("public health", "hh");
		imgObject.put("human", "pd");
		imgObject.put("society", "pd");
		imgObject.put("risk", "nz");
		imgObject.put("disaster", "nz");
		imgObject.put("spills", "nz");
		imgObject.put("impact", "am");
		imgObject.put("toxics", "am");
		imgObject.put("waste", "am");
		imgObject.put("location", "ad");
		imgObject.put("buildings", "bu");
		imgObject.put("structure", "bu");
		imgObject.put("cleanup", "am");
		imgObject.put("compliance", "am");
		imgObject.put("contaminant", "am");
		imgObject.put("pollutants & contaminants", "am");
		imgObject.put("management", "am");
		imgObject.put("facilities", "pf");
		imgObject.put("facility", "pf");
		imgObject.put("facility site", "pf");
		imgObject.put("regulatory", "am");
		imgObject.put("remediation", "am");
		imgObject.put("sites", "ad");
		imgObject.put("remediation", "am");
		imgObject.put("resources", "lc");
		imgObject.put("emergency response", "nz");
		imgObject.put("air", "ac");
		imgObject.put("air quality", "ac");
		imgObject.put("emergency", "nz");
		imgObject.put("energy", "er");
		imgObject.put("response", "nz");
		imgObject.put("drinking water", "hy");
		imgObject.put("ground water", "hy");
		imgObject.put("agriculture", "af");
		imgObject.put("hazards", "nz");
		imgObject.put("hazardous air pollutants", "nz");
		imgObject.put("monitoring", "ef");
		imgObject.put("permits", "am");
		imgObject.put("boundaries", "gg");
		imgObject.put("navigation", "gg");
		imgObject.put("roadmap", "gg");
		imgObject.put("routing", "gg");
		imgObject.put("ecology", "sd");
		imgObject.put("biology", "sd");
		imgObject.put("ecosystem", "hb");
		imgObject.put("land", "so");
		imgObject.put("natural resources", "lc");
		imgObject.put("conservation", "br");
		imgObject.put("economy", "su");
		imgObject.put("ecosystem", "hb");
		imgObject.put("habitat", "hb");
		imgObject.put("water", "of");
		imgObject.put("land cover", "lc");
		imgObject.put("modeling", "su");
		imgObject.put("recreation", "pd");
		imgObject.put("oceans", "of");
		imgObject.put("surface water", "hy");
		imgObject.put("air quality", "ac");
		imgObject.put("inlandwaters", "hy");
		imgObject.put("wetlands", "hy");
		imgObject.put("estuary", "hy");
		imgObject.put("census block groups", "cp");
		imgObject.put("transportation", "tn");
		imgObject.put("exposure", "ef");
		imgObject.put("indicator", "ef");
		imgObject.put("riparian", "hy");
		imgObject.put("geoscientificinformation", "gg");
		imgObject.put("biodiversity and ecosystems", "hb");
		imgObject.put("green space", "lc");
		imgObject.put("regulated sites", "pf");
		imgObject.put("toxic release", "am");
		imgObject.put("demographics", "pd");
		imgObject.put("biota", "sd");
		imgObject.put("biodiversity", "sd");
		imgObject.put("geocoding", "gg");
		imgObject.put("elevation", "el");
		
	String thumbnailResponseBody = "";
	String url = "https://edg-staging.epa.gov/metadata/RestQueryServlet?uuid="+URLEncoder.encode(uuid)+"&f=dcat&start=1&max=1";
		
	HttpClientRequest thumbnailClient = new HttpClientRequest();
    JSONObject thumbnailObj = null;
    thumbnailClient.setUrl(url);
		
    try{
		thumbnailResponseBody =  thumbnailClient.readResponseAsCharacters();
		thumbnailObj = new JSONObject(thumbnailResponseBody);
   
    }catch(Exception e){
		//e.printStackTrace();
		return "br";
	}
	String keyword = "";
	try{
	
	thumbnailObj = thumbnailObj.getJSONArray("dataset").getJSONObject(0);
	JSONArray keywordsArray = thumbnailObj.getJSONArray("keyword");
	ArrayList<String> matchArray = new ArrayList<String>();
	for(int i=0; i<keywordsArray.length(); i++){
		String jsonkeyword = keywordsArray.getString(i).toLowerCase();
		if(!matchArray.contains(jsonkeyword) && imgObject.containsKey(jsonkeyword) && jsonkeyword!="environment"){
			matchArray.add(jsonkeyword);
		}
	}
	if (matchArray.size()==0) {
		matchArray.add("environment");
	}
	
	Random random = new Random();
	keyword = matchArray.get(random.nextInt(matchArray.size()));
		
	}catch(Exception ex){
		ex.printStackTrace();
	}
	String thumnailCss = imgObject.containsKey(keyword)?imgObject.get(keyword):"ps";
	return thumnailCss;
}
	%>

<%
String responseBody = "";
//String site = "http://localhost:8080";
String site = "https://edg-staging.epa.gov";
String featuredTab1Title = "Climate Change";
String featuredTab2Title = "Environmental Justice";
String featuredTab3Title = "Facility Data";
String urlSuffix = "&start=1&max=6&f=json";
String baseURL = "/metadata/RestQueryServlet?searchText=";
String popURL = "/metadata/RestQueryServlet?";
/**Climate Change URL**/
String featuredTab1SearchStr = "sys.collection%3a%22%7b9B7778AC-DE79-287A-2A79-F05863C8A212%7d%22";
String tab1 = site + baseURL + featuredTab1SearchStr + urlSuffix;
/**Environmental Justice URL**/
String featuredTab2SearchStr = "sys.collection%3a%22%7bADC0F16A-E2EB-7F86-C1FB-33CB6E726851%7d%22";
String tab2 = site + baseURL + featuredTab2SearchStr + urlSuffix;
/**Facility Data URL**/
String featuredTab3SearchStr = "sys.collection%3a%22%7bD5F39F59-7647-1653-DCCF-1EE6354CE412%7d%22";
String tab3 = site + baseURL + featuredTab3SearchStr + urlSuffix;
/**Popular Datasets URL**/
//String popDataUrl = site + popURL + "childrenof=%7B9007D9FF-E18F-9A91-564F-5C4FF3FAB904%7D" + urlSuffix;
String popDataSearchStr = "sys.collection%3a%22%7b6EAEF950-03F4-566A-62DA-D597657634AC%7d%22";
String popDataUrl = site + baseURL + popDataSearchStr + urlSuffix;
String region1TabTitle = "Region1";
String region2TabTitle = "Region2";
String region3TabTitle = "Region3";
String region4TabTitle = "Region4";
String region5TabTitle = "Region5";
String region6TabTitle = "Region6";
String region7TabTitle = "Region7";
String region8TabTitle = "Region8";
String region9TabTitle = "Region9";
String region10TabTitle = "Region10";
String region1TabSearchStr = "owner=4";
String region2TabSearchStr = "owner=9";
String region3TabSearchStr = "owner=22";
String region4TabSearchStr = "owner=27";
String region5TabSearchStr = "owner=13";
String region6TabSearchStr = "owner=26";
String region7TabSearchStr = "owner=10";
String region8TabSearchStr = "owner=15";
String region9TabSearchStr = "owner=11";
String region10TabSearchStr = "owner=14";
String epaReg1Url = site + popURL + region1TabSearchStr + urlSuffix;
String epaReg2Url = site + popURL + region2TabSearchStr + urlSuffix;
String epaReg3Url = site + popURL + region3TabSearchStr + urlSuffix;
String epaReg4Url = site + popURL + region4TabSearchStr + urlSuffix;
String epaReg5Url = site + popURL + region5TabSearchStr + urlSuffix;
String epaReg6Url = site + popURL + region6TabSearchStr + urlSuffix;
String epaReg7Url = site + popURL + region7TabSearchStr + urlSuffix;
String epaReg8Url = site + popURL + region8TabSearchStr + urlSuffix;
String epaReg9Url = site + popURL + region9TabSearchStr + urlSuffix;
String epaReg10Url = site + popURL + region10TabSearchStr+ urlSuffix;
HttpClientRequest client = new HttpClientRequest();
//data reading from file
JSONObject dataObject=null;
String dataUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/catalog/json/cached_json/metadata_json.json";
client.setUrl(dataUrl);
try{
    responseBody =  client.readResponseAsCharacters();
    dataObject = new JSONObject(responseBody);
   
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject cliChobj= dataObject.getJSONObject("climateChange");
JSONObject ejobj= dataObject.getJSONObject("environmentalJustice");
JSONObject fDataobj= dataObject.getJSONObject("facilityData");
JSONObject popobj= dataObject.getJSONObject("popularDatasets");
JSONObject reg1obj= dataObject.getJSONObject("region1");
JSONObject reg2obj= dataObject.getJSONObject("region2");
JSONObject reg3obj= dataObject.getJSONObject("region3");
JSONObject reg4obj= dataObject.getJSONObject("region4");
JSONObject reg5obj= dataObject.getJSONObject("region5");
JSONObject reg6obj= dataObject.getJSONObject("region6");
JSONObject reg7obj= dataObject.getJSONObject("region7");
JSONObject reg8obj= dataObject.getJSONObject("region8");
JSONObject reg9obj= dataObject.getJSONObject("region9");
JSONObject reg10obj= dataObject.getJSONObject("region10");
%>

<f:verbatim>
	<!-- CSS -->
	<link rel="stylesheet" href="../skins/themes/blue/css/font-awesome.min.css">
	<link rel="stylesheet" href="../skins/themes/blue/css/owl.carousel.css">
	<link rel="stylesheet" href="../skins/themes/blue/css/owl.theme.css">
	<link rel="stylesheet" href="../skins/themes/blue/css/animate.css">

	<style>
.thumbnail .caption {
    padding: 9px;
    color: #333;
    font-weight: bold;
}
.site-name span {
    background: url(https://www.epa.gov/sites/all/themes/epa/img/svg/epa-logo.svg) no-repeat;
    color: transparent;
    display: block;
    font: 0/0 a;
    height: 31px;
    text-shadow: none;
}
thumbnail caption div {
  font-weight:bold;
}
caption, div {
    margin: 0pt;
    padding: 0pt;
	margin-bottom: 0.6em;
}
.inspire-themes-icons-box, .iti-box {
    border-radius: 6px;
    width: 34px;
    height: 34px;
    float: left;
    margin-right: 6px;
    border: 0px;
}
.x50 .iti-box {
    width: 132px;
    height: 121px;
    margin-right: 20px;
}
.x50 .iti-box .icon {
  border-radius: 14px;
  border-width: 2px;
  font-size: 140px;
}
.x50 .iti-box.acr {
  width: 300px;
}
.x50 .iti-box.full {
  width: 1000px;
}
.x50 .iti-box .label,
.x50 .iti-box .label:before {
  margin-left: 15px;
}
.x50 .iti-box.acr .label {
  font-size: 110px;
  margin-top: 30px;
}
.x50 .iti-box.full .label {
  font-size: 46px;
  margin-top: 46px;
  width: 808px;
}
.x50 .iti-box.full .label.two {
  margin-top: 20px;
}
body, .box.special > .pane-content, .box.special > .pane-content {
    font-size: 98%;
}
.media-left, .media>.pull-left {
    padding-right: 24px;
}
.region-footer {
    background-position: 0 0;
    background-size: 5.8824em 5.8824em;
    font-family: "Merriweather","Georgia","Cambria","Times New Roman","Times",serif;
    font-weight: bold;
    min-height: 5.8824em;
    padding-top: 0em;
}
.main-content {
    background-color: #fff;
    color: black;
}
p {
    margin: 0 0 10px;
}
body, button, input, select, textarea {
    font-family: Tahoma, Geneva, Verdana, sans-serif;
}
.title p {
    font-size: 18px;
    font-weight: 400px;
    color: #9da8ad;
}
.title {
    text-align: center;
}
.title h2 {
    font-size: 36px;
    color: #1b1b1b;
    font-weight: 300;
}
.site-slogan {
    padding-top: 1.7272em;
    font-size: 75.75%;
    font-weight: normal;
   
}
.masthead {
    color: #fff;
    padding-bottom: 0em;
    padding-top: 1.2em;
    position: relative;
}
.secondary-menu > li > a {
    color: #fff;
    font-size: 75%;
    margin: -.3333em;
    padding: .3333em;
    text-decoration: none;
}
.nav a, .nav a:visited, .nav a:active {
    border: 0px;
    font-weight: bold;
    margin: 0em 0em;
    text-align: center;
    text-decoration: none;
}
.secondary-nav {
  position: relative;
  z-index: 10;
  height:  0;
}
.secondary-nav > .menu {
    float: right;
    margin-top: .875em;
}
.page-title {
    padding-top: 0.25em;
	visibility: hidden;
}
.main-column, .region-highlighted {
    clear: left;
    margin-top: -4.4em;
}
.main-nav > .nav__inner > .menu > .menu-item > .menu-link {
    /* color: #fff; */
    font-family: "Merriweather", "Georgia", "Cambria", "Times New Roman", "Times", serif;
    font-size: .9em;
    font-weight: bold;
    line-height: 1;
    padding: 1.2em 1.6em;
    text-decoration: none;
    max-width: 83em;
}
body, button, input, select, textarea {
    font-family: Tahoma, Geneva, Verdana, sans-serif;
}
.scrollup {
	width: 40px;
	height: 40px;
	position: fixed;
	bottom: 200px;
	right: 100px;
	display: none;
	text-indent: 50px;
	padding-top: 10px;
	background: url('../skins/themes/blue/images/icon_top.png') no-repeat;
}
</style>

<!-- Js -->

<script type="text/javascript" src="../../catalog/js/jquery-ui/js/jquery.js"></script>
<script type="text/javascript" src="../../catalog/js/jquery-ui/js/jquery-ui.js"></script>
<script src="../skins/themes/blue/js/vendor/modernizr-2.6.2.min.js"></script>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="../skins/themes/blue/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="../skins/themes/blue/css/bootstrap.min.css">
<script>window.jQuery || document.write('<script src="../skins/themes/blue/js/vendor/jquery-1.10.2.min.js"><\/script>')</script>
<script src="../skins/themes/blue/js/wow.min.js"></script>
<script src="../skins/themes/blue/js/owl.carousel.min.js"></script>
<script type="text/javascript" src="../js/v1/Utils.js"></script>
<script src="../skins/themes/blue/js/main.js"></script>
<link rel="stylesheet" href="../skins/themes/blue/css/inspire-themes.css">
<script src="../skins/themes/blue/js/search.js"></script>
<script type="text/javascript">
if (window.location.href == "https://edg-staging.epa.gov/metadata/"){
    window.location.replace("https://edg-staging.epa.gov/metadata/catalog/main/home.page");
}
            new WOW(
            ).init();
			
	jQuery(document).ready(function () {
    jQuery(window).scroll(function () {
        if (jQuery(this).scrollTop() > 100) {
            jQuery('.scrollup').fadeIn();
        } else {
            jQuery('.scrollup').fadeOut();
        }
    });
    jQuery('.scrollup').click(function () {
        jQuery("html, body").animate({
            scrollTop: 0
        }, 600);
        return false;
    });
});
$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});
</script>
	
</f:verbatim>
	
						<div class="container"
							style="background-color: #efefef; width: 100%; padding-top: 10px;">
							<div class="row">
								<div class="col-md-3 col-sm-6">
									<img src="../skins/themes/blue/images/edg_logo.jpg" alt="logo" class="pull-right" style="margin-right:-20px;height:110px;"/>
								</div>
								<div class="col-md-6 col-sm-6">
									<div class="block wow fadeInRight" data-wow-delay="1s">
										<h2>Environmental Dataset Gateway</h2>
										<p>Find data easily. Connecting EPA's Environmental Resources.</p>
										<div class="app-showcase wow fadeInDown" data-wow-delay=".5s">
											<h:form id="hpFrmSearch"
												onkeypress="javascript:hpSubmitForm(event,this);">
												<h:inputText id="itxFilterKeywordText" 
													styleClass="search-field form-control"
													onkeypress="if (event.keyCode == 13) return false;"
													value="#{SearchFilterKeyword.searchText}" />
											    <h:inputHidden id="start" value="1" />
												<h:inputHidden id="max" value="10" />
												<h:commandLink id="btnDoSearch"
													value="#{gptMsg['catalog.search.search.advBtnSearch']}"
													action="#{SearchController.getNavigationOutcome}"
													actionListener="#{SearchController.processAction}"
													onkeypress="if (event.keyCode == 13) return false;javascript:homeSearch();">
													<f:attribute name="#{SearchController.searchEvent.event}"
														value="#{SearchController.searchEvent.eventExecuteSearch}" />
													<!--Added by Netty-->
													<f:attribute name="f" value="searchpageresults" />
												</h:commandLink>
												<h:selectBooleanCheckbox id="region1" value="#{SearchFilterKeyword.checkMap['Region 01']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region2" value="#{SearchFilterKeyword.checkMap['Region 02']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region3" value="#{SearchFilterKeyword.checkMap['Region 03']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region4" value="#{SearchFilterKeyword.checkMap['Region 04']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region5" value="#{SearchFilterKeyword.checkMap['Region 05']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region6" value="#{SearchFilterKeyword.checkMap['Region 06']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region7" value="#{SearchFilterKeyword.checkMap['Region 07']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region8" value="#{SearchFilterKeyword.checkMap['Region 08']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region9" value="#{SearchFilterKeyword.checkMap['Region 09']}" style="display: none;"></h:selectBooleanCheckbox>
												<h:selectBooleanCheckbox id="region10" value="#{SearchFilterKeyword.checkMap['Region 10']}" style="display: none;"></h:selectBooleanCheckbox>
											</h:form>
										</div>
									</div>
								</div>
								<div class="col-md-3 col-sm-6">
									<p>
										<a href="../search/browse/browse.page">
                                        <i class="fa fa-binoculars fa-2x"></i> Browse the EDG</a> </p> 
                                    <p>
                                        <a href="/metrics/"> 
                                        <i class="fa fa-bar-chart fa-2x"></i> Metrics</a> </p>
                                    <p>
                                        <a href="../../webhelp/en/gptlv10/inno/Stewards/Stewards.html" target="_blank">
                                        <i class="fa fa-users fa-2x"></i> Stewards</a>
									</p>
								</div>
								<!-- Advanced Search -->
								<f:verbatim>
								<script type="text/javascript">
				function hpSubmitForm(event, form) {
					homeSearch();
					  var e = event;
					  if (!e) e = window.event;
					  var tgt = (e.srcElement) ? e.srcElement : e.target; 
					  if ((tgt != null) && tgt.id) {
					    if (tgt.id == "frmSearchCriteria:mapInput-locate") return;
					  }
					  
					  if(!GptUtils.exists(event)) {
						 
					    GptUtils.logl(GptUtils.log.Level.WARNING, 
					         "fn submitform: could not get event so as to determine if to submit form ");
					    return;
					  }
					  var code;
					  
					  if(GptUtils.exists(event.which)) {
					    code = event.which;
					  } else if (GptUtils.exists(event.keyCode)) {
					    code = event.keyCode;
					  } else {
					    GptUtils.logl(GptUtils.log.Level.WARNING, 
					         "fn submitForm: Could not determine key pressed");
					    return;
					  }
					  
					  if(code == 13) {
						 		    
					    // Getting main search button
					    var searchButtonId = "hpFrmSearch:btnDoSearch";
					    var searchButton = document.getElementById(searchButtonId);
					    if(!GptUtils.exists(searchButton)){
					      GptUtils.logl(GptUtils.log.Level.WARNING, 
					         "Could not find button id = " + searchButtonId);
					    } else if (!GptUtils.exists(searchButton.click)) {
					      GptUtils.logl(GptUtils.log.Level.WARNING, 
					         "Could not find click action on id = " + searchButtonId);
					    } else {
					    	 searchButton.click();
					    }
					  } else {
					    return true;
					  }
					}
				function executeSearchAction(searchText){
				    searchText=decodeURIComponent(searchText);
					var textEle=document.getElementById('hpFrmSearch:itxFilterKeywordText');
					//var startEle=document.getElementById('hpFrmSearch:start');
					//var maxEle=document.getElementById('hpFrmSearch:max');
					textEle.value=searchText;
					/*start and max values will vary*/
					//startEle.value="7";
					//maxEle.value="100";
					//var searchButtonId = "hpFrmSearch:btnDoSearch";
					//var searchButton = document.getElementById(searchButtonId);
					//searchButton.click();
					clickSearchButton();
					   
				}
				
			 
				function executeRegionSearch(searchText){
					
					var regionEle=document.getElementById('hpFrmSearch:'+searchText);
					regionEle.checked = true;
					uncheckOtherRegions(searchText);
					clickSearchButton();
				}
				function clickSearchButton(){
					var startEle=document.getElementById('hpFrmSearch:start');
					var maxEle=document.getElementById('hpFrmSearch:max');
					
					/*start and max values will vary*/
					startEle.value="7";
					maxEle.value="100";
					var searchButtonId = "hpFrmSearch:btnDoSearch";
					var searchButton = document.getElementById(searchButtonId);
					searchButton.click();
				}
				function uncheckOtherRegions(region){
					
					for(var i=1;i<=10;i++){
						var otherRegion ="region"+i;
						if(otherRegion != region){
							document.getElementById('hpFrmSearch:'+otherRegion).checked =false;
						}
					}
				}
				
				function homeSearch()
				{
					uncheckOtherRegions("reg");
					
				}
				</script></f:verbatim>
								<!-- <div class="col-md-6 col-sm-6">
                   <div class="app-showcase wow fadeInDown" data-wow-delay=".5s">
<input type="search" id="search-header" title="" value="" name="q" class="search-field form-control">
<i class="fa fa-search fa-2x" style=" position: absolute;right: 0px;padding-top:5px;"></i>
<a href="#">Advanced Search</a>
                    </div>
                </div> -->
								<!-- JSF Serach Form Added Here  -->
								<%--  <h:panelGrid columns="1" summary="#{gptMsg['catalog.general.designOnly']}" width="90%" styleClass="homeTableCol">
				<h:panelGrid columns="2" id="_pnlKeyword" cellpadding="0" cellspacing="0"> --%>
								<%-- </h:panelGrid> --%>
								<!-- end -->
							</div>
						</div>
						
						<div class="container">
							<h2>Featured Data Products</h2>
							<ul class="nav nav-tabs">
								<li class="active"><a data-toggle="tab"
									href="#climateChange"><%=featuredTab1Title%></a></li>
								<li><a data-toggle="tab" href="#envJustice"><%=featuredTab2Title%></a></li>
								<li><a data-toggle="tab" href="#facData"><%=featuredTab3Title%></a></li>
							</ul>
							<div class="tab-content">
								<div id="climateChange" class="tab-pane fade in active">
									<div class="row" style="padding-top: 22px">
										<%
											try {
													JSONArray arr = cliChobj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
										<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						
									</div>
									<div class="col-md-12 col-sm-12 text-right">
										<p>
											<a href="javascript: void(0)" onclick="javascript:executeSearchAction('<%=featuredTab1SearchStr%>')">See More</a>
										</p>
										<p></p>
									</div>
								</div>
								<div id="envJustice" class="tab-pane fade">
									<div class="row" style="padding-top: 22px">
										<%
											try {
													JSONArray arr = ejobj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
										
										<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						
									</div>
									<div class="col-md-12 col-sm-12 text-right">
										<p>
											<a href="javascript: void(0)" onclick="javascript:executeSearchAction('<%=featuredTab2SearchStr%>')">See More</a>
										</p>
										<p></p>
									</div>
								</div>
							
								<div id="facData" class="tab-pane fade">
		                        <div class="row" style="padding-top: 22px">
								<%
											try {
													JSONArray arr = fDataobj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
										
										<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						
									</div>
									<div class="col-md-12 col-sm-12 text-right">
										<p>
											<a href="javascript: void(0)" onclick="javascript:executeSearchAction('<%=featuredTab3SearchStr%>')">See More</a>
										</p>
										<p></p>
									</div>
								</div>
									</div>
								</div>
				<div class="container">
						<h2>Popular Datasets</h2>
									<div class="row" style="padding-top: 22px">
										<%
											try {
													JSONArray arr = popobj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
										<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						
									</div>
												<div class="col-md-12 col-sm-12 text-right">
										<p>
											<a href="javascript: void(0)" onclick="javascript:executeSearchAction('<%=popDataSearchStr%>')">See More</a>
										</p>
										<p></p>
									</div>
									</div> 
									<!-- Modal -->
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
				aria-labelledby="ModalLabel" aria-hidden="true">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<div class="modal-title" id="ModalLabel">Please click
								on the map to select a region
							<button type="button" id="mapClose" class="close"
								data-dismiss="modal" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button></div>
						</div>
						<div class="modal-body">
							<img name="usregions"
								src="https://www2.epa.gov/sites/production/files/2013-06/us-regions.png"
								width="450" height="340" border="0" usemap="#m_us-regions"
								alt="Map of the US, split into EPA regions">

							<map name="m_us-regions">

								<area shape="poly"
									coords="390,46,362,40,373,3,426,7,449,42,450,96,419,96,412,84,398,91,394,67,392,65"
									onclick="$('#tab-region1').click(); $('#mapClose').click();"
									title="Region 1: Connecticut, Maine, Massachusetts, New Hampshire, Rhode Island, Vermont"
									alt="Region 1: Connecticut, Maine, Massachusetts, New Hampshire, Rhode Island, Vermont">

								<area shape="poly"
									coords="351,87,356,74,378,51,389,47,392,66,395,67,399,92,412,85,417,99,433,99,433,302,247,302,246,257,348,257,348,303,433,302,433,109,416,110,394,116,388,106,393,101,390,95,391,90,387,90,385,83,352,90"
									onclick="$('#tab-region2').click(); $('#mapClose').click();"
									title="Region 2: New Jersey, New York, Puerto Rico, US Virgin Islands"
									alt="Region 2: New Jersey, New York, Puerto Rico, US Virgin Islands">
								<area shape="poly"
									coords="351,86,345,89,349,105,345,119,340,121,336,131,339,134,342,143,331,150,365,146,396,138,407,152,425,152,426,111,408,111,394,115,388,105,394,99,389,94,392,89,387,89,384,83,352,88"
									onclick="$('#tab-region3').click(); $('#mapClose').click();"
									title="Region 3: Delaware, District of Columbia, Maryland, Pennsylvania, Virginia, West Virginia"
									alt="Region 3: Delaware, District of Columbia, Maryland, Pennsylvania, Virginia, West Virginia">

								<area shape="poly"
									coords="335,130,319,126,318,133,314,131,308,138,294,142,292,148,289,150,292,152,284,157,276,170,279,174,272,185,270,199,274,205,270,221,282,219,288,225,377,268,387,251,398,145,395,138,363,146,330,151,342,142,340,134"
									onclick="$('#tab-region4').click(); $('#mapClose').click();"
									title="Region 4: Alabama, Florida, Georgia, Kentucky, Mississippi, North Carolina, South Carolina, Tennessee "
									alt="Region 4: Alabama, Florida, Georgia, Kentucky, Mississippi, North Carolina, South Carolina, Tennessee ">

								<area shape="poly"
									coords="220,17,220,39,224,41,222,46,225,68,227,68,227,85,262,84,265,92,271,96,271,105,266,108,269,112,264,117,272,134,275,132,278,138,275,141,282,147,282,154,286,155,292,152,290,149,293,149,294,143,309,139,314,131,319,132,320,127,324,128,335,130,341,120,345,120,348,104,345,89,309,24"
									onclick="$('#tab-region5').click(); $('#mapClose').click();"
									title="Region 5: Illinois, Indiana, Michigan, Minnesota, Ohio, Wisconsin"
									alt="Region 5: Illinois, Indiana, Michigan, Minnesota, Ohio, Wisconsin">
								<area shape="poly"
									coords="203,270,217,272,221,256,293,235,282,219,269,221,271,208,273,205,270,198,272,185,279,173,277,169,281,164,274,163,279,160,240,159,239,155,180,155,118,149,107,210,144,234,165,240,190,250"
									onclick="$('#tab-region6').click(); $('#mapClose').click();"
									title="Region 6: Arkansas, Louisiana, New Mexico, Oklahoma, Texas"
									alt="Region 6: Arkansas, Louisiana, New Mexico, Oklahoma, Texas">

								<area shape="poly"
									coords="180,154,182,113,166,112,168,90,186,91,208,92,226,99,228,84,263,84,264,91,271,95,271,105,266,108,268,112,263,118,272,134,274,132,276,136,275,141,283,148,283,153,286,155,280,163,276,164,278,158,239,159,239,155"
									onclick="$('#tab-region7').click(); $('#mapClose').click();"
									title="Region 7: Iowa, Kansas, Missouri, Nebraska"
									alt="Region 7: Iowa, Kansas, Missouri, Nebraska">

								<area shape="poly"
									coords="89,8,83,31,88,43,90,44,91,46,88,50,88,54,91,55,97,65,107,67,111,70,107,95,85,90,76,142,117,149,179,152,181,111,165,110,169,90,207,91,226,97,226,84,226,67,224,66,222,48,223,40,219,36,220,32,219,16"
									onclick="$('#tab-region8').click(); $('#mapClose').click();"
									title="Region 8: Colorado, Montana, North Dakota, South Dakaota, Utah, Wyoming"
									alt="Region 8: Colorado, Montana, North Dakota, South Dakaota, Utah, Wyoming">

								<area shape="poly"
									coords="85,92,10,73,4,86,4,316,86,316,86,244,108,210,117,150,76,142"
									onclick="$('#tab-region9').click(); $('#mapClose').click();"
									title="Region 9: Arizona, California, Hawaii, Nevada, Pacific Islands"
									alt="Region 9: Arizona, California, Hawaii, Nevada, Pacific Islands">

								<area shape="poly"
									coords="1,1,41,2,87,15,83,31,87,44,89,44,91,47,87,49,87,54,91,55,97,67,111,71,106,96,0,71,1,337,240,337,241,274,94,275,93,337,0,337"
									onclick="$('#tab-region10').click(); $('#mapClose').click();"
									title="Region 10: Alaska, Idaho, Oregon, Washington"
									alt="Region 10: Alaska, Idaho, Oregon, Washington">

							</map>
						</div>
					</div>
				</div>
			</div>
			<div class="container" >
				<h2 style="display: inline-block;">Regional Datasets</h2>
				<button type="button" class="btn btn-primary text-left" data-toggle="modal" data-target="#myModal" style="text-align: center;
    padding-bottom: -17px;">Find My Region</button>
				<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#region1" id="tab-region1"><%=region1TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region2" id="tab-region2"><%=region2TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region3" id="tab-region3"><%=region3TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region4" id="tab-region4"><%=region4TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region5" id="tab-region5"><%=region5TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region6" id="tab-region6"><%=region6TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region7" id="tab-region7"><%=region7TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region8" id="tab-region8"><%=region8TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region9" id="tab-region9"><%=region9TabTitle%></a></li>
					<li><a data-toggle="tab" href="#region10" id="tab-region10"><%=region10TabTitle%></a></li>
				</ul>
				<div class="tab-content">

					<div id="region1" class="tab-pane fade in active">
						<div class="row" style="padding-top: 22px">
						<%
											try {
													JSONArray arr = reg1obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
						
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region1')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>

					<div id="region2" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
						<%
											try {
													JSONArray arr = reg2obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region2')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region3" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg3obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region3')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region4" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg4obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>

						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region4')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region5" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg5obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>

						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region5')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region6" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg6obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region6')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region7" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg7obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region7')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region8" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg8obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region8')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region9" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg9obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region9')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
					<div id="region10" class="tab-pane fade">
						<div class="row" style="padding-top: 22px">
							<%
											try {
													JSONArray arr = reg10obj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														String imageHtml = "";
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet = null;
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
																imageHtml = "<img src=\""+hrefDet+"\" data-toggle=\"tooltip\" alt=\"\" title=\""+title+"\">";
																
															}
														}
														
														if(hrefDet == null){
															hrefDet = getThumbnail(uuid);
															imageHtml = "<div class=\"clearfix bshadow0 pbs x50\"><div class=\"iti-box\"><div class=\"icon\"><span class=\"iti-"+hrefDet+"\"></span></div></div></div>";
														}
														counter++;
										%>
										<a
											href="/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<%=imageHtml%>
													<div class="caption" style="word-wrap: break-word; font-size:14px;"><%=title%></div>
												</div>
											</div>
										</a>
							<%
										}
												} catch (Exception e) {
													System.out.println("print catch:" + e);
												}
										%>
						</div>
						<div class="col-md-12 col-sm-12 text-right">
							<p>
								<a href="javascript: void(0)"
									onclick="javascript:executeRegionSearch('region10')">See
									More</a>
							</p>
							<p></p>
						</div>
					</div>
				</div>
			</div>
			<section id="feature">
							<div class="container">
								<div class="row">
									<div class="col-md-12">
										<div class="title wow pulse" data-wow-delay=".5s">
											<h2>Learn More</h2>
											<p>Links to the most popular information in the EDG</p>
											<a href="/metadata/webhelp/en/gptlv10/inno/EDG_FactSheet.pdf" target="_blank">EDG Fact Sheet</a>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-6 col-sm-6">
										<div class="block">
											<div class="media wow fadeInDown" data-wow-delay=".5s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-1.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Download Data</h4>
													<ul>
														<li><a href="/data/" target='_blank'>EPA Data Download Site</a></li>
														<li><a href="/clipship/" target='_blank'>Clip and Ship</a></li>
                                                        <li><a href="ftp://newftp.epa.gov/EPADataCommons/" target='_blank'>EPA Data Commons FTP Site</a></li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay=".8s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-2.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Metadata Publishing</h4>
													<ul>
														<li><a href="/EME/">EPA
																Metadata Editor</a></li>
														<li><a
															href="../../webhelp/en/gptlv10/inno/EDG_GettingStarted.pdf">Quick
																start guide for publishing metadata</a></li>
														<li><a
															href="../../webhelp/en/gptlv10/inno/EDG_Metadata_Recommendations.pdf">EPA
																Recommendations for Metadata Documentation</a></li>
														<li><a
															href="https://www2.epa.gov/geospatial/epa-geospatial-metadata-technical-specification">Geospatial
																Metadata Technical Specifications</a></li>
														<li><a
															href="../../webhelp/en/gptlv10/inno/GenericMetadataGuide.pdf">Metadata
																Style Guide</a></li>
														<li><a
															href="https://project-open-data.cio.gov/schema/">Project
																Open Data Metadata Schema</a></li>
														
														<li><a href="/metadata/webhelp/en/gptlv10/inno/EDG_ClipAndShip_procedures.pdf" target = "_blank">
																How to Post Data to EDG Clip N Ship (PDF)</a></li>
																
														<li><a href="/metadata/webhelp/en/gptlv10/inno/EDG_Download_Locations.pdf" target = "_blank">
														How to Post Data to EDG Download Sites (PDF)</a></li>
														
														<li><a href="/metadata/webhelp/en/gptlv10/inno/Stewards/Stewards.html" target = "_blank">
														List of EDG Stewards (opens new window)</a></li>		
														
													</ul>
												</div>
											</div>
                                            <div class="media wow fadeInDown" data-wow-delay="1.4s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-4.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Geospatial Program</h4>
													<ul>
														<li><a href="https://www.epa.gov/geospatial">EPA Geospatial Program</a></li>
														<li><a href="https://epa.maps.arcgis.com/home/gallery.html#c=organization&o=numviews">EPA GeoPlatform Online</a></li>
                                                        <li><a href="https://www.geoplatform.gov/">Federal GeoPlatform</a></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
									<div class="col-md-6 col-sm-6">
										<div class="block">
											<div class="media wow fadeInDown" data-wow-delay="1.1s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-3.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Training and More</h4>
													<ul>
                                                        <li><a href="../../webhelp/en/gptlv10/index.html#/How_to_Login_and_Manage_my_Password/00t000000023000000/" target="_blank">Get Help Logging In </a></li>
                                                        <li><a href="../../webhelp/en/gptlv10/inno/EDGSearchandDiscovery101Webinar_1.wmv" target = "_blank">EDG Search and Discovery Video 1 (Homepage Overview) (WMV)</a> <a href="../../webhelp/en/gptlv10/inno/SearchandDiscovery101Video1_Agenda.pdf" target = "_blank">Video Agenda</a> <a href="../../webhelp/en/gptlv10/inno/EDGSearchandDiscovery101Presentation1_HomepageWalkThrough.pdf" target = "_blank">Slides (PDF)<a/></li>
                                                        <li><a href="../../webhelp/en/gptlv10/inno/EDGSearchandDiscovery101Webinar_2.wmv" target = "_blank">EDG Search and Discovery Video 2 (Advanced Search) (WMV)</a> <a href="../../webhelp/en/gptlv10/inno/SearchandDiscovery101Video2_Agenda.pdf" target = "_blank">Video Agenda</a> <a href="../../webhelp/en/gptlv10/inno/EDGSearchandDiscovery101Presentation2_AdvancedSearch.pdf" target = "_blank">Slides (PDF)<a/></li>
                                                        <li><a href="../../webhelp/en/gptlv10/inno/EDGSearchandDiscovery101Webinar_3.wmv" target = "_blank">EDG Search and Discovery Video 3 (Search Results) (WMV)</a> &nbsp;<a href="../../webhelp/en/gptlv10/inno/SearchandDiscovery101Video3_Agenda.pdf" target = "_blank">Video Agenda</a> &nbsp;<a href="../../webhelp/en/gptlv10/inno/EDGSearchandDiscovery101Presentation3_SearchResults.pdf" target = "_blank">Slides (PDF)<a/></li>
                                                        <li><a href="../../webhelp/en/gptlv10/inno/EDG_RSS_Feed_procedures.pdf" target = "_blank">How to Capture and Use RSS Feeds from EDG (PDF)</a> </li> 
                                                        <li><a href="../../webhelp/en/gptlv10/inno/EDG_Reuse.pdf" target = "_blank">How to Get Started with EDG Reuse (PDF) </a> </li>
														<li><a href="../../webhelp/en/gptlv10/inno/EDGSOPV3_1_20151118.pdf" target="_blank">EDG Standard Operating Procedure and Governance Document (PDF)</a></li>
														<li><a href="../../webhelp/en/gptlv10/inno/PublicDataForumRolesandResponsibilities.pdf" target="_blank">Public Data Forum Roles and Responsibilites (PDF)</a></li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay="1.7s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-5.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Developer Resources</h4>
													<ul>
														<li><a href="../../webhelp/en/gptlv10/index.html#/Catalog_Service/00t00000004m000000/" target = "_blank">EDG REST Interface</a></li>
														<li><a href="../../webhelp/en/gptlv10/inno/EDG_Reuse.pdf" target = "_blank">EDG Search Widget</a></li>
														<li><a href="../../webhelp/en/gptlv10/index.html#/Catalog_Service/00t00000004m000000/" target = "_blank">EDG CS-W Interface</a></li>
														<li><a href="https://developer.epa.gov" target = "_blank">EPA's Developer Central</a></li>
														<li><a href="https://www.epa.gov/sor/">EPA's System of Registries</a></li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay="1.9s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-6.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Open Data</h4>
													<ul>
														<li><a href="https://www.data.gov/">U.S. Government's Open Data Site: Data.gov</a></li>
														<li><a href="https://project-open-data.cio.gov/">Federal Open Data Policy: Project
																Open Data</a></li>
														<li><a
															href="https://project-open-data.cio.gov/schema/">Project
																Open Data Metadata Schema</a></li>
                                                        <li><a href="https://www.epa.gov/open/digital-strategy">EPA Digital Strategy for Open Data</a></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
					</section>			
