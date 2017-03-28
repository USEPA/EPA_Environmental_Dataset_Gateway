<% // homeBody.jsp - Home page (JSF body) %>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="com.esri.gpt.framework.http.HttpClientRequest" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt"%>
<%@page import="com.esri.gpt.framework.util.Val"%>  
<%
String responseBody = "";
//String site = "http://localhost:8080";
String site = "https://edg-staging.epa.gov";
String featuredTab1Title = "Climate Change";
String featuredTab2Title = "Environmental Justice";
String featuredTab3Title = "Facility Data";
String urlSuffix = "&start=1&max=6&f=json";
String baseURL = "/metadata/rest/find/document?searchText=";
String popURL = "/metadata/rest/find/document?";
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

String epaReg1Url = site + popURL + "owner=Region%201&f=json";
String epaReg2Url = site + popURL + "owner=Region%202&f=json";
String epaReg3Url = site + popURL + "owner=Region%203&f=json";
String epaReg4Url = site + popURL + "owner=Region%204&f=json";
String epaReg5Url = site + popURL + "owner=Region%205&f=json";
String epaReg6Url = site + popURL + "owner=Region%206&f=json";
String epaReg7Url = site + popURL + "owner=Region%207&f=json";
String epaReg8Url = site + popURL + "owner=Region%208&f=json";
String epaReg9Url = site + popURL + "owner=Region%209&f=json";
String epaReg10Url = site + popURL + "owner=Region%2010&f=json";

String region1TabSearchStr = "sys.owner:4";
String region2TabSearchStr = "sys.owner:9";
String region3TabSearchStr = "sys.owner:22";
String region4TabSearchStr = "sys.owner:27";
String region5TabSearchStr = "sys.owner:13";
String region6TabSearchStr = "sys.owner:26";
String region7TabSearchStr = "sys.owner:10";
String region8TabSearchStr = "sys.owner:15";
String region9TabSearchStr = "sys.owner:11";
String region10TabSearchStr = "";
HttpClientRequest client = new HttpClientRequest();
JSONObject cliChobj=null;
client.setUrl(tab1);
try{
    responseBody =  client.readResponseAsCharacters();
    cliChobj = new JSONObject(responseBody);
   
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject ejobj=null;
client.setUrl(tab2);
try{
    responseBody =  client.readResponseAsCharacters();
    ejobj = new JSONObject(responseBody);
   
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject fDataobj=null;
client.setUrl(tab3);
try{
    responseBody =  client.readResponseAsCharacters();
    fDataobj = new JSONObject(responseBody);
   
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject popobj=null;
client.setUrl(popDataUrl);
try{
    responseBody =  client.readResponseAsCharacters();
    popobj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg1obj=null;
client.setUrl(epaReg1Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg1obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg2obj=null;
client.setUrl(epaReg2Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg2obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg3obj=null;
client.setUrl(epaReg3Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg3obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg4obj=null;
client.setUrl(epaReg4Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg4obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg5obj=null;
client.setUrl(epaReg5Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg5obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg6obj=null;
client.setUrl(epaReg6Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg6obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg7obj=null;
client.setUrl(epaReg7Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg7obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg8obj=null;
client.setUrl(epaReg8Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg8obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg9obj=null;
client.setUrl(epaReg9Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg9obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
JSONObject reg10obj=null;
client.setUrl(epaReg10Url);
try{
    responseBody =  client.readResponseAsCharacters();
    reg10obj = new JSONObject(responseBody);
    
   }catch(Exception e){
    e.printStackTrace();
}
%>
<f:view>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
	<!--[if IEMobile 7]><html class="iem7 no-js" lang="en" dir="ltr"><![endif]-->
	<!--[if lt IE 7]><html class="lt-ie9 lt-ie8 lt-ie7 no-js" lang="en" dir="ltr"><![endif]-->
	<!--[if (IE 7)&(!IEMobile)]><html class="lt-ie9 lt-ie8 no-js" lang="en" dir="ltr"><![endif]-->
	<!--[if IE 8]><html class="lt-ie9 no-js" lang="en" dir="ltr"><![endif]-->
	<!--[if (gt IE 8)|(gt IEMobile 7)]><!-->
	<html>
<!--<![endif]-->
<f:loadBundle basename="gpt.resources.gpt" var="gptMsg" />
<gpt:prepareView />
<%-- <gpt:prepareView/> --%>
<f:verbatim>
	<script type="text/javascript"
		src="../../catalog/js/jquery-ui/js/jquery.js"></script>
	<script type="text/javascript"
		src="../../catalog/js/jquery-ui/js/jquery-ui.js"></script>
		
	<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="HandheldFriendly" content="true" />
<link rel="shortcut icon"
	href="http://www2.epa.gov/sites/all/themes/epa/favicon.ico"
	type="image/vnd.microsoft.icon" />
<meta name="MobileOptimized" content="width" />
<meta http-equiv="cleartype" content="on" />
<meta http-equiv="ImageToolbar" content="false" />
<meta name="viewport" content="width=device-width" />
<meta name="version" content="20150331" />
<!--googleon: all-->
<meta name="DC.description" content="" />
<meta name="DC.title" content="" />
<title>Environmental Dataset Gateway | US EPA</title>
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

<!-- EPA Stuff -->
<link type="text/css" rel="stylesheet"
	href="https://www2.epa.gov/sites/all/libraries/template/s.css"
	media="all" />
<!--[if lt IE 9]><link type="text/css" rel="stylesheet" href="https://www2.epa.gov/sites/all/themes/epa/css/ie.css" media="all" /><![endif]-->
<link rel="alternate" type="application/atom+xml" title="EPA.gov News"
	href="https://yosemite.epa.gov/opa/admpress.nsf/RSSRecentNews" />
<link rel="alternate" type="application/atom+xml"
	title="EPA.gov Headquarters Press Releases"
	href="https://yosemite.epa.gov/opa/admpress.nsf/RSSByLocation?open&amp;location=Headquarters" />
<link rel="alternate" type="application/atom+xml"
	title="Greenversations, EPA's Blog"
	href="https://blog.epa.gov/blog/feed/" />
<!--[if lt IE 9]><script src="https://www2.epa.gov/sites/all/themes/epa/js/html5.js"></script><![endif]-->


<!-- CSS -->
<link rel="stylesheet" href="../skins/themes/blue/css/bootstrap.min.css">
<link rel="stylesheet"
	href="../skins/themes/blue/css/font-awesome.min.css">
<link rel="stylesheet" href="../skins/themes/blue/css/owl.carousel.css">
<link rel="stylesheet" href="../skins/themes/blue/css/owl.theme.css">
<link rel="stylesheet" href="../skins/themes/blue/css/animate.css">
<link rel="stylesheet" href="../skins/themes/blue/css/main.css">
<link rel="stylesheet" href="../skins/themes/blue/css/responsive.css">
<style>
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
.secondary-nav {
  position: relative;
  z-index: 10;
  height:  0;
}
.bigGreen {
    -webkit-appearance: none;
    -webkit-rtl-ordering: logical;
    -webkit-user-select: none;
    background-color: rgb(118, 182, 108);
    background-image: -webkit-linear-gradient(top, rgba(255, 255, 255, 0.2) 0%, rgba(0, 0, 0, 0.14902) 100%);
    background-image: -ms-linear-gradient(top,rgba(255,255,255,.2) 0%,rgba(0,0,0,.15) 100%);
    background-image:-moz-linear-gradient(top,rgba(255,255,255,.2) 0%,rgba(0,0,0,.15) 100%);
    background-image: linear-gradient(top,rgba(255,255,255,.2) 0%,rgba(0,0,0,.15) 100%);
    border-bottom-color: rgb(118, 182, 108);
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    border-bottom-style: solid;
    border-bottom-width: 1px;
    border-image-outset: 0px;
    border-image-repeat: stretch;
    border-image-slice: 100%;
    border-image-source: none;
    border-image-width: 1;
    border-left-color: rgb(118, 182, 108);
    border-left-style: solid;
    border-left-width: 1px;
    border-right-color: rgb(118, 182, 108);
    border-right-style: solid;
    border-right-width: 1px;
    border-top-color: rgb(118, 182, 108);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
    border-top-style: solid;
    border-top-width: 1px;
    border-radius: 4px;
	border: 0;
    box-sizing: border-box;
    color: rgb(255, 255, 255);
    cursor: pointer;
    display: inline-block;
    font-family: Tahoma, Geneva, Verdana, sans-serif;
    font-size: 14px;
    font-stretch: normal;
    font-style: normal;
    font-variant: normal;
    font-weight: bold;
    height: 24px;
    letter-spacing: normal;
    line-height: 22px;
    max-width: 100%;
    outline-color: rgb(255, 255, 255);
    outline-style: none;
    outline-width: 0px;
    padding-bottom: 0px;
    padding-left: 7px;
    padding-right: 7px;
    padding-top: 0px;
    text-align: center;
    text-decoration: none;
    text-indent: 0px;
    text-rendering: auto;
    text-shadow: none;
    text-transform: none;
    transition-delay: 0s, 0s, 0s, 0s, 0s, 0s, 0s;
    transition-duration: 0.25s, 0.25s, 0.25s, 0.25s, 0.25s, 0.25s, 0.25s;
    transition-property: background-color, border-color, box-shadow, color, opacity, text-shadow, transform;
    transition-timing-function: linear, linear, linear, linear, linear, linear, linear;
    vertical-align: baseline;
    word-spacing: 0px;
    word-wrap: break-word;
    writing-mode: lr-tb;
    -webkit-writing-mode: horizontal-tb;
}
.bigGreen:hover{
    background-color: #85cf7a;
    border-color: #85cf7a;
    outline: 0;
}
</style>

<!-- Js -->

<script src="../skins/themes/blue/js/vendor/modernizr-2.6.2.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="../skins/themes/blue/js/vendor/jquery-1.10.2.min.js"><\/script>')</script>
<script src="../skins/themes/blue/js/bootstrap.min.js"></script>
<script src="../skins/themes/blue/js/wow.min.js"></script>
<script src="../skins/themes/blue/js/owl.carousel.min.js"></script>
<script type="text/javascript" src="../js/v1/Utils.js"></script>
<script src="../skins/themes/blue/js/main.js"></script>
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
</head>
<body class="node-type-page resource-directory wide-template">
	<!-- Google Tag Manager -->
	<noscript>
		<iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB"
			height="0" width="0" style="display: none; visibility: hidden"></iframe>
	</noscript>
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-L8ZB');</script>
	<!-- End Google Tag Manager -->
	<div class="skip-links">
		<a href="#main-content"
			class="skip-link element-invisible element-focusable">Jump to
			main content</a>
	</div>
	<header class="masthead clearfix" role="banner">
		<img class="site-logo"
			src="https://www2.epa.gov/sites/all/themes/epa/logo.png" alt="" />
		<hgroup class="site-name-and-slogan">
			<h1 class="site-name">
				<a href="https://www.epa.gov/" title="Go to the home page" rel="home"><span>US
						EPA</span></a>
			</h1>
			<div class="site-slogan">United States Environmental Protection
				Agency</div>
		</hgroup>
		<%-- <form class="epa-search" method="get" action="https://search.epa.gov/epasearch/epasearch">
      <label class="element-hidden" for="search-box">Search</label>
      <input class="form-text" placeholder="Search EPA.gov" name="querytext" id="search-box" value=""/>
      <button class="epa-search-button" id="search-button" type="submit" title="Search">Search</button>
      <input type="hidden" name="fld" value="" />
      <input type="hidden" name="areaname" value="" />
      <input type="hidden" name="areacontacts" value="" />
      <input type="hidden" name="areasearchurl" value="" />
      <input type="hidden" name="typeofsearch" value="epa" />
      <input type="hidden" name="result_template" value="2col.ftl" />
      <input type="hidden" name="filter" value="sample4filt.hts" />
    </form> --%>
	</header>
	<section id="main-content" class="main-content clearfix" role="main">
		<div class="region-preface clearfix">
			<div id="block-pane-epa-web-area-connect"
				class="block block-pane contextual-links-region">
				<ul class="menu utility-menu">
					<li class="menu-item"><a href="../identity/feedback.page"
						class="menu-link contact-us">Contact Us</a></li>
				</ul>
			</div>
		</div>
			
		<div class="main-column clearfix">
			<!--googleon: all-->
			<%-- <h1 class="page-title"></h1> --%>
			<div class="panel-pane pane-node-content">
				<div class="pane-content">
					<div class="node node-page clearfix view-mode-full">
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
                                        <a href="../../webhelp/en/gptlv10/inno/Stewards/Stewards.html">
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
										%>
										<a
											href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<img src="<%=hrefDet%>" data-toggle="tooltip" alt="" title="<%=title%>">
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
										%>
										<a
											href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<img src="<%=hrefDet%>" data-toggle="tooltip" alt="" title="<%=title%>">
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
										%>
										<a
											href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<img src="<%=hrefDet%>" data-toggle="tooltip" alt="" title="<%=title%>">
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
							</div>
						</div>
					</div>
	<%-- 					<section id="service">
							<div class="container">
								<div class="row">
									<div class="col-md-12">
										<div class="title wow pulse" data-wow-delay=".5s">
											<h2>Featured Datasets</h2>
											<p>Here you will find our most popular datsets</p>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4 col-sm-4">
										<div class="block wow fadeInLeft" data-wow-delay=".7s">
											<img src="../skins/themes/blue/images/climate_square.jpg"
												alt="">
											<h3>Climate Change</h3>
											<p>Lorem Ipsum is simply dummy text of the printing and
												typesetting industry. Lorem Ipsum has been typesetting
												industry</p>
										</div>
									</div>
									<div class="col-md-4 col-sm-4">
										<div class="block wow fadeInLeft" data-wow-delay=".8s">
											<img src="../skins/themes/blue/images/ej_square.jpg" alt="">
											<h3>Environmental Justice</h3>
											<p>Lorem Ipsum is simply dummy text of the printing and
												typesetting industry. Lorem Ipsum has been typesetting
												industry</p>
										</div>
									</div>
									<div class="col-md-4 col-sm-4">
										<div class="block wow fadeInLeft" data-wow-delay="1.1s">
											<img src="../skins/themes/blue/images/facility_square.jpg"
												alt="">
											<h3>Facility Data</h3>
											<p>Lorem Ipsum is simply dummy text of the printing and
												typesetting industry. Lorem Ipsum has been typesetting
												industry</p>
										</div>
									</div>
								</div>
							</div>
						</section> --%>
				<div class="container">
						<h2>Popular Datasets</h2>
									<div class="row" style="padding-top: 22px">
										<%
											try {
													JSONArray arr = popobj.getJSONArray("records");
													int counter = 0;
													for (int i = 0; i < arr.length(); i++) {
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
										%>
										<a
											href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
											target="_blank">
											<div class="col-md-2">
												<div class="thumbnail">
													<img src="<%=hrefDet%>" data-toggle="tooltip" alt="" title="<%=title%>">
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
    padding-bottom: 24px;">Find My Region</button>
				<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="region1" id="tab-region1"><%=region1TabTitle%></a></li>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {

															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");

															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
														JSONObject record = arr.getJSONObject(i);
														JSONArray links = record.getJSONArray("links");
														String title = record.getString("title");
														String uuid = record.getString("id");
														if (counter == 6) {
															break;
														}
														String hrefDet="../skins/themes/blue/images/generalicon100x120.png";
														for (int j = 0; j < links.length(); j++) {
															JSONObject details = links.getJSONObject(j);
															String typeDet = details.getString("type");
															if ("thumbnail".equalsIgnoreCase(typeDet)) {
																hrefDet = details.getString("href");
															}
														}
														counter++;
														%>
							<a
								href="https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page?uuid=<%=uuid%>"
								target="_blank">
								<div class="col-md-2">
									<div class="thumbnail">
										<img src="<%=hrefDet%>" data-toggle="tooltip" alt=""
											title="<%=title%>">
										<div class="caption"
											style="word-wrap: break-word; font-size: 14px;"><%=title%></div>
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
						<%-- <section id="testimonial">
							<div class="container">
								<div class="row">
									<div class="col-md-12">
										<div class="block">
											<div id="owl-example" class="owl-carousel">
												<div>
													<h5>Got a question?</h5>
												</div>
												<div>
													<h5>Got a comment?</h5>
												</div>
												<div>
													<h5>
														<a href="https://developer.epa.gov/forums"
															style="color: #FFF">Visit our Developer Forum!</a>
													</h5>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</section> --%>
						<a href="#" class="scrollup">Top</a>
					</div>
				</div>
			</div>
			<div id="block-epa-og-footer" class="block block-epa-og"></div>
			<!--googleoff: all-->
		</div>
	</section>
	<h:form id="frmPrimaryNavigation">
		<nav class="nav simple-nav simple-main-nav" role="navigation">
			<h2 class="element-invisible">Main menu</h2>
			<ul class="menu" role="menu">
				<li class="menu-item" id="menu-learn" role="presentation"><h:commandLink
						id="mainHome" action="catalog.main.home"
						value="#{gptMsg['catalog.main.home.menuCaption']}"
						styleClass="menu-link" /></li>
			<%-- 	<li class="menu-item" id="menu-scitech" role="presentation">
					styleClass="#{PageContext.tabStyleMap['catalog.content.about']}"
					<h:commandLink id="contentAbout" action="catalog.content.about"
						value="#{gptMsg['catalog.content.about.menuCaption']}"
						styleClass="menu-link" title="About the EDG" />
				</li> --%>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
						id="searchHome" action="catalog.search.home"
						value="#{gptMsg['catalog.search.home.menuCaption']}"
						styleClass="menu-link" /></li>
				<li class="menu-item" id="menu-about" role="presentation"><h:commandLink
						id="browse" action="catalog.browse" styleClass="menu-link"
						value="#{gptMsg['catalog.browse.menuCaption']}"
						rendered="#{PageContext.tocsByKey['browseCatalog']}" /></li>
				<li class="menu-item" id="menu-about" role="presentation"><h:commandLink
						id="data" action="catalog.data.home"
						value="#{gptMsg['catalog.data.home.menuCaption']}"
						styleClass="menu-link" title="Data" /></li>
				<li class="menu-item" id="menu-about" role="presentation"><h:commandLink
						id="components" action="catalog.components.home"
						value="#{gptMsg['catalog.components.home.menuBar.menuCaption']}"
						styleClass="menu-link" title="Reuse Components of the EDG" /></li>
				<li class="menu-item" id="menu-about" role="presentation"><h:commandLink
						id="resources" action="catalog.resources.home"
						value="#{gptMsg['catalog.resources.home.menuCaption']}"
						styleClass="menu-link" title="Resources" /></li>
				<h:panelGroup rendered="#{PageContext.roleMap['gptPublisher']}">
			    <li class="menu-item" id="menu-about" role="presentation"><h:commandLink 
                        id="publicationManageMetadata"
                        action="catalog.publication.manageMetadata" 
                        styleClass="menu-link"
                        value="#{gptMsg['catalog.publication.manageMetadata.menuCaption']}"
                        rendered="#{PageContext.roleMap['gptPublisher']}"
                        actionListener="#{ManageMetadataController.processAction}" /></li>
                <li class="menu-item" id="menu-about" role="presentation"><h:commandLink
                        id="collection" 
                        action="catalog.collection.home"
                        value="#{gptMsg['catalog.collection.home.menuCaption']}"
                        styleClass="menu-link"
                        rendered="#{PageContext.roleMap['gptPublisher']}"/></li></h:panelGroup>
		</ul>
		</nav>
	</h:form>
	<f:verbatim>
	<script type="text/javascript">
	function openHelp(sTitle, sKey) {
		var sUrl = "<%=request.getContextPath()%>/webhelp/index.jsp";
		var sLang= "<%=com.esri.gpt.framework.jsf.PageContext.extract().getLanguage()%>";
		var sVers= "<%=com.esri.gpt.framework.jsf.PageContext.extract().getVersion()%>";
		if (sKey) sUrl += "?cmd="+sKey;
		if (sLang) {
		  if (sKey) {
		    sUrl += "&";
		  } else {
		    sUrl += "?";
		  }
		  sUrl += "lang="+sLang;
		}
		if (sVers) {
		  if (sKey || sLang) {
		    sUrl += "&";
		  } else {
		    sUrl += "?";
		  }
		  sUrl += "vers="+sVers;
		}
		var sOpt = "left=10,top=10,width=770,height=450";
		sOpt += ",toolbar=0,location=0,directories=0,status=0,resizable=yes,scrollbars=yes";
		var winHelp = window.open(sUrl,sTitle,sOpt);
		winHelp.focus();
	}
	
	function mainOpenHelp() {
		openHelp("GPT_Help", "toc");
	}
	function mainOpenInternalLink(oLink,sHref) {
		if (oLink && oLink.href && sHref) {
			oLink.href = "<%=request.getContextPath()%>/"+sHref;
		}
	}
	
	function mainOpenPageHelp() {
		openHelp("GPT_Context_Help", "<%=com.esri.gpt.framework.jsf.PageContext.extract().getPageId()%>");
	}
        </script></f:verbatim>
	<h:form id="frmTertiaryNavigation">
		<nav class="nav simple-nav simple-secondary-nav" role="navigation">
			<h2 class="element-invisible">Secondary menu</h2>
			<ul class="menu secondary-menu">
				<li class="menu-1569 menu-item"><h:commandLink
						id="identityLogin" action="catalog.identity.login"
						value="#{gptMsg['catalog.identity.login.menuCaption']}"
						styleClass="menu-link"
						rendered="#{PageContext.roleMap['anonymous'] && PageContext.identitySupport.supportsLogin}" />
				</li>
				<li><h:commandLink id="msgAuthenticatedUser"
						rendered="#{not PageContext.roleMap['anonymous']}"
						value="#{PageContext.welcomeMessage}" styleClass="menu-link" /></li>
				<li><h:commandLink id="msgNonAuthenticatedUser"
						rendered="#{PageContext.roleMap['anonymous']}"
						value="#{gptMsg['catalog.site.anonymous']}" styleClass="menu-link"/></li>
				<li><h:commandLink action="catalog.identity.logout"
		                id="identityLogoutAE" styleClass="menu-link"
		                rendered="#{not PageContext.roleMap['anonymous'] && PageContext.identitySupport.supportsLogout}">
		                <h:outputText value="#{gptMsg['catalog.identity.logout.menuCaption']}" /></h:commandLink>
	                    </li>
	                
				<li><h:outputLink value="#"
						id="openHelp" onclick="javascript:mainOpenPageHelp()"
						styleClass="menu-link">
						<h:outputText value="#{gptMsg['catalog.help.menuCaption']}" />
					</h:outputLink></li>
				<li><div id="gptBanner">
				   <h:outputLink styleClass="bigGreen" value="#"
						style="padding-top:0px;border: 0" id="openShareFeedback"
						onclick="window.open('https://developer.epa.gov/forums/forum/dataset-qa/', 'ShareYourFeedback')">
						<h:outputText value="#{gptMsg['catalog.shareFeedback']}" />
					</h:outputLink></div></li>
				
			</ul>
		</nav>
		
	</h:form>
	                  
        
	<footer class="main-footer clearfix" role="contentinfo">
		<div class="region-footer">
			<div id="block-epa-core-footer" class="block block-epa-core">
				<div class="row cols-2">
					<div class="col size-2of5">
						<ul class="pipeline">
							<li><a href="https://www.epa.gov/">EPA Home</a></li>
							<li><a
								href="https://www2.epa.gov/home/privacy-and-security-notice">Privacy
									and Security Notice</a></li>
							<li><a href="https://www2.epa.gov/accessibility">Accessibility</a></li>
						</ul>
						<!-- <p class="last-updated">{LAST UPDATED DATE}</p> -->
					</div>
					<div class="col size-3of5">
						<ul class="menu epa-menu">
							<li class="menu-item"><a class="menu-link epa-hotline"
								href="https://www2.epa.gov/home/epa-hotlines">Hotlines</a></li>
							<li class="menu-item"><a class="menu-link epa-news"
								href="https://www2.epa.gov/newsroom">News</a></li>
							<li class="menu-item"><a class="menu-link epa-blog"
								href="https://www2.epa.gov/aboutepa/greenversations">Blogs</a></li>
							<li class="menu-item"><a class="menu-link epa-apps"
								href="https://developer.epa.gov/category/apps/">Apps</a></li>
							<li class="menu-item"><a class="menu-link epa-widgets"
								href="https://developer.epa.gov/category/widgets/">Widgets</a></li>
						</ul>
						<div class="social-menu-wrapper">
							<div class="social-menu-title">Social sites:</div>
							<ul class="menu social-menu">
								<li class="menu-item"><a class="menu-link social-twitter"
									href="https://twitter.com/epa">Twitter</a></li>
								<li class="menu-item"><a class="menu-link social-facebook"
									href="https://www.facebook.com/EPA">Facebook</a></li>
								<li class="menu-item"><a class="menu-link social-youtube"
									href="https://www.youtube.com/user/USEPAgov">YouTube</a></li>
								<li class="menu-item"><a class="menu-link social-flickr"
									href="https://www.flickr.com/photos/usepagov">Flickr</a></li>
								<li class="menu-item"><a class="menu-link social-instagram"
									href="https://instagram.com/epagov">Instagram</a></li>
							</ul>
							<p class="social-menu-more">
								<a href="https://www2.epa.gov/home/social-media">More social
									media at&#160;EPA&#160;»</a>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</footer>
	<script
		src="https://www2.epa.gov/sites/all/libraries/template/jquery.js"></script>
	<script src="https://www2.epa.gov/sites/all/libraries/template/js.js"></script>
	<script
		src="https://www2.epa.gov/sites/all/modules/custom/epa_core/js/alert.js"></script>
	<!--[if lt IE 9]><script src="https://www2.epa.gov/sites/all/themes/epa/js/ie.js"></script><![endif]-->
</body>
	</html>
</f:view>
