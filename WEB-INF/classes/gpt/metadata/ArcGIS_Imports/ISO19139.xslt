<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:res="http://www.w3.org/2005/xpath-functions">

<!-- An XSLT template for displaying metadata in ArcGIS that is stored in the ISO 19139 metadata format.

     Copyright (c) 2009-2013, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 4/21/2009 avienneau 
-->

<xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"  />

<xsl:template name="iso19139" >
  <h3><res:IDMetadataFormat19139/></h3>
  <h1 style="color: #666666;"><xsl:value-of select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/></h1>

	<xsl:variable name="dataIdInfo" select="/gmd:MD_Metadata/gmd:identificationInfo"/>
	<xsl:variable name="spatRepInfo" select="/gmd:MD_Metadata/gmd:spatialRepresentationInfo"/>
	<xsl:variable name="contInfo" select="/gmd:MD_Metadata/gmd:contentInfo"/>
	<xsl:variable name="refSysInfo" select="/gmd:MD_Metadata/gmd:referenceSystemInfo"/>
	<xsl:variable name="dqInfo" select="/gmd:MD_Metadata/gmd:dataQualityInfo"/>
	<xsl:variable name="porCatInfo" select="/gmd:MD_Metadata/gmd:portrayalCatalogueInfo"/>
	<xsl:variable name="distInfo" select="/gmd:MD_Metadata/gmd:distributionInfo"/>
	<xsl:variable name="appSchInfo" select="/gmd:MD_Metadata/gmd:applicationSchemaInfo"/>
	<xsl:variable name="mdExtInfo" select="/gmd:MD_Metadata/gmd:metadataExtensionInfo"/>
		
	<xsl:variable name="metadata-sections" select="
		/gmd:MD_Metadata/gmd:fileIdentifier |
		/gmd:MD_Metadata/gmd:language |
		/gmd:MD_Metadata/gmd:characterSet |
		/gmd:MD_Metadata/gmd:parentIdentifier |
		/gmd:MD_Metadata/gmd:hierarchyLevel |
		/gmd:MD_Metadata/gmd:hierarchyLevelName |
		/gmd:MD_Metadata/gmd:contact |
		/gmd:MD_Metadata/gmd:dateStamp |
		/gmd:MD_Metadata/gmd:metadataStandardName |
		/gmd:MD_Metadata/gmd:metadataStandardVersion |
		/gmd:MD_Metadata/gmd:dataSetURI |
		/gmd:MD_Metadata/gmd:metadataMaintenance |
		/gmd:MD_Metadata/gmd:metadataConstraints | 
		/gmd:MD_Metadata/gmd:locale"/>

  <ul>
	<li class="iso19139heading"><res:IDISO19139MetaDataCnt/></li>  
    
    <!-- Resource Identification -->
    <!-- DIS version of the DTD doesn't account for data and service subclasses of MD_Identification. 
          This template assumes service elements may appear in metadata/dataIdInfo even though
          those elements aren't in the DTD at all. If subclasses were included, the structure would be
          similar to spatial representation. -->
          
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$dataIdInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('idResIdInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('idResource')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Spatial Representation Information  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$spatRepInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('idSpatRepInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('idRepresentation')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Content Information  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$contInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDContentInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDDescription3')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Reference System Information  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$refSysInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDRefSysInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDRefSys')"/></xsl:with-param>
		</xsl:call-template>
		
    <!-- Data Quality Information -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$dqInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDDataQualInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDDataQuality')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Distribution Information  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$distInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDDistInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDDist')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Portrayal Catalogue Reference  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$porCatInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDPorCatRef')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDCatalogue')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Application Schema Information  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$appSchInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDAppSchInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDSchema')"/></xsl:with-param>
		</xsl:call-template>
		
    <!-- Metadata Extension Information  -->
		<xsl:call-template name="TOC-HEADING">
			<xsl:with-param name="nodes" select="$mdExtInfo"/>
			<xsl:with-param name="label"><xsl:value-of select="res:string('IDMetaExtInfo')"/></xsl:with-param>
			<xsl:with-param name="sub-label"><xsl:value-of select="res:string('IDExtension')"/></xsl:with-param>
		</xsl:call-template>

    <!-- Metadata Identification -->
    <!-- Root node "metadata" will always exist. Only add to TOC if it contains elements
          that describe the metadata. -->
			
    <xsl:if test="count($metadata-sections) &gt; 0">
			<li><a href="#Metadata_Information"><res:IDMetaInfo/></a></li>
    </xsl:if>

    </ul>

		<!-- PUT METADATA CONTENT ON THE HTML PAGE  -->

    <!-- Resource Identification -->
    <xsl:apply-templates select="$dataIdInfo/*" mode="iso19139"/>

    <!-- Spatial Representation Information -->
    <xsl:apply-templates select="$spatRepInfo/*" mode="iso19139"/>

    <!-- Content Information -->
    <xsl:apply-templates select="$contInfo" mode="iso19139"/> <!-- NOTE: special case, see template -->

    <!-- Reference System Information -->
    <xsl:apply-templates select="$refSysInfo/*" mode="iso19139"/>

    <!-- Data Quality Information -->
    <xsl:apply-templates select="$dqInfo/*" mode="iso19139"/>

    <!-- Distribution Information -->
    <xsl:apply-templates select="$distInfo/*" mode="iso19139"/>

    <!-- Portrayal Catalogue Reference -->
    <xsl:apply-templates select="$porCatInfo/*" mode="iso19139"/>

    <!-- Application Schema Information -->
    <xsl:apply-templates select="$appSchInfo/*" mode="iso19139"/>

    <!-- Metadata Extension Information -->
    <xsl:apply-templates select="$mdExtInfo/*" mode="iso19139"/>

    <!-- Metadata Information -->
    <!-- Root node "metadata" will always exist. Only apply template if it contains elements
          that describe the metadata. -->
    <xsl:if test="count($metadata-sections) &gt; 0">
      <xsl:apply-templates select="gmd:MD_Metadata" mode="iso19139"/>
    </xsl:if>

</xsl:template>

<!-- Generic template for displaying the TOC headings and links -->
<xsl:template name="TOC-HEADING">
	<xsl:param name="nodes"/>
	<xsl:param name="label"/>
	<xsl:param name="sub-label"/>
	
	<xsl:if test="count($nodes) = 1">
		<xsl:for-each select="$nodes">
			<li><a>
				<xsl:attribute name="href">#<xsl:value-of select="generate-id(./*[1])"/></xsl:attribute>
				<xsl:value-of select="$label"/>
			</a></li>
		</xsl:for-each>
	</xsl:if>
	<xsl:if test="count($nodes) &gt; 1">
		<li style="color: #666666;"><xsl:value-of select="$label"/></li>
		<xsl:for-each select="$nodes">
			<li style="margin-left:0.5in; color: #666666;"><a>
				<xsl:attribute name="href">#<xsl:value-of select="generate-id(./*[1])"/></xsl:attribute>
				<xsl:value-of select="$sub-label"/>&#x20;<xsl:value-of select="position()"/>
			</a></li>
		</xsl:for-each>
	</xsl:if>
	
</xsl:template>

<!-- TEMPLATES FOR METADATA UML CLASSES -->

<!-- Metadata Information (B.2.1 MD_Metadata - line 1) -->
<!-- can't use match parameter - mixes up applying templates, triggers applying XML style sheet instead -->
<!-- <xsl:template match="gmd:MD_Metadata"> -->
<xsl:template match="gmd:MD_Metadata"  mode="iso19139">
  <a name="Metadata_Information" id="Metadata_Information"><hr /></a>
  <dt><h2 style="color: #666666;"><res:IDMetaInfo/></h2></dt>
  <dl>
  <dd>
    <xsl:for-each select="gmd:dateStamp">
      <dt><span class="element"><res:idLastUpdate/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
    </xsl:for-each>
    <xsl:apply-templates select="gmd:metadataMaintenance" mode="iso19139"/>
    <xsl:if test="gmd:dateStamp and not(gmd:metadataMaintenance)"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:metadataConstraints">
      <dt><span class="element"><res:idMDConstraints/></span></dt>
      <dl>
				<!-- 
						NOTE: will match sub-class templates:
						MD_LegalConstraints, MD_SecurityConstraints
				-->
        <xsl:apply-templates select="*" mode="iso19139"/>
      </dl>
    </xsl:for-each>

    <xsl:apply-templates select="gmd:contact/gmd:CI_ResponsibleParty" mode="iso19139"/>
    
    <xsl:for-each select="gmd:hierarchyLevel">
      <dt><span class="element"><res:idScopeOfMDDesc/></span>&#x2002;<xsl:call-template name="AnyCode" /></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:hierarchyLevelName">
      <dt><span class="element"><res:idScopeName/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:hierarchyLevel | gmd:hierarchyLevelName"><br /><br /></xsl:if>
 
    <xsl:for-each select="gmd:language">
      <dt><span class="element"><res:idMDLang/></span>&#x2002;
        <xsl:apply-templates select="." mode="iso19139" />
      </dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:characterSet">
      <dt><span class="element"><res:idMDCharSet/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:locale/gmd:PT_Locale">
		<xsl:if test="position() = 1">
			<dt><span class="element"><res:loc/></span></dt>
		</xsl:if>
		<dl>
		<dd>
			<xsl:for-each select="gmd:languageCode">
			  <dt><span class="element"><res:locLang/></span>&#x2002;
				<xsl:apply-templates select="." mode="iso19139" />
			  </dt>
			</xsl:for-each>
			<dl>
			<dd>
				<xsl:for-each select="gmd:country">
					<dt><span class="element"><res:locCountry/></span>&#x2002;<xsl:apply-templates select="."  mode="arcgis"/></dt>
				</xsl:for-each>
				<xsl:for-each select="gmd:characterEncoding">
				  <dt><span class="element"><res:locEncoding/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
				</xsl:for-each>
			</dd>
			</dl>
		</dd>
		</dl>
    </xsl:for-each>
    <xsl:if test="gmd:language | gmd:characterSet | gmd:locale"><br /></xsl:if>
    <xsl:if test="(gmd:language or gmd:characterSet) and not(gmd:locale)"><br /></xsl:if>
    
    <xsl:for-each select="gmd:metadataStandardName">
      <dt><span class="element"><res:idNameMDStand/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:metadataStandardVersion">
      <dt><span class="element"><res:idVerMDStand/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:metadataStandardName | gmd:metadataStandardVersion"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:fileIdentifier">
      <dt><span class="element"><res:idMDIdent/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:parentIdentifier">
      <dt><span class="element"><res:idParIdent/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:dataSetURI">
      <dt><span class="element"><res:idURIDataDesc/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:fileIdentifier | gmd:parentIdentifier | gmd:dataSetURI"><br /><br /></xsl:if>
  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- 2 letter language code list from ISO 639 : 1988, in alphabetic order by code -->
<xsl:template match="gmd:language | gmd:languageCode" mode="iso19139">
	<span class="textOld">
	<xsl:choose>
		<xsl:when test="gco:CharacterString">
			<xsl:call-template name="ISO639_LanguageCode">
				<xsl:with-param name="code" select="gco:CharacterString" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="gmd:LanguageCode">
			<xsl:call-template name="ISO639_LanguageCode">
				<xsl:with-param name="code" select="gmd:LanguageCode/@codeListValue" />
			</xsl:call-template>
		</xsl:when>
        <xsl:when test="not(gco:CharacterString) and not(gmd:LanguageCode) and (@gco:nilReason)"><xsl:call-template name="nilReason"/></xsl:when>
	</xsl:choose>
	</span>
</xsl:template>

<!-- Maintenance Information (B.2.5 MD_MaintenanceInformation - line142) -->
<xsl:template match="gmd:MD_MaintenanceInformation" mode="iso19139"> <!-- match="(mdMaint | resMaint)"> -->
    <dd>
    <xsl:choose>
      <xsl:when test="../gmd:resourceMaintenance">
        <dt><span class="element"><res:idResMaint/></span></dt>
      </xsl:when>
      <xsl:otherwise>
        <dt><span class="element"><res:idMaint/></span></dt>
      </xsl:otherwise>
    </xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="gmd:dateOfNextUpdate">
        <dt><span class="element"><res:idDateOfNxtUpdate/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:maintenanceAndUpdateFrequency">
        <dt><span class="element"><res:idUpdateFreq/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:userDefinedMaintenanceFrequency/gts:TM_PeriodDuration">
        <dt><span class="element"><res:idTimePerBtwUpdate/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:dateOfNextUpdate | gmd:maintenanceAndUpdateFrequency | gmd:userDefinedMaintenanceFrequency"><br /><br /></xsl:if>

		<xsl:for-each select="gmd:updateScope">
		  <dt><span class="element"><res:idScopeOfUpdates/></span>&#x2002;<xsl:call-template name="AnyCode" /></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:updateScopeDescription">
			<xsl:if test="position() = 1">
				<dt><span class="element"><res:idUpdateScopeDescription/></span></dt>
			</xsl:if>
			<dl>
			<dd>
			  <xsl:apply-templates select="gmd:MD_ScopeDescription" mode="iso19139"/>
			</dd>
			</dl>
			<xsl:if test="count (following-sibling::*) = 0"><br /></xsl:if>
		</xsl:for-each>
      <xsl:if test="gmd:updateScope and not(gmd:updateScopeDescription)"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:maintenanceNote">
        <dt><span class="element"><res:idOtherMaintReq/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
        <br /><br />
      </xsl:for-each>
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- Time Period Information (from 19103 information in 19115 DTD) -->
<!-- break time period string up into individual components for display?
<xsl:template match="usrDefFreq" mode="iso19139">
  <dd>
  <dt><span class="element"><res:idTimePerBtwUpdate/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="designator">
      <dt><span class="element"><res:idTimePerDes/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="years">
      <dt><span class="element"><res:idYrs/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="months">
      <dt><span class="element"><res:idMths/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="days">
      <dt><span class="element"><res:idDays/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="timeIndicator">
      <dt><span class="element"><res:idTimeInd/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="hours">
      <dt><span class="element"><res:idHrs/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="minutes">
      <dt><span class="element"><res:idMin/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="seconds">
      <dt><span class="element"><res:idSec/></span>&#x2002;<xsl:value-of select="."/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>
 -->
 
<!-- Scope Description Information (B.2.5.1 MD_ScopeDescription - line149) -->
<xsl:template match="gmd:MD_ScopeDescription" mode="iso19139">
	<dl>
	<dd>
		<!--<dt><span class="element"><res:idScopeDesc/></span></dt> -->
		<xsl:for-each select="gmd:attributes">
			<dt><span class="element"><res:idAtt/></span>&#x2002;<xsl:call-template name="uuidref"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:features">
			<dt><span class="element"><res:idFeat/></span>&#x2002;<xsl:call-template name="uuidref"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:featureInstances">
			<dt><span class="element"><res:idFeatInst/></span>&#x2002;<xsl:call-template name="uuidref"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:attributeInstances">
			<dt><span class="element"><res:idAttInst/></span>&#x2002;<xsl:call-template name="uuidref"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:dataset">
			<dt><span class="element"><res:idDs/></span>&#x2002;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:other">
			<dt><span class="element"><res:idOther/></span>&#x2002;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
	</dd>
	</dl>
</xsl:template>

<!-- General Constraint Information (B.2.3 MD_Constraints - line67) -->
<xsl:template match="gmd:MD_Constraints" mode="iso19139">
  <dd>
    <dt><span class="element"><res:idConstaints/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:useLimitation">
        <dt><span class="element"><res:idLimOfUse/></span></dt>
        <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Legal Constraint Information (B.2.3 MD_LegalConstraints - line69) -->
<xsl:template match="gmd:MD_LegalConstraints" mode="iso19139">
  <dd>
    <dt><span class="element"><res:idLegConst/></span></dt>
    <dd>
    <dl>
      <xsl:if test="gmd:accessConstraints">
        <dt><span class="element"><res:idAccConst/></span>&#x2002;
			<xsl:for-each select="gmd:accessConstraints">
				<xsl:call-template name="AnyCode"/><xsl:if test="not(position()=last())">, </xsl:if>
			</xsl:for-each>
        </dt>
        <br /><br />
      </xsl:if>

      <xsl:if test="gmd:useConstraints">
        <dt><span class="element"><res:idUseConst/></span>&#x2002;
			<xsl:for-each select="gmd:useConstraints">
				<xsl:call-template name="AnyCode"/><xsl:if test="not(position()=last())">, </xsl:if>
			</xsl:for-each>
        </dt>
        <br /><br />
      </xsl:if>

      <xsl:for-each select="gmd:otherConstraints">
        <dt><span class="element"><res:idOtherConst/></span></dt>
        <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
      </xsl:for-each>
			
	  <xsl:for-each select="gmd:useLimitation">
        <dt><span class="element"><res:idLimOfUse/></span></dt>
        <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
      </xsl:for-each>
			
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Security Constraint Information (B.2.3 MD_SecurityConstraints - line73) -->
<xsl:template match="gmd:MD_SecurityConstraints" mode="iso19139">
  <dd>
    <dt><span class="element"><res:idSecConst/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:classification">
        <dt><span class="element"><res:idClassification/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:classificationSystem">
        <dt><span class="element"><res:idClassificationSys/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:classification | gmd:classificationSystem"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:userNote">
        <dt><span class="element"><res:idUserNote/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
        <br /><br />
      </xsl:for-each>

      <xsl:for-each select="gmd:handlingDescription">
        <dt><span class="element"><res:idAddResHandRes/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
        <br /><br />
      </xsl:for-each>

      <xsl:for-each select="gmd:useLimitation">
        <dt><span class="element"><res:idLimOfUse/></span></dt>
        <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- RESOURCE IDENTIFICATION -->

<!-- Resource Identification Information (B.2.2 MD_Identification - line23, including MD_DataIdentification - line36) -->
<!-- DTD doesn't account for data and service subclasses of MD_Identification -->
<xsl:template match="gmd:MD_DataIdentification | srv:SV_ServiceIdentification" mode="iso19139">
	<a>
	  <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
	  <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
	  <xsl:if test="not(name(..) = 'srv:operatesOn')">
		  <hr />
	  </xsl:if>
	</a>
	<xsl:choose>
		<xsl:when test="(name(..) = 'srv:operatesOn')">
			<dt><span class="element"><res:svOperOn /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'MD_DataIdentification') and (count (../../*[gmd:MD_DataIdentification]) = 1)">
			<dt><h2 style="color: #666666;"><res:IDResIdInfo2/></h2></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'MD_DataIdentification') and (count (../../*[gmd:MD_DataIdentification]) &gt; 1)">
			<dt><h2 style="color: #666666;"><res:IDResIdInfo/>
				<xsl:for-each select="..">
					<xsl:value-of select="position()"/>
				</xsl:for-each></h2>
			</dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'SV_ServiceIdentification') and (count (../../*[srv:SV_ServiceIdentification]) =  1)">
			<dt><h2 style="color: #666666;"><res:IDSvcIdInfo2/></h2></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'SV_ServiceIdentification') and (count (../../*[srv:SV_ServiceIdentification]) &gt; 1)">
			<dt><h2 style="color: #666666;"><res:IDSvcIdInfoRes/>
				<xsl:for-each select="..">
					<xsl:value-of select="position()"/>
				</xsl:for-each></h2>
			</dt>
		</xsl:when>
    </xsl:choose>
	<dl>
	<dd>
    <xsl:apply-templates select="gmd:citation/gmd:CI_Citation" mode="iso19139"/>

	<xsl:choose>
		<xsl:when test="gmd:topicCategory[gmd:MD_TopicCategoryCode]">
			<dt><span class="element"><res:idThemeCatRes/></span>&#x2002;<span class="textOld">
				<xsl:for-each select="gmd:topicCategory">
					<xsl:value-of select="gmd:MD_TopicCategoryCode"/><xsl:if test="not(position()=last())">, </xsl:if>        
				</xsl:for-each></span>
			</dt>
			<xsl:if test="count (following-sibling::*) = 0"><br /><br /></xsl:if>
		</xsl:when>
		<xsl:when test="gmd:topicCategory[@gco:nilReason]">
			<dt><span class="element"><res:idThemeCatRes/></span>&#x2002;<span class="textOld">
				<xsl:for-each select="gmd:topicCategory">
					<xsl:call-template name="nilReason"/>
				</xsl:for-each></span>
			</dt>
			<br />
		</xsl:when>
	</xsl:choose>

    <xsl:apply-templates select="gmd:descriptiveKeywords/gmd:MD_Keywords" mode="iso19139"/>
    
    <xsl:for-each select="gmd:abstract">
      <dt><span class="element"><res:idAbst/></span></dt>
      <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
    </xsl:for-each>

    <xsl:for-each select="gmd:purpose">
      <dt><span class="element"><res:idPurpose/></span></dt>
      <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
    </xsl:for-each>

    <xsl:for-each select="srv:serviceType"><!-- NOTE: will match gco:LocalName and gco:ScopedName -->
      <dt><span class="element"><res:idServiceType /></span>&#x2003;<xsl:call-template name="SimpleText"/></dt>
    </xsl:for-each>
    <xsl:for-each select="srv:serviceType/*/@codeSpace">
		<dl>
			<dd><span class="element"><res:idServiceType_codespace /></span>&#x2003;<xsl:call-template name="SimpleText"/></dd>
		</dl>
    </xsl:for-each>
    <xsl:for-each select="srv:serviceTypeVersion">
      <dt><span class="element"><res:idServiceTypeVersion /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="(srv:serviceType or srv:serviceTypeVersion)"><br /><br /></xsl:if>

    <xsl:apply-templates select="srv:accessProperties/gmd:MD_StandardOrderProcess" mode="iso19139"/>

    <xsl:apply-templates select="gmd:graphicOverview/gmd:MD_BrowseGraphic" mode="iso19139"/>
    
    <xsl:for-each select="gmd:language">
      <dt><span class="element"><res:idDsLang/></span>&#x2002;
          <xsl:apply-templates select="."  mode="iso19139"/>
      </dt>
    </xsl:for-each>
       
    <xsl:for-each select="gmd:characterSet">
      <dt><span class="element"><res:idDsCharSet/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:language | gmd:characterSet"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:status">
      <dt><span class="element"><res:idStatus/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:apply-templates select="gmd:resourceMaintenance" mode="iso19139"/>
<!--    <xsl:if test="gmd:status | gmd:resourceMaintenance"><br /><br /></xsl:if> -->

    <xsl:for-each select="gmd:resourceConstraints">
      <dt><span class="element"><res:idResConst/></span></dt>
      <dl>
        <xsl:apply-templates select="gmd:MD_Constraints" mode="iso19139"/>
        <xsl:apply-templates select="gmd:MD_LegalConstraints" mode="iso19139"/>
        <xsl:apply-templates select="gmd:MD_SecurityConstraints" mode="iso19139"/>
      </dl>
    </xsl:for-each>

    <xsl:apply-templates select="gmd:resourceSpecificUsage/gmd:MD_Usage" mode="iso19139"/>

    <xsl:for-each select="gmd:spatialRepresentationType">
      <dt><span class="element"><res:idSpatRepType/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:apply-templates select="gmd:resourceFormat/gmd:MD_Format" mode="iso19139"/>
    <xsl:if test="gmd:spatialRepresentationType and not(gmd:resourceFormat)"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:environmentDescription">
      <dt><span class="element"><res:idProcEnv/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      <br /><br />
    </xsl:for-each>
    
    <xsl:apply-templates select="gmd:spatialResolution/gmd:MD_Resolution" mode="iso19139"/> 
    
	<xsl:apply-templates select="gmd:extent/gmd:EX_Extent" mode="iso19139"/>
	<xsl:apply-templates select="srv:extent/gmd:EX_Extent" mode="iso19139"/>

    <xsl:for-each select="gmd:supplementalInformation">
      <dt><span class="element"><res:idSubInfo/></span></dt>
      <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
    </xsl:for-each>

    <xsl:for-each select="gmd:credit">
      <dt><span class="element"><res:idCredits/></span></dt>
      <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
    </xsl:for-each>
    
    <xsl:apply-templates select="gmd:pointOfContact/gmd:CI_ResponsibleParty" mode="iso19139"/>
    
    <xsl:apply-templates select="gmd:aggregationInfo/gmd:MD_AggregateInformation" mode="iso19139"/>
    
	<xsl:for-each select="srv:couplingType">
      <dt><span class="element"><res:idServiceCouplingType /></span>&#x2003;<xsl:call-template name="AnyCode"/></dt>
      <br /><br />
	</xsl:for-each>
    <xsl:for-each select="srv:coupledResource/srv:SV_CoupledResource">
		<dt><span class="element"><res:idServiceCoupledResource /></span></dt>
		<dl>
		<dd>
			<xsl:for-each select="srv:operationName">
			  <dt><span class="element"><res:idServiceOperationName /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
			</xsl:for-each>
			<xsl:for-each select="srv:identifier">
			  <dt><span class="element"><res:idServiceResourceIdentifier /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
			</xsl:for-each>
		</dd>
		</dl><br />
	</xsl:for-each>

    <xsl:apply-templates select="srv:containsOperations/srv:SV_OperationMetadata"  mode="iso19139"/>
    <xsl:apply-templates select="srv:operatesOn/gmd:MD_DataIdentification"  mode="iso19139"/>
  </dd>
  </dl>
  <xsl:if test="not(name(..) = 'srv:operatesOn')">
	  <a class="top" href="#Top"><res:IDBackToTop/></a>
  </xsl:if>
</xsl:template>

<!-- Keyword Information (B.2.2.2 MD_Keywords - line52)-->
<xsl:template match="gmd:MD_Keywords" mode="iso19139">
  <dd>
   <xsl:choose>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='001' or @codeListValue='discipline']">
        <dt><span class="element"><res:idDisKey/></span></dt>
     </xsl:when>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='002' or @codeListValue='place']">
        <dt><span class="element"><res:idPlaceKeywords/></span></dt>
     </xsl:when>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='003' or @codeListValue='stratum']">
        <dt><span class="element"><res:idStrKeywords/></span></dt>
     </xsl:when>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='004' or @codeListValue='temporal']">
        <dt><span class="element"><res:idTempKeywords/></span></dt>
     </xsl:when>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='005' or @codeListValue='theme']">
        <dt><span class="element"><res:idThemeKeywords/></span></dt>
     </xsl:when>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='006' or @codeListValue='product']">
        <dt><span class="element"><res:idProductKeywords/></span></dt>
     </xsl:when>
     <xsl:when test="gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='007' or @codeListValue='subTopicCategory']">
        <dt><span class="element"><res:idSubtopicKeywords/></span></dt>
     </xsl:when>
     <xsl:otherwise>
        <dt><span class="element"><res:idDescKeywords/>&#160;<xsl:value-of select="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/></span></dt>
     </xsl:otherwise>
   </xsl:choose>
    <dd>
    <dl>
      <xsl:if test="gmd:keyword">
        <dt>
        <xsl:for-each select="gmd:keyword">
          <xsl:if test="position() = 1"><span class="element"><res:idKeywords/></span>&#x2003;</xsl:if>
          <xsl:call-template name="CharacterString"/><span class="textOld"><xsl:if test="not(position()=last())">, </xsl:if></span>
        </xsl:for-each>
        </dt>
        <br /><br />
      </xsl:if>

      <xsl:apply-templates select="gmd:thesaurusName/gmd:CI_Citation" mode="iso19139"/>
      
      <xsl:if test="(gmd:thesaurusName/@uuidref = '723f6998-058e-11dc-8314-0800200c9a66')">
        <dt><span class="element"><res:IDthesaurusName/></span>&#x2003;<res:imsContentTypeThesaurus/></dt><br /><br />
      </xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Browse Graphic Information (B.2.2.1 MD_BrowseGraphic - line48) -->
<xsl:template match="gmd:MD_BrowseGraphic" mode="iso19139">
  <dd>
    <dt><span class="element"><res:idGraphicOverview/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:fileName">
        <dt><span class="element"><res:idFileName/></span>&#x2003;<xsl:call-template name="urlType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:fileType">
        <dt><span class="element"><res:idFileType/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:fileDescription">
        <dt><span class="element"><res:idFileDesc/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Usage Information (B.2.2.5 MD_Usage - line62) -->
<xsl:template match="gmd:MD_Usage" mode="iso19139">
  <dd>
    <dt><span class="element"><res:idHowToResUsed/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:usageDateTime">
        <dt><span class="element"><res:idDateTimeUse/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:specificUsage">
        <dt><span class="element"><res:idDesc/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:usageDateTime | gmd:specificUsage"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:userDeterminedLimitations">
        <dt><span class="element"><res:idHowResUsed/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
        <br /><br />
      </xsl:for-each>

      <xsl:apply-templates select="gmd:userContactInfo/gmd:CI_ResponsibleParty" mode="iso19139"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Aggregate Information (B.2.2.7 MD_AggregateInformation - line66.1) -->
<xsl:template match="gmd:MD_AggregateInformation" mode="iso19139">
  <dd>
    <dt><span class="element"><res:idAggregateInfo /></span></dt>
    <dd>
    <dl>
		<xsl:for-each select="gmd:associationType">
		  <dt><span class="element"><res:idAssociationType /></span>&#x2003;<xsl:call-template name="AnyCode"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:initiativeType">
		  <dt><span class="element"><res:idInitiativeType /></span>&#x2003;<xsl:call-template name="AnyCode"/></dt>
		</xsl:for-each>
		<xsl:if test="gmd:associationType/gmd:DS_AssociationTypeCode | gmd:initiativeType/gmd:DS_InitiativeTypeCode"><br /><br /></xsl:if>

		<xsl:apply-templates select="gmd:aggregateDataSetName/gmd:CI_Citation" mode="iso19139"/>

		<xsl:for-each select="gmd:aggregateDataSetIdentifier/gmd:MD_Identifier">
		  <dt><span class="element"><res:idAggregateIdentifier/></span></dt>
		  <xsl:apply-templates select="." mode="iso19139"/>
		</xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Resolution Information (B.2.2.4 MD_Resolution - line59) -->
<xsl:template match="gmd:MD_Resolution" mode="iso19139">
  <dd>
  <dt><span class="element"><res:idSpatialRes/></span></dt>
    <dd>
    <dl>
      <xsl:apply-templates select="gmd:equivalentScale/gmd:MD_RepresentativeFraction" mode="iso19139"/>

      <xsl:for-each select="gmd:distance/gco:Distance">
        <dt><span class="element"><res:idGrdSampleDist/></span>&#x2002;<xsl:apply-templates select="." mode="iso19139"/></dt><br /><br />
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Representative Fraction Information (B.2.2.3 MD_RepresentativeFraction - line56) -->
<xsl:template match="gmd:MD_RepresentativeFraction" mode="iso19139">
  <dt><span class="element"><res:idDsScle/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="gmd:denominator">
      <dt><span class="element"><res:idScaleDem/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>

<!-- Service Operation Metadata (SV_OperationMetadata) -->
<xsl:template match="srv:SV_OperationMetadata" mode="iso19139">
	<dd>
	<dt><span class="element"><res:idServiceOperation /></span></dt>
	<dd>
    <dl>
		<xsl:for-each select="srv:operationName">
		  <dt><span class="element"><res:idServiceOperationName /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:operationDescription">
		  <dt><span class="element"><res:idServiceOperationDescription /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:invocationName">
		  <dt><span class="element"><res:idServiceOperationInvocationName /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:DCP">
		  <dt><span class="element"><res:idServiceDCPtype /></span>&#x2003;<xsl:call-template name="AnyCode"/></dt>
		</xsl:for-each>

		<xsl:apply-templates select="srv:connectPoint/gmd:CI_OnlineResource" mode="iso19139"/>
		<xsl:apply-templates select="srv:parameters/srv:SV_Parameter" mode="iso19139"/>
		<xsl:apply-templates select="srv:dependsOn/srv:SV_OperationMetadata" mode="iso19139"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Service Operation Parameters (SV_Parameter) -->
<xsl:template match="srv:SV_Parameter" mode="iso19139">
  <dd>
	<dt><span class="element"><res:idServiceParameter /></span></dt>
	<dd>
    <dl>
		<xsl:if test="srv:name/gco:MemberName">
			<dt><span class="element"><res:idServiceParameterName /></span>&#x2003;</dt>
			<xsl:apply-templates select="srv:name/gco:MemberName"  mode="iso19139"/>
		</xsl:if>
		<xsl:for-each select="srv:description">
		  <dt><span class="element"><res:idServiceParameterDescription /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:direction/srv:SV_ParameterDirection">
		  <dt><span class="element"><res:idServiceParameterDirection /></span>&#x2003;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:optionality">
		  <dt><span class="element"><res:idServiceParameterOptionality /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:repeatability">
		  <dt><span class="element"><res:idServiceParameterRepeatability /></span>&#x2003;<xsl:call-template name="Boolean"/></dt>
		</xsl:for-each>
		<xsl:for-each select="srv:valueType/gco:TypeName/gco:aName">
			<dt><span class="element"><res:idServiceParameterValueType /></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
    </dl>
    </dd>
  </dd><br />
</xsl:template>

<!-- SPATIAL REPRESENTATION -->

<!-- Spatial Representation Information (B.2.6  MD_SpatialRepresentation - line156) -->
    <!--
<xsl:template match="gmd:spatialRepresentationInfo" mode="iso19139">
  <a>
	<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
	<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
  <dl>
    <xsl:choose>
      <xsl:when test="gmd:MD_GridSpatialRepresentation">
        <dt><h2>Grid</h2></dt>
      </xsl:when>
      <xsl:when test="gmd:MD_VectorSpatialRepresentation">
        <dt><h2>Vector</h2></dt>
      </xsl:when>
			<xsl:when test="gmd:MD_Georectified">
        <dt><h2>Georectified Grid</h2></dt>
      </xsl:when>
      <xsl:when test="gmd:MD_Georeferenceable">
        <dt><h2>Georeferenceable Grid</h2></dt>
      </xsl:when>
    -->
			<!-- NOTE: abstract -->
    <!--
      <xsl:otherwise>
        <dt><font color="#0000AA" size="3"><span class="element">Spatial Representation</span></font></dt>
      </xsl:otherwise>
    </xsl:choose>
    -->
    <!--  
  <dl>
    <dd>
      <xsl:apply-templates select="*" mode="iso19139"/>
    </dd>
  </dl>
  </dl> 
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>
	-->

<!-- Grid Information (B.2.6  MD_GridSpatialRepresentation - line157 -->
<xsl:template name="MD_GridSpatialRepresentation"> 
   	<xsl:for-each select="gmd:numberOfDimensions">
      <dt><span class="element"><res:idNumDim/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
    </xsl:for-each>
	<dd>
		<dt><span class="element"><res:idAxisDimProp/></span></dt>
		<dd>
		<dl>
			<xsl:apply-templates select="gmd:axisDimensionProperties/gmd:MD_Dimension" mode="iso19139"/>
		</dl>
		</dd>
	</dd>

	<xsl:for-each select="gmd:cellGeometry">
    	<dt><span class="element"><res:cellGeometry/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
		
	<xsl:for-each select="gmd:transformationParameterAvailability">
		<dt><span class="element"><res:transformationParameterAvailability/></span>&#x2002;
			<xsl:call-template name="Boolean"/>
		</dt>      
	</xsl:for-each>
		
	<xsl:if test="gmd:numberOfDimensions and not (gmd:axisDimensionProperties)"><br /></xsl:if>
		
</xsl:template>

<!-- Grid Information (B.2.6  MD_GridSpatialRepresentation - line157 -->
<xsl:template match="gmd:MD_GridSpatialRepresentation" mode="iso19139">
	<a>
		<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<hr />
	</a>
	<dt><h2 style="color: #666666;"><res:IDSpatRefGrid/></h2></dt>
	<dl>
	<dd>
		<xsl:call-template name="MD_GridSpatialRepresentation"/>
	</dd>
	</dl>
	<br/>
	<a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<xsl:template match="gmd:MD_Georectified" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
  <dt><h2 style="color: #666666;"><res:IDSpatRepGeorec/></h2></dt>
  <dl>
  <dd>
	<xsl:call-template name="MD_GridSpatialRepresentation"/>
	
	<xsl:for-each select="gmd:pointInPixel">
		<dt><span class="element"><res:pointInPixel/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
	</xsl:for-each>
	<xsl:if test="gmd:cellGeometry | gmd:pointInPixel"><br /><br /></xsl:if>
	
	<xsl:for-each select="gmd:transformationDimensionDescription">
		<dt><span class="element"><res:IDtransformationDimensionDescription/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
	</xsl:for-each>
	<xsl:for-each select="gmd:transformationDimensionMapping">
		<dt><span class="element"><res:IDtransformationDimensionMapping/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
	</xsl:for-each>
	<xsl:if test="gmd:transformationParameterAvailability | gmd:transformationDimensionDescription | gmd:transformationDimensionMapping"><br /><br /></xsl:if>
    
	<xsl:for-each select="gmd:checkPointAvailability">
		<dt><span class="element"><res:IDcheckPointAvailability/></span>&#x2002;<xsl:call-template name="Boolean"/></dt>      
	</xsl:for-each>
	<xsl:for-each select="gmd:checkPointDescription">
		<dt><span class="element"><res:IDcheckPointDescription/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
	</xsl:for-each>
	<xsl:if test="gmd:checkPointAvailability | gmd:checkPointDescription"><br /><br /></xsl:if>

	<xsl:if test="gmd:cornerPoints">
		<dt><span class="element"><res:IDcornerPoints/></span></dt>
		<dd>
		<dl>
			<xsl:apply-templates select="gmd:cornerPoints/gml:Point" mode="iso19139" />
		</dl>
		</dd>
	</xsl:if>
	<xsl:for-each select="gmd:centerPoint">
		<dt><span class="element"><res:IDcenterPoint/></span></dt>
		<dd>
		<dl>
			<xsl:apply-templates select="gml:Point" mode="iso19139" />
		</dl>
		</dd>
	</xsl:for-each>

  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<xsl:template match="gmd:MD_Georeferenceable" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
  <dt><h2 style="color: #666666;"><res:IDSpatRepGeoRef/></h2></dt>
  <dl>
  <dd>
	<xsl:call-template name="MD_GridSpatialRepresentation"/>
	
      <xsl:for-each select="gmd:controlPointAvailability">
        <dt><span class="element"><res:IDcontrolPointAvailability/></span>&#x2002;<xsl:call-template name="Boolean"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:orientationParameterAvailability">
        <dt><span class="element"><res:IDorientationParameterAvailability/></span>&#x2002;<xsl:call-template name="Boolean"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:orientationParameterDescription">
        <dt><span class="element"><res:IDorientationParameterDescription/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:controlPointAvailability | gmd:orientationParameterAvailability | gmd:orientationParameterDescription"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:georeferencedParameters">
        <dt><span class="element"><res:IDgeoreferencedParameters/></span>&#x2002;<xsl:call-template name="Record"/></dt>
      </xsl:for-each>
      <xsl:apply-templates select="gmd:parameterCitation/gmd:CI_Citation" mode="iso19139"/>
      <xsl:if test="gmd:georeferencedParameters and not (gmd:parameterCitation)"><br /><br /></xsl:if>
		
  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template> 

<!-- Dimension Information (B.2.6.1 MD_Dimension - line179) -->
<!-- DataType -->
<xsl:template match="gmd:MD_Dimension" mode="iso19139">
  
      <!--<xsl:for-each select="gmd:MD_Dimension">-->
				<dt><span class="element"><res:IDDimension/></span></dt>
				<dd>
				<dl>
					<xsl:for-each select="gmd:dimensionName">
						<dt><span class="element"><res:IDdimensionName/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
					</xsl:for-each>
					<xsl:for-each select="gmd:dimensionSize">
						<dt><span class="element"><res:IDdimensionSize/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
					</xsl:for-each>
					<xsl:for-each select="gmd:resolution/gco:Measure">
						<dt><span class="element"><res:IDresolution/></span></dt>
						<dl>
						<dt><span class="element"><res:IDDistance/></span>&#x2002;<xsl:apply-templates select="." mode="iso19139"/></dt>
						</dl>
					</xsl:for-each>
				</dl>
				</dd>
				<br />
      <!--</xsl:for-each>-->
 
</xsl:template>

<!-- Vector Information (B.2.6  MD_VectorSpatialRepresentation - line176) -->
<xsl:template match="gmd:MD_VectorSpatialRepresentation" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
  <dt><h2 style="color: #666666;"><res:IDSpatRepVec/></h2></dt>
  <dl>
  <dd>
      <xsl:for-each select="gmd:topologyLevel">
        <dt><span class="element"><res:IDtopologyLevel/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:apply-templates select="gmd:geometricObjects/gmd:MD_GeometricObjects" mode="iso19139"/>
      <xsl:if test="gmd:topologyLevel and not (gmd:geometricObjects)"><br /><br /></xsl:if>
  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- Geometric Object Information (B.2.6.2 MD_GeometricObjects - line183) -->
<!-- Data Type -->
<xsl:template match="gmd:MD_GeometricObjects" mode="iso19139">
  <dd>
    <dt><span class="element"><res:IDMD_GeometricObjects/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:geometricObjectType">
        <dt><span class="element"><res:IDgeometricObjectType/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:geometricObjectCount">
        <dt><span class="element"><res:IDgeometricObjectCount/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Identifier Information (B.2.7.2 MD_Identifier - line205) -->
<xsl:template match="gmd:MD_Identifier" mode="iso19139">
	<xsl:call-template name="MD_Identifier"/>
</xsl:template>

<xsl:template match="gmd:RS_Identifier" mode="iso19139">
	<xsl:call-template name="MD_Identifier"/>
	<dl>
	<dd>
		<xsl:for-each select="gmd:codeSpace">
			<dt><span class="element"><res:idCodeSpace/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:version">
			<dt><span class="element"><res:idVersion/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
	</dd>
	</dl>
	<xsl:if test="gmd:codeSpace or gmd:version"><br /></xsl:if>
</xsl:template>

<xsl:template name="MD_Identifier"> <!-- NOTE: was match="geoId | refSysID | projection | ellipsoid | datum | refSysName | 
      MdIdent | RS_Identifier | datumID"> -->
	<xsl:choose>
	<xsl:when test="../gmd:geographicIdentifier">
		<dt><span class="element"><res:IDgeographicIdentifier/></span></dt>
	</xsl:when>
	<!-- don't include an xsl:otherwise so the identCode value will appear correctly indented under the heading -->
	  </xsl:choose>
	<dl>
	<dd>
		<xsl:for-each select="gmd:code">
			<dt><span class="element"><res:IDValue/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
	
		<xsl:apply-templates select="gmd:authority/gmd:CI_Citation" mode="iso19139"/>
		
		<xsl:if test="(gmd:code) and not (gmd:authority)"><br /><br /></xsl:if>
	</dd>
	</dl>
</xsl:template>


<!-- CONTENT INFORMATION -->

<!-- Content Information (B.2.8 MD_ContentInformation - line232) -->
<xsl:template name="MD_CoverageDescription"> 
	<xsl:for-each select="gmd:contentType">
		<dt><span class="element"><res:IDTypeofContent/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
	</xsl:for-each>
	<xsl:for-each select="gmd:attributeDescription">
		<dt><span class="element"><res:IDAttDescCellValue/></span>&#x2002;<xsl:call-template name="RecordType"/></dt>
	</xsl:for-each>
    <xsl:if test="gmd:contentType | gmd:attributeDescription"><br /><br /></xsl:if>

    <xsl:apply-templates select="gmd:dimension" mode="iso19139"/>
</xsl:template>

<!-- Feature Catalogue Description (B.2.8 MD_FeatureCatalogueDescription - line233) -->
<xsl:template match="gmd:MD_FeatureCatalogueDescription" mode="iso19139">
	<a>
		<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<hr />
	</a>
    <dt><h2 style="color: #666666;"><res:IDContInfoFeatCatDesc/></h2></dt>
	<dl>
    <dd>
      <xsl:for-each select="gmd:language">
        <dt><span class="element"><res:IDlanguage/></span>&#x2002;
			<xsl:apply-templates select="."  mode="iso19139"/>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:includedWithDataset">
        <dt><span class="element"><res:IDincludedWithDataset/></span>&#x2002;
        	<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="gmd:complianceCode">
        <dt><span class="element"><res:IDcomplianceCode/></span>&#x2002;
        	<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:if test="gmd:language | gmd:includedWithDataset | gmd:complianceCode"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:featureTypes"><!-- NOTE: will match gco:LocalName and gco:ScopedName -->
        <dt><span class="element"><res:IDfeatureTypes/>&#x2003;<xsl:call-template name="SimpleText"/></span></dt>
		<xsl:for-each select="gmd:featureTypes/*/@codeSpace">
			<dl>
				<dd><span class="element"><res:svType_codespace /></span>&#x2003;<xsl:call-template name="SimpleText"/></dd>
			</dl>
		</xsl:for-each>
		<xsl:if test="position() = last()"><br /><br /></xsl:if>
      </xsl:for-each>

     <xsl:apply-templates select="gmd:featureCatalogueCitation/gmd:CI_Citation" mode="iso19139"/>
    </dd>
    </dl>
	<a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- Coverage Description (B.2.8 MD_CoverageDescription - line239) -->
<xsl:template match="gmd:MD_CoverageDescription" mode="iso19139">
	<a>
		<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<hr />
	</a>
    <dt><h2 style="color: #666666;"><res:IDContInfoFeatCovDesc/></h2></dt>
	<dl>
    <dd>
		<xsl:call-template name="MD_CoverageDescription"/>
    </dd>
    </dl>
	<a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- Range dimension Information (B.2.8.1 MD_RangeDimension - line256) -->
<xsl:template match="gmd:dimension" mode="iso19139"> <!-- NOTE: not matching class because there is one subclass -->
    <dd>
    <xsl:choose>
      <xsl:when test="gmd:MD_RangeDimension">
        <dt><span class="element"><res:IDMD_RangeDimension/></span></dt>
      </xsl:when>
      <xsl:when test="gmd:MD_Band">
        <dt><span class="element"><res:IDMD_Band/></span></dt>
      </xsl:when>
			<!-- don't see any way that this could be anything but the two options above -->	
			<!--
      <xsl:otherwise>
        <dt><span class="element">Cell value information</span></dt>
      </xsl:otherwise> -->
    </xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="*/gmd:descriptor">
        <dt><span class="element"><res:IDdescriptor/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="*/gmd:sequenceIdentifier/gco:MemberName">
        <dt><span class="element"><res:IDsequenceIdentifier/></span></dt>
        <xsl:apply-templates select="."  mode="iso19139"/>
      </xsl:for-each>

    <xsl:for-each select="gmd:MD_Band">
      <xsl:for-each select="gmd:maxValue">
        <dt><span class="element"><res:IDLongWavelength/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:minValue">
        <dt><span class="element"><res:IDShortWaveLength/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:peakResponse">
        <dt><span class="element"><res:IDpeakResponse/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:units">
        <dt><span class="element"><res:IDunits/></span></dt>
        <xsl:apply-templates select="gmd:units/gml:UnitDefinition" mode="iso19139"/>
      </xsl:if>
      <xsl:if test="(gmd:maxValue | gmd:minValue | gmd:peakResponse) and not (gmd:units)"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:bitsPerValue">
        <dt><span class="element"><res:IDbitsPerValue/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:toneGradation">
        <dt><span class="element"><res:IDtoneGradation/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:scaleFactor">
        <dt><span class="element"><res:IDscaleFactor/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:offset">
        <dt><span class="element"><res:IDoffset/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:bitsPerValue | gmd:toneGradation | gmd:scaleFactor | gmd:offset"><br /><br /></xsl:if>
    </xsl:for-each>
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- Type Name -->
<!-- TODO: is this in 19115? 
<xsl:template match="TypeName" mode="iso19139">
    <dd>
    <dl>
      <xsl:for-each select="scope">
        <dt><span class="element">Scope</span>&#x2002;<xsl:value-of /></dt>
      </xsl:for-each>
      <xsl:for-each select="aName">
        <dt><span class="element">Name</span>&#x2002;<xsl:value-of select = "." /></dt>
      </xsl:for-each>
    </dl>
    </dd>
    <br />
</xsl:template>-->

<!-- Member Name -->
<xsl:template match="gco:MemberName" mode="iso19139">
    <dd>
    <dl>
      <!-- TODO: is this in 19115? <xsl:for-each select="scope">
        <dt><span class="element">Scope</span>&#x2002;<xsl:value-of /></dt>
      </xsl:for-each>-->
      <xsl:for-each select="gco:aName">
        <dt><span class="element"><res:IDaName/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gco:attributeType/gco:TypeName/gco:aName">
        <dt><span class="element"><res:IDattributeType/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
    </dl>
    </dd>
    <br />
</xsl:template>

<!-- Image Description (B.2.8 MD_ImageDescription - line243) -->
<xsl:template match="gmd:MD_ImageDescription" mode="iso19139">
	<a>
		<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<hr />
	</a>
    <dt><h2 style="color: #666666;"><res:IDContInfoImgDesc/></h2></dt>
	<dl>
    <dd>
      <xsl:call-template name="MD_CoverageDescription"/>

      <xsl:for-each select="gmd:illuminationElevationAngle">
        <dt><span class="element"><res:IDilluminationElevationAngle/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:illuminationAzimuthAngle">
        <dt><span class="element"><res:IDilluminationAzimuthAngle/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:imagingCondition">
        <dt><span class="element"><res:IDimagingCondition/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:cloudCoverPercentage">
        <dt><span class="element"><res:IDcloudCoverPercentage/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:illuminationElevationAngle | gmd:illuminationAzimuthAngle | gmd:imagingCondition | gmd:cloudCoverPercentage"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:imageQualityCode/gmd:MD_Identifier">
        <dt><span class="element"><res:IDimageQualityCode/></span></dt>&#x2002;
        <xsl:apply-templates select="." mode="iso19139"/>
      </xsl:for-each>

      <xsl:for-each select="gmd:processingLevelCode/gmd:MD_Identifier">
        <dt><span class="element"><res:IDprocessingLevelCode/></span>&#x2002;</dt>
        <xsl:apply-templates select="."  mode="iso19139"/>
      </xsl:for-each>

      <xsl:for-each select="gmd:compressionGenerationQuantity">
        <dt><span class="element"><res:IDcompressionGenerationQuantity/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:triangulationIndicator">
        <dt><span class="element"><res:IDtriangulationIndicator/></span>&#x2002;
          <xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="gmd:radiometricCalibrationDataAvailability">
        <dt><span class="element"><res:IDradiometricCalibrationDataAvailability/></span>&#x2002;
					<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="gmd:cameraCalibrationInformationAvailability">
        <dt><span class="element"><res:IDcameraCalibrationInformationAvailability/></span>&#x2002;
					<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="gmd:filmDistortionInformationAvailability">
        <dt><span class="element"><res:IDfilmDistortionInformationAvailability/></span>&#x2002;
					<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="gmd:lensDistortionInformationAvailability">
        <dt><span class="element"><res:IDlensDistortionInformationAvailability/></span>&#x2002;
					<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:if test="gmd:compressionGenerationQuantity | gmd:triangulationIndicator | 
				gmd:radiometricCalibrationDataAvailability | gmd:cameraCalibrationInformationAvailability |  
				gmd:filmDistortionInformationAvailability | gmd:lensDistortionInformationAvailability"><br /><br /></xsl:if>
    </dd>
    </dl>
	<a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>


<!-- REFERENCE SYSTEM -->

<!-- Reference System Information (B.2.7 MD_ReferenceSystem - line186) -->
<xsl:template match="gmd:MD_ReferenceSystem" mode="iso19139"> 
	<xsl:if test="(local-name(./..) = 'referenceSystemInfo')">
	  <a>
		<xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
		<hr />
	  </a>
	</xsl:if>
	<xsl:if test="count (../../gmd:referenceSystemInfo) = 1">
	  <dt><h2 style="color: #666666;"><res:IDRefSysinfo2/></h2></dt>
	</xsl:if>
	<xsl:if test="count (../../gmd:referenceSystemInfo) &gt; 1">
	  <dt><h2 style="color: #666666;"><res:IDRefSysInfoSys/> <xsl:value-of select="position()"/></h2></dt>
	</xsl:if>
	<dl>
	<dd>
		 <xsl:if test="gmd:referenceSystemIdentifier">
			<dt><span class="element"><res:IDreferenceSystemIdentifier/></span></dt>
			<xsl:apply-templates select="gmd:referenceSystemIdentifier/gmd:RS_Identifier" mode="iso19139"/>
		</xsl:if>
		<!-- no support for RS_ReferenceSystem information -->
	</dd>
	</dl>
	<xsl:if test="(local-name(./..) = 'referenceSystemInfo')">
		<a class="top" href="#Top"><res:IDBackToTop/></a>
	</xsl:if>
</xsl:template>

<!-- DATA QUALITY -->

<!-- Data Quality Information  (B.2.4 DQ_DataQuality - line78) -->
<xsl:template match="gmd:DQ_DataQuality" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
  <xsl:if test="count (../../gmd:dataQualityInfo) = 1">
  	<dt><h2 style="color: #666666;"><res:IDDataQualInfo2/></h2></dt>
  </xsl:if>
  <xsl:if test="count (../../gmd:dataQualityInfo) &gt; 1">
	<dt><h2 style="color: #666666;"><res:IDDataQualDesc/> <xsl:value-of select="position()"/></h2></dt>
  </xsl:if>
  <dl>
  <dd>
    <xsl:apply-templates select="gmd:scope/gmd:DQ_Scope" mode="iso19139"/>

    <xsl:apply-templates select="gmd:lineage/gmd:LI_Lineage" mode="iso19139"/>

    <xsl:for-each select="gmd:report/*"> <!-- NOTE: will select sub-classes -->
      <xsl:apply-templates select="." mode="iso19139"/>
    </xsl:for-each>
  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- Scope Information (B.2.4.4 DQ_Scope - line138) -->
<xsl:template match="gmd:DQ_Scope" mode="iso19139">
    <dd>
    <dt><span class="element"><res:IDScopeQuality/></span></dt>
    <dd>
    <dl>
		<xsl:for-each select="gmd:level">
		  <dt><span class="element"><res:IDlevel/></span>&#x2002;<xsl:call-template name="AnyCode" /></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:levelDescription">
			<xsl:if test="position() = 1">
				<dt><span class="element"><res:idLevelDescription/></span></dt>
			</xsl:if>
			<dl>
			<dd>
			  <xsl:apply-templates select="gmd:MD_ScopeDescription" mode="iso19139"/>
			</dd>
			</dl>
			<xsl:if test="count (following-sibling::*) = 0"><br /></xsl:if>
		</xsl:for-each>
      <xsl:if test="(gmd:level) and not (gmd:levelDescription)"><br /><br /></xsl:if>

      <xsl:apply-templates select="gmd:extent/gmd:EX_Extent" mode="iso19139"/> <!-- TODO: make sure there's a global template for this -->
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- Lineage Information (B.2.4.1 LI_Lineage - line82) -->
<xsl:template match="gmd:LI_Lineage" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDLI_Lineage/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="gmd:statement">
      <dt><span class="element"><res:IDstatement/></span></dt>
      <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
    </xsl:for-each>

    <xsl:apply-templates select="gmd:processStep/gmd:LI_ProcessStep" mode="iso19139"/>

    <xsl:apply-templates select="gmd:source/gmd:LI_Source" mode="iso19139"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Process Step Information (B.2.4.1.1 LI_ProcessStep - line86) -->
<xsl:template match="gmd:LI_ProcessStep" mode="iso19139"> <!-- NOTE: was match="(prcStep | srcStep)"> -->
  <dd>
  <dt><span class="element"><res:IDLI_ProcessStep/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="gmd:dateTime">
      <dt><span class="element"><res:IDdateTime/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:description">
      <dt><span class="element"><res:IDdescription/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:rationale">
      <dt><span class="element"><res:IDRationale/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:dateTime | gmd:description |gmd:rationale"><br /><br /></xsl:if>

    <xsl:apply-templates select="gmd:processor/gmd:CI_ResponsibleParty" mode="iso19139"/>

		<!-- TODO: review this -->
    <xsl:if test="not (../gmd:sourceStep)">
      <xsl:apply-templates select="gmd:source/gmd:LI_Source" mode="iso19139"/>
    </xsl:if>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Source Information (B.2.4.1.2 LI_Source - line92) -->
<xsl:template match="gmd:LI_Source" mode="iso19139"> <!-- TODO: make sure there are callers of this template -->
  <dd>
  <dt><span class="element"><res:IDLI_Source/></span></dt>
  <dd>
  <dl>
      <xsl:for-each select="gmd:description">
        <dt><span class="element"><res:IDLI_SourceData/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
        <br /><br />
      </xsl:for-each>
      
      <xsl:apply-templates select="gmd:scaleDenominator/gmd:MD_RepresentativeFraction" mode="iso19139"/>
      
      <xsl:apply-templates select="gmd:sourceCitation/gmd:CI_Citation" mode="iso19139"/>
      
      <xsl:for-each select="gmd:sourceReferenceSystem">
        <dt><span class="element"><res:IDsourceReferenceSystem/></span></dt>
	    <xsl:apply-templates select="gmd:MD_ReferenceSystem" mode="iso19139"/>
      </xsl:for-each>
      
      <xsl:apply-templates select="gmd:sourceExtent/gmd:EX_Extent" mode="iso19139"/>

			<!-- TODO: review this -->
      <xsl:if test="not (../gmd:source)">
        <xsl:apply-templates select="gmd:sourceStep" mode="iso19139"/>
      </xsl:if>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Data Quality Element Information (B.2.4.2 DQ_Element - line99) -->
<xsl:template match="gmd:DQ_CompletenessOmission | gmd:DQ_CompletenessCommission | gmd:DQ_TopologicalConsistency | gmd:DQ_FormatConsistency | gmd:DQ_DomainConsistency | gmd:DQ_ConceptualConsistency | gmd:DQ_RelativeInternalPositionalAccuracy | gmd:DQ_GriddedDataPositionalAccuracy | gmd:DQ_AbsoluteExternalPositionalAccuracy | gmd:DQ_QuantitativeAttributeAccuracy | gmd:DQ_NonQuantitativeAttributeAccuracy | gmd:DQ_ThematicClassificationCorrectness | gmd:DQ_TemporalValidity | gmd:DQ_TemporalConsistency | gmd:DQ_AccuracyOfATimeMeasurement" mode="iso19139">
  <dd>
  <xsl:choose>
		<!-- NOTE: this is abstract
    <xsl:when test="../DQComplete">
        <dt><span class="element">Data quality report - Completeness</span></dt>
    </xsl:when>-->
    <xsl:when test="local-name(.) = 'DQ_CompletenessCommission'">
        <dt><span class="element"><res:IDDQ_CompletenessCommission/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_CompletenessOmission'">
        <dt><span class="element"><res:IDDQ_CompletenessOmission/></span></dt>
    </xsl:when>
		<!-- NOTE: this is abstract
    <xsl:when test="../DQLogConsis">
        <dt><span class="element">Data quality report - Logical consistency</span></dt>
    </xsl:when>-->
    <xsl:when test="local-name(.) = 'DQ_ConceptualConsistency'">
        <dt><span class="element"><res:IDDQ_ConceptualConsistency/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_DomainConsistency'">
        <dt><span class="element"><res:IDDQ_DomainConsistency/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_FormatConsistency'">
        <dt><span class="element"><res:IDDQ_FormatConsistency/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_TopologicalConsistency'">
        <dt><span class="element"><res:IDDQ_TopologicalConsistency/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_AbsoluteExternalPositionalAccuracy'">
        <dt><span class="element"><res:IDDQ_AbsoluteExternalPositionalAccuracy/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_GriddedDataPositionalAccuracy'">
        <dt><span class="element"><res:IDDQ_GriddedDataPositionalAccuracy/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_RelativeInternalPositionalAccuracy'">
        <dt><span class="element"><res:IDDQ_RelativeInternalPositionalAccuracy/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_AccuracyOfATimeMeasurement'">
        <dt><span class="element"><res:IDDQ_AccuracyOfATimeMeasurement/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_TemporalConsistency'">
        <dt><span class="element"><res:DQTempConsis/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_TemporalValidity'">
        <dt><span class="element"><res:DQTempValid/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_ThematicClassificationCorrectness'">
        <dt><span class="element"><res:IDDQ_ThematicClassificationCorrectness/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_NonQuantitativeAttributeAccuracy'">
        <dt><span class="element"><res:IDDQ_NonQuantitativeAttributeAccuracy/></span></dt>
    </xsl:when>
    <xsl:when test="local-name(.) = 'DQ_QuantitativeAttributeAccuracy'">
        <dt><span class="element"><res:IDDQ_QuantitativeAttributeAccuracy/></span></dt>
    </xsl:when>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="gmd:nameOfMeasure">
      <dt><span class="element"><res:IDnameOfMeasure/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:evaluationMethodType">
      <dt><span class="element"><res:IDevaluationMethodType/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:dateTime">
      <dt><span class="element"><res:IDdateTime2/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:nameOfMeasure | gmd:evaluationMethodType | gmd:dateTime"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:measureDescription">
      <dt><span class="element"><res:IDmeasureDescription/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      <br /><br />
    </xsl:for-each>

    <xsl:for-each select="gmd:evaluationMethodDescription">
      <dt><span class="element"><res:IDevaluationMethodDescription/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      <br /><br />
    </xsl:for-each>

    <xsl:for-each select="gmd:measureIdentification/gmd:MD_Identifier">
      <dt><span class="element"><res:IDmeasureIdentification/></span></dt>
      <xsl:apply-templates select="." mode="iso19139"/>
    </xsl:for-each>

    <xsl:apply-templates select="gmd:evaluationProcedure/gmd:CI_Citation" mode="iso19139"/>

    <xsl:for-each select="gmd:result">
		<!-- NOTE: this will select the sub-classes: DQ_ConformanceResult, DQ_QuantitativeResult -->
        <xsl:apply-templates select="*" mode="iso19139"/>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Conformance Result Information (B.2.4.3 DQ_ConformanceResult - line129) -->
<xsl:template match="gmd:DQ_ConformanceResult" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDDQ_ConformanceResult/></span>&#x2002;</dt>
  <dd>
  <dl>
    <xsl:for-each select="gmd:pass">
      <dt><span class="element"><res:IDpass/></span>&#x2002;
      	<xsl:call-template name="Boolean"/>
      </dt>      
    </xsl:for-each>
    <xsl:for-each select="gmd:explanation">
      <dt><span class="element"><res:IDexplanation/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:pass | gmd:explanation"><br /><br /></xsl:if>

    <xsl:apply-templates select="gmd:specification/gmd:CI_Citation" mode="iso19139"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Quantitative Result Information (B.2.4.3 DQ_QuantitativeResult - line133) -->
<xsl:template match="gmd:DQ_QuantitativeResult" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDDQ_QuantitativeResult/></span></dt>
  <dd>
  <dl>
    <xsl:if test="gmd:value">
      <xsl:for-each select="gmd:value">
        <dt><span class="element"><res:IDResvalue/></span>&#x2002;<xsl:call-template name="Record"/></dt>
      </xsl:for-each>
      <br /><br />
    </xsl:if>
    <xsl:for-each select="gmd:valueType">
      <dt><span class="element"><res:IDvalueType/></span>&#x2002;<xsl:call-template name="RecordType"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:valueUnit">
      <dt><span class="element"><res:IDvalueUnit/></span></dt>
      <dd>
      <dl>
			<xsl:choose>
				<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="gml:UnitDefinition" mode="iso19139"/>
				</xsl:otherwise>
			</xsl:choose>

          <xsl:if test="count (following-sibling::*) = 0"><br /><br /></xsl:if>
      </dl>
      </dd>
    </xsl:for-each>
    <xsl:if test="(gmd:valueType) and not (gmd:valueUnit)"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:errorStatistic">
      <dt><span class="element"><res:IDerrorStatistic/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      <br /><br />
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- DISTRIBUTION INFORMATION -->

<!-- Distribution Information (B.2.10 MD_Distribution - line270) -->
<xsl:template match="gmd:MD_Distribution" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
	<xsl:if test="count (../../gmd:distributionInfo) = 1">
		<dt><h2 style="color: #666666;"><res:idMD_Distribution /></h2></dt>
    </xsl:if>
    <xsl:if test="count (../../gmd:distributionInfo) &gt; 1">
      <dt><h2 style="color: #666666;">
        <res:idMD_DistributionMany /> <xsl:value-of select="position()"/>
      </h2></dt>
    </xsl:if>
  <dl>
  <dd>
      <xsl:apply-templates select="gmd:distributor/gmd:MD_Distributor" mode="iso19139"/>

      <xsl:apply-templates select="gmd:distributionFormat/gmd:MD_Format" mode="iso19139"/>

      <xsl:apply-templates select="gmd:transferOptions/gmd:MD_DigitalTransferOptions[.//*/text()]" mode="iso19139"/>
  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>


<!-- Distributor Information (B.2.10.2 MD_Distributor - line279) -->
<xsl:template match="gmd:MD_Distributor" mode="iso19139"> <!-- NOTE: was (distributor | formatDist)"> -->
  <dd>
  <dt><span class="element"><res:IDMD_Distributor/></span></dt>
  <dd>
  <dl>
    <xsl:apply-templates select="gmd:distributorContact/gmd:CI_ResponsibleParty" mode="iso19139"/>
    <!-- NOTE: removed tests for recursion <xsl:if test="context()[not ((../../dsFormat) or (../../distorFormat) or (../../distFormat))]">
      <xsl:apply-templates select="gmd:distributorFormat/gmd:MD_Format" mode="iso19139"/> 
    </xsl:if>-->
		<xsl:apply-templates select="gmd:distributorFormat/gmd:MD_Format" mode="iso19139"/>
		
    <xsl:apply-templates select="gmd:distributionOrderProcess/gmd:MD_StandardOrderProcess" mode="iso19139"/>

    <xsl:apply-templates select="gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions[.//*/text()]" mode="iso19139"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Format Information (B.2.10.3 MD_Format - line284) -->
<xsl:template match="gmd:MD_Format" mode="iso19139">
  <dd>
  <xsl:choose>
    <xsl:when test="../gmd:resourceFormat">
        <dt><span class="element"><res:IDresourceFormat/></span></dt>
    </xsl:when>
		<!-- TODO: is there an "available format"? -->
    <xsl:when test="../gmd:distributorFormat">
        <dt><span class="element"><res:IDdistributorFormat/></span></dt>
    </xsl:when>
    <xsl:otherwise>
        <dt><span class="element"><res:IDFormat/></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="gmd:name">
      <dt><span class="element"><res:IDFormatname/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:version">
      <dt><span class="element"><res:IDFormatversion/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:amendmentNumber">
      <dt><span class="element"><res:IDamendmentNumber/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:specification">
      <dt><span class="element"><res:IDspecification/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:fileDecompressionTechnique">
      <dt><span class="element"><res:IDfileDecompressionTechnique/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:name | gmd:version | gmd:amendmentNumber | gmd:specification | gmd:fileDecompressionTechnique"><br /><br /></xsl:if>

    <!-- NOTE: removed <xsl:if test="context()[not ((../../distributor) or (../../formatDist))]">
      <xsl:apply-templates select="formatDist" mode="iso19139"/>
    </xsl:if>-->
		<xsl:apply-templates select="gmd:formatDistributor/gmd:MD_Distributor" mode="iso19139"/>
		
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Standard Order Process Information (B.2.10.5 MD_StandardOrderProcess - line298) -->
<xsl:template match="gmd:MD_StandardOrderProcess" mode="iso19139">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(./..) = 'distributionOrderProcess')">
        <dt><span class="element"><res:IDMD_StandardOrderProcess/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'accessProperties')">
        <dt><span class="element"><res:idServiceAccessProperties/></span></dt>
    </xsl:when>
  </xsl:choose>
  <dd>
  <dl>
    <xsl:for-each select="gmd:fees">
      <dt><span class="element"><res:IDfees/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:plannedAvailableDateTime">
      <dt><span class="element"><res:IDplannedAvailableDateTime/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:orderingInstructions">
      <dt><span class="element"><res:IDorderingInstructions/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:turnaround">
      <dt><span class="element"><res:IDturnaround/></span></dt>
      <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>

<!-- Digital Transfer Options Information (B.2.10.1 MD_DigitalTransferOptions - line274) -->
<xsl:template match="gmd:MD_DigitalTransferOptions" mode="iso19139"> <!-- NOTE: was (distorTran | distTranOps)"> -->
  <dd>
  <dt><span class="element"><res:IDMD_DigitalTransferOptions/></span></dt>

  <dd>
  <dl>
    <xsl:for-each select="gmd:transferSize">
      <dt><span class="element"><res:IDtransferSize/></span>&#x2002;<xsl:call-template name="Real"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:unitsOfDistribution">
      <dt><span class="element"><res:IDunitsOfDistribution/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:transferSize | gmd:unitsOfDistribution"><br /><br /></xsl:if>

    <xsl:apply-templates select="gmd:onLine/gmd:CI_OnlineResource" mode="iso19139"/>

    <xsl:apply-templates select="gmd:offLine/gmd:MD_Medium" mode="iso19139"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Medium Information (B.2.10.4 MD_Medium - line291) -->
<xsl:template match="gmd:MD_Medium" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDMD_Medium/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="gmd:name">
      <dt><span class="element"><res:IDname/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:volumes">
      <dt><span class="element"><res:IDvolumes/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:name | gmd:volumes"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:mediumFormat">
      <dt><span class="element"><res:IDmediumFormat/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:density">
      <dt><span class="element"><res:IDdensity/></span>&#x2002;<xsl:call-template name="Real"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:densityUnits">
      <dt><span class="element"><res:IDdensityUnits/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:mediumFormat | gmd:density | gmd:densityUnits"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:mediumNote">
      <dt><span class="element"><res:IDmediumNote/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      <xsl:if test="count (following-sibling::*) = 0"><br /><br /></xsl:if>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Portrayal Catalogue Reference (B.2.9 MD_PortrayalCatalogueReference - line268) -->
<xsl:template match="gmd:MD_PortrayalCatalogueReference" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
	<!-- removed 
  <xsl:if test="(this.selectNodes('/metadata/porCatInfo').length == 1)">
      <dt><font color="#0000AA" size="3"><span class="element">Portrayal Catalogue Reference</span></font></dt>
  </xsl:if>
  <xsl:if test="(this.selectNodes('/metadata/porCatInfo').length > 1)">
      <dt><font color="#0000AA" size="3"><span class="element">
        Portrayal Catalogue Reference - Catalogue <xsl:value-of select="position()"/>:
      </span></font></dt>
  </xsl:if>-->
	<dt><h2 style="color: #666666;"><res:IDPortCatRef/></h2></dt>
  <dl>
  <dd>
    <xsl:apply-templates select="gmd:portrayalCatalogueCitation/gmd:CI_Citation" mode="iso19139"/>
  </dd>
  </dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- APPLICATION SCHEMA -->

<!-- Application schema Information (B.2.12 MD_ApplicationSchemaInformation - line320) -->
<xsl:template match="gmd:MD_ApplicationSchemaInformation" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
  <xsl:if test="count (../../*[gmd:MD_ApplicationSchemaInformation]) =  1">
      <dt><h2 style="color: #666666;"><res:IDAppSchInfo2/></h2></dt>
  </xsl:if>
  <xsl:if test="count (../../*[gmd:MD_ApplicationSchemaInformation]) &gt; 1">
      <dt><h2 style="color: #666666;"><res:IDAppSchInfoSchema/>
				<xsl:for-each select="..">
					<xsl:value-of select="position()"/>
				</xsl:for-each></h2>
			</dt>
  </xsl:if>
	<dl>
	<dd>
	<xsl:apply-templates select="gmd:name/gmd:CI_Citation" mode="iso19139"/>

	<xsl:for-each select="gmd:schemaLanguage">
		<dt><span class="element"><res:IDschemaLanguage/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
	</xsl:for-each>
	<xsl:for-each select="gmd:constraintLanguage">
		<dt><span class="element"><res:IDconstraintLanguage/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
	</xsl:for-each>
	<xsl:if test="gmd:schemaLanguage | gmd:constraintLanguage"><br /><br /></xsl:if>

	<xsl:for-each select="gmd:schemaAscii">
		<dt><span class="element"><res:IDschemaAscii/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		<br /><br />
	</xsl:for-each>
	<xsl:for-each select="gmd:graphicsFile">
		<dt><span class="element"><res:IDgraphicsFile/></span></dt>
		<xsl:call-template name="Binary"/>
	</xsl:for-each>
	<xsl:for-each select="gmd:softwareDevelopmentFile">
		<dt><span class="element"><res:IDsoftwareDevelopmentFile/></span></dt>
		<xsl:call-template name="Binary"/>
	</xsl:for-each>
	<xsl:for-each select="gmd:softwareDevelopmentFileFormat">
		<dt><span class="element"><res:IDsoftwareDevelopmentFileFormat/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		<br /><br />
	</xsl:for-each>
	</dd>
	</dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- Spatial Attribute Supplement Information (B.2.12.2 MD_SpatialAttributeSupplement - line332) -->
<!-- NOTE: not in ISO 19139 schemas
<xsl:template match="featCatSup" mode="iso19139">
  <dd>
    <dt><span class="element">Feature catalogue supplement</span></dt>
    <dd>
    <dl>
      <xsl:apply-templates select="featTypeList" mode="iso19139"/>
    </dl>
    </dd>
  </dd>
</xsl:template>-->

<!-- Feature Type List Information (B.2.12.1 MD_FeatureTypeList - line329 -->
<!-- NOTE: not in ISO 19139 schemas
<xsl:template match="featTypeList" mode="iso19139">
  <dd>
    <dt><span class="element">Feature type list</span></dt>
    <dd>
    <dl>
      <xsl:for-each select="spatObj">
        <dt><span class="element">Spatial object</span>&#x2002;<xsl:value-of select = "." /></dt>
      </xsl:for-each>
      <xsl:for-each select="spatSchName">
        <dt><span class="element">Spatial schema name</span>&#x2002;<xsl:value-of select = "." /></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>-->

<!-- METADATA EXTENSIONS -->

<!-- Metadata Extension Information (B.2.11 MD_MetadataExtensionInformation - line303) -->
<xsl:template match="gmd:MD_MetadataExtensionInformation" mode="iso19139">
  <a>
    <xsl:attribute name="name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
    <hr />
  </a>
	<dt><h2 style="color: #666666;"><res:IDMetadataExtInfo/></h2></dt>
	<dl>
	<dd>
		<xsl:apply-templates select="gmd:extensionOnLineResource/gmd:CI_OnlineResource" mode="iso19139"/>
		
		<xsl:apply-templates select="gmd:extendedElementInformation/gmd:MD_ExtendedElementInformation" mode="iso19139"/>
	</dd>
	</dl>
  <a class="top" href="#Top"><res:IDBackToTop/></a>
</xsl:template>

<!-- Extended Element Information (B.2.11.1 MD_ExtendedElementInformation - line306) -->
<xsl:template match="gmd:MD_ExtendedElementInformation" mode="iso19139">
    <dd>
    <dt><span class="element"><res:IDMD_ExtendedElementInformation/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:name">
        <dt><span class="element"><res:IDElementname/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:shortName">
        <dt><span class="element"><res:IDshortName/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:domainCode">
        <dt><span class="element"><res:IDdomainCode/></span>&#x2002;<xsl:call-template name="Integer"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:definition">
        <dt><span class="element"><res:IDdefinition/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:name | gmd:shortName | gmd:domainCode | gmd:definition"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:obligation">
        <dt><span class="element"><res:IDObligation/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:condition">
        <dt><span class="element"><res:IDcondition/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:maximumOccurrence">
        <dt><span class="element"><res:IDmaximumOccurrence/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:dataType">
        <dt><span class="element"><res:IDdataType/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:domainValue">
        <dt><span class="element"><res:IDdomainValue/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:obligation | gmd:condition | gmd:maximumOccurrence | gmd:dataType | gmd:domainValue"><br /><br /></xsl:if>

      <xsl:for-each select="gmd:parentEntity">
        <dt><span class="element"><res:IDparentEntity/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:rule">
        <dt><span class="element"><res:IDrule/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:rationale">
        <dt><span class="element"><res:IDrationale2/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:if test="gmd:parentEntity | gmd:rule | gmd:rationale"><br /><br /></xsl:if>

      <xsl:apply-templates select="gmd:source/gmd:CI_ResponsibleParty" mode="iso19139"/>
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- TEMPLATES FOR DATA TYPE CLASSES -->

<!-- CITATION AND CONTACT INFORMATION -->

<!-- Citation Information (B.3.2 CI_Citation - line359) -->
<xsl:template match="gmd:CI_Citation" mode="iso19139">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(./..) = 'citation')">
      <dt><span class="element"><res:IDcitation2/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'thesaurusName')">
      <dt><span class="element"><res:IDthesaurusName/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'authority')"> 
      <dt><span class="element"><res:IDauthority/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'sourceCitation')">
      <dt><span class="element"><res:IDsourceCitation/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'evaluationProcedure')">
      <dt><span class="element"><res:IDevaluationProcedure/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'specification')">
      <dt><span class="element"><res:IDspecification2/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'parameterCitation')">
      <dt><span class="element"><res:IDparameterCitation/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'portrayalCatalogueCitation')">
      <dt><span class="element"><res:IDportrayalCatalogueCitation/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'featureCatalogueCitation')">
      <dt><span class="element"><res:IDfeatureCatalogueCitation/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'name')">
      <dt><span class="element"><res:IDAppSchname/></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(./..) = 'aggregateDataSetName')">
      <dt><span class="element"><res:idAggregateInfo/></span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="element"><res:IDCitation3/></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="gmd:title">
      <dt><span class="element"><res:IDTitle/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:alternateTitle">
	    <dt><span class="element"><res:IDalternateTitle/></span>&#x2002;
	      <xsl:for-each select="gmd:alternateTitle">
	       	<xsl:call-template name="CharacterString"/><xsl:if test="not(position()=last())">, </xsl:if>
	      </xsl:for-each>
	    </dt>
    </xsl:if>
    <xsl:if test="gmd:title | gmd:alternateTitle"><br /></xsl:if>
    <xsl:if test="gmd:title[not(gmd:PT_FreeText)] | gmd:alternateTitle"><br /></xsl:if>

    <xsl:apply-templates select="gmd:date/gmd:CI_Date" mode="iso19139"/>

    <xsl:for-each select="gmd:edition">
      <dt><span class="element"><res:IDEdition/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:editionDate">
      <dt><span class="element"><res:IDeditionDate/></span>&#x2002;<xsl:call-template name="Date_PropertyType"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:presentationForm">
      <dt><span class="element"><res:IDpresentationForm/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:if test="gmd:edition | gmd:editionDate | gmd:presentationForm"><br /><br /></xsl:if>
    
    <xsl:for-each select="gmd:collectiveTitle">
      <dt><span class="element"><res:IDcollectiveTitle/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:apply-templates select="gmd:series/gmd:CI_Series" mode="iso19139"/>
    <xsl:if test="gmd:collectiveTitle or gmd:series"><br /></xsl:if>
    <xsl:if test="gmd:collectiveTitle and not(gmd:series)"><br /></xsl:if>

    <xsl:for-each select="gmd:ISBN">
      <dt><span class="element"><res:IDISBN/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:ISSN">
      <dt><span class="element"><res:IDISSN/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:identifier/gmd:MD_Identifier">
      <dt><span class="element"><res:IDidentifier/></span></dt>&#x2002;
      <xsl:apply-templates select="." mode="iso19139"/>
    </xsl:for-each>

    <xsl:if test="gmd:ISBN | gmd:ISSN | gmd:identifier"><br /><br /></xsl:if>

    <xsl:for-each select="gmd:otherCitationDetails">
      <dt><span class="element"><res:IDotherCitationDetails/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      <br /><br />
    </xsl:for-each>
    
    <xsl:apply-templates select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty" mode="iso19139"/>

    <!-- NOTE: removed <xsl:if test="context()[not (text()) and not(*)]"><br /></xsl:if>-->
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Date Information (B.3.2.3 CI_Date) -->
<xsl:template match="gmd:CI_Date" mode="iso19139">
  <dd>
    <dt><span class="element">
	   <xsl:choose>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='001') or (@codeListValue='creation')]"><res:idCreationDate/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='002') or (@codeListValue='publication')]"><res:idPublicationDate2/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='003') or (@codeListValue='revision')]"><res:idRevisionDate/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='004') or (@codeListValue='notAvailable')]"><res:idNotAvailableDate/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='005') or (@codeListValue='inForce')]"><res:idInForceDate/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='006') or (@codeListValue='adopted')]"><res:idAdoptedDate/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='007') or (@codeListValue='deprecated')]"><res:idDeprecatedDate/></xsl:when>
		 <xsl:when test="gmd:dateType/gmd:CI_DateTypeCode[(@codeListValue='008') or (@codeListValue='superseded')]"><res:idSupersededDate/></xsl:when>
		 <xsl:otherwise>
			<res:IDDate/>&#160;<xsl:value-of select="@codeListValue"/>
		 </xsl:otherwise>
	   </xsl:choose></span>&#x2002;
	  <xsl:for-each select="gmd:date">
		<xsl:call-template name="Date_PropertyType"/>
	  </xsl:for-each>
    </dt>
  </dd>
  <xsl:if test="position()=last()"><br /><br /></xsl:if>
</xsl:template>

<!-- Responsible Party Information (B.3.2 CI_ResponsibleParty - line374) -->
<xsl:template match="gmd:CI_ResponsibleParty" mode="iso19139"> <!-- TODO: (gmd:contact | gmd:pointOfContact | gmd:userContactInfo | stepProc | distorCont | 
      citRespParty | extEleSrc)"> -->
  <dd>
  <dt><span class="element">
  <xsl:choose>
    <xsl:when test="../../gmd:contact">
      <res:IDMetadataContact/>
    </xsl:when>
    <xsl:when test="../../gmd:pointOfContact"> 
      <res:IDPtOfCnt/>
    </xsl:when>
    <xsl:when test="../../gmd:userContactInfo"> 
      <res:IDPartyUsRes/>
    </xsl:when>
    <xsl:when test="../../gmd:processor">
      <res:IDPrcCnt/>
    </xsl:when>
    <xsl:when test="../../gmd:distributorContact">
      <res:IDDistInfo2/>
    </xsl:when>
    <xsl:when test="../../gmd:citedResponsibleParty">
      <res:IDResParty/>
    </xsl:when>
    <!-- gmd:source?? -->
    <xsl:when test="../gmd:source">
      <res:IDExtSrc/>
    </xsl:when>
    <xsl:otherwise>
      <res:IDContact/>
    </xsl:otherwise>
  </xsl:choose> - 
  <xsl:for-each select="gmd:role">
	  <xsl:call-template name="AnyCode"/>
  </xsl:for-each></span>
  </dt>
  <dd>
  <dl>
		<xsl:for-each select="gmd:individualName">
			<dt><span class="element"><res:IDindividualName/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:organisationName">
			<dt><span class="element"><res:IDorganisationName/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmd:positionName">
			<dt><span class="element"><res:IDpositionName/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
		</xsl:for-each>
		<xsl:if test="gmd:individualName | gmd:organisationName | gmd:positionName"><br /><br /></xsl:if>

		<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact" mode="iso19139"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Contact Information (B.3.2.2 CI_Contact - line387) -->
<xsl:template match="gmd:CI_Contact" mode="iso19139">
  <dd>
    <dt><span class="element"><res:IDCI_Contact/></span></dt>
    <dd>
    <dl>
      <xsl:apply-templates select="gmd:phone/gmd:CI_Telephone" mode="iso19139"/>

      <xsl:apply-templates select="gmd:address/gmd:CI_Address" mode="iso19139"/>

      <xsl:apply-templates select="gmd:onlineResource/gmd:CI_OnlineResource" mode="iso19139"/>

      <xsl:for-each select="gmd:hoursOfService">
        <dt><span class="element"><res:IDhoursOfService/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:contactInstructions">
        <dt><span class="element"><res:IDcontactInstructions/></span></dt>
        <dl><dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd></dl>
      </xsl:for-each>
      <xsl:if test="gmd:hoursOfService and not(gmd:contactInstructions)"><br /><br /></xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Telephone Information (B.3.2.6 CI_Telephone - line407) -->
<xsl:template match="gmd:CI_Telephone" mode="iso19139">
  <dd>
    <dt><span class="element"><res:IDCI_Telephone/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:voice">
        <dt><span class="element"><res:IDVoice/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:facsimile">
        <dt><span class="element"><res:IDFax/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Address Information (B.3.2.1 CI_Address - line380) -->
<xsl:template match="gmd:CI_Address" mode="iso19139">
  <dd>
    <dt><span class="element"><res:IDCI_Address/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:deliveryPoint">
        <dt><span class="element"><res:IDdeliveryPoint/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:city">
        <dt><span class="element"><res:IDCity/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:administrativeArea">
        <dt><span class="element"><res:IDadministrativeArea/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:postalCode">
        <dt><span class="element"><res:IDpostalCode/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:country">
        <dt><span class="element"><res:IDCountry/></span>&#x2002;<span class="textOld"><xsl:apply-templates select="."  mode="arcgis"/></span></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:electronicMailAddress">
        <dt><span class="element"><res:IDelectronicMailAddress/></span>&#x2002;<a><xsl:attribute name="href">mailto:<xsl:value-of select="."/>?subject=<xsl:value-of select="/gmd:MD_Metadata/identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/></xsl:attribute><xsl:value-of select="."/></a></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- country code list from ISO 3166 -->
<xsl:template match="gmd:country" mode="arcgis">
	<xsl:choose>
		<xsl:when test="gco:CharacterString">
			<xsl:call-template name="ISO3166_CountryCode">
				<xsl:with-param name="code" select="gco:CharacterString" />
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="gmd:Country">
			<xsl:call-template name="ISO3166_CountryCode">
				<xsl:with-param name="code" select="gmd:Country/@codeListValue" />
			</xsl:call-template>
		</xsl:when>
        <xsl:when test="not(gco:CharacterString) and not(gmd:Country) and (@gco:nilReason)"><xsl:call-template name="nilReason"/></xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Online Resource Information (B.3.2.4 CI_OnlineResource - line396) -->
<xsl:template match="gmd:CI_OnlineResource" mode="iso19139">
  <dd>
	<dt><span class="element"><res:IDCI_OnlineResource/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="gmd:name">
      <dt><span class="element"><res:IDname2/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:linkage/gmd:URL">
      <dt><span class="element"><res:IDlinkage/></span>&#x2002;<xsl:call-template name="urlType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:protocol">
      <dt><span class="element"><res:IDprotocol/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:function">
      <dt><span class="element"><res:IDfunction/></span>&#x2002;<xsl:call-template name="AnyCode"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:description">
      <dt><span class="element"><res:IDDescription2/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
    <xsl:for-each select="gmd:applicationProfile">
      <dt><span class="element"><res:IDapplicationProfile/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>

<!-- Series Information (B.3.2.5 CI_Series - line403) -->
<xsl:template match="gmd:CI_Series" mode="iso19139">
  <dd>
    <dt><span class="element"><res:IDSeries/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:name">
        <dt><span class="element"><res:IDName3/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:issueIdentification">
        <dt><span class="element"><res:IDIssue/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:page">
        <dt><span class="element"><res:IDPage/></span>&#x2003;<xsl:call-template name="CharacterString"/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>
	
<!-- EXTENT INFORMATION -->

<!-- Extent Information (B.3.1 EX_Extent - line334) -->
<xsl:template match="gmd:EX_Extent" mode="iso19139"><!-- NOTE: was (dataExt | scpExt | srcExt)">-->
  <dd>
	<!-- TODO: show more descriptive text
  <xsl:choose>
    <xsl:when test="../dataExt">
      <dt><span class="element">Other extent information</span></dt>
    </xsl:when>
    <xsl:when test="../scpExt">
      <dt><span class="element">Scope extent</span></dt>
    </xsl:when>
    <xsl:when test="../srcExt">
      <dt><span class="element">Extent of the source data</span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="element">Extent</span></dt>
    </xsl:otherwise>
  </xsl:choose>-->
	<dt><span class="element"><res:IDExtent/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:description">
        <dt><span class="element"><res:IDExtdescription/></span></dt>
        <dd><pre class="wrap"><xsl:call-template name="CharacterString"/></pre></dd>
      </xsl:for-each>

      <xsl:for-each select="gmd:geographicElement">
        <dt><span class="element"><res:IDGeogExtent/></span></dt>
        <dd>
          <dd>
          <dl>
				<xsl:apply-templates select="*" mode="iso19139"/>
          </dl>
          </dd>
        </dd>
<!--        <xsl:if test="not (following-sibling::*)"><br /></xsl:if> -->
      </xsl:for-each>

      <xsl:for-each select="gmd:temporalElement">
			<xsl:apply-templates select="*" mode="iso19139"/>
      </xsl:for-each>

      <xsl:apply-templates select="gmd:verticalElement/gmd:EX_VerticalExtent" mode="iso19139"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Bounding Polygon Information (B.3.1.1 EX_BoundingPolygon - line341) -->
<xsl:template match="gmd:EX_BoundingPolygon" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDEX_BoundingPolygon/></span></dt>
    <dd>
    <dl>
		<xsl:for-each select="gmd:extentTypeCode">
			<dt><span class="element"><res:IDextentTypeCode/></span>&#x2002;
				<xsl:call-template name="Boolean"/>
			</dt>      
		</xsl:for-each>
		<xsl:for-each select="gmd:polygon/gml:Polygon">
			<dt><span class="element"><res:polygon/></span></dt>
			<dl>
			<dd>
				<xsl:for-each select="gml:exterior/gml:LinearRing">
					<dt><span class="element"><res:exterior/></span></dt>      
					<dl>
					<dd>
						<xsl:for-each select="gml:pos">
							<dt><span class="element"><res:gmlPos/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>      
						</xsl:for-each>
					</dd>
					</dl>
				</xsl:for-each>
				<xsl:for-each select="gml:interior/gml:LinearRing">
					<dt><span class="element"><res:interior/></span></dt>      
					<dl>
					<dd>
						<xsl:for-each select="gml:pos">
							<dt><span class="element"><res:gmlPos/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>      
						</xsl:for-each>
					</dd>
					</dl>
				</xsl:for-each>
			</dd>
			</dl>
		</xsl:for-each>
		<br />
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Bounding Box Information (B.3.1.1 EX_GeographicBoundingBox - line343) -->
<xsl:template match="gmd:EX_GeographicBoundingBox" mode="iso19139">
  <dd>
	<dt><span class="element"><res:IDEX_GeographicBoundingBox/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:extentTypeCode">
        <dt><span class="element"><res:IDextentTypeCode2/></span>&#x2002;
        	<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="gmd:westBoundLongitude">
        <dt><span class="element"><res:IDwestBoundLongitude/></span>&#x2002;<xsl:call-template name="Decimal"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:eastBoundLongitude">
        <dt><span class="element"><res:IDeastBoundLongitude/></span>&#x2002;<xsl:call-template name="Decimal"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:northBoundLatitude">
        <dt><span class="element"><res:IDnorthBoundLatitude/></span>&#x2002;<xsl:call-template name="Decimal"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:southBoundLatitude">
        <dt><span class="element"><res:IDsouthBoundLatitude/></span>&#x2002;<xsl:call-template name="Decimal"/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Geographic Description Information (B.3.1.1 EX_GeographicDescription - line348) -->
<xsl:template match="EX_GeographicDescription" mode="iso19139">
  <dd>
	<dt><span class="element"><res:IDEX_GeographicDescription/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:extentTypeCode">
        <dt><span class="element"><res:IDextentTypeCode4/></span>&#x2002;
        	<xsl:call-template name="Boolean"/>
        </dt>      
      </xsl:for-each>
      <xsl:apply-templates select="gmd:geographicIdentifier/gmd:MD_Identifier" mode="iso19139"/>
      <xsl:if test="(gmd:extentTypeCode) and not (gmd:geographicIdentifier)"><br /><br /></xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Temporal Extent Information (B.3.1.2 EX_TemporalExtent - line350) -->
<xsl:template match="gmd:EX_TemporalExtent" mode="iso19139">
  <dd>
		<dt><span class="element"><res:IDEX_TemporalExtent/></span></dt>
		<xsl:apply-templates select="gmd:extent/*" mode="iso19139"/>
  </dd>
</xsl:template>

<!-- temporal extent Information from ISO 19103 as defined is DTD -->
<xsl:template match="gml:TimePeriod" mode="iso19139">
  <dd>
  <dl>
	<xsl:for-each select="gml:beginPosition">
		<dt><span class="element"><res:IDbeginPosition/></span>&#x2002;<xsl:call-template name="TimeInstant"/></dt>
	</xsl:for-each>
	<xsl:for-each select="gml:begin/gml:TimeInstant">
		<dt><span class="element"><res:IDbeginPosition/></span>&#x2002;<xsl:call-template name="TimeInstant"/></dt>
	</xsl:for-each>
	<xsl:for-each select="gml:endPosition">
		<dt><span class="element"><res:IDendPosition/></span>&#x2002;<xsl:call-template name="TimeInstant"/></dt>
	</xsl:for-each>
	<xsl:for-each select="gml:end/gml:TimeInstant">
		<dt><span class="element"><res:IDendPosition/></span>&#x2002;<xsl:call-template name="TimeInstant"/></dt>
	</xsl:for-each>
	</dl>
  </dd>
  <br />
</xsl:template>

<!-- temporal extent Information from ISO 19103 as defined is DTD -->
<xsl:template match="gml:TimeInstant" mode="iso19139">
  <dd>
  <dl>
  <xsl:for-each select="gml:timePosition">
		<dt><span class="element"><res:IDtimePosition/></span>&#x2002;
			<xsl:call-template name="TimeInstant"/>
		</dt>
  </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>

<!-- Spatial Temporal Extent Information (B.3.1.2 EX_SpatialTemporalExtent - line352) -->
<xsl:template match="gmd:EX_SpatialTemporalExtent" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDEX_SpatialTemporalExtent/></span></dt>
    <dd>
    <dl>
			<!-- NOTE: select sub-classes of gml:AbstractTimePrimitive -->
			<xsl:apply-templates select="gmd:extent/*" mode="iso19139"/>

      <xsl:for-each select="gmd:spatialExtent">
        <dt><span class="element"><res:IDspatialExtent/></span></dt>
        <dd>
          <dd>
          <dl>
						<!-- 
								NOTE: can call sub-classes' templates:
								EX_BoundingPolygon, EX_GeographicBoundingBox, EX_GeographicDescription
						-->
						<xsl:apply-templates select="*" mode="iso19139"/>
          </dl>
          </dd>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Vertical Extent Information (B.3.1.3 EX_VerticalExtent - line354) -->
<xsl:template match="gmd:EX_VerticalExtent" mode="iso19139">
  <dd>
  <dt><span class="element"><res:IDEX_VerticalExtent/></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="gmd:minimumValue">
        <dt><span class="element"><res:IDminimumValue/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
      <xsl:for-each select="gmd:maximumValue">
        <dt><span class="element"><res:IDmaximumValue/></span>&#x2002;<xsl:call-template name="Real"/></dt>
      </xsl:for-each>
			
			<!-- 19139 uses GML here instead of ISO 19115's unitOfMeasure (UomLength) -->
			<xsl:if test="gmd:verticalCRS">
				<xsl:for-each select="gmd:verticalCRS/*">
					<!-- TODO: review this -->
					<dt><span class="element"><res:IDCoordRefSys/></span>&#x2002;<xsl:call-template name="AbstractCRS"/></dt>
				</xsl:for-each>
			</xsl:if>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- gml:TimeInstant -->
<xsl:template name="TimeInstant">
	<!-- NOTE: ignoring attributes: frame, calendarEraName, indeterminatePosition -->
	<xsl:choose>
		<xsl:when test="@indeterminatePosition"><xsl:call-template name="indeterminatePosition"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld">
				<xsl:choose>
					<xsl:when test="contains(., 'T')"><xsl:value-of select="substring-before(.,'T')"/>&#x2003;<xsl:value-of select="substring-after(.,'T')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Boolean -->
<xsl:template name="Boolean">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="gco:Boolean">
				<span class="textOld"><xsl:value-of select="."/></span>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:CodeListValue_Type -->
<xsl:template name="AnyCode">
	<xsl:choose>
		<xsl:when test="@gco:nilReason or ../@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld"><xsl:value-of select="(*/@codeListValue | */text())[1]"/></span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Measure and gco:Distance -->
<xsl:template match="gco:Measure | gco:Distance" mode="iso19139">
	<!-- NOTE: uom attribute supressed -->
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld">
			<xsl:value-of select="."/><xsl:for-each select="./@uom">&#160;<xsl:call-template name="ucum_units">
					<xsl:with-param name="unit" select="." />
				</xsl:call-template>
			</xsl:for-each>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Integer -->
<xsl:template name="Integer">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="gco:Integer">
				<span class="textOld"><xsl:value-of select="."/></span>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Real -->
<xsl:template name="Real">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="gco:Real">
				<span class="textOld"><xsl:value-of select="."/></span>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Decimal -->
<xsl:template name="Decimal">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld"><xsl:value-of select="gco:Decimal"/></span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Date_PropertyType -->
<xsl:template name="Date_PropertyType">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld">
				<xsl:choose>
					<xsl:when test="contains(*, 'T')"><xsl:value-of select="substring-before(*,'T')"/>&#x2003;<xsl:value-of select="substring-after(*,'T')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="(gco:Date | gco:DateTime)[1]"/></xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:CharacterString , gco:FreeText -->
<xsl:template name="CharacterString">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld">
			<xsl:for-each select="*">
				<xsl:if test="local-name(.) = 'CharacterString'">
					<xsl:value-of select="."/>
				</xsl:if>
				<xsl:if test="local-name(.) = 'PT_FreeText'">
					<!-- <b><xsl:value-of select="name(ancestor-or-self::*[2])" /></b> -->
					<dl>
						<dd><b><xsl:value-of select="gmd:textGroup/gmd:LocalisedCharacterString/@locale"/></b>&#x2002;<xsl:value-of select="gmd:textGroup/gmd:LocalisedCharacterString"/></dd>
					</dl>
				</xsl:if>
			</xsl:for-each>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- simple text -->
<xsl:template name="SimpleText">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<span class="textOld"><xsl:value-of select="."/></span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Record -->
<xsl:template name="Record">
	<!-- NOTE: this has no content model in the ISO 19139 schemas -->
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="gco:Record">
				<span class="textOld"><xsl:value-of select="." /></span>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gml:Point -->
<xsl:template match="gml:Point" mode="iso19139">
	<!-- NOTE: ignoring attribute-group gml:SRSReferenceGroup -->
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="gml:pos">
				<dt><span class="element"><res:gmlPos/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>      
			</xsl:for-each>
			<dl>
				<xsl:for-each select="gml:name">
				   <dt><span class="element"><res:gmlName2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
				</xsl:for-each>
				<xsl:for-each select="gml:name/@codeSpace">
					<dl>
					<dd>
					   <dt><span class="element"><res:gmlName2_codespace/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
					</dd>
					</dl>
				</xsl:for-each>
				<xsl:for-each select="gml:description">
				   <dt><span class="element"><res:gmlDesc2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
				</xsl:for-each>
				<xsl:for-each select="gml:descriptionReference/@xlink:href">
				   <dt><span class="element"><res:gmlDescRef2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
				</xsl:for-each>
				<xsl:for-each select="gml:identifier">
				   <dt><span class="element"><res:gmlIdent2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
				</xsl:for-each>
				<xsl:for-each select="gml:identifier/@codeSpace">
					<dl>
					<dd>
					   <dt><span class="element"><res:gmlIdent2_codespace/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
					</dd>
					</dl>
				</xsl:for-each>
				<xsl:for-each select="@gml:id">
				   <dt><span class="element"><res:gmlID2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
				</xsl:for-each>
				<xsl:for-each select="gml:remarks">
				   <dt><span class="element"><res:gmlRemarks2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
				</xsl:for-each>
			</dl>
		</xsl:otherwise>
	</xsl:choose>
	<br/>
</xsl:template>

<!-- gml:UnitDefinitionType -->
<xsl:template match="gml:UnitDefinition" mode="iso19139">
	<!-- NOTE: there are lots of elements and attributes not included -->
	<dd>
	<dl>
		<xsl:for-each select="gml:catalogSymbol">
		   <dt><span class="element"><res:gmlCatalogSymbol/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gml:catalogSymbol/@codeSpace">
			<dl>
			<dd>
			   <dt><span class="element"><res:gmlCatalogSymbol_codespace/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
			</dd>
			</dl>
		</xsl:for-each>
		<xsl:if test="gml:catalogSymbol/text() or gml:catalogSymbol/@codeSpace"><br /></xsl:if>
		
		<xsl:for-each select="gml:quantityType">
		   <dt><span class="element"><res:gmlQuantityType/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt><br /><br />
		</xsl:for-each>
		<xsl:for-each select="gml:name">
		   <dt><span class="element"><res:gmlName2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gml:name/@codeSpace">
			<dl>
			<dd>
			   <dt><span class="element"><res:gmlName2_codespace/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
			</dd>
			</dl>
		</xsl:for-each>
		<xsl:for-each select="gml:description">
		   <dt><span class="element"><res:gmlDesc2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gml:identifier">
		   <dt><span class="element"><res:gmlIdent2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gml:identifier/@codeSpace">
			<dl>
			<dd>
			   <dt><span class="element"><res:gmlIdent2_codespace/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
			</dd>
			</dl>
		</xsl:for-each>
		<xsl:for-each select="@gml:id">
		   <dt><span class="element"><res:gmlID2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
		<xsl:for-each select="gml:remarks">
		   <dt><span class="element"><res:gmlRemarks2/></span>&#x2002;<xsl:call-template name="SimpleText"/></dt>
		</xsl:for-each>
	</dl>
	</dd>
	<br />
</xsl:template>

<!-- gml:AbstractGeometry -->
<xsl:template name="AbstractGeometry">
	<!-- NOTE: no implementation -->
</xsl:template>

<!-- gml:AbstractCRS -->
<xsl:template name="AbstractCRS">
	<!-- NOTE: no implementation -->
</xsl:template>

<!-- gco:RecordType -->
<xsl:template name="RecordType">
	<!-- NOTE: attribute-group xlink:simpleLink ignored -->
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="gco:RecordType">
				<span class="textOld"><xsl:value-of select="."/> </span>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- gco:Binary -->
<xsl:template name="Binary">
	<xsl:choose>
		<xsl:when test="@gco:nilReason"><xsl:call-template name="nilReason"/></xsl:when>
		<xsl:otherwise>
			<dl>
			<dd>
				<span class="textOld"><xsl:value-of select="gco:Binary"/> </span>
				<xsl:if test="gco:Binary/@src">
					<dt><span class="element"><res:srcAttribute/></span>&#x2002;<span class="textOld"><xsl:call-template name="urlType">
						<xsl:with-param name="value" select="gco:Binary/@src" />
					</xsl:call-template></span></dt>
				</xsl:if>
			</dd>
			</dl><br />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- uuidref -->
<xsl:template name="uuidref">
	<xsl:if test="(@uuidref != '')">
		<xsl:for-each select="@uuidref">
			<span class="textOld"><xsl:value-of select="."/> </span>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<!-- gco:nilReason -->
<xsl:template name="nilReason">
	<dl>
		<dt><span class="element"><res:nilReason/></span>&#x2003;<span class="textOld"><xsl:value-of select="@gco:nilReason"/></span></dt>
	</dl>
</xsl:template>

<!-- GML time indeterminatePosition -->
<xsl:template name="indeterminatePosition">
	<dl>
		<dt><span class="element"><res:IndeterminateTime/></span>&#x2003;<span class="textOld"><xsl:value-of select="@indeterminatePosition"/></span></dt>
	</dl>
</xsl:template>

</xsl:stylesheet>