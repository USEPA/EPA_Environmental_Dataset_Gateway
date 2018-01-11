<%@page import="java.util.Calendar"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="jspClasses/commonMethods.jsp"%>
<%@ include file="jspClasses/login.jsp"%>
<%!    public Calendar getDate(String dateStr) {
        String tmp[];
        tmp = dateStr.split("/");
        Calendar calendar1 = Calendar.getInstance();
        calendar1.set(Integer.parseInt(tmp[2]), Integer.parseInt(tmp[0]), Integer.parseInt(tmp[1]));
        return calendar1;
    }

%><%
    String fromDateStr, toDateStr, jsonUrl, sumbit, headerMessage = null, todayDateStr;
    Calendar today, fromDate = null, toDate = null;

    sumbit = (request.getParameter("form_post") != null) ? request.getParameter("form_post") : "false";

    today = Calendar.getInstance();
    long now = today.getTimeInMillis();

    todayDateStr = (today.get(Calendar.MONTH) + 1) + "/" + today.get(Calendar.DATE) + "/" + today.get(Calendar.YEAR);

    if (sumbit.equals("false")) {
        toDateStr = todayDateStr;
        toDate = getDate(toDateStr);
        today.add(Calendar.DATE, -30);
        fromDateStr = (today.get(Calendar.MONTH) + 1) + "/" + today.get(Calendar.DATE) + "/" + today.get(Calendar.YEAR);
        fromDate = getDate(fromDateStr);
    } else {
        fromDateStr = (request.getParameter("fromDate") != null) ? request.getParameter("fromDate") : (session.getAttribute("fromDate") != null ? ((String) session.getAttribute("fromDate")) : "");
        if (!(fromDateStr == null || fromDateStr == "")) {
            fromDate = getDate(fromDateStr);
        }

        toDateStr = (request.getParameter("toDate") != null) ? request.getParameter("toDate") : (session.getAttribute("toDate") != null ? ((String) session.getAttribute("toDate")) : "");
        if (!(toDateStr == null || toDateStr == "")) {
            toDate = getDate(toDateStr);
        }

        if (fromDate == null && toDate != null) {
            fromDate = toDate;
            fromDate.add(Calendar.DATE, -30);
            fromDateStr = (fromDate.get(Calendar.MONTH)) + "/" + fromDate.get(Calendar.DATE) + "/" + fromDate.get(Calendar.YEAR);
        } else if (toDate == null && fromDate != null) {
            toDate = fromDate;
            toDate.add(Calendar.DATE, 30);
            toDateStr = (toDate.get(Calendar.MONTH)) + "/" + toDate.get(Calendar.DATE) + "/" + toDate.get(Calendar.YEAR);
        } else {
            long diff = toDate.getTimeInMillis() - fromDate.getTimeInMillis();
            int daysDiff = Math.abs((int) (diff / (1000 * 60 * 60 * 24)));
            if (daysDiff > 31) {
                toDate = fromDate;
                toDate.add(Calendar.DATE, 30);
                toDateStr = (toDate.get(Calendar.MONTH)) + "/" + toDate.get(Calendar.DATE) + "/" + toDate.get(Calendar.YEAR);
            }
        }
    }
    jsonUrl = "json/jsonAccessDetails.jsp?cacheClr=" + now;
    jsonUrl = jsonUrl + "&fromDate=" + fromDateStr + "&toDate=" + toDateStr;
    headerMessage = "Current report restricted to resource access from \"" + fromDateStr + "\" to \"" + toDateStr + "\".";


    String resourceLink, metadataLink;
    commonMethods objCommon = new commonMethods();
    objCommon.setHttpServletRequest(request);
    
    String[] links = objCommon.getMetaDataLinks(request);
    resourceLink = links[0];
    metadataLink = links[1];

    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(objCommon.getNoAccessPage(ret));
        out.close();
    }

    //set params for function that returns data for google plot
    HashMap params = new HashMap();
    if (ret[1].toString().equals("public")) {
        params.put("acl", ret[1].toString());
    }



%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <!-- TemplateBeginEditable name="doctitle" -->
        <title>Metrics</title>
        <link href="main.css" rel="stylesheet" type="text/css" /> 

        <link href="<% out.print(jsonUrl);%>" type="application/json" rel="exhibit/data" />
        <script src="/simile_new/exhibit/api/exhibit-api.js?bundle=false" type="text/javascript"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script src="/simile_new/exhibit/api/extensions/map/map-extension.js?bundle=false&service=openlayers" type="text/javascript"></script>
        <link href='javaScripts/jquery-ui/development-bundle/themes/base/jquery.ui.all.css' rel='stylesheet' type='text/css' />


        <style> 

            .olFramedCloudPopupContent {
                width:250px;
                height: 180px;
            }


        </style> 
    </head>

    <body >

        <div id="body_container">

            <div id="header"></div>
            <% out.print(objCommon.getMenu()); %>
            <div class="container">
                <div >
                    <div class="box" >
                        <div class="box_header">Summary<span style="float:right"><img src="images/bullet-toggle-minus-icon.png" onclick="toggleSign(this);" style="cursor: pointer;"/></span></div>
                        <div class="box_content">
                            <table border="0" width="100%">
                                <tr>
                                    <td id="chart_div_country"></td>
                                    <td id="chart_div_state"></td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="title">Total no of records : <span id="total_count"></span></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <div >

                    <% if (headerMessage != null) {
                            out.print("<h3>" + headerMessage + "</h3>");
                        }%>
                    <div ex:role="coder" id="wealth-coder"
                         ex:coderClass="SizeGradient" 
                         ex:gradientPoints="0, 15; 200, 70">
                    </div>  

                    <div ex:role="viewPanel" id="view">    
                        <div ex:role="view"  
                             ex:orders=".access_date" 
                             ex:directions="descending" 
                             ex:paginate = "true"
                             ex:pageSize = "10"
                             ex:page = "0"
                             ex:pageWindow = "10"
                             ex:alwaysShowPagingControls="true"
                             ex:pagingControlLocations="topbottom"
                             ex:label="Details">
                            <!-- VIEW -->
                            <div ex:role="exhibit-lens"> 
                                <div class="box">
                                    <div class="box_header">
                                        <div ex:content=".title" class="leftTitle"></div>
                                        <div style="float:right" class="rightTitle"><img src="images/Actions-arrow-up-double-icon.png" onclick="collapseAll();" style="cursor: pointer;" title="Collapse all"/><img src="images/Actions-arrow-down-double-icon.png" onclick="expandAll();" style="cursor: pointer;" title="Expand all"/><img src="images/bullet-toggle-plus-icon.png" onclick="toggleSign(this);" style="cursor: pointer;"/></div>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="box_content hidden">
                                        <fieldset>
                                            <legend>Metadata Information</legend>
                                            <div><span class="label">Resource title : </span><span ex:content=".title"></span></div>
                                            <div><span class="label">Resource link : </span><a ex:content=".linkage" ex:href-subcontent="javaScript:openLink('{{.linkage}}');"></a></div>
                                            <div><span class="label">Metadata links : </span>
                                                <span>
                                                    <a ex:href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.uuid}}&xsl=metadata_to_html_full');">Formatted</a>
                                                    /<a ex:href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.uuid}}');">XML</a>
                                                    /<a ex:href-subcontent="javaScript:openLink('<% out.print(metadataLink);%>?uuid={{.uuid}}');">Details</a>
                                                </span>
                                            </div>
                                        </fieldset>
                                        <fieldset>
                                            <legend>Access Information</legend>
                                            <div ex:select=".uid">
                                                <div ex:case="Unknown"></div>
                                                <div><span class="label">User ID : </span><span ex:content=".uid"></span></div>
                                            </div>

                                            <div><span class="label">Organization : </span><span ex:content=".organization"></span></div>
                                            <div><span class="label">City : </span><span ex:content=".city"></span></div> 
                                            <div><span class="label">State/Region : </span><span ex:content=".region_name"></span>&nbsp;&nbsp;<span class="label">Zip Code : </span>&nbsp;<span ex:content=".zip_code"></span></div> 
                                            <div><span class="label">Country : </span><span ex:content=".country_name"></span></div>                                
                                            <div><span class="label">IP Address : </span><span ex:content=".ip_address"></span></div> 
                                            <div><span class="label">Resource access Date : </span><span ex:content=".access_date_part"></span>&nbsp;<span name="time_part" ex:content=".access_time_part" style="display:none;"></span></div> 
                                            <div><span class="label">Longitude, Latitude : </span><span ex:content=".longitude"></span>,&nbsp;<span ex:content=".latitude"></span></div> 
                                            <div><span class="label">Area Code : </span><span ex:content=".area_code"></span>&nbsp;<span class="label">Metro Code : </span><span ex:content=".metro_code"></span></div>
                                            <div><span class="label">ISP : </span><span ex:content=".isp"></span></div>
                                            <div><span class="label">Domain Name : </span><span ex:content=".domain_name"></span></div>
                                        </fieldset>    
                                    </div>
                                </div>

                            </div> 
                        </div>

                        <div 
                            ex:role="view" 
                            ex:label="Location Based"
                            ex:viewClass="OLMap"
                            ex:type="vmap"
                            ex:lat=".latitude"
                            ex:lng=".longitude"
                            ex:sizeKey="1"
                            ex:sizeCoder="wealth-coder"
                            ex:bubbleWidth="250"
                            ex:bubbleHeight="200"
                            ex:mapHeight="500"
                            ex:sizeLegendLabel="Downloads"
                            ex:zoom="3"    
                            ex:scaleControl="false"
                            >
                            <div ex:role="lens" style="display: none;">
                                <div><span class="label">Resource title : <div ex:role="lens" style="display: none;">asdasd</div></span><span ex:content=".title"></span></div>
                                <div><span class="label">Resource link : </span><a ex:content=".linkage" ex:href-subcontent="javaScript:openLink('{{.linkage}}');"></a></div>
                                <div><span class="label">Metadata links : </span>
                                    <span>
                                        <a ex:href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.uuid}}&xsl=metadata_to_html_full');">Formatted</a>
                                        /<a ex:href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.uuid}}');">XML</a>
                                        /<a ex:href-subcontent="javaScript:openLink('<% out.print(metadataLink);%>?uuid={{.uuid}}');">Details</a>
                                    </span>
                                </div>
                                <hr />
                                <div ex:select=".uid">
                                    <div ex:case="Unknown"></div>
                                    <div><span class="label">User ID : </span><span ex:content=".uid"></span></div>
                                </div>
                                <div><span class="label">Organization : </span><span ex:content=".organization"></span></div>
                            </div>
                        </div>



                    </div>
                    <div id="facet">
                        <!-- FACET -->
                        <div>
                            <form method="post" target="_blank" action="csvExporter.jsp" name="csvForm">
                                <textarea name="csv" id="csv" style="display:none;"  ></textarea>
                                <input type="hidden" name="filename" value="EDG_Resource_Access_Metrics_Report" />
                                <input type="hidden" name="report" value="accessDetails" />
                                <a href="javascript:void(0)" onClick="submitFrom();"><img src="images/document_excel_csv.png" border="0" /> [ Generate CSV ] </a>
                                &nbsp;<input type="checkbox" name="showTimeComponent" id="showTimeComponent" onclick="toggleTimeComponent(this)" > Show timestamps
                            </form>
                        </div>
                        <fieldset>
                            <legend>Filters</legend>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".title" ex:facetLabel="Text based search on &quot;Resource title&quot;"> </div>
                            <div ex:role="facet" ex:expression=".title" ex:facetLabel="Resource title"></div>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".uid" ex:facetLabel="Text based search on &quot;User ID&quot;"> </div>
                            <div ex:role="facet" ex:expression=".uid" ex:facetLabel="User ID"></div>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".organization" ex:facetLabel="Text based search on &quot;Organization&quot;"> </div>
                            <div ex:role="facet" ex:expression=".organization" ex:facetLabel="Organization"></div>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".country_name" ex:facetLabel="Text based search on &quot;Country&quot;"> </div>
                            <div ex:role="facet" ex:expression=".country_name" ex:facetLabel="Country"></div>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".region_name" ex:facetLabel="Text based search on &quot;State/Region&quot;"> </div>
                            <div ex:role="facet" ex:expression=".region_name" ex:facetLabel="State/Region"></div>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".city" ex:facetLabel="Text based search on &quot;City&quot;"> </div>
                            <div ex:role="facet" ex:expression=".city" ex:facetLabel="City"></div>
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".ip_address" ex:facetLabel="Text based search on &quot;IP Address&quot;"> </div>
                            <div ex:role="facet" ex:expression=".ip_address" ex:facetLabel="IP Address"></div>
                            <div>

                                <form name="dateFilter" method="post" action="">
                                    <input type="hidden" name="form_post" id="form_post" value="false" />
                                    <div><span class="exhibit-facet-header-title">Dates</span></div>
                                    <div class="exhibit-facet-body-frame">
                                        <div style=" display: block;" class="exhibit-facet-body">
                                            <div title="Source" class="exhibit-facet-value">

                                                <div class="exhibit-facet-value-inner" style="padding:4px;">
                                                    <div> 
                                                        <span>From date : </span><span><input type="text" name="fromDate" id="fromDate" maxlength="10" style="width:80px;"></span>
                                                        &nbsp;&nbsp;<span>To date : </span><span><input type="text" name="toDate" id="toDate" maxlength="10" style="width:80px;"></span>
                                                        &nbsp;&nbsp;<span><a href="javascript:void(0);" onclick="submitForm();">[Submit]</a></span>
                                                    </div>
                                                </div>
                                                <div class="exhibit-facet-value-inner" style="padding:4px; "><a href="javascript:void(0);" onclick="submitForm(1);" style="text-decoration: none;">Today's activity report</a></div>
                                                <div class="exhibit-facet-value-inner" style="padding:4px; "><a href="javascript:void(0);" onclick="submitForm(7);" style="text-decoration: none;">7 days activity report</a></div>
                                                <div class="exhibit-facet-value-inner" style="padding:4px; "><a href="javascript:void(0);" onclick="submitForm(30);" style="text-decoration: none;">30 days activity report</a></div>
                                            </div>
                                        </div>
                                    </div>
                                </form>    
                            </div>  

                        </fieldset>

                    </div>

                </div>
                <div class="footer">
                    <span>The EDG is part of <a href="http://www.epa.gov/sor" target="_blank" style="color: #FFFFFF;">EPA's System of Registries</a>. Please read EPA's <a href="http://www.epa.gov/epahome/usenotice2.htm" target="_blank" style="color: #FFFFFF;">Privacy and Security Notice</a>.<img align="center" src="images/seal-bottom.png" alt="" width="82" height="82" border="0" style="padding-left: 10px;"/></span>
                </div>
            </div>

            <!-- end .container --></div>

    </body>
    <script src="javaScripts/jquery-ui/development-bundle/jquery-1.5.1.js"></script>
    <script src="javaScripts/jquery-ui/development-bundle/ui/jquery.ui.core.js"></script>
    <script src="javaScripts/jquery-ui/development-bundle/ui/jquery.ui.widget.js"></script>
    <script src="javaScripts/jquery-ui/development-bundle/ui/jquery.ui.datepicker.js"></script>
    <script type="text/javascript">
        var dataForGraph = <% out.print(objCommon.getJsonAccessResourceMetrics(params));%>;
        
        $(function() {
            $( "#fromDate" ).datepicker({
                onSelect: function(dateText, inst) {
                    $( "#toDate" ).val('');
                    
                    var maxDatePossible = new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
                    maxDatePossible.setDate(maxDatePossible.getDate()+30);
                    var minDatePossible = new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
                    
                    
                    $( "#toDate" ).datepicker('option','maxDate',maxDatePossible);
                    $( "#toDate" ).datepicker('option','minDate',minDatePossible);
                    $( "#toDate" ).val((maxDatePossible.getMonth()+1)+'/'+maxDatePossible.getDate()+'/'+maxDatePossible.getFullYear());
                } 
            });
            $( "#fromDate" ).val('<% out.print(fromDateStr);%>');
            var fromDate = ($( "#fromDate" ).datepicker( "getDate" ));
            var maxDatePossible = ($( "#fromDate" ).datepicker( "getDate" ));
            maxDatePossible.setDate(maxDatePossible.getDate()+30);
            
            $( "#toDate" ).datepicker();
            $( "#toDate" ).datepicker('option','maxDate',maxDatePossible);
            $( "#toDate" ).datepicker('option','minDate',fromDate);
            
            $( "#toDate" ).val('<% out.print(toDateStr);%>');
            
            
        });
    </script>
    <script type="text/javascript" src="javaScripts/index.js"></script>
</html>
