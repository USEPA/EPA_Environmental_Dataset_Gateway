<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:res="http://www.esri.com/metadata/res/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd" >

<!-- An XSLT template for displaying metadata in ArcGIS that is stored in the ArcGIS metadata format.

     Copyright (c) 2009-2013, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 3/19/2009 avienneau
-->

  <xsl:import href = "ArcGIS_Imports\general.xslt" />
  <xsl:import href = "ArcGIS_Imports\ItemDescription.xslt" />
  <xsl:import href = "ArcGIS_Imports\geoprocessing.xslt" />
  <xsl:import href = "ArcGIS_Imports\ESRIISO2.xslt" />
  <xsl:import href = "ArcGIS_Imports\FGDC.xslt" />
  <xsl:import href = "ArcGIS_Imports\ISO19139.xslt" />
  <xsl:import href = "ArcGIS_Imports\XML.xslt" />
  <xsl:import href = "ArcGIS_Imports\codelists.xslt" />
  <xsl:import href = "ArcGIS_Imports\auxLanguages.xslt" />
  <xsl:import href = "ArcGIS_Imports\auxCountries.xslt" />
  <xsl:import href = "ArcGIS_Imports\auxUCUM.xslt" />

  <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  
  
  <xsl:variable name="arcgis1" select="/metadata[not(*)]" />
  <xsl:variable name="arcgis2" select="/metadata/Esri//* | /metadata/Binary//*" />
  <xsl:variable name="arcgis3" select="/metadata/mdLang/languageCode | /metadata/mdChar/CharSetCd | /metadata/mdHrLv/ScopeCd | /metadata/mdHrLvName | /metadata/mdStanName | /metadata/mdStanVer | /metadata/mdFileID | /metadata/mdDateSt | /metadata/mdContact//* | /metadata/mdParentID | /metadata/dataSetURI | /metadata/mdConst//* | /metadata/mdMaint//* | /metadata/dataIdInfo//* | /metadata/distInfo//* | /metadata/spatRepInfo//* | /metadata/dqInfo//* | /metadata/refSysInfo//* | /metadata/mdExtInfo//* | /metadata/svIdInfo//* | /metadata/contInfo//* | /metadata/porCatInfo//* | /metadata/appSchInfo//* | /metadata/loc//* | /metadata/eainfo//* | /metadata/spdoinfo/ptvctinf/esriterm//*" />

  <xsl:variable name="fgdc" select="/metadata/idinfo//* | /metadata/metainfo//* | /metadata/dataqual//* | /metadata/spref//* | /metadata/distinfo//* | /metadata/eainfo//*" />

  <xsl:variable name="iso19139" select="(local-name(/*) = 'MD_Metadata')" />
  
  <xsl:param name="flowdirection"/>

  <xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <xsl:if test="/*/@xml:lang[. != '']">
	  <xsl:attribute name="xml:lang"><xsl:value-of select="/*/@xml:lang"/></xsl:attribute>
	  <xsl:attribute name="lang"><xsl:value-of select="/*/@xml:lang"/></xsl:attribute>
  </xsl:if>
  
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <xsl:call-template name="styles" />
    <xsl:call-template name="scripts" />
  </head>

  <body oncontextmenu="return true">
  <xsl:if test="$flowdirection = 'RTL'">
    <xsl:attribute name="style">direction:rtl;</xsl:attribute>
  </xsl:if>
    
	<xsl:choose>
		<xsl:when test="/metadata/tool | /metadata/toolbox">
			<xsl:call-template name="gp"/> 
		</xsl:when>
		<xsl:when test="$arcgis1[text()] or $arcgis2[text()] or $arcgis3[text()] or $fgdc[text()]">
			<xsl:call-template name="iteminfo"/> 
		</xsl:when>
	</xsl:choose>

	<xsl:if test="$arcgis1[text()] or $arcgis2[text()] or $arcgis3[text()]">
		<h2 class="iso head"><a href="#arcgisMetadata" onclick="hideShow('arcgisMetadata')">
			<!-- <xsl:attribute name="title"><xsl:value-of select="res:str('idTopArcGISTooltip')"/></xsl:attribute> -->
			<res:idTopArcGIS />&#160;<span id="arcgisMetadataShow" class="hide">&#9660;</span><span id="arcgisMetadataHide" class="show">&#9658;</span></a></h2>
		<xsl:call-template name="arcgis"/> 
	</xsl:if>

	<xsl:if test="$fgdc[text()]">
		<h2 class="fgdc head"><a href="#fgdcMetadata" onclick="hideShow('fgdcMetadata')">
			<!-- <xsl:attribute name="title"><xsl:value-of select="res:str('idTopFGDCTooltip')"/></xsl:attribute> -->
			<res:idTopFGDC />&#160;<span id="fgdcMetadataShow" class="show">&#9660;</span><span id="fgdcMetadataHide" class="hide">&#9658;</span></a></h2>
		<xsl:call-template name="fgdc"/> 
	</xsl:if>

	<xsl:if test="$iso19139">
		<xsl:call-template name="iso19139"/> 
	</xsl:if>

	<xsl:if test="not($arcgis1[text()] or $arcgis2[text()] or $arcgis3[text()] or $fgdc[text()] or $iso19139)">
		<xsl:call-template name="unknown" /> 
	</xsl:if>

  </body>
  </html>

</xsl:template>

</xsl:stylesheet>