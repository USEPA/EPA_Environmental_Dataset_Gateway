<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:res="http://www.w3.org/2005/xpath-functions" xmlns:esri="http://www.esri.com/metadata/" xmlns:msxsl="urn:schemas-microsoft-com:xslt" >

  <!-- An XSLT template for displaying metadata in ArcGIS that is stored in the ArcGIS metadata format.

     Copyright (c) 2009-2013, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 11/19/2009 avienneau
-->

  <xsl:template name="iteminfo" >
    <div class="itemDescription" id="overview">

	<!-- Title -->
	<h1 class="idHeading">
		<xsl:choose>
			<xsl:when test="/metadata/dataIdInfo[1]/idCitation/resTitle/text()">
				<xsl:value-of select="/metadata/dataIdInfo[1]/idCitation/resTitle[1]" />
			</xsl:when>
			<xsl:when test="/metadata/Esri/DataProperties/itemProps/itemName/text()">
				<xsl:value-of select="/metadata/Esri/DataProperties/itemProps/itemName" />
			</xsl:when>
			<xsl:otherwise>
				<span class="noContent"><res:idNoTitle/></span>
			</xsl:otherwise>
		</xsl:choose>
	</h1>

	<!-- Data type -->
	<xsl:if test="/metadata/distInfo/distFormat/formatName or /metadata/distInfo/distributor/distorFormat/formatName">
		<p class="center">
			<span class="idHeading">
				<xsl:choose>
					<xsl:when test="/metadata/distInfo/distFormat/formatName/text()">
						<xsl:value-of select="/metadata/distInfo/distFormat/formatName[text()][1]"/>
					</xsl:when>
					<xsl:when test="/metadata/distInfo/distributor/distorFormat/formatName/text()">
						<xsl:value-of select="/metadata/distInfo/distributor/distorFormat/formatName[text()][1]"/>
					</xsl:when>
				</xsl:choose>
			</span>
		</p>
	</xsl:if>

	<!-- Thumbnail/Tool Illustration -->
	<div class="center">
		<xsl:choose>
			<xsl:when test="/metadata/Binary/Thumbnail/img/@src">
				<img name="thumbnail" id="thumbnail" alt="Thumbnail" title="Thumbnail" class="summary">
					<xsl:attribute name="src">
						<xsl:value-of select="/metadata/Binary/Thumbnail/img/@src"/>
					</xsl:attribute>
					<xsl:attribute name="class">center</xsl:attribute>
				</img>
			</xsl:when>
			<xsl:when test="/metadata/idinfo/browse/img/@src">
				<img name="thumbnail" id="thumbnail" alt="Thumbnail" title="Thumbnail" class="summary">
					<xsl:attribute name="src">
						<xsl:value-of select="/metadata/idinfo/browse/img/@src"/>
					</xsl:attribute>
					<xsl:attribute name="class">center</xsl:attribute>
				</img>
			</xsl:when>
			<xsl:otherwise>
				<div class="noThumbnail"><res:idThumbnailNotAvail/></div>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<!-- Tags/Metadata Theme Keywords -->
	<p class="center">
		<span class="idHeading"><res:idTags /></span>
		<br/>
		<xsl:choose>
			<xsl:when test="/metadata/dataIdInfo[1]/searchKeys/keyword[text() and (. != '001') and (. != '002') and (. != '003') and (. != '004') and (. != '005') and (. != '006') and (. != '007') and (. != '008') and (. != '009') and (. != '010')]">
				<xsl:for-each select="/metadata/dataIdInfo[1]/searchKeys/keyword[text() and (. != '001') and (. != '002') and (. != '003') and (. != '004') and (. != '005') and (. != '006') and (. != '007') and (. != '008') and (. != '009') and (. != '010')]">
					<xsl:value-of select="."/>
					<xsl:if test="not(position()=last())">, </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="/metadata/dataIdInfo[1]/themeKeys/keyword/text() or /metadata/dataIdInfo/placeKeys/keyword/text()">
				<xsl:for-each select="/metadata/dataIdInfo[1]/themeKeys/keyword[text()] | /metadata/dataIdInfo/placeKeys/keyword[text()]">
					<xsl:value-of select="."/>
					<xsl:if test="not(position()=last())">, </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<span class="noContent"><res:idNoTagsForItem/></span>
			</xsl:otherwise>
		</xsl:choose>
	</p><br/>

	<!-- AGOL Summary/Metadata Purpose -->
	<div class="itemInfo">
		<span class="idHeading"><res:idSummary_ItemDescription /></span>
		<xsl:choose>
			<xsl:when test="(/metadata/dataIdInfo[1]/idPurp != '')">
				<p>
					<xsl:call-template name="elementSupportingMarkup">
						<xsl:with-param name="ele" select="/metadata/dataIdInfo[1]/idPurp" />
					</xsl:call-template>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p><span class="noContent"><res:idNoSummaryForItem/></span></p>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<!-- AGOL Description/Metadata Abstract/Tool Summary -->
	<div class="itemInfo">
		<span class="idHeading"><res:idDesc_ItemDescription /></span>
		<xsl:choose>
			<xsl:when test="(/metadata/dataIdInfo[1]/idAbs != '')">
				<p>
					<xsl:call-template name="elementSupportingMarkup">
						<xsl:with-param name="ele" select="/metadata/dataIdInfo[1]/idAbs" />
					</xsl:call-template>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p><span class="noContent"><res:idNoDescForItem/></span></p>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<!-- Credits -->
	<div class="itemInfo">
		<span class="idHeading"><res:idCredits_ItemDescription /></span>
		<xsl:choose>
			<xsl:when test="(/metadata/dataIdInfo[1]/idCredit != '')">
				<p>
					<xsl:call-template name="elementSupportingMarkup">
						<xsl:with-param name="ele" select="/metadata/dataIdInfo[1]/idCredit" />
					</xsl:call-template>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p><span class="noContent"><res:idNoCreditsForItem/></span></p>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<!-- Use constraints -->
	<div class="itemInfo">
		<span class="idHeading"><res:idUseLimits_ItemDescription /></span>
		<xsl:choose>
			<xsl:when test="(/metadata/dataIdInfo[1]/resConst/Consts/useLimit[1] != '')">
				<p>
					<xsl:call-template name="elementSupportingMarkup">
						<xsl:with-param name="ele" select="/metadata/dataIdInfo[1]/resConst/Consts/useLimit[1]" />
					</xsl:call-template>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p><span class="noContent"><res:idNoUseLimitsForItem/></span></p>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<!-- Extent -->
	<p>
		<span class="idHeading"><res:idExtent_ItemDescription /></span>
		<br/>
		<xsl:choose>
			<xsl:when test="/metadata/dataIdInfo[1]/dataExt/geoEle/GeoBndBox[(@esriExtentType = 'search') and (westBL != '') and (eastBL != '') and (northBL != '') and (southBL != '')]">
				<xsl:for-each select="/metadata/dataIdInfo[1]/dataExt[geoEle/GeoBndBox/@esriExtentType = 'search'][1]/geoEle[(GeoBndBox/@esriExtentType = 'search')][1]/GeoBndBox[(@esriExtentType = 'search')][1]">
					<xsl:call-template name="extentTable">
						<xsl:with-param name="west" select="westBL" />
						<xsl:with-param name="east" select="eastBL" />
						<xsl:with-param name="north" select="northBL" />
						<xsl:with-param name="south" select="southBL" />
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<span class="noContent"><res:idNoExtentForItem /></span>
			</xsl:otherwise>
		</xsl:choose>
	</p>

	<!-- Scale range -->
	<p>
		<div><span class="idHeading"><res:idScaleRange_ItemDescription /></span></div>
		<xsl:choose>
			<xsl:when test="/metadata/Esri/scaleRange[(. != '')]">
				<xsl:for-each select="/metadata/Esri/scaleRange">
					<dl>
						<dt>
							<table cols="2" width="auto" border="0">
								<col align="left" />
								<col align="left" />
								<tr><!-- the little number (large scale), stored in maxScale -->
									<td class="description"><span class="idHeading"><res:idScaleRangeMax_ItemDescription /></span>&#160;</td>
									<td class="description"><xsl:text>1:</xsl:text><xsl:value-of select="format-number(maxScale,'###,###,###')"/></td>
								</tr>
								<tr><!-- the big number (small scale), stored in minScale -->
									<td class="description"><span class="idHeading"><res:idScaleRangeMin_ItemDescription /></span>&#160;</td>
									<td class="description"><xsl:text>1:</xsl:text><xsl:value-of select="format-number(minScale,'###,###,###')"/></td>
								</tr>
							</table>
						</dt>
					</dl>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<span class="noContent"><res:idNoScaleRangeForItem /></span>
			</xsl:otherwise>
		</xsl:choose>
	</p>

    </div>
  </xsl:template>
  
  <xsl:template name="elementSupportingMarkup">
	<xsl:param name="ele" />
	<xsl:choose>
		<xsl:when test="$ele/*">
			<!-- whitespace between nodes will be removed IF it isn't full HTML -->
			<!-- b or a inside plain text won't have carriage returns, br respected as carriage returns; must live with this behavior for unsupported content format -->
			<!-- full DIV or P containing all content will have whitespace retained between nodes -->
			<pre class="wrap">
				<xsl:copy-of select="$ele/node()" />
			</pre>
		</xsl:when>
		<xsl:when test="$ele[(contains(.,'&lt;/')) or (contains(.,'/&gt;'))]">
			<xsl:variable name="text">
				<xsl:copy-of select="esri:decodenodeset($ele)" />
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="($text != '')">
					<xsl:variable name="newText">
						<!-- <xsl:apply-templates select="msxsl:node-set($text)/node() | msxsl:node-set($text)/@*" mode="linkTarget" /> -->
					</xsl:variable>
					<pre class="wrap">
						<xsl:copy-of select="$newText" />
					</pre>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="escapedHtmlText">
						<xsl:value-of select="esri:striphtml($ele)" />
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="($escapedHtmlText != '')">
							<xsl:variable name="handleURLsResult">
								<xsl:call-template name="handleURLs">
									<xsl:with-param name="text" select="$ele" />
								</xsl:call-template>
							</xsl:variable>
							<pre class="wrap">
								<xsl:copy-of select="($handleURLsResult)" />
							</pre>
						</xsl:when>
						<xsl:otherwise>
							<p><span class="noContent">
								<xsl:choose>
									<xsl:when test="(name($ele) = 'idAbs')"><res:idNoDescForItem/></xsl:when>
									<xsl:when test="(name($ele) = 'idPurp')"><res:idNoSummaryForItem/></xsl:when>
									<xsl:when test="(name($ele) = 'idCredit')"><res:idNoCreditsForItem/></xsl:when>
									<xsl:when test="(name($ele) = 'useLimit')"><res:idNoUseLimitsForItem/></xsl:when>
								</xsl:choose>
							</span></p>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$ele[(contains(.,'&amp;')) or (contains(.,'&lt;')) or (contains(.,'&gt;'))]">
			<!-- add pre tag with specific class around resulting text to keep whitespace -->
			<!-- putting result of handleURLs in a variable and using value-of with the variable causes URL to not be a link; use copy-of instead -->
			<!-- adding normalize-space around $ele to remove trailing whitespace removes all carriage returns; must live with trailing whitespace -->
			<xsl:variable name="handleURLsResult">
				<xsl:call-template name="handleURLs">
					<xsl:with-param name="text" select="$ele" />
				</xsl:call-template>
			</xsl:variable>
			<pre class="wrap">
				<xsl:copy-of select="($handleURLsResult)" />
			</pre>
		</xsl:when>
		<xsl:when test="$ele/text()">
			<xsl:variable name="escapedHtmlText">
				<xsl:value-of select="esri:striphtml($ele)" />
			</xsl:variable>
			<!-- add pre tag around result to keep whitespace -->
			<xsl:variable name="handleURLsResult">
				<xsl:call-template name="handleURLs">
					<xsl:with-param name="text" select="$escapedHtmlText" />
				</xsl:call-template>
			</xsl:variable>
			<pre class="wrap">
				<xsl:copy-of select="($handleURLsResult)" />
			</pre>
		</xsl:when>
	</xsl:choose>
  </xsl:template>
  
  <xsl:template name="extentTable">
	<xsl:param name="west" />
	<xsl:param name="east" />
	<xsl:param name="north" />
	<xsl:param name="south" />
	<dl>
		<dt>
			<table cols="4" width="auto" border="0">
				<col align="left" />
				<col align="right" />
				<col align="left" />
				<col align="right" />
				<tr>
					<td class="description"><span class="idHeading"><res:idExtentWest_ItemDescription /></span>&#160;</td>
					<td class="description"><xsl:value-of select="$west"/></td>
					<td class="description">&#160;&#160;&#160;<span class="idHeading"><res:idExtentEast_ItemDescription /></span>&#160;</td>
					<td class="description"><xsl:value-of select="$east"/></td>
				</tr>
				<tr>
					<td class="description"><span class="idHeading"><res:idExtentNorth_ItemDescription /></span>&#160;</td>
					<td class="description"><xsl:value-of select="$north"/></td>
					<td class="description">&#160;&#160;&#160;<span class="idHeading"><res:idExtentSouth_ItemDescription /></span>&#160;</td>
					<td class="description"><xsl:value-of select="$south"/></td>
				</tr>
			</table>
		</dt>
	</dl>
  </xsl:template>
  
</xsl:stylesheet>