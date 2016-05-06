
<% // homeBody.jsp - Home page (JSF body) %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt"%>

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
</style>

<!-- Js -->

<script src="../skins/themes/blue/js/vendor/modernizr-2.6.2.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="../skins/themes/blue/js/vendor/jquery-1.10.2.min.js"><\/script>')</script>
<script src="../skins/themes/blue/js/bootstrap.min.js"></script>
<script src="../skins/themes/blue/js/wow.min.js"></script>
<script src="../skins/themes/blue/js/owl.carousel.min.js"></script>


<script type="text/javascript" src="../js/v1/Utils.js"></script>
<script src="../skins/themes/blue/js/main.js"></script>
<script src="../skins/themes/blue/js/search.js"</script>
<script type="text/javascript">
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
					<li class="menu-item"><a href="{CONTACT URL}"
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
										<p>Easily find Datasets. EDG slogan goes here.</p>
										<div class="app-showcase wow fadeInDown" data-wow-delay=".5s">
											<h:form id="hpFrmSearch"
												onkeypress="javascript:hpSubmitForm(event,this);">
												<h:inputText id="itxFilterKeywordText"
													styleClass="search-field form-control"
													onkeypress="if (event.keyCode == 13) return false;"
													value="#{SearchFilterKeyword.searchText}" />

												<h:commandLink id="btnDoSearch"
													value="#{gptMsg['catalog.search.search.advBtnSearch']}"
													action="#{SearchController.getNavigationOutcome}"
													actionListener="#{SearchController.processAction}"
													onkeypress="if (event.keyCode == 13) return false;">
													<f:attribute name="#{SearchController.searchEvent.event}"
														value="#{SearchController.searchEvent.eventExecuteSearch}" />
													<!--Added by Netty-->
													<f:attribute name="f" value="searchpageresults" />
												</h:commandLink>
											</h:form>
										</div>

									</div>
								</div>

								<div class="col-md-3 col-sm-6">
									<p>
										<i class="fa fa-binoculars fa-2x"></i> <a href="https://edg-staging.epa.gov/metadata/catalog/search/browse/browse.page">Browse
											the EDG</a> <br /> <i class="fa fa-bar-chart fa-2x"></i><a
											href="https://edg-staging.epa.gov/metrics/"> Metrics</a>
									</p>

								</div>
								<!-- Advanced Search -->
								<f:verbatim>
								<script type="text/javascript">
				function hpSubmitForm(event, form) {
					
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
					}</script></f:verbatim>



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


						<section id="service">
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
						</section>


						<section id="feature">
							<div class="container">
								<div class="row">
									<div class="col-md-12">
										<div class="title wow pulse" data-wow-delay=".5s">
											<h2>Popular Information Resources</h2>
											<p>Links to the most popular information in the EDG</p>
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
														<li>EPA Data download site</li>
														<li>Clip and Ship</li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_ClipAndShip_procedures.pdf">How
																to post to the EDG clip and Ship</a></li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_Download_Locations.pdf">How
																to post to the EDG download sites</a></li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay=".8s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-2.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Metadata Publishing</h4>
													<ul>
														<li>Link to Administration functions (sign in needed)</li>
														<li>Link to collections function (sign in needed)</li>
														<li><a href="https://edg.epa.gov/EME/">EPA
																Metadata Editor</a></li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_GettingStarted.pdf">Quick
																start guide for publishing metadata</a></li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_Metadata_Recommendations.pdf">EPA
																Recommendations for Metadata Documentation</a></li>
														<li><a
															href="https://www2.epa.gov/geospatial/epa-geospatial-metadata-technical-specification">Geospatial
																Metadata Technical Specifications</a></li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/GenericMetadataGuide.pdf">Metadata
																Style Guide</a></li>
														<li><a
															href="https://project-open-data.cio.gov/schema/">Project
																Open Data Metadata Schema</a></li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay="1.1s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-3.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Training and More</h4>
													<ul>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_GettingStarted.pdf">How
																to get started publishing metadata to the EDG</a></li>
														<li>Search and discovery</li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_FactSheet.pdf">EDG
																fact sheet</a></li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_ClipAndShip_procedures.pdf">How
																to post to the EDG clip and Ship</a></li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_Download_Locations.pdf">How
																to post to the EDG download sites</a></li>
														<li>Capturing and Using RSS Feeds from the EDG</li>
														<ul>
															<li><a
																href="https://edg-staging.epa.gov/metadata/webhelp/en/gptlv10/index.html#/Welcome_to_the_EPA_Environmental_Dataset_Server_Help/00t00000001z000000/">EDG
																	Help Feature</a></li>
														</ul>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_Metadata_Recommendations.pdf">EPA
																Recommendations for Metadata Documentation</a></li>
													</ul>
												</div>
											</div>
										</div>

									</div>

									<div class="col-md-6 col-sm-6">
										<div class="block">
											<div class="media wow fadeInDown" data-wow-delay="1.4s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-4.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Geospatial Program</h4>
													<ul>
														<li>Link to GeoPlatform</li>
														<li>Link to public geo page</li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay="1.7s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-5.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Developer Resources</h4>
													<ul>
														<li>EDG REST Interface</li>
														<li>EDG Search Widget</li>
														<li>EDG CS-W Interface</li>
														<li><a
															href="https://edg.epa.gov/metadata/webhelp/en/gptlv10/inno/EDG_RSS_Feed_procedures.pdf">Capturing
																and Using RSS Feeds from the EDG</a></li>
														<li>How to get started with EDG Reuse Components</li>
														<li><a href="https://developer.epa.gov">Developer
																Central</a></li>
														<li>Link to RCS</li>
													</ul>
												</div>
											</div>
											<div class="media wow fadeInDown" data-wow-delay="1.9s">
												<img class="media-object pull-left"
													src="../skins/themes/blue/images/item-6.png" alt="Image">
												<div class="media-body">
													<h4 class="media-heading">Open Data</h4>
													<ul>
														<li>Data.gov link</li>
														<li><a href="https://project-open-data.cio.gov/">Project
																Open Data</a></li>
														<li><a
															href="https://project-open-data.cio.gov/schema/">Project
																Open Data Metadata Schema</a></li>
													</ul>
												</div>
											</div>
										</div>

									</div>
								</div>
							</div>
						</section>



						<section id="testimonial">
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
						</section>

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
				<li class="menu-item" id="menu-scitech" role="presentation">
					<%-- styleClass="#{PageContext.tabStyleMap['catalog.content.about']}" --%>
					<h:commandLink id="contentAbout" action="catalog.content.about"
						value="#{gptMsg['catalog.content.about.menuCaption']}"
						styleClass="menu-link" title="About the EDG" />

				</li>
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
						<p class="last-updated">{LAST UPDATED DATE}</p>
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
