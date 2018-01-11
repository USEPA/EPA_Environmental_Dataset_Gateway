<%@page import="java.util.Set"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="jspClasses/commonMethods.jsp"%>
<%@ include	file="jspClasses/login.jsp"%>
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
<link href="<% out.print(jsonUrl);%>" type="application/json"
	rel="exhibit-data" />
<!--<script src="/simile_new/exhibit/api/exhibit-api.js?bundle=false&js=/simile_new/exhibit/api/extensions/invalid-json/invalid-json-extension.js" type="text/javascript"></script>-->
<script src="/simile_new/exhibit/api/exhibit-api.js?bundle=false"
	type="text/javascript"></script>
<script src="/simile_new/ajax/api/simile-ajax-api.js"
	type="text/javascript"></script>
<script src="/simile_new/ajax/api/simile-ajax-bundle.js"
	type="text/javascript"></script>
<!--<link rel="exhibit-extension" href="/simile_new/exhibit/api/extensions/map/map-extension.js"/>-->
<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<link
	href='javaScripts/jquery-ui/development-bundle/themes/base/jquery.ui.all.css'
	rel='stylesheet' type='text/css' />
<script>

 
 function filterDropdown() {
			//document.getElementById("anytext").value = "";
			var textEle = document.getElementById("anytext").childNodes[1].childNodes[0];
			textEle.value="";
			document.getElementById("anytext").setAttribute("data-ex-expressions","");
			if ("createEvent" in document) {
				var evt = document.createEvent("HTMLEvents");
				evt.initEvent("keyup", false, true);
				
				textEle.dispatchEvent(evt);
			} else {
				//textEle.setAttribute("data-ex-expressions", defaultDataPath);
				textEle.fireEvent("onkeyup");
			}
			document.getElementById("anytext").setAttribute("data-ex-expressions",
					document.getElementById("sel").value);
		}
		</script>
<style>
.olFramedCloudPopupContent {
	width: 400px;
	height: 300px;
}

.hlpImg {
	cursor: help;
	padding-right: 2px;
}

.seldrp {
	padding-bottom: 0px;
	padding-top: -3px;
	margin-left: 255px;
	width: 75px;
	margin-top: -22px;
	height: 22px;
}
</style>

</head>

<body>
	<div id="body_container">
		<div id="header"></div>
		<%out.print(obj.getMenu()); %>
		<div class="container">

			<div class="box">
				<div class="box_header">
					Summary<span style="float: right;"><img
						src="images/bullet-toggle-minus-icon.png"
						onclick="toggleSign(this.parentNode);" style="cursor: pointer;" /></span>

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
							<td colspan="4" class="title">Total no of records : <span
								id="total_count"></span></td>
						</tr>
					</table>
				</div>
			</div>
			<div id="facet">
				<!-- FACET -->

				<!--  <fieldset>
                        <legend>Legends</legend>
                        <div style="float:left; width: 10px; height: 10px; background-color: #d6d7d9; border: 1px solid #CCC; margin-top: 4px; margin-left: 10px;"></div>
                        <div style="float:left; padding-left: 2px;">Public Records</div>
                        <div style="float:left; width: 10px; height: 10px; background-color: #FFA824; border: 1px solid #CCC; margin-top: 4px;"></div>
                        <div style="float:left; padding-left: 2px;">Restricted Records</div>
                    </fieldset>-->
				<fieldset>
					<legend>Filters</legend>
					<div id="anytext" data-ex-role="facet"
						data-ex-history-enabled="false" data-ex-facet-class="TextSearch"
						data-ex-expressions=""
						data-ex-facet-label="Text based search on &quot;Publisher&quot;">
					</div>
					<select id="sel"
						style="padding-bottom: 0px; padding-top: -3px; margin-left: 242px; width: 122px; margin-top: -22px; height: 22px;"
						onchange="filterDropdown()">
						<option value="">Filter By</option>
						<option value=".title">Title</option>
						<option value=".username">Owner</option>
						<option value=".publisher">Publisher</option>
						<option value=".docuuid">Document UUID</option>


					</select>

					<div data-ex-role="facet" data-ex-expression=".username"
						data-ex-collapsed="true" data-ex-facet-label="Owner :"
						title="Name of the account or organization that owns he document in the EDG."></div>


					<div data-ex-role="facet" data-ex-expression=".epapub"
						data-ex-collapsed="true" data-ex-facet-label="EPA/Non-EPA :"
						title="EPA Dataset that is contributed to Data.gov."></div>


					<div data-ex-role="facet" data-ex-expression=".publisher"
						data-ex-collapsed="true" data-ex-facet-label="Publisher :"
						title="Name of the publisher listed in the document."></div>

					<div data-ex-role="facet" data-ex-expression=".inputdate"
						data-ex-collapsed="true" data-ex-facet-label="Input Date :"
						title="Date resource was registered."></div>
					<div data-ex-role="facet" data-ex-expression=".updatedate"
						data-ex-collapsed="true" data-ex-facet-label="Update Date :"
						title="Date resource was last updated."></div>
					<div data-ex-role="facet" data-ex-expression=".approvalstatus"
						data-ex-collapsed="true" data-ex-facet-label="Approval Status :"
						title="Indicates if resource is approved (&quot;approved&quot;=approved, &quot;not approved&quot;= not approved, record has any other status) "></div>
					<div data-ex-role="facet" data-ex-expression=".pubmethod"
						data-ex-collapsed="true"
						data-ex-facet-label="Publication Method :"
						title="How the resource was published to the portal (e.g. &quot;upload&quot;, &quot;registration&quot;, &quot;harvester&quot; (synchronization), &quot;batch&quot;, &quot;editor&quot;) "></div>
					<div data-ex-role="facet" data-ex-expression=".acl_opt"
						data-ex-collapsed="true" data-ex-facet-label="EDG Access Level :"
						title="Indicates whether a user must log in to the EDG to view the record. Restricted records may still be published to Data.gov."></div>
					<div data-ex-role="facet" data-ex-expression=".accesslevel"
						data-ex-collapsed="true"
						data-ex-facet-label="Data.gov Access Level :"
						title="Indicates the restriction policy (if any) on whether the data may be released to the public."></div>
					<div data-ex-role="facet" data-ex-expression=".schema_key"
						data-ex-collapsed="true" data-ex-facet-label="Metadata standard :"
						title="Name of the metadata format or schema of the record"></div>
					<div data-ex-role="facet" data-ex-expression=".content_type"
						data-ex-collapsed="true" data-ex-facet-label="Content Type :"
						title="Type of resource represented by the metadata document"></div>
					<div data-ex-role="facet" data-ex-expression=".source"
						data-ex-collapsed="true" data-ex-facet-label="Harvest Source :"
						title="Repository from which the metadata record was harvested"></div>
					<div data-ex-role="facet" data-ex-expression=".licensestatus"
						data-ex-collapsed="true" data-ex-facet-label="License Status :"
						title="This shows whether the standard EPA Data License is included in the metadata or not."></div>
					<div data-ex-role="facet" data-ex-expression=".licenseurl"
						data-ex-collapsed="true" data-ex-facetlabel="License URL :"
						title="This should be a URL to a page describing the license under which the data is released."></div>
					<div data-ex-role="facet" data-ex-expression=".rightsstatus"
						data-ex-collapsed="true" data-ex-facet-label="Rights Status :"
						title="This shows whether a standard EPA CUI justification is included in the metadata or not."></div>
					<div data-ex-role="facet" data-ex-expression=".rightsnote"
						data-ex-collapsed="true"
						data-ex-facet-label="Rights (CUI Statement) :"
						title="If access to a dataset is restricted because of data sensitivity, this field should list the official CUI category. Otherwise it may be free text."></div>
					<!--<div data-ex-role="facet" data-ex-expression=".progressstatus" data-ex-facetLabel="Progress Status :" title="Progress Status"></div>-->
					<div data-ex-role="facet" data-ex-expression=".cmpparenttitle"
						data-ex-collapsed="true" data-ex-facet-label="Compilation :"
						title="Indicates whether the metadata record is part of an EDG compilation"></div>
					<div data-ex-role="facet" data-ex-expression=".colparenttitle"
						data-ex-collapsed="true" data-ex-facet-label="Collection :"
						title="Indicates whether the metadata record is part of a collection recognized by data.gov."></div>
				</fieldset>
				<div>
					<form method="post" target="_blank" action="csvExporter.jsp"
						name="csvForm">
						<textarea name="docuuids" id="docuuids" style="display: none;"></textarea>
						<input type="hidden" name="report" value="inventory" /> <input
							type="hidden" name="headings" /> <a href="javascript:void(0)"
							onClick='submitFrom({"title":"Resource title","username":"Owner","epapub":"EPA/Non-EPA","publisher":"Publisher","docuuid":"Document UUID","sourceuri_str":"Source URI","content_type":"Content Type","acl_opt":"Access Level","accesslevel":"POD AccessLevel","schema_key":"Metadata standard","inputdate":"Input Date","updatedate":"Update Date","approvalstatus":"Approval Status","pubmethod":"Publication Method","source":"Source","abstract":"Abstract","pri_linkage":"Primary Linkage","licenseurl":"License URL"});'><img
							src="images/document_excel_csv.png" border="0" /> [ EDG
							Inventory CSV ] </a>
					</form>
				</div>
			</div>

			<div data-ex-role="lens" style="display: none;" id="subLens"></div>
			<div data-ex-role="viewPanel" id="view">
				<div data-ex-role="view" data-ex-orders=".title"
					data-ex-directions="ascending" data-ex-paginate="true"
					data-ex-page-size="10" data-ex-page="0" data-ex-page-window="10"
					data-ex-always-show-paging-controls="true"
					data-ex-paging-control-locations="topbottom"
					data-ex-label="Details">
					<!-- VIEW -->
					<div data-ex-role="exhibit-lens">
						<div data-ex-class-subcontent="box {{.acl_opt}}">
							<div class="box_header">
								<div data-ex-content=".title" class="leftTitle"
									onclick="toggleSign(this.nextElementSibling.lastChild);"></div>
								<div class="rightTitle">
									<img src="images/bullet-toggle-plus-icon.png"
										onclick="toggleSign(this);" style="cursor: pointer;" />
								</div>
								<div class="clear"></div>
							</div>
							<div class="box_content hidden">

								<div class="map_desc">
									<div>
										<table class="table">
											<thead class="thead-default">
												<tr>
													<th><span title="Metadata Links" /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Metadata Links (XML/Details)</span></th>
													<th colspan="2"><span title="Abstract" /><img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
						     							class="title">Abstract</span></th>
												</tr>
											</thead>
											<tbody>

												<tr>
													<td><a
														data-ex-href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.docuuid}}&xsl=metadata_to_html_full');">Formatted</a>
														/<a
														data-ex-href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.docuuid}}');">XML</a>
														/<a
														data-ex-href-subcontent="javaScript:openLink('<% out.print(metadataLink);%>?uuid={{.docuuid}}');">Details</a></td>
													<td colspan="2"><span class="abstract_content"
														data-ex-label-subcontent="{{.docuuid}}"
														data-ex-id-subcontent="abs_{{.docuuid}}"></span></td>

													</div>
												</tr>

											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span
														title="Name of the account or organization that owns he document in the EDG." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Owner</span></th>
													<th colspan="2"><span
														title="Name of the publisher listed in the document." /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Publisher</span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".username"></span></td>
													<td colspan="2"><span data-ex-content=".publisher"></span>
													</td>
												</tr>
											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span
														title="Name of the metadata format or schema of the record." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Metadata Standard</span></th>
													<th colspan="2"><span
														title="Repository from which the metadata record was harvested." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Source</span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".schema_key"></span></td>
													<td colspan="2"><span
														data-ex-if="not(contains(.siteuuid, 'unknown'))"> <span>
																<span data-ex-content=".site_title"></span> (<a
																data-ex-href-subcontent="javaScript:openLink('{{.site_host_url}}');"
																data-ex-content=".site_host_url"></a>)
														</span>
													</span> <span data-ex-if="contains(.siteuuid, 'unknown')">
															<span data-ex-content=".siteuuid"></span>
													</span></td>
												</tr>
											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span title="Progress Status" /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Progress Status</span></th>
													<th colspan="2"><span
														title="User id and originating filename/location of the resource." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Source URI</span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".progressstatus"></span></td>
													<td colspan="2">
														<div data-ex-if="contains(.pubmethod, 'registration')">
															<span><a data-ex-content=".sourceuri_str"
																data-ex-href-subcontent="javaScript:openLink('{{.sourceuri}}');"></a></span>
															<div data-ex-if="contains(.pubmethod, 'harvester')">
																<span><a data-ex-content=".sourceuri_str"
																	data-ex-href-subcontent="javaScript:openLink('{{.sourceuri}}');"></a></span>
																<span data-ex-content=".sourceuri_str"></span>
															</div>
														</div>
													</td>
												</tr>
											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span
														title="EPA Dataset that is contributed to Data.gov." /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">EPA/Non-EPA Status</span></th>
													<th colspan="2"><span
														title="This should be a URL to a page describing the license under which the data is released." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">License URL</span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".epapub"></span></td>
													<td colspan="2"><a data-ex-content=".licenseurl"
														data-ex-href-subcontent="javaScript:openLink('{{.licenseURL}}');"></a></td>
												</tr>
											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span
														title="Indicates the restriction policy (if any) on whether the data may be released to the public." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Project Open Data Access Level</span></th>
													<th colspan="2"><span
														title="If access to a dataset is restricted because of data sensitivity, this field should list the official CUI category. Otherwise it may be free text." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Rights (CUI Statement)</span></th>
    											</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".accesslevel"></span></td>
													<td colspan="2"><span data-ex-content=".rightsnote"></span>
													</td>
												</tr>
											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span title="Data resource was last updated." /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Update Date</span></th>
													<th><span
														title="Unique string associated with each resource." /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Document UUID</span></th>
													<th><span title="Embedded UUID." /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Embedded UUID</span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".updatedate"></span></td>
													<td><span data-ex-content=".docuuid"></span></td>
													<td><span data-ex-content=".fileidentifier"></span></td>
												</tr>
											</tbody>
											<thead class="thead-default">
												<tr>
													<th><span title="Data resource was registered." /> <img
														src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Input Date</span></th>
													<th><span
														title="Indicates whether the metadata record is part of an EDG compilation." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Compilation</span></th>
													<th><span
														title="Indicates whether the metadata record is part of a collection recognized by data.gov." />
														<img src="images/Help-icon.png"
														onclick="showItem(this.parentNode);" class="hlpImg" /><span
														class="title">Collection</span></th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td><span data-ex-content=".inputdate"></span></td>
													<td><span data-ex-content=".cmpparenttitle"></span></td>
													<td><span data-ex-content=".colparenttitle"></span></td>
												</tr>
											</tbody>
										</table>
										<!-- <div>
                                            <span title="Title of the resource">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title" >Resource title :</span>
                                            </span>
                                            <span data-ex-content=".title"></span>
                                        </div>
                                        <div>
                                            <span title="Name of the user who has ownership of the document." >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Owner :</span> 
                                            </span>
                                            <span data-ex-content=".username"></span> 
                                        </div>
                                        <div>
                                            <span title="Unique string associated with each resource ">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Document UUID :</span>
                                            </span>
                                            <span data-ex-content=".docuuid"></span>                                            
                                        </div>
                                        <div>
                                            <span title="User id and originating filename/location of the resource">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Source URI :</span> 
                                            </span>
                                            <div data-ex-if="contains(.pubmethod, 'registration')">
                                                <span><a data-ex-content=".sourceuri_str" data-ex-href-subcontent="javaScript:openLink('{{.sourceuri}}');"></a></span>
                                                <div data-ex-if="contains(.pubmethod, 'harvester')">
                                                    <span><a data-ex-content=".sourceuri_str" data-ex-href-subcontent="javaScript:openLink('{{.sourceuri}}');"></a></span>
                                                    <span data-ex-content=".sourceuri_str"></span>  
                                                </div>
                                            </div>

                                        </div>
                                        <div>
                                            <span title="Metadata links">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Metadata links : </span>
                                            </span>
                                            <span>
                                                <a data-ex-href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.docuuid}}&xsl=metadata_to_html_full');">Formatted</a>
                                                /<a data-ex-href-subcontent="javaScript:openLink('<% out.print(resourceLink);%>?id={{.docuuid}}');">XML</a>
                                                /<a data-ex-href-subcontent="javaScript:openLink('<% out.print(metadataLink);%>?uuid={{.docuuid}}');">Details</a>
                                            </span>
                                        </div>
                                        <div>
                                            <span title="Content Type" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Content Type :</span> 
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'applications')">
                                                <img title="Applications" alt="Applications" src="https://edg.epa.gov/metadata/catalog/images/ContentType_application.png" />
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'downloadable data')">
                                                <img title="Downloadable Data" alt="Downloadable Data" src="https://edg.epa.gov/metadata/catalog/images/ContentType_downloadableData.png" />
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'live map services')">
                                                <img title="Live Map Services" alt="Live Map Services" src="https://edg.epa.gov/metadata/catalog/images/ContentType_liveData.png" />
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'offline data')">
                                                <img title="Offline Data" alt="Offline Data" src="https://edg.epa.gov/metadata/catalog/images/ContentType_offlineData.png" />
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'map files')">
                                                <img title="Map Files" alt="Map Files" src="https://edg.epa.gov/metadata/catalog/images/ContentType_mapFiles.png" />
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'documents')">
                                                <img title="Documents" alt="Documents" src="https://edg.epa.gov/metadata/catalog/images/ContentType_document.png" />
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'clearinghouse')">
                                                <img title="Clearinghouses" alt="Clearinghouses" src="https://edg.epa.gov/metadata/catalog/images/ContentType_clearinghouse.png">
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'geographic activities')">
                                                <img title="Geographic Activities" alt="Geographic Activities" src="https://edg.epa.gov/metadata/catalog/images/ContentType_geographicActivities.png">
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'geographic service')">
                                                <img title="Geographic Services" alt="Geographic Services" src="https://edg.epa.gov/metadata/catalog/images/ContentType_geographicService.png">
                                            </span>
                                            <span data-ex-if="contains(.content_type, 'static map image')">
                                                <img title="Static Map Images" alt="Static Map Images" src="https://edg.epa.gov/metadata/catalog/images/ContentType_staticMapImage.png">
                                            </span>
                                            <span data-ex-content=".content_type"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates the restriction policy type (if any) on the record" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Access Level :</span> 
                                            </span>
                                            <span data-ex-content=".acl_opt"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates the restriction policy type (if any) on the data" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Project Open Data Access Level :</span> 
                                            </span>
                                            <span data-ex-content=".accesslevel"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates the publisher listed in the metadata" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Publisher :</span> 
                                            </span>
                                            <span data-ex-content=".publisher"></span> 
                                        </div>
                                        <div>
                                            <span title="Metadata standard" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Metadata standard :</span> 
                                            </span>

                                            <span data-ex-content=".schema_key"></span> 
                                        </div>
                                        <div>
                                            <span title="Date resource was registered" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Input Date :</span> 
                                            </span>
                                            <span data-ex-content=".inputdate"></span> 
                                        </div>
                                        <div>
                                            <span  title="Date resource was last updated">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Update Date :</span> 
                                            </span>
                                            <span data-ex-content=".updatedate"></span> 
                                        </div>
                                        <div>
                                            <span title="Indicates if resource is approved (&quot;approved&quot;=approved, &quot;not approved&quot;= not approved, record has any other status)" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title" >Approval Status :</span> 
                                            </span>
                                            <span data-ex-content=".approvalstatus"></span> 
                                        </div>
                                        <div>
                                            <span title="How the resource was published to the portal (e.g. &quot;upload&quot;, &quot;registration&quot;, &quot;harvester&quot; (synchronization), &quot;batch&quot;, &quot;editor&quot;)" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title" >Publication Method :</span> 
                                            </span>
                                            <span data-ex-content=".pubmethod"></span> 
                                        </div>
                                        <div>
                                            <span title="Source" >
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Source :</span> 
                                            </span>
                                            <span data-ex-if="not(contains(.siteuuid, 'unknown'))">
                                                <span>
                                                    <span data-ex-content=".site_title" ></span>
                                                    (<a data-ex-href-subcontent="javaScript:openLink('{{.site_host_url}}');" data-ex-content=".site_host_url"></a>)
                                                </span>
                                            </span>
                                            <span data-ex-if="contains(.siteuuid, 'unknown')">
                                                <span data-ex-content=".siteuuid" ></span>
                                            </span>
                                        </div>
                                        <div>
                                            <span title="Abstract">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Abstract :</span>
                                            </span>
                                            <span class="abstract_content" data-ex-label-subcontent="{{.docuuid}}" data-ex-id-subcontent="abs_{{.docuuid}}"></span>
                                        </div>
                                        <div>
                                            <span title="Primary Linkage">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Primary Linkage :</span>
                                            </span>
                                            <a data-ex-content=".pri_linkage" data-ex-href-subcontent="javaScript:openLink('{{.pri_linkage}}');"></a>                                         
                                        </div>
                                        <div>
                                            <span title="License URL">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">License URL :</span>
                                            </span>
                                            <a data-ex-content=".licenseurl" data-ex-href-subcontent="javaScript:openLink('{{.licenseURL}}');"></a>                                         
                                        </div>
                                        <div>
                                            <span title="Rights (CUI Statement)">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Rights (CUI Statement) :</span>
                                            </span>
                                            <span data-ex-content=".rightsnote"></span>                                        
                                        </div>
                                        <div>
                                            <span title="Progress Status">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Progress Status :</span>
                                            </span>
                                            <span data-ex-content=".progressstatus"></span> 
                                        </div>
                                        <div>
                                            <span title="Compilation">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Compilation :</span>
                                            </span>
                                            <span data-ex-content=".cmpparenttitle"></span> 
                                        </div>
                                        <div>
                                            <span title="Collection">
                                                <img src="images/Help-icon.png" onclick="showItem(this.parentNode);" class="hlpImg"/>
                                                <span class="title">Collection :</span>
                                            </span>
                                            <span data-ex-content=".colparenttitle"></span> 
                                        </div>-->
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>
			<div class="footer">
				<span>The EDG is part of <a href="http://www.epa.gov/sor"
					target="_blank" style="color: #FFFFFF;">EPA's System of
						Registries</a>. Please read EPA's <a
					href="http://www.epa.gov/epahome/usenotice2.htm" target="_blank"
					style="color: #FFFFFF;">Privacy and Security Notice</a>.<img
					align="center" src="images/seal-bottom.png" alt="" width="82"
					height="82" border="0" style="padding-left: 10px;" /></span>
			</div>
		</div>

		<!-- end .container -->
	</div>

</body>
<script type="text/javascript" src="javaScripts/inventory.js"></script>
</html>