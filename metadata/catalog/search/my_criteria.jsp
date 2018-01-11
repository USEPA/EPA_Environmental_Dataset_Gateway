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
<%// criteria.jsp - Search criteria (JSF include)%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@ taglib prefix="gpt" uri="http://www.esri.com/tags-gpt"%>

<%
  com.esri.gpt.framework.jsf.MessageBroker schMsgBroker = com.esri.gpt.framework.jsf.PageContext.extractMessageBroker();
	String schContextPath = request.getContextPath();	
	com.esri.gpt.framework.context.RequestContext schContext = com.esri.gpt.framework.context.RequestContext.extract(request);
	com.esri.gpt.catalog.context.CatalogConfiguration schCatalogCfg = schContext.getCatalogConfiguration();
	com.esri.gpt.framework.collection.StringAttributeMap schParameters = schCatalogCfg.getParameters();
	boolean hasSearchHint = false;
	if(schParameters.containsKey("catalog.searchCriteria.hasSearchHint")){	
		String schHasSearchHint = com.esri.gpt.framework.util.Val.chkStr(schParameters.getValue("catalog.searchCriteria.hasSearchHint"));
		hasSearchHint = Boolean.valueOf(schHasSearchHint);
	}
	String schHintPrompt = schMsgBroker.retrieveMessage("catalog.searchCriteria.hintSearch.prompt");
	//String VER121 = "v1.2.1";
	String PROD = "prod";
%>


<h:inputHidden id="scDistributedSitesPanelShow" 
               value="#{SearchController.searchFilterHarvestSites.distributedPanelOpen}"/>
<h:inputHidden id="scSearchUrl" 
               value="#{SearchController.searchFilterHarvestSites.searchUrl}"/>
              

