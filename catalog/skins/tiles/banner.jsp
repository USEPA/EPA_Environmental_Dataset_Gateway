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
<style>
#share .on + ul {
  display: block;
  pointer-events:none;
}
#share li a {
    display: inline-block;
    vertical-align: top;
    text-decoration: none;
}
#share li:before {
  background-repeat: no-repeat;
  content: '';
  display: inline-block;
  height: 20px;
  margin-right: 0.25em;
  vertical-align: top;
  width: 20px;
}
#share ul {
    background: #fff;
    border: 1px solid #0071bc;
    display: none;
    list-style: none;
    width: 9em;
    padding: 0.25em;
    position: absolute;
    top: 1.4em;
    z-index: 3;
}
#share li {
    margin: 0.5em 0.25em;
}
.username {
    float: right;
    margin-bottom: 1.6em;
    padding-top: 1.6em;
    margin-right: .8em;
}
.share-button {
    background: transparent;
    border: 0;
    border-radius: 0;
    color: #0071bc;
    display: block;
    font-size: 87%;
    font-weight: normal;
    height: inherit;
    line-height: inherit;
    margin: 0;
    padding: 0 0.3333em;
}
#block-pane-epa-web-area-connect {
    float: right;
     padding-left: 0em; 
     padding-right: 0em; 
    /* padding-top: .66667em; */
    padding-top: 1.6em;
}
.share-link {
    color: #0071bc;
    margin-right: 1em;
    padding-top: 0.5em;
    text-decoration: none;
    float: right;
    margin-top: -0.7em;
    margin-left: -0.4em;
}
.caret {
    display: inline-block;
    width: 0;
    height: 0;
    vertical-align: top;
    border-top: 4px solid #000000;
    border-right: 4px solid transparent;
    border-left: 4px solid transparent;
    content: "";
}
</style>
<div id="gptTitle">
	<%=com.esri.gpt.framework.jsf.PageContext.extract().getSiteTitle()%>
</div>

<h:form id="frmTertiaryNavigation">
<ul class="menu secondary-menu">
    <li><f:verbatim
        rendered="#{not PageContext.roleMap['anonymous']}">
        <a href="/metrics/" target="_blank">EDG Inventory</a>
    </f:verbatim></li>

	<%--h:outputLink value="#" styleClass="bigGreen" value = "#{gptMsg['catalog.shareFeedback']}"
		id="openShareFeedback" 
		onclick="window.open('http://developer.epa.gov/forums/forum/dataset-qa/', 'ShareYourFeedback')">
	</h:outputLink--%>
	
				<li>
	<h:outputLink styleClass="bigGreen"  value = "#" style="padding-top:0px;border: 0" id="openShareFeedback" 
		onclick="window.open('http://developer.epa.gov/forums/forum/dataset-qa/', 'ShareYourFeedback')">
		<h:outputText value="#{gptMsg['catalog.shareFeedback']}" />
	</h:outputLink></li>
	
	<%--h:commandLink 
        id="identityFeedback"
        action="catalog.identity.feedback" 
        styleClass="#{PageContext.tabStyleMap['catalog.identity.feedback']}"
        value="#{gptMsg['catalog.identity.feedback.menuCaption']}" /--%>
		<li><h:outputLink value="../identity/feedback.page"
		styleClass="menu-link" id="contactus">Contact Us	
	</h:outputLink></li>
	<%--<li>
	
			<div class="btn-group" style="float:right;">
                <button class="btn btn-inverse dropdown-toggle" data-toggle="dropdown">Share <span class="caret"></span></button>
                <ul id="share" class="dropdown-menu">
                  <li class="share-facebook"><a class="share-link" href="https://www.facebook.com/sharer.php?u=https%3A%2F%2Fwww.epa.gov%2Fsites%2Fall%2Flibraries%2Ftemplate2%2Fstandalone.html&amp;t=%7BPAGE%20NAME%7D%20%7C%20%7BWEB%20AREA%20NAME%7D%20%7C%20US%20EPA" title="Share this page">Facebook</a></li>
				  <li class="share-twitter"><a class="share-link" href="https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fwww.epa.gov%2Fsites%2Fall%2Flibraries%2Ftemplate2%2Fstandalone.html&amp;text=%7BPAGE%20NAME%7D%20%7C%20%7BWEB%20AREA%20NAME%7D%20%7C%20US%20EPA&amp;url=https%3A%2F%2Fwww.epa.gov%2Fsites%2Fall%2Flibraries%2Ftemplate2%2Fstandalone.html&amp;via=EPA&amp;count=none&amp;lang=en" title="Tweet this page">Twitter</a></li>
				  <li class="share-googleplus"><a class="share-link" href="https://plus.google.com/share?url=https%3A%2F%2Fwww.epa.gov%2Fsites%2Fall%2Flibraries%2Ftemplate2%2Fstandalone.html" title="Plus 1 this page">Google+</a></li>
				  <li class="share-pinterest"><a class="share-link" href="http://pinterest.com/pin/create/button/?url=https%3A%2F%2Fwww.epa.gov%2Fsites%2Fall%2Flibraries%2Ftemplate2%2Fstandalone.html&amp;description=%7BPAGE%20NAME%7D%20%7C%20%7BWEB%20AREA%20NAME%7D%20%7C%20US%20EPAmedia=https%3A%2F%2Fwww.epa.gov%2Fsites%2Fall%2Fthemes%2Fepa%2Fimg%2Fepa-seal.png" title="Pin this page">Pinterest</a></li>
                </ul>
              </div>
		
	</li><%--
				
   
	<li><h:outputLink value="#"
		id="openHelp"  styleClass="menu-link"
		onclick="javascript:mainOpenPageHelp()">
		<h:outputText value="#{gptMsg['catalog.help.menuCaption']}" />
	</h:outputLink></li>
	
	<%--h:commandLink id="identityMyProfile"
		action="catalog.identity.myProfile" 
		value="#{gptMsg['catalog.identity.myProfile.menuCaption']}"
		styleClass="#{PageContext.menuStyleMap['catalog.identity.myProfile']}"
		rendered="#{not PageContext.roleMap['anonymous'] && not PageContext.roleMap['openid'] && PageContext.identitySupport.supportsUserProfileManagement}"/>
		
	<h:commandLink id="identityUserRegistration" 
		action="catalog.identity.userRegistration" 
		value="#{gptMsg['catalog.identity.userRegistration.menuCaption']}"
		styleClass="#{PageContext.menuStyleMap['catalog.identity.userRegistration']}"
		rendered="#{PageContext.roleMap['anonymous'] && PageContext.identitySupport.supportsUserRegistration}"/--%>
    
	<li><h:commandLink id="identityLogin" action="catalog.identity.login" 
		value="#{gptMsg['catalog.identity.login.menuCaption']}"
		
		rendered="#{PageContext.roleMap['anonymous'] && PageContext.identitySupport.supportsLogin}"/> </li>
	
	<li><h:outputLink value="/metadata/logout.jsp"
		id="identityLogoutAE" styleClass="menu-link" 
		rendered="#{not PageContext.roleMap['anonymous'] && not PageContext.identitySupport.supportsLogout}"
		>
		<h:outputText value="#{gptMsg['catalog.identity.logout.menuCaption']}" />
	</h:outputLink></li>

  <li><h:outputText styleClass="username" 
    id="msgAuthenticatedUser" 
    rendered="#{not PageContext.roleMap['anonymous']}"
    value="#{PageContext.welcomeMessage}"/></li>
  <li><h:outputText 
    id="msgNonAuthenticatedUser" 
    rendered="#{PageContext.roleMap['anonymous']}"
    value="#{gptMsg['catalog.site.anonymous']}"/></li>
</ul>

</h:form>
