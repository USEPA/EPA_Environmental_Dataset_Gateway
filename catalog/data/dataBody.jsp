<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt" %>
<%@taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<f:view>
<f:loadBundle basename="gpt.resources.gpt" var="gptMsg"/>
<gpt:prepareView/>
<!--[if IEMobile 7]><html class="iem7 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if lt IE 7]><html class="lt-ie9 lt-ie8 lt-ie7 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if (IE 7)&(!IEMobile)]><html class="lt-ie9 lt-ie8 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if IE 8]><html class="lt-ie9 no-js" lang="en" dir="ltr"><![endif]-->
<!--[if (gt IE 8)|(gt IEMobile 7)]><!--> <html class="no-js not-oldie" lang="en" dir="ltr"> <!--<![endif]-->
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="HandheldFriendly" content="true" />
  <link rel="shortcut icon" href="https://www.epa.gov/sites/all/themes/epa/favicon.ico" type="image/vnd.microsoft.icon" />
  <meta name="MobileOptimized" content="width" />
  <meta http-equiv="cleartype" content="on" />
  <meta http-equiv="ImageToolbar" content="false" />
  <meta name="viewport" content="width=device-width" />
  <meta name="version" content="20161218" />
<!--googleon: all-->
  <meta name="DC.description" content="" />
  <meta name="DC.title" content="" />
  <title>EPA Environmental Dataset Gateway</title>
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
  <link type="text/css" rel="stylesheet" href="https://www.epa.gov/sites/all/libraries/template2/s.css" media="all" />
  <!--[if lt IE 9]><link type="text/css" rel="stylesheet" href="https://www.epa.gov/sites/all/themes/epa/css/ie.css" media="all" /><![endif]-->
  <link rel="alternate" type="application/atom+xml" title="EPA.gov All Press Releases" href="https://www.epa.gov/newsreleases/search/rss" />
  <link rel="alternate" type="application/atom+xml" title="EPA.gov Headquarters Press Releases" href="https://www.epa.gov/newsreleases/search/rss/field_press_office/headquarters" />
  <link rel="alternate" type="application/atom+xml" title="Greenversations, EPA's Blog" href="https://blog.epa.gov/blog/feed/" />
  <!--[if lt IE 9]><script src="https://www.epa.gov/sites/all/themes/epa/js/html5.js"></script><![endif]-->
</head>
<!-- NOTE, figure out body classes! -->
<body class="node-type-(web-area|page|document|webform) (microsite|resource-directory)" >
  <!-- Google Tag Manager -->
  <noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-L8ZB');
  function mainOpenPageHelp() {
		openHelp("GPT_Context_Help", "<%=com.esri.gpt.framework.jsf.PageContext.extract().getPageId()%>");
	}
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
	}</script>
  <!-- End Google Tag Manager -->
  <div class="skip-links"><a href="#main-content" class="skip-link element-invisible element-focusable">Jump to main content</a></div>
  <header class="masthead clearfix" role="banner">
    <img class="site-logo" src="https://www.epa.gov/sites/all/themes/epa/logo.png" alt="" />
    <hgroup class="site-name-and-slogan">
      <h1 class="site-name"><a href="https://www.epa.gov/" title="Go to the home page" rel="home"><span>US EPA</span></a></h1>
      <div class="site-slogan">United States Environmental Protection Agency</div>
    </hgroup>
    <form class="epa-search" method="get" action="https://search.epa.gov/epasearch/epasearch">
      <input type="hidden" name="areaname" value="" />
      <input type="hidden" name="areacontacts" value="" />
      <input type="hidden" name="areasearchurl" value="" />
      <input type="hidden" name="typeofsearch" value="epa" />
      <input type="hidden" name="result_template" value="2col.ftl" />
    </form>
  </header>
  <section id="main-content" class="main-content clearfix" role="main">
    <div class="region-preface clearfix">
      <div id="block-pane-epa-web-area-connect" class="block block-pane contextual-links-region">
        <ul class="menu utility-menu">
          <li class="menu-item"><a href="../identity/feedback.page"
						class="menu-link contact-us">Contact Us</a></li>
        </ul>
      </div>
    </div>
    <div class="main-column clearfix">
<!--googleon: all-->
      <h1 class="page-title">Data</h1>
      <div class="panel-pane pane-node-content" >
        <div class="pane-content">
          <div class="node node-page clearfix view-mode-full">
<% // dataBody.jsp -  (JSF body) %>
<h:outputText escape="false" styleClass="prompt" value="#{gptMsg['catalog.data.home.prompt']}"/>
<f:verbatim>
    <br/><br/>
    <table width="100%">
        <tbody>
            <tr>
                <td width="8%">
                    <a href="/data" style="border-bottom:none;background-color: transparent;">
                        <img src="../images/data_download.png" alt="Data" title="Data"/>
                    </a>
                </td>
                <td valign="top">
                    <div class="prompt">
                         <a href="/data"><b>EDG Data Download Locations</b></a><br/>
                            Download data posted by an EPA Regional Office, Program Office, or Laboratory. Browse folders for each group and download data files.
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <a href="https://edg.epa.gov/clipship/" style="border-bottom:none;background-color: transparent;">
                        <img src="../images/clip.png" alt="Clip" title="Clip"/>
                    </a>
                </td>
                <td valign="top">
                    <div class="prompt">
                        <a href="https://edg.epa.gov/clipship/"><b>EPA's Clip N Ship Site</b></a><br/>
                       Use an interactive web map to select geospatial data for an area of interest and download the data clipped to your selected area.
                    </div>
                </td>
            </tr>

        </tbody>
    </table>
</f:verbatim>
</div>
        </div>
      </div>
      
<!--googleoff: all-->
    </div>
  </section>
	<h:form id="frmPrimaryNavigation">
		<nav class="nav simple-nav simple-main-nav" role="navigation">
		<div class="nav__inner">
			<h2 class="element-invisible">Main menu</h2>
			<ul class="menu" role="menu">
				<li class="menu-item" id="menu-learn" role="presentation"><h:commandLink
						id="mainHome" action="catalog.main.home"
						value="#{gptMsg['catalog.main.home.menuCaption']}"
						styleClass="menu-link" /></li>
				<li class="menu-item" id="menu-learn" role="presentation"><h:commandLink
						id="searchHome" action="catalog.search.home"
						value="#{gptMsg['catalog.search.home.menuCaption']}"
						styleClass="menu-link" /></li>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
						id="browse" action="catalog.browse" styleClass="menu-link"
						value="#{gptMsg['catalog.browse.menuCaption']}"
						rendered="#{PageContext.tocsByKey['browseCatalog']}" /></li>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
						id="data" action="catalog.data.home"
						value="#{gptMsg['catalog.data.home.menuCaption']}"
						styleClass="menu-link" title="Data" /></li>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
						id="components" action="catalog.components.home"
						value="#{gptMsg['catalog.components.home.menuBar.menuCaption']}"
						styleClass="menu-link" title="Reuse Components of the EDG" /></li>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
						id="resources" action="catalog.resources.home"
						value="#{gptMsg['catalog.resources.home.menuCaption']}"
						styleClass="menu-link" title="Resources" /></li>
				<h:panelGroup rendered="#{PageContext.roleMap['gptPublisher']}">
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
							id="publicationManageMetadata"
							action="catalog.publication.manageMetadata"
							styleClass="menu-link"
							value="#{gptMsg['catalog.publication.manageMetadata.menuCaption']}"
							rendered="#{PageContext.roleMap['gptPublisher']}"
							actionListener="#{ManageMetadataController.processAction}" /></li>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
							id="collection" action="catalog.collection.home"
							value="#{gptMsg['catalog.collection.home.menuCaption']}"
							styleClass="menu-link"
							rendered="#{PageContext.roleMap['gptPublisher']}" /></li>
				</h:panelGroup>

			</ul>
		</div>
		</nav>
	</h:form>
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
					value="#{gptMsg['catalog.site.anonymous']}" styleClass="menu-link" /></li>
			<li><h:commandLink action="catalog.identity.logout"
					id="identityLogoutAE" styleClass="menu-link"
					rendered="#{not PageContext.roleMap['anonymous'] && PageContext.identitySupport.supportsLogout}">
					<h:outputText
						value="#{gptMsg['catalog.identity.logout.menuCaption']}" />
				</h:commandLink></li>

			<li><h:outputLink value="#" id="openHelp"
					onclick="javascript:mainOpenPageHelp()" styleClass="menu-link">
					<h:outputText value="#{gptMsg['catalog.help.menuCaption']}" />
				</h:outputLink></li>
			<li><div id="gptBanner">
					<h:outputLink styleClass="bigGreen" value="#"
						style="padding-top:0px;border: 0" id="openShareFeedback"
						onclick="window.open('https://developer.epa.gov/forums/forum/dataset-qa/', 'ShareYourFeedback')">
						<h:outputText value="#{gptMsg['catalog.shareFeedback']}" />
					</h:outputLink>
				</div></li>
		</ul>
		</nav>
	</h:form>
	<footer class="main-footer clearfix" role="contentinfo">
    <div class="main-footer__inner">
      <div class="region-footer">
        <div class="block block-pane block-pane-epa-global-footer">
          <div class="row cols-3">
            <div class="col size-1of3">
              <div class="col__title">Discover.</div>
              <ul class="menu">
                <li><a href="https://www.epa.gov/accessibility">Accessibility</a></li>
                <li><a href="https://www.epa.gov/aboutepa/administrator-gina-mccarthy">EPA Administrator</a></li>
                <li><a href="https://www.epa.gov/planandbudget">Budget &amp; Performance</a></li>
                <li><a href="https://www.epa.gov/contracts">Contracting</a></li>
                <li><a href="https://www.epa.gov/home/grants-and-other-funding-opportunities">Grants</a></li>
                <li><a href="https://www.epa.gov/ocr/whistleblower-protections-epa-and-how-they-relate-non-disclosure-agreements-signed-epa-employees">No FEAR Act Data</a></li>
                <li><a href="https://www.epa.gov/home/privacy-and-security-notice">Privacy and Security</a></li>
				<li><a href="http://www.epa.gov/sor" target="_blank">System of Registries</a></li>
				<li><a href="http://www.epa.gov/geospatial">National Geospatial Home Page</a></li>
              </ul>
            </div>
            <div class="col size-1of3">
              <div class="col__title">Connect.</div>
              <ul class="menu">
                <li><a href="https://www.data.gov/">Data.gov</a></li>
                <li><a href="https://www.epa.gov/office-inspector-general/about-epas-office-inspector-general">Inspector General</a></li>
                <li><a href="https://www.epa.gov/careers">Jobs</a></li>
                <li><a href="https://www.epa.gov/newsroom">Newsroom</a></li>
                <li><a href="https://www.whitehouse.gov/open">Open Government</a></li>
                <li><a href="http://www.regulations.gov/">Regulations.gov</a></li>
                <li><a href="https://www.epa.gov/newsroom/email-subscriptions">Subscribe</a></li>
                <li><a href="https://www.usa.gov/">USA.gov</a></li>
                <li><a href="https://www.whitehouse.gov/">White House</a></li>
              </ul>
            </div>
            <div class="col size-1of3">
              <div class="col__title">Ask.</div>
              <ul class="menu">
                <li><a href="https://www.epa.gov/home/forms/contact-us">Contact Us</a></li>
                <li><a href="https://www.epa.gov/home/epa-hotlines">Hotlines</a></li>
                <li><a href="https://www.epa.gov/foia">FOIA Requests</a></li>
                <li><a href="https://www.epa.gov/home/frequent-questions-specific-epa-programstopics">Frequent Questions</a></li>
              </ul>
              <div class="col__title">Follow.</div>
              <ul class="social-menu">
                <li><a class="menu-link social-facebook" href="https://www.facebook.com/EPA">Facebook</a></li>
                <li><a class="menu-link social-twitter" href="https://twitter.com/epa">Twitter</a></li>
                <li><a class="menu-link social-youtube" href="https://www.youtube.com/user/USEPAgov">YouTube</a></li>
                <li><a class="menu-link social-flickr" href="https://www.flickr.com/photos/usepagov">Flickr</a></li>
                <li><a class="menu-link social-instagram" href="https://instagram.com/epagov">Instagram</a></li>
              </ul>
              <p class="last-updated">{LAST UPDATED DATE}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
  <script src="https://www.epa.gov/sites/all/libraries/template2/jquery.js"></script>
  <script src="https://www.epa.gov/sites/all/libraries/template2/js.js"></script>
  <script src="https://www.epa.gov/sites/all/modules/custom/epa_core/js/alert.js"></script>
  <!--[if lt IE 9]><script src="https://www.epa.gov/sites/all/themes/epa/js/ie.js"></script><![endif]-->
  <!-- REMOVE if not using -->
  {LOCAL JAVASCRIPT}

</body>
</html>
</div>
</div>
</div>
</div>
</section>
</body>
</html>
</f:view>