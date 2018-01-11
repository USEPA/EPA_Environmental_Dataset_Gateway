<%@page import="java.util.Set"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="jspClasses/commonMethods.jsp" %><%@ include file="jspClasses/login.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%  String jsonUrl;
    Calendar today;
    today = Calendar.getInstance();
    long now = today.getTimeInMillis();

    //jsonUrl = "json/jsonInventory.jsp?cacheClr=" + now;
    jsonUrl = request.getContextPath()+"/json/cached_json/inventory.json?cacheClr=" + now;
    commonMethods obj = new commonMethods();
    obj.setHttpServletRequest(request);
    
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(obj.getNoAccessPage(ret));
        out.close();
    }

    String resourceLink, metadataLink;
    String[] links = obj.getMetaDataLinks(request);
    resourceLink = links[0];
    metadataLink = links[1];
%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>EDG Inventory</title>
        <link href="main.css" rel="stylesheet" type="text/css" /> 
        <link href="<% out.print(jsonUrl);%>" type="application/json" rel="exhibit/data" />
        <script src="/simile_new/exhibit/api/exhibit-api.js?bundle=false" type="text/javascript"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <link href='javaScripts/jquery-ui/development-bundle/themes/base/jquery.ui.all.css' rel='stylesheet' type='text/css' />

        <style> 

            .olFramedCloudPopupContent {
                width:400px;
                height: 300px;
            }


            .hlpImg{
                cursor: help;
                padding-right:2px; 
            }

        </style> 

    </head>

    <body >
        <div id="body_container">
            <div id="header"></div>
            <%out.print(obj.getMenu()); %>
            <div class="container">

                <div class="box">
                    <div class="box_header">
                        Summary<span style="float:right;"><img src="images/bullet-toggle-minus-icon.png" onclick="toggleSign(this.parentNode);" style="cursor: pointer;"/></span>

                    </div>
                    <div class="box_content">
                        <table border="0" width="100%">
                            <tr>
                                <td id="chart_div_pub_res"></td>
                                <td id="chart_div_metadata"></td>
                                <td id="chart_div_content_type"></td>
                                <td id="chart_div_owner"></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="title">Total no of records : <span id="total_count"></span></td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div ex:role="lens"  style="display: none;" id="subLens"></div>
                <div ex:role="viewPanel" id="view">    
                    <div ex:role="view"  
                         ex:orders=".title" 
                         ex:directions="ascending" 
                         ex:paginate = "true"
                         ex:pageSize = "10"
                         ex:page = "0"
                         ex:pageWindow = "10"
                         ex:alwaysShowPagingControls="true"
                         ex:pagingControlLocations="topbottom"
                         ex:label="Details"
                         >
                        <!-- VIEW -->
                        <div ex:role="exhibit-lens"> 
                            <div ex:class-subcontent="box {{.acl_opt}}">
                                <div class="box_header">
                                    <div ex:content=".title" class="leftTitle"></div>
                                    <div class="rightTitle" ><img src="images/Actions-arrow-up-double-icon.png" onclick="collapseAll();" style="cursor: pointer;" title="Collapse all"/><img src="images/Actions-arrow-down-double-icon.png" onclick="expandAll();" style="cursor: pointer;" title="Expand all"/><img src="images/bullet-toggle-plus-icon.png" onclick="toggleSign(this);" style="cursor: pointer;"/></div>
                                    <div class="clear"></div>
                                </div>
                                <div class="box_content hidden">

                                    <div class="map_desc">
                                        <div>
                                            <span title="Title of the resource">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title" >Resource title :</span>
                                            </span>
                                            <span ex:content=".title"></span>
                                        </div>
                                        <div>
                                            <span title="Name of the user who has ownership of the document." >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Owner :</span> 
                                            </span>
                                            <span ex:content=".username"></span> 
                                        </div>
                                        <div>
                                            <span title="Unique string associated with each resource ">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Document UUID :</span>
                                            </span>
                                            <span ex:content=".docuuid"></span>                                            
                                        </div>
                                        <div>
                                            <span title="User id and originating filename/location of the resource">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Source URI :</span> 
                                            </span>
                                            <div ex:if="contains(.pubmethod, 'registration')">
                                                <span><a ex:content=".sourceuri_str" ex:href-subcontent="javaScript:openLink('{{.sourceuri}}');"></a></span>
                                                <div ex:if="contains(.pubmethod, 'harvester')">
                                                    <span><a ex:content=".sourceuri_str" ex:href-subcontent="javaScript:openLink('{{.sourceuri}}');"></a></span>
                                                    <span ex:content=".sourceuri_str"></span>  
                                                </div>
                                            </div>

                                        </div>
                                        <div>
                                            <span title="Metadata links">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Metadata links : </span>
                                            </span>
                                            <span>
                                                <a ex:href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.docuuid}}&xsl=metadata_to_html_full');">Formatted</a>
                                                /<a ex:href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.docuuid}}');">XML</a>
                                                /<a ex:href-subcontent="javaScript:openLink('<% out.print(metadataLink);%>?uuid={{.docuuid}}');">Details</a>
                                            </span>
                                        </div>
                                        <div>
                                            <span title="Content Type" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Content Type :</span> 
                                            </span>
                                            <span ex:if="contains(.content_type, 'applications')">
                                                <img title="Applications" alt="Applications" src="https://edg.epa.gov/metadata/catalog/images/ContentType_application.png" />
                                            </span>
                                            <span ex:if="contains(.content_type, 'downloadable data')">
                                                <img title="Downloadable Data" alt="Downloadable Data" src="https://edg.epa.gov/metadata/catalog/images/ContentType_downloadableData.png" />
                                            </span>
                                            <span ex:if="contains(.content_type, 'live map services')">
                                                <img title="Live Map Services" alt="Live Map Services" src="https://edg.epa.gov/metadata/catalog/images/ContentType_liveData.png" />
                                            </span>
                                            <span ex:if="contains(.content_type, 'offline data')">
                                                <img title="Offline Data" alt="Offline Data" src="https://edg.epa.gov/metadata/catalog/images/ContentType_offlineData.png" />
                                            </span>
                                            <span ex:if="contains(.content_type, 'map files')">
                                                <img title="Map Files" alt="Map Files" src="https://edg.epa.gov/metadata/catalog/images/ContentType_mapFiles.png" />
                                            </span>
                                            <span ex:if="contains(.content_type, 'documents')">
                                                <img title="Documents" alt="Documents" src="https://edg.epa.gov/metadata/catalog/images/ContentType_document.png" />
                                            </span>
                                            <span ex:if="contains(.content_type, 'clearinghouse')">
                                                <img title="Clearinghouses" alt="Clearinghouses" src="https://edg.epa.gov/metadata/catalog/images/ContentType_clearinghouse.png">
                                            </span>
                                            <span ex:if="contains(.content_type, 'geographic activities')">
                                                <img title="Geographic Activities" alt="Geographic Activities" src="https://edg.epa.gov/metadata/catalog/images/ContentType_geographicActivities.png">
                                            </span>
                                            <span ex:if="contains(.content_type, 'geographic service')">
                                                <img title="Geographic Services" alt="Geographic Services" src="https://edg.epa.gov/metadata/catalog/images/ContentType_geographicService.png">
                                            </span>
                                            <span ex:if="contains(.content_type, 'static map image')">
                                                <img title="Static Map Images" alt="Static Map Images" src="https://edg.epa.gov/metadata/catalog/images/ContentType_staticMapImage.png">
                                            </span>
                                            <span ex:content=".content_type"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates the restriction policy type (if any) on the record" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Access Level :</span> 
                                            </span>
                                            <span ex:content=".acl_opt"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates the restriction policy type (if any) on the data" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Project Open Data Access Level :</span> 
                                            </span>
                                            <span ex:content=".accesslevel"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates the publisher listed in the metadata" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Publisher :</span> 
                                            </span>
                                            <span ex:content=".publisher"></span> 
                                        </div>
                                        <div>
                                            <span title="Metadata standard" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Metadata standard :</span> 
                                            </span>

                                            <span ex:content=".schema_key"></span> 
                                        </div>
                                        <div>
                                            <span title="Date resource was registered" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Input Date :</span> 
                                            </span>
                                            <span ex:content=".inputdate"></span> 
                                        </div>
                                        <div>
                                            <span  title="Date resource was last updated">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Update Date :</span> 
                                            </span>
                                            <span ex:content=".updatedate"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates if resource is approved (&quot;approved&quot;=approved, &quot;not approved&quot;= not approved, record has any other status)" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title" >Approval Status :</span> 
                                            </span>
                                            <span ex:content=".approvalstatus"></span> 
                                        </div>
                                        <div>
                                            <span title="How the resource was published to the portal (e.g. &quot;upload&quot;, &quot;registration&quot;, &quot;harvester&quot; (synchronization), &quot;batch&quot;, &quot;editor&quot;)" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title" >Publication Method :</span> 
                                            </span>
                                            <span ex:content=".pubmethod"></span> 
                                        </div>
                                        <div>
                                            <span title="Source" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Source :</span> 
                                            </span>
                                            <span ex:if="not(contains(.siteuuid, 'unknown'))">
                                                <span>
                                                    <span ex:content=".site_title" ></span>
                                                    (<a ex:href-subcontent="javaScript:openLink('{{.site_host_url}}');" ex:content=".site_host_url"></a>)
                                                </span>
                                            </span>
                                            <span ex:if="contains(.siteuuid, 'unknown')">
                                                <span ex:content=".siteuuid" ></span>
                                            </span>
                                        </div>
                                        <div>
                                            <span title="Abstract">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Abstract :</span>
                                            </span>
                                            <span class="abstract_content" ex:label-subcontent="{{.docuuid}}" ex:id-subcontent="abs_{{.docuuid}}"></span>
                                        </div>
                                        <div>
                                            <span title="Primary Linkage">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Primary Linkage :</span>
                                            </span>
                                            <a ex:content=".pri_linkage" ex:href-subcontent="javaScript:openLink('{{.pri_linkage}}');"></a>                                         
                                        </div>
                                        <div>
                                            <span title="License URL">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">License URL :</span>
                                            </span>
                                            <a ex:content=".licenseurl" ex:href-subcontent="javaScript:openLink('{{.licenseURL}}');"></a>                                         
                                        </div>
                                        <div>
                                            <span title="Rights (CUI Statement)">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Rights (CUI Statement) :</span>
                                            </span>
                                            <span ex:content=".rightsnote"></span>                                        
                                        </div>
                                        <div>
                                            <span title="Progress Status">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Progress Status :</span>
                                            </span>
                                            <span ex:content=".progressstatus"></span> 
                                        </div>
                                        <div>
                                            <span title="Compilation">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Compilation :</span>
                                            </span>
                                            <span ex:content=".cmpparenttitle"></span> 
                                        </div>
                                        <div>
                                            <span title="Collection">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Collection :</span>
                                            </span>
                                            <span ex:content=".colparenttitle"></span> 
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> 
                    </div>
                </div>
                <div id="facet">
                    <!-- FACET -->
                    <div>
                        <form method="post" target="_blank" action="csvExporter.jsp" name="csvForm">
                            <textarea name="docuuids" id="docuuids" style="display:none;"  ></textarea>
                            <input type="hidden" name="report" value="inventory" />
                            <input type="hidden" name="headings" />
                            <a href="javascript:void(0)" onClick='submitFrom({"title":"Resource title","username":"Owner","epapub":"EPA/Non-EPA","publisher":"Publisher","docuuid":"Document UUID","sourceuri_str":"Source URI","content_type":"Content Type","acl_opt":"Access Level","accesslevel":"POD AccessLevel","schema_key":"Metadata standard","inputdate":"Input Date","updatedate":"Update Date","approvalstatus":"Approval Status","pubmethod":"Publication Method","source":"Source","abstract":"Abstract","pri_linkage":"Primary Linkage","licenseurl":"License URL"});'><img src="images/document_excel_csv.png" border="0" /> [ EDG Inventory CSV ] </a>
                        </form>
                    </div>
                    <fieldset>
                        <legend>Legends</legend>
                        <div style="float:left; width: 10px; height: 10px; background-color: #d6d7d9; border: 1px solid #CCC; margin-top: 4px; margin-left: 10px;"></div>
                        <div style="float:left; padding-left: 2px;">Public Records</div>
                        <div style="float:left; width: 10px; height: 10px; background-color: #FFA824; border: 1px solid #CCC; margin-top: 4px;"></div>
                        <div style="float:left; padding-left: 2px;">Restricted Records</div>
                    </fieldset>
                    <fieldset>
                        <legend>Filters</legend>
                        <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".title" ex:facetLabel="Text based search on &quot;Resource Title&quot;"> </div>
                        <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".username" ex:facetLabel="Text based search on &quot;Owner&quot;"> </div>
                        <div ex:role="facet" ex:expression=".username" ex:facetLabel="Owner :" title="Name of the account or organization that owns he document in the EDG."></div>
                        <div ex:role="facet" ex:expression=".epapub" ex:facetLabel="EPA/Non-EPA :" title="EPA Dataset that is contributed to Data.gov."></div>
                        <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".publisher" ex:facetLabel="Text based search on &quot;Publisher&quot;"> </div>
                        <div ex:role="facet" ex:expression=".publisher" ex:facetLabel="Publisher :" title="Name of the publisher listed in the document."></div>
                        <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".docuuid" ex:facetLabel="Text based search on &quot;Document UUID&quot;"> </div>
                        <div ex:role="facet" ex:expression=".inputdate" ex:facetLabel="Input Date :" title="Date resource was registered."></div>
                        <div ex:role="facet" ex:expression=".updatedate" ex:facetLabel="Update Date :" title="Date resource was last updated."></div>
                        <div ex:role="facet" ex:expression=".approvalstatus" ex:facetLabel="Approval Status :" title="Indicates if resource is approved (&quot;approved&quot;=approved, &quot;not approved&quot;= not approved, record has any other status) "></div>
                        <div ex:role="facet" ex:expression=".pubmethod" ex:facetLabel="Publication Method :" title="How the resource was published to the portal (e.g. &quot;upload&quot;, &quot;registration&quot;, &quot;harvester&quot; (synchronization), &quot;batch&quot;, &quot;editor&quot;) "></div>
                        <div ex:role="facet" ex:expression=".acl_opt" ex:facetLabel="EDG Access Level :" title="Indicates whether a user must log in to the EDG to view the record. Restricted records may still be published to Data.gov."></div>
                        <div ex:role="facet" ex:expression=".accesslevel" ex:facetLabel="Data.gov Access Level :" title="Indicates the restriction policy (if any) on whether the data may be released to the public."></div>
                        <div ex:role="facet" ex:expression=".schema_key" ex:facetLabel="Metadata standard :" title="Name of the metadata format or schema of the record"></div>
                        <div ex:role="facet" ex:expression=".content_type" ex:facetLabel="Content Type :" title="Type of resource represented by the metadata document"></div>
                        <div ex:role="facet" ex:expression=".source" ex:facetLabel="Harvest Source :" title="Repository from which the metadata record was harvested"></div>
                        <div ex:role="facet" ex:expression=".licensestatus" ex:facetLabel="License Status :" title="This shows whether the standard EPA Data License is included in the metadata or not."></div>
                        <div ex:role="facet" ex:expression=".licenseurl" ex:facetLabel="License URL :" title="This should be a URL to a page describing the license under which the data is released."></div>
                        <div ex:role="facet" ex:expression=".rightsstatus" ex:facetLabel="Rights Status :" title="This shows whether a standard EPA CUI justification is included in the metadata or not."></div>
                        <div ex:role="facet" ex:expression=".rightsnote" ex:facetLabel="Rights (CUI Statement) :" title="If access to a dataset is restricted because of data sensitivity, this field should list the official CUI category. Otherwise it may be free text."></div>
                        <!--<div ex:role="facet" ex:expression=".progressstatus" ex:facetLabel="Progress Status :" title="Progress Status"></div>-->
                        <div ex:role="facet" ex:expression=".cmpparenttitle" ex:facetLabel="Compilation :" title="Indicates whether the metadata record is part of an EDG compilation"></div>
                        <div ex:role="facet" ex:expression=".colparenttitle" ex:facetLabel="Collection :" title="Indicates whether the metadata record is part of a collection recognized by data.gov."></div>
                    </fieldset>

                </div>

            </div>
            <div class="footer">
                <span>The EDG is part of <a href="http://www.epa.gov/sor" target="_blank" style="color: #FFFFFF;">EPA's System of Registries</a>. Please read EPA's <a href="http://www.epa.gov/epahome/usenotice2.htm" target="_blank" style="color: #FFFFFF;">Privacy and Security Notice</a>.<img align="center" src="images/seal-bottom.png" alt="" width="82" height="82" border="0" style="padding-left: 10px;"/></span>
            </div>
        </div>

        <!-- end .container --></div>

    </body>
	
    <script type="text/javascript" src="javaScripts/inventory.js"></script>
</html>