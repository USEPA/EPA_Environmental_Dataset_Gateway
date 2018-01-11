<% // data.jsp -  (tiles definition) %>
<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt" %>
<% // initialize the page %>
<gpt:page id="catalog.data.home"/>
<tiles:insertDefinition name=".gptLayout" flush="false" >
	<tiles:putAttribute name="body" value="/catalog/data/dataBody.jsp"/>
</tiles:insertDefinition>
