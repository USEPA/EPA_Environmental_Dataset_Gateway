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
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt" %>

<gpt:jscriptVariable quoted="true" value="#{SearchFilterSpatial.mvsUrl}" variableName="mainGptMvsUrl" id="cmPlGptMvsUrl"/>

<f:verbatim>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="search" type="application/opensearchdescription+xml" 
  title="<%=com.esri.gpt.framework.jsf.PageContext.extract().getResourceMessage("catalog.openSearch.shortName")%>"
  href="<%=request.getContextPath()%>/openSearchDescription" />

<script type="text/javascript">

$(document).ready(function(){
	$("#cmPlPgpGptMessages span").each(function (i) {
		var htmlStr = $(this).html();
		$(this).html(htmlStr.replace(/&lt;br \/&gt;/g,'<br />'));
	});
});

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
// Global variable to be used for map viewer
var mainGptMapViewer = new GptMapViewer(mainGptMvsUrl);

/**
 * Opens the map viewer
 * @returns false always
 */
function mainOpenDefaultMapViewer() {
	if(!GptUtils.exists(mainGptMapViewer) || !GptUtils.exists(mainGptMapViewer.openDefaultMap)) {
		return false;
	}
	var win = mainGptMapViewer.openDefaultMap();
	if(GptUtils.exists(win) && GptUtils.exists(win.focus)) {
		win.focus();
	}
	return false;
}

</script>
<script type="text/javascript" src="/metadata/catalog/js/epa-core-v4.js"></script>

<!-- Google Tag Manager 
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-L8ZB');</script>
<!-- End Google Tag Manager -->
</f:verbatim>
