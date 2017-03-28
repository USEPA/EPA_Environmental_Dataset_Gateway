<%--
 See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 Esri Inc. licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
--%>
<% // centeredLayout.jsp - Primary layout for a page within the site. %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles"  %>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt" %>
<%-- <%
  String cl_jsapi = "";
  String cl_pageId = com.esri.gpt.framework.jsf.PageContext.extract().getPageId();
  if ((cl_pageId != null) && cl_pageId.equals("catalog.search.home")) {
    String tmp = com.esri.gpt.framework.context.RequestContext.extract(
                 request).getApplicationConfiguration().getInteractiveMap().getJsapiUrl();
    if ((tmp != null) && (tmp.trim().length() > 0)) {
      tmp = com.esri.gpt.framework.util.Val.escapeXmlForBrowser(tmp);
      cl_jsapi = "<script type='text/javascript'>djConfig = {parseOnLoad: true, locale: 'en'};</script>";
      cl_jsapi += "<script type='text/javascript' src='"+tmp+"'></script>";
    }
  }
%> --%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/loose.dtd">
<f:view>
<f:loadBundle basename="gpt.resources.gpt" var="gptMsg"/>
<gpt:prepareView/>
<html>
<head>
	<title><%=com.esri.gpt.framework.jsf.PageContext.extract().getSiteTitle()%></title>
  <jsp:include page="/catalog/skins/lookAndFeel.jsp"/>
	<tiles:insert attribute="head" flush="false"/>
	<%-- <%=cl_jsapi%> --%>
</head>

<body>
	<!-- Google Tag Manager -->
	<noscript>
		<iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB"
			height="0" width="0" style="display: none; visibility: hidden"></iframe>
	</noscript>
	<script>
		(function(w, d, s, l, i) {
			w[l] = w[l] || [];
			w[l].push({
				'gtm.start' : new Date().getTime(),
				event : 'gtm.js'
			});
			var f = d.getElementsByTagName(s)[0], j = d.createElement(s), dl = l != 'dataLayer' ? '&l='
					+ l
					: '';
			j.async = true;
			j.src = '//www.googletagmanager.com/gtm.js?id=' + i + dl;
			f.parentNode.insertBefore(j, f);
		})(window, document, 'script', 'dataLayer', 'GTM-L8ZB');
	</script>
	<div id="gptMainWrap" style="position: static;">

		<div class="skip-links">
			<a href="#main-content"
				class="skip-link element-invisible element-focusable">Jump to
				main content</a>
		</div>
		<header class="masthead clearfix" role="banner"> <img
			class="site-logo"
			src="https://www.epa.gov/sites/all/themes/epa/logo.png" alt="" /> <hgroup
			class="site-name-and-slogan">
		<h1 class="site-name">
			<a href="https://www.epa.gov/" title="Go to the home page" rel="home"><span>US
					EPA</span></a>
		</h1>
		<div class="site-slogan">United States Environmental Protection
			Agency</div>
		</hgroup>
		<div id="gptBanner" title="EDG Banner">
			<tiles:insert attribute="banner" flush="false" />
		</div>
		</header>
		<div style="clear: both"></div>
		<div id="gptPrimaryNavigation">
			<tiles:insert attribute="primaryNavigation" flush="false" />
		</div>
		<div style="clear: both"></div>

		<div id="gptBody">

			<div id="gptSecondaryNavigation">
				<tiles:insert attribute="secondaryNavigation" flush="false" />
			</div>
			<div class="main-column clearfix">
				<h1 class="page-title">
					<h:outputText id="cmPlPcCaption" value="#{PageContext.caption}" />
				</h1>
				<div class="panel-pane pane-node-content">
					<div class="pane-content">
						<div class="node node-page clearfix view-mode-full">
							<% // page content - navigation menu and main body %>
							<h:panelGrid id="cmPlPgdNavMenuAndMainBody"
								styleClass="pageContent" columns="1" cellpadding="0"
								cellspacing="0"
								summary="#{gptMsg['catalog.general.designOnly']}">

								<% // page content right - page caption, messages and page body  %>
								<h:panelGrid id="cmPlPgdPageContentBody"
									styleClass="pageContentRight" columns="1" cellpadding="0"
									cellspacing="0"
									summary="#{gptMsg['catalog.general.designOnly']}">

									<% // messages %>
									<h:panelGroup id="cmPlPgpGptMessages">
										<h:messages id="cmPlMsgsPageMessages" layout="list"
											infoClass="successMessage" errorClass="errorMessage" />
									</h:panelGroup>

									<% // page body %>
									<h:panelGrid id="cmPlPgdPageBody" styleClass="pageBody"
										columns="1" cellpadding="0" cellspacing="0"
										summary="#{gptMsg['catalog.general.designOnly']}">
										<h:panelGroup id="cmPlPgpPageBody">
											<tiles:insert attribute="body" flush="false" />
										</h:panelGroup>
									</h:panelGrid>
								</h:panelGrid>

							</h:panelGrid>
						</div>
					</div>
				</div>
			</div>
			<div style="clear: both"></div>
			<div id="gptFooter">
				<tiles:insert attribute="footer" flush="false" />
			</div>
		</div>
		<!-- gptMainWrap -->
</body>
	</html>
</f:view>
