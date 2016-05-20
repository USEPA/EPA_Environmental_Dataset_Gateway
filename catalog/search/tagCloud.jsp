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
<%// results.jsp - Search results (JSF include)%>
<%@page import="com.esri.gpt.framework.http.HttpClientRequest"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<!--%@page import="com.esri.gpt.catalog.search.SearchCriteria"%-->
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@ taglib prefix="gpt" uri="http://www.esri.com/tags-gpt"%>




<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/dojo/1.9.3/dojo/dojo.js'></script>
<script type="text/javascript" src="../js/jquery-ui/js/jquery.js"></script>
<script type="text/javascript" src="../js/jquery-ui/js/jquery-ui.js"></script>
<script type="text/javascript">


var contextPath = "";
var dictUuidToRowNum = new Array(); 
if(typeof(contextPath) == 'undefined' || contextPath == "") {
  contextPath = "<%=request.getRequestURL().toString()%>";
}



</script>


-
	<table width="100%" cellpadding="0" cellspacing="0" id="tagbox" name="tagboxName">
    	       <tr  name="tagboxName">



				<h:outputText value="1"     />


    	      </tr>
	</table>


