<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="jspClasses/commonMethods.jsp" %>
<%
    commonMethods obj = new commonMethods();
    obj.setHttpServletRequest(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Introduction</title>
        <link href="main.css" rel="stylesheet" type="text/css" /> 
    </head>
    <body >

        <div id="body_container">
            <div id="header"></div>
            <% out.print(obj.getMenu());%>
            <div class="container">
                <div style="padding:50px; font-weight:bold;">
                    <fieldset>
                        <legend>Introduction</legend>
                        <div>
                            <br />
                            <font size='2' color='#000000' face='Verdana'>The EDG Performance Metrics and Inventory site allows users to access information about EDG content and usage.  The site is intended as a means to allow EDG contributors to access detailed information about their contributions and to understand how their resources are being accessed via the EDG.<br /><br />  

                                The EDG Inventory page provides a simple interface that allows users to filter, sort and export content to a CSV file.  Users may filter the data to show only those records that match their particular interests (such as contributions made by a particular EPA office, or records that are accessible to the public, or contributions by type [e.g. services, downloadable data]).  Dynamic charts display the distribution of EDG metadata by office, type, access level, and metadata standard.  The EDG Inventory page was created to allow users to easily understand what type of information is in the EDG and to then export the information to CSV so that it can be used for reporting or other needs.  The Detailed Inventory is an extended version of the basic EDG inventory and allows users to see more detailed information about EDG metadata, and optionally export the more detailed information to CSV format.
                                <p align="center"><image align="center" src="images/chart.jpg" border="0" /><br /><br />
                                    <image align="center" src="images/record.jpg" border="0" /><br /><br />
                                </p>
                                The EDG Metrics page allows EDG contributors to view usage information about their resources at the EDG. The EDG records when users click on a metadata record's links, such as Open, Website, ArcMap, Globe (.kml) and Globe (.nmf), made available from the metadata record. This information is stored so that users can review when their resources were accessed and how often (via the EDG). This information is also geocoded by IP address so that EDG contributors can obtain a sense of the distribution of their user base. 
                            </font>
                        </div>
                    </fieldset>
                </div>
                <div style="padding-bottom: 600px;"></div>
                <div class="footer">
                    <span>The EDG is part of <a href="http://www.epa.gov/sor" target="_blank" style="color: #FFFFFF;">EPA's System of Registries</a>. Please read EPA's <a href="http://www.epa.gov/epahome/usenotice2.htm" target="_blank" style="color: #FFFFFF;">Privacy and Security Notice</a>.<img align="center" src="images/seal-bottom.png" alt="" width="82" height="82" border="0" style="padding-left: 10px;"/></span>
                </div>
            </div>
        </div>
    </body>
</html>