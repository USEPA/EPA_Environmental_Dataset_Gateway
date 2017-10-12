<% // components.jsp - Link pages (tiles definition) %>

<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt" %> 

<% // initialize the page %>

<gpt:page id="catalog.components.home"/>

<tiles:insertDefinition name=".gptLayout" flush="false" >

<tiles:putAttribute name="body" value="/catalog/components/componentsBody.jsp"/>

</tiles:insertDefinition> 


