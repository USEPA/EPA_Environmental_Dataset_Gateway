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

<%@taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles"  %>
<%--<h:form id="frmBanner">	
	<h:outputLink 
	  rendered="#{not empty PageContext.applicationConfiguration.catalogConfiguration.searchConfig.mapViewerUrl}"
		id="openMapViewerMvs" 
		value="#"
		onclick="javascript: mainOpenDefaultMapViewer(); return false;">
		<h:outputText value="#{gptMsg['catalog.menu.menuitem.launchMapViewer']}" />
	</h:outputLink>
	<h:outputLink 
    rendered="#{empty PageContext.applicationConfiguration.catalogConfiguration.searchConfig.mapViewerUrl and not empty PageContext.applicationConfiguration.catalogConfiguration.searchConfig.defaultViewerUrl }"
    id="openMapViewerGeneric" 
    onclick="#{PageContext.applicationConfiguration.catalogConfiguration.searchConfig.defaultViewerUrl}; return false;">
    <h:outputText value="#{gptMsg['catalog.menu.menuitem.launchMapViewer']}" />
  </h:outputLink>
</h:form>--%>

<%--Modified to handle the AllowOnlyAuthenticatedUser parameter. If set to true (default is false), then login is required for all users --%>
<h:form id="frmPrimaryNavigation">
		<nav class="nav simple-nav simple-main-nav" role="navigation">
		<div class="nav__inner">
			<h2 class="element-invisible">Main menu</h2>
			<ul class="menu" role="menu">
				<li class="menu-item" id="menu-learn" role="presentation"><h:commandLink
        id="mainHome" 
        action="#{SearchController.getHomePageAction}"
        value="#{gptMsg['catalog.main.home.menuCaption']}"
       	styleClass="menu-link" /></li>
		<%
	com.esri.gpt.framework.context.RequestContext rcx = com.esri.gpt.framework.context.RequestContext.extract(request);
	String sAllowOnlyAuthenticatedUser=rcx.getApplicationConfiguration().getCatalogConfiguration().getParameters().getValue("AllowOnlyAuthenticatedUser");
	if("true".equals(sAllowOnlyAuthenticatedUser))
	{
	%>  
				<li class="menu-item" id="menu-learn" role="presentation">
				
				<h:commandLink
						id="searchHome" 
						rendered="#{PageContext.roleMap['gptRegisteredUser']}"
						action="catalog.search.home"
						value="#{gptMsg['catalog.search.home.menuCaption']}"
						styleClass="menu-link" /></li>
				<li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
						id="browse" action="catalog.browse" styleClass="menu-link"
						value="#{gptMsg['catalog.browse.menuCaption']}"
						rendered="#{PageContext.tocsByKey['browseCatalog'] and PageContext.roleMap['gptRegisteredUser']}" /></li>
						<%
	}
	else
	{
	%>
	<li class="menu-item" id="menu-learn" role="presentation"><h:commandLink 
	        id="searchHome" 
	        action="catalog.search.home" 
	        value="#{gptMsg['catalog.search.home.menuCaption']}"
	        styleClass="menu-link"/>                 
    </li>
    <li class="menu-item" id="menu-learn" role="presentation">
		<h:commandLink 
		id="browse"
		action="catalog.browse" 
		styleClass="menu-link"
		value="#{gptMsg['catalog.browse.menuCaption']}"
		rendered="#{PageContext.tocsByKey['browseCatalog']}" /></li>
	<%
	}
	%>
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
               <li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink
                          id="validationManageMetadata" 
                          action="catalog.publication.validateMetadata"
                          styleClass="menu-link"
                          value="#{gptMsg['catalog.publication.validateMetadata.menuCaption']}"
                          rendered="#{PageContext.roleMap['gptRegisteredUser'] and not PageContext.roleMap['gptPublisher']}"/></li>

	           <li class="menu-item" id="menu-lawsregs" role="presentation"><h:commandLink 
                        id="extractDownload"
                        action="catalog.download" 
                        styleClass="menu-link"
                        value="#{gptMsg['catalog.download.menuCaption']}"
                        rendered="#{not empty PageContext.applicationConfiguration.downloadDataConfiguration.taskUrl}"/></li>
			</ul>
		</div>
		</nav>
	</h:form>