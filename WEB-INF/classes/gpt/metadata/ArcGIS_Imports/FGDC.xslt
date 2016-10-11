<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:res="http://www.w3.org/2005/xpath-functions" >

<!-- An XSLT template for displaying metadata in ArcGIS that is stored in the FGDC metadata format. 

     Copyright (c) 2009-2013, Environmental Systems Research Institute, Inc. All rights reserved.
     	
     Revision History: Created 4/21/2009 avienneau
-->


<xsl:template name="fgdc" >

<div class="hide" id="fgdcMetadata">
<div class="box fgdc">

    <div><a name="TopFGDC" id="TopFGDC" /></div>
	<div>

		<xsl:for-each select="/metadata/idinfo">
			<xsl:call-template name="tocSectionFGDC">
				<xsl:with-param name="count"><xsl:value-of select="count(../idinfo)" /></xsl:with-param>
				<xsl:with-param name="sectionHeading"><xsl:value-of select="res:string('idIdent')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="/metadata/dataqual">
			<xsl:call-template name="tocSectionFGDC">
				<xsl:with-param name="count"><xsl:value-of select="count(../dataqual)" /></xsl:with-param>
				<xsl:with-param name="sectionHeading"><xsl:value-of select="res:string('idDataQual')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="/metadata/spdoinfo[.//sdtsterm or .//vpfterm or .//rastinfo]">
			<xsl:call-template name="tocSectionFGDC">
				<xsl:with-param name="count"><xsl:value-of select="count(../spdoinfo)" /></xsl:with-param>
				<xsl:with-param name="sectionHeading"><xsl:value-of select="res:string('idSpaDataOrg')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="/metadata/spref">
			<xsl:call-template name="tocSectionFGDC">
				<xsl:with-param name="count"><xsl:value-of select="count(../spref)" /></xsl:with-param>
				<xsl:with-param name="sectionHeading"><xsl:value-of select="res:string(stringSpaRef')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:if test="/metadata/eainfo">
			<xsl:variable name="eleID">/metadata/eainfo//text()[1]</xsl:variable>
			<xsl:variable name="show"><xsl:value-of select="concat($eleID, 'Show')" /></xsl:variable>
			<xsl:variable name="hide"><xsl:value-of select="concat($eleID, 'Hide')" /></xsl:variable>
			<h2 class="fgdc">
				<a onclick="hideShow('{$eleID}')" href="#{$eleID}"><xsl:value-of select="res:string(stringEntsAndAttribs')"/>&#160;
				<span id="{$show}" class="hide">&#9660;</span><span id="{$hide}" class="show">&#9658;</span></a>
			</h2>
			<div class="show" id="{$eleID}">
				<xsl:apply-templates select="/metadata/eainfo" mode="fgdc"/>
				<div class="backToTop"><a onclick="hideShow('{$eleID}')" href="#{$eleID}"><xsl:value-of select="res:string('idHide')"/>&#160;<xsl:value-of select="res:string('idEntsAndAttribs')"/>&#160;&#9650;</a></div>
			</div>
		</xsl:if>

		<xsl:for-each select="/metadata/distinfo">
			<xsl:call-template name="tocSectionFGDC">
				<xsl:with-param name="count"><xsl:value-of select="count(../distinfo)" /></xsl:with-param>
				<xsl:with-param name="sectionHeading"><xsl:value-of select="res:string('idDistInfo_FGDC')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="/metadata/metainfo">
			<xsl:call-template name="tocSectionFGDC">
				<xsl:with-param name="count"><xsl:value-of select="count(../metainfo)" /></xsl:with-param>
				<xsl:with-param name="sectionHeading"><xsl:value-of select="res:string('idMetaRef')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

	</div>

</div>
</div>
</xsl:template>


<!-- TEMPLATES FOR TABLE OF CONTENTS -->

<xsl:template name="tocSectionFGDC">
	<xsl:param name="count" />
	<xsl:param name="sectionHeading" />
	<xsl:variable name="eleID"><xsl:value-of select="generate-id(.)" /></xsl:variable>
	<xsl:variable name="show"><xsl:value-of select="concat($eleID, 'Show')" /></xsl:variable>
	<xsl:variable name="hide"><xsl:value-of select="concat($eleID, 'Hide')" /></xsl:variable>
    <h2 class="fgdc">
		<a onclick="hideShow('{$eleID}')" href="#{$eleID}">
			<xsl:value-of select="$sectionHeading" />
			<xsl:if test="$count > 1">&#160;<xsl:value-of select="position()" /></xsl:if>&#160;
			<span id="{$show}" class="hide">&#9660;</span><span id="{$hide}" class="show">&#9658;</span>
		</a>
    </h2>
    <div class="show" id="{$eleID}">
		<xsl:apply-templates select="." mode="fgdc"/>
		<div class="backToTop"><a onclick="hideShow('{$eleID}')" href="#{$eleID}"><res:idHide/>&#160;<xsl:value-of select="$sectionHeading" />&#160;<xsl:if test="$count > 1">&#160;<xsl:value-of select="position()" /></xsl:if>&#160;&#9650;</a></div>
	</div>
</xsl:template>


<!-- Identification -->
<xsl:template match="idinfo" mode="fgdc">
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="citation">
        <dt><span class="element"><res:idCitation/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="citeinfo" mode="fgdc"/>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="descript">
        <dt><span class="element"><res:idDesc/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="abstract">
              <dt><span class="element"><res:idAbstract/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>

          <xsl:for-each select="purpose">
              <dt><span class="element"><res:idPurpose/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>

          <xsl:for-each select="supplinf">
              <dt><span class="element"><res:idSupplInfo/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="timeperd">
        <dt><span class="element"><res:idTimePerOfContent/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="timeinfo" mode="fgdc"/>
          <xsl:for-each select="current">
              <dt><span class="element"><res:idCurrRef/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="status">
        <dt><span class="element"><res:idStatus/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="progress">
            <dt><span class="element"><res:idProgress/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="update">
            <dt><span class="element"><res:idMaintAndUpdateFreq/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>

      <xsl:for-each select="spdom">
        <dt><span class="element"><res:idSpaDomain/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="bounding">
            <dt><span class="element"><res:idBoundCoords/></span></dt>
            <dd>
            <dl>
              <dt><span class="element"><res:idWestBoundCoord/></span>&#x2003;<span class="textOld"><xsl:value-of select="westbc"/></span></dt>
              <dt><span class="element"><res:idEastBoundCoord/></span>&#x2003;<span class="textOld"><xsl:value-of select="eastbc"/></span></dt>
              <dt><span class="element"><res:idNorthBoundCoord/></span>&#x2003;<span class="textOld"><xsl:value-of select="northbc"/></span></dt>
              <dt><span class="element"><res:idSouthBoundCoord/></span>&#x2003;<span class="textOld"><xsl:value-of select="southbc"/></span></dt>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:for-each select="dsgpoly">
            <dt><span class="element"><res:idDatasetGPoly/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="dsgpolyo">
                <dt><span class="element"><res:idDatasetGPolyOuterGRing/></span></dt>
                <dd>
                <dl>
                  <xsl:apply-templates select="grngpoin" mode="fgdc"/>
                  <xsl:apply-templates select="gring" mode="fgdc"/>
                </dl>
                </dd>
              </xsl:for-each>
              <xsl:for-each select="dsgpolyx">
                <dt><span class="element"><res:idDatasetGPolyExclGRing/></span></dt>
                <dd>
                <dl>
                  <xsl:apply-templates select="grngpoin" mode="fgdc"/>
                  <xsl:apply-templates select="gring" mode="fgdc"/>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>

      <xsl:for-each select="keywords">
        <dt><span class="element"><res:idKeywds/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="theme">
            <dt><span class="element"><res:idTheme/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="themekt">
                <dt><span class="element"><res:idThemeKeywdThes/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="themekey">
                <dt><span class="element"><res:idThemeKeywd/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>

          <xsl:for-each select="place">
            <dt><span class="element"><res:idPlace/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="placekt">
                <dt><span class="element"><res:idPlaceKeywdThes/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="placekey">
                <dt><span class="element"><res:idPlaceKeywd/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>

          <xsl:for-each select="stratum">
            <dt><span class="element"><res:idStratum/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="stratkt">
                <dt><span class="element"><res:idStratumKeywdThes/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="stratkey">
                <dt><span class="element"><res:idStratumKeywd/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>
 
          <xsl:for-each select="temporal">
            <dt><span class="element"><res:idTemporal/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="tempkt">
                <dt><span class="element"><res:idTemporalKeywdThes/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="tempkey">
                <dt><span class="element"><res:idTemporalKeywd/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="accconst">
		  <dt><span class="element"><res:idAccessConst/></span></dt>
          <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
      </xsl:for-each>
      <xsl:for-each select="useconst">
          <dt><span class="element"><res:idUseConst/></span></dt>
          <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
      </xsl:for-each>

      <xsl:for-each select="ptcontac">
        <dt><span class="element"><res:idPointOfContact/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="cntinfo" mode="fgdc"/>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="browse">
        <dt><span class="element"><res:idBrowseGraphic/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="browsen">
            <dt><span class="element"><res:idBrowseGraphicFN/></span>&#x2003;<a target="viewer">
              <xsl:attribute name="href"><xsl:value-of select = "." /></xsl:attribute>
              <span class="textOld"><xsl:value-of select = "." /></span></a>
            </dt>
          </xsl:for-each>
          <xsl:for-each select="browsed">
            <dt><span class="element"><res:idBrowseGraphicFDesc/></span></dt>
            <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
          </xsl:for-each>
          <xsl:for-each select="browset">
            <dt><span class="element"><res:idBrowseGraphicFType/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>

      <xsl:for-each select="datacred">
          <dt><span class="element"><res:idDatasetCredit/></span></dt>
          <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
      </xsl:for-each>

      <xsl:for-each select="secinfo">
        <dt><span class="element"><res:idSecInfo/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="secsys">
            <dt><span class="element"><res:idSecClassSys/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="secclass">
            <dt><span class="element"><res:idSecClass/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="sechandl">
            <dt><span class="element"><res:idSecHandlingDesc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>

      <xsl:for-each select="native">
        <dt><span class="element"><res:idNaticeDatasetEnv/></span></dt>
        <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
      </xsl:for-each>

      <xsl:for-each select="crossref">
        <dt><span class="element"><res:idCrossRef/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="citeinfo" mode="fgdc"/>
        </dl>
        </dd>
      </xsl:for-each>

    </dl>
    </dd>
  </dl><br />
</xsl:template>

<!-- Data Quality -->
<xsl:template match="dataqual" mode="fgdc">
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="attracc">
        <dt><span class="element"><res:idAttribAcc/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="attraccr">
              <dt><span class="element"><res:idAttribAccRep/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>
          <xsl:for-each select="qattracc">
            <dt><span class="element"><res:idQuantAttribAccAssess/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="attraccv">
                <dt><span class="element"><res:idAttribAccVal/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="attracce">
                  <dt><span class="element"><res:idAttribAccExpl/></span></dt>
                  <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="logic">
          <dt><span class="element"><res:idLogConsistRep/></span></dt>
          <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
      </xsl:for-each>
      <xsl:for-each select="complete">
          <dt><span class="element"><res:idCompleteRep/></span></dt>
          <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
      </xsl:for-each>

      <xsl:for-each select="posacc">
        <dt><span class="element"><res:idPosAcc/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="horizpa">
            <dt><span class="element"><res:idHorizPosAcc/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="horizpar">
                  <dt><span class="element"><res:idHorizPosAccRep/></span></dt>
                  <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
              </xsl:for-each>
              <xsl:for-each select="qhorizpa">
                <dt><span class="element"><res:idQuantHorizPosAccAssess/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="horizpav">
                    <dt><span class="element"><res:idHorizPosAccVal/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="horizpae">
                      <dt><span class="element"><res:idHorizPosAccExpl/></span></dt>
                      <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
          <xsl:for-each select="vertacc">
            <dt><span class="element"><res:idVertPosAcc/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="vertaccr">
                  <dt><span class="element"><res:idVertPosAccRep/></span></dt>
                  <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
              </xsl:for-each>
              <xsl:for-each select="qvertpa">
                <dt><span class="element"><res:idQuantVertPosAccAssess/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="vertaccv">
                    <dt><span class="element"><res:idVertPosAccVal/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="vertacce">
                      <dt><span class="element"><res:idVertPosAccExpl/></span></dt>
                      <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="lineage">
        <dt><span class="element"><res:idLineage/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="srcinfo">
            <dt><span class="element"><res:idSrcInfo/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="srccite">
                <dt><span class="element"><res:idSrcCitation/></span></dt>
                <dd>
                <dl>
                  <xsl:apply-templates select="citeinfo" mode="fgdc"/>
                </dl>
                </dd>
              </xsl:for-each>
              <xsl:for-each select="srcscale">
                <dt><span class="element"><res:idSrcScaleDenom/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="typesrc">
                <dt><span class="element"><res:idTypeSrcMedia/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>

              <xsl:for-each select="srctime">
                <dt><span class="element"><res:idSrcTimePrdContent/></span></dt>
                <dd>
                <dl>
                  <xsl:apply-templates select="timeinfo" mode="fgdc"/>
                  <xsl:for-each select="srccurr">
                    <dt><span class="element"><res:idSrcCurrRef/></span></dt>
                    <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>

              <xsl:for-each select="srccitea">
                <dt><span class="element"><res:idSrcCitationAbbrev/></span></dt>
                <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
              </xsl:for-each>
              <xsl:for-each select="srccontr">
                  <dt><span class="element"><res:idSrcContrib/></span></dt>
                  <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:for-each select="procstep">
            <dt><span class="element"><res:idProcStep/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="procdesc">
                  <dt><span class="element"><res:idProcDesc/></span></dt>
                  <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
              </xsl:for-each>
              <xsl:for-each select="srcused">
                <dt><span class="element"><res:idSrcUsedCitationAbbrev/></span></dt>
                <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
              </xsl:for-each>
              <xsl:for-each select="procdate">
                <dt><span class="element"><res:idProcDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
					<xsl:with-param name="value" select="." />
				</xsl:call-template></span></dt>
              </xsl:for-each>
              <xsl:for-each select="proctime">
                <dt><span class="element"><res:idProcTime/></span>&#x2003;<span class="textOld"><xsl:call-template name="timeType">
					<xsl:with-param name="value" select="." />
				</xsl:call-template></span></dt>
              </xsl:for-each>
              <xsl:for-each select="srcprod">
                <dt><span class="element"><res:idSrcProdCitationAbbrev/></span></dt>
                <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
              </xsl:for-each>
			  <br /><br />
              <xsl:for-each select="proccont">
                <dt><span class="element"><res:idProcContact/></span></dt>
                <dd>
                <dl>
                  <xsl:apply-templates select="cntinfo" mode="fgdc"/>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>
      <xsl:for-each select="cloud">
        <dt><span class="element"><res:idCloudCover/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt><br /><br />
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- Spatial Data Organization -->
<xsl:template match="spdoinfo[.//sdtsterm or .//vpfterm or .//rastinfo]" mode="fgdc">
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="indspref">
        <dt><span class="element"><res:idIndirectSpaRefMethod/></span></dt>
        <dd><span class="textOld"><xsl:value-of select = "." /></span></dd><br /><br />
      </xsl:for-each>

      <xsl:for-each select="direct">
        <dt><span class="element"><res:idDirectSpaRefMethod/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt><br /><br />
      </xsl:for-each>

      <xsl:for-each select="ptvctinf[sdtsterm/*/text()]">
        <dt><span class="element"><res:idPtVecObjInfo/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="sdtsterm">
            <dt><span class="element"><res:idSdtsTermsDesc/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="sdtstype">
                <dt><span class="element"><res:idSdtsPtVecObjType/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="ptvctcnt">
                <dt><span class="element"><res:idPtVecObjCnt/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>

          <xsl:for-each select="vpfterm">
            <dt><span class="element"><res:idVpfTermsDesc/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="vpflevel">
                <dt><span class="element"><res:idVpfTopoLvl/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="vpfinfo">
                <dt><span class="element"><res:idVpfPtVecObjInfo/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="vpftype">
                    <dt><span class="element"><res:idVpfPtVecObjType/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="ptvctcnt">
                    <dt><span class="element"><res:idPtVecObjCnt_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="rastinfo">
        <dt><span class="element"><res:idRasterObjInfo/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="rasttype">
            <dt><span class="element"><res:idRasterObjType/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="rowcount">
            <dt><span class="element"><res:idRowCnt/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="colcount">
            <dt><span class="element"><res:idColCnt/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="vrtcount">
            <dt><span class="element"><res:idVertCnt/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- Spatial Reference -->
<xsl:template match="spref" mode="fgdc">
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="horizsys">
        <dt><span class="element"><res:idHorizCoordSysDef/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="geograph">
            <dt><span class="element"><res:idGeographic/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="latres">
                <dt><span class="element"><res:idLatRez/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="longres">
                <dt><span class="element"><res:idLongRez/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="geogunit">
                <dt><span class="element"><res:idGeoCoordUnits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>

          <xsl:for-each select="planar">
            <dt><span class="element"><res:idPlanar/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="mapproj">
                <dt><span class="element"><res:idMapProj/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="mapprojn">
                    <dt><span class="element"><res:idMapProjName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>

                  <xsl:for-each select="albers">
                    <dt><span class="element"><res:idAlbersConicEqArea/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="azimequi">
                    <dt><span class="element"><res:idAzimuthEquidist/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="equicon">
                    <dt><span class="element"><res:idEquidistConic/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="equirect">
                    <dt><span class="element"><res:idEquirect/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="gvnsp">
                    <dt><span class="element"><res:idGenVertNearsidePerspective/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="gnomonic">
                    <dt><span class="element"><res:idGnomonic/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="lamberta">
                    <dt><span class="element"><res:idLambertAzimuthEqArea/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="lambertc">
                    <dt><span class="element"><res:idLambertConfConic/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="mercator">
                    <dt><span class="element"><res:idMercator/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="modsak">
                    <dt><span class="element"><res:idModStereoAlaska/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="miller">
                    <dt><span class="element"><res:idMillerCylind/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="obqmerc">
                    <dt><span class="element"><res:idObliqueMercator/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="orthogr">
                    <dt><span class="element"><res:idOrtho/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="polarst">
                    <dt><span class="element"><res:idPolarStereo/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="polycon">
                    <dt><span class="element"><res:idPolyconic/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="robinson">
                    <dt><span class="element"><res:idRobinson/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="sinusoid">
                    <dt><span class="element"><res:idSinusoidal/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="spaceobq">
                    <dt><span class="element"><res:idSpaceObliqueMercatorLandsat/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="stereo">
                    <dt><span class="element"><res:idStereo/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="transmer">
                    <dt><span class="element"><res:idXverseMercator/></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="vdgrin">
                    <dt><span class="element"><res:idVanderGrinten/></span></dt>
                  </xsl:for-each>

                  <xsl:apply-templates select="*[not(text())]" mode="fgdc"/>
                </dl>
                </dd><br />
              </xsl:for-each>

              <xsl:for-each select="gridsys">
                <dt><span class="element"><res:idGridCoordSys/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="gridsysn">
                    <dt><span class="element"><res:idGridCoordSysName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>

                  <xsl:for-each select="utm">
                    <dt><span class="element"><res:idUnivXverseMercator/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="utmzone">
                        <dt><span class="element"><res:idUtmZoneNum/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="transmer">
                        <dt><span class="element"><res:idXverseMercator_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer" mode="fgdc"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="ups">
                    <dt><span class="element"><res:idUnivPolarStereo/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="upszone">
                        <dt><span class="element"><res:idUpsZoneID/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="polarst">
                        <dt><span class="element"><res:idPolarStereo_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="polarst" mode="fgdc"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="spcs">
                    <dt><span class="element"><res:idStatePlaneCoordSys/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="spcszone">
                        <dt><span class="element"><res:idSpcsZoneID/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="lambertc">
                        <dt><span class="element"><res:idLambertConfConic_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="lambertc" mode="fgdc"/>
                      <xsl:for-each select="transmer">
                        <dt><span class="element"><res:idXverseMercator_FGDC2/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer" mode="fgdc"/>
                      <xsl:for-each select="obqmerc">
                        <dt><span class="element"><res:idObliqueMercator_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="obqmerc" mode="fgdc"/>
                      <xsl:for-each select="polycon">
                        <dt><span class="element"><res:idPolyconic_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="polycon" mode="fgdc"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="arcsys">
                    <dt><span class="element"><res:idArcCoordSys/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="arczone">
                        <dt><span class="element"><res:idArcSysZoneID/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="equirect">
                        <dt><span class="element"><res:idEquirect_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="equirect" mode="fgdc"/>
                      <xsl:for-each select="azimequi">
                        <dt><span class="element"><res:idAzimuthEquidist_FGDC/></span></dt>
                      </xsl:for-each>
                      <xsl:apply-templates select="azimequi" mode="fgdc"/>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="othergrd">
                    <dt><span class="element"><res:idOtherGridSysDef/></span></dt>
                    <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                </dl>
                </dd><br />
              </xsl:for-each>

              <xsl:for-each select="localp">
                <dt><span class="element"><res:idLocalPlanar/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="localpd">
                    <dt><span class="element"><res:idLocalPlanarDesc/></span></dt>
                    <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                  <xsl:for-each select="localpgi">
                    <dt><span class="element"><res:idLocalPlanarGeorefInfo/></span></dt>
                    <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                </dl>
                </dd><br />
              </xsl:for-each>

              <xsl:for-each select="planci">
                <dt><span class="element"><res:idPlanarCoordInfo/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="plance">
                    <dt><span class="element"><res:idPlanarCoordEncodMethod/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="coordrep">
                    <dt><span class="element"><res:idCoordRep/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="absres">
                        <dt><span class="element"><res:idAbscissaReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="ordres">
                        <dt><span class="element"><res:idOrdinateReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>
                  <xsl:for-each select="distbrep">
                    <dt><span class="element"><res:idDistBearingRep/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="distres">
                        <dt><span class="element"><res:idDistReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="bearres">
                        <dt><span class="element"><res:idBearingReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="bearunit">
                        <dt><span class="element"><res:idBearingUnits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="bearrefd">
                        <dt><span class="element"><res:idBearingRefDir/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="bearrefm">
                        <dt><span class="element"><res:idBearingRefMeridian/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>
                  <xsl:for-each select="plandu">
                    <dt><span class="element"><res:idPlanarDistUnits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                </dl>
                </dd><br />
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:for-each select="local">
            <dt><span class="element"><res:idLocal/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="localdes">
                <dt><span class="element"><res:idLocalDesc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="localgeo">
                <dt><span class="element"><res:idLocalGeorefInfo/></span></dt>
                <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>

          <xsl:for-each select="geodetic">
            <dt><span class="element"><res:idGeodeticModel/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="horizdn">
                <dt><span class="element"><res:idHorizDatumName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="ellips">
                <dt><span class="element"><res:idEllipsName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="semiaxis">
                <dt><span class="element"><res:idSemimajorAxis/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="denflat">
                <dt><span class="element"><res:idDenomFlatRatio/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>

      <xsl:for-each select="vertdef">
        <dt><span class="element"><res:idVertCoordSysDef/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="altsys">
            <dt><span class="element"><res:idAltSysDef/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="altdatum">
                <dt><span class="element"><res:idAltDatumName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="altres">
                <dt><span class="element"><res:idAltReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="altunits">
                <dt><span class="element"><res:idAltDistUnits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="altenc">
                <dt><span class="element"><res:idAltEncMethod/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:for-each select="depthsys">
            <dt><span class="element"><res:idDepthSysDef/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="depthdn">
                <dt><span class="element"><res:idDepthDatumName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="depthres">
                <dt><span class="element"><res:idDepthReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="depthdu">
                <dt><span class="element"><res:idDepthDistUnits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="depthem">
                <dt><span class="element"><res:idDepthEncMethod/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- Entity and Attribute -->
<xsl:template match="eainfo" mode="fgdc">
  <a name="Entity and Attribute Information" id="Entity and Attribute Information"></a>
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="detailed">
        <dt><span class="element"><res:idDetailedDesc/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="enttyp">
            <dt><span class="element"><res:idEntityType/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="enttypl">
                <dt><span class="element"><res:idEntityTypeLbl/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="enttypd">
                <dt><span class="element"><res:idEntityTypeDef/></span></dt>
                <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
              </xsl:for-each>
              <xsl:for-each select="enttypds">
                <dt><span class="element"><res:idEntityTypeDefSrc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>

          <xsl:for-each select="attr">
            <dt><span class="element"><res:idAttrib/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="attrlabl">
                <dt><span class="element"><res:idAttribLbl/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>
              <xsl:for-each select="attrdef">
                  <dt><span class="element"><res:idAttribDef/></span></dt>
                  <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
              </xsl:for-each>
              <xsl:for-each select="attrdefs">
                  <dt><span class="element"><res:idAttribDefSrc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
              </xsl:for-each>

              <xsl:for-each select="attrdomv">
                <dt><span class="element"><res:idAttribDomainVals/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="edom">
                    <dt><span class="element"><res:idEnumDomain/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="edomv">
                        <dt><span class="element"><res:idEnumDomainVal/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="edomvd">
                          <dt><span class="element"><res:idEnumDomainValDef/></span></dt>
                          <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                      </xsl:for-each>
                      <xsl:for-each select="edomvds">
                          <dt><span class="element"><res:idEnumDomainValDefSrc/></span></dt>
                          <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                      </xsl:for-each>
                      <xsl:for-each select="attr">
                        <dt><span class="element"><res:idAttrib_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="rdom">
                    <dt><span class="element"><res:idRangeDomain/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="rdommin">
                        <dt><span class="element"><res:idRangeDomainMin/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="rdommax">
                        <dt><span class="element"><res:idRangeDomainMax/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="attrunit">
                        <dt><span class="element"><res:idAttribUnitsMeasure/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="attrmres">
                        <dt><span class="element"><res:idAttribMeasureReso/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="attr">
                        <dt><span class="element"><res:idAttrib_FGDC2/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="codesetd">
                    <dt><span class="element"><res:idCodesetDomain/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="codesetn">
                        <dt><span class="element"><res:idCodesetName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="codesets">
                        <dt><span class="element"><res:idCodesetSrc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="udom">
                    <dt><span class="element"><res:idUnrepDomain/></span></dt>
                    <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>

              <xsl:for-each select="begdatea">
                <dt><span class="element"><res:idBeginDateAttribVals/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
              </xsl:for-each>
              <xsl:for-each select="enddatea">
                <dt><span class="element"><res:idEndDateAttribVals/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
              </xsl:for-each>

              <xsl:for-each select="attrvai">
                <dt><span class="element"><res:idAttribValAccInfo/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="attrva">
                    <dt><span class="element"><res:idAttribValAcc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="attrvae">
                    <dt><span class="element"><res:idAttribValAccExpl/></span></dt>
                    <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
                  </xsl:for-each>
                 </dl>
                </dd>
              </xsl:for-each>
              <xsl:for-each select="attrmfrq">
                <dt><span class="element"><res:idAttribMeasureFreq/></span></dt>
                <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
              </xsl:for-each>
            </dl>
            </dd><br />
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="overview">
        <dt><span class="element"><res:idOverviewDesc/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="eaover">
              <dt><span class="element"><res:idEntityAttribOverview/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>
          <xsl:for-each select="eadetcit">
              <dt><span class="element"><res:idEntityAttribDetailCitation/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- Distribution -->
<xsl:template match="distinfo" mode="fgdc">
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="distrib">
        <dt><span class="element"><res:idDistrib/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="cntinfo" mode="fgdc"/>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="resdesc">
        <dt><span class="element"><res:idResourceDesc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
      </xsl:for-each>
      <xsl:for-each select="distliab">
          <dt><span class="element"><res:idDistribLiability/></span></dt>
          <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
      </xsl:for-each>

      <xsl:for-each select="stdorder">
        <dt><span class="element"><res:idStdOrderProc/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="nondig">
            <dt><span class="element"><res:idNondigitalForm/></span></dt>
            <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
          </xsl:for-each>
          <xsl:for-each select="digform">
            <dt><span class="element"><res:idDigitalForm/></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="digtinfo">
                <dt><span class="element"><res:idDigitalXferInfo/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="formname">
                    <dt><span class="element"><res:idFormatName_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="formvern">
                    <dt><span class="element"><res:idFormatVersNum/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="formverd">
                    <dt><span class="element"><res:idFormatVersDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="formspec">
                      <dt><span class="element"><res:idFormatSpec/></span></dt>
                      <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                  <xsl:for-each select="formcont">
                      <dt><span class="element"><res:idFormatInfoContent/></span></dt>
                      <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                  </xsl:for-each>
                  <xsl:for-each select="filedec">
                    <dt><span class="element"><res:idFileDecompressTech/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                  <xsl:for-each select="transize">
                    <dt><span class="element"><res:idXferSize/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                  </xsl:for-each>
                </dl>
                </dd><br />
              </xsl:for-each>

              <xsl:for-each select="digtopt">
                <dt><span class="element"><res:idDigitalXferOpt/></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="onlinopt">
                    <dt><span class="element"><res:idOnlineOpt/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="computer">
                        <dt><span class="element"><res:idCompContactInfo/></span></dt>
                        <dd>
                        <dl>
                          <xsl:for-each select="networka">
                            <dt><span class="element"><res:idNetAddr/></span></dt>
                            <dd>
                            <dl>
                              <xsl:for-each select="networkr">
                                <dt><span class="element"><res:idNetResName/></span>&#x2003;<a target="viewer">
                                  <xsl:attribute name="href"><xsl:value-of select = "." /></xsl:attribute>
                                  <xsl:value-of select = "." /></a>
                                </dt>
                              </xsl:for-each>
                            </dl>
                            </dd><br />
                          </xsl:for-each>

                          <xsl:for-each select="dialinst">
                            <dt><span class="element"><res:idDialupInst/></span></dt>
                            <dd>
                            <dl>
                              <xsl:for-each select="lowbps">
                                <dt><span class="element"><res:idLowestBPS/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="highbps">
                                <dt><span class="element"><res:idHighestBPS/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="numdata">
                                <dt><span class="element"><res:idNumDataBits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="numstop">
                                <dt><span class="element"><res:idNumStopBits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="parity">
                                <dt><span class="element"><res:idParity/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="compress">
                                <dt><span class="element"><res:idCompressionSupport/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="dialtel">
                                <dt><span class="element"><res:idDialupTelephone/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                              <xsl:for-each select="dialfile">
                                <dt><span class="element"><res:idDialupFileName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                              </xsl:for-each>
                            </dl>
                            </dd><br />
                          </xsl:for-each>
                        </dl>
                        </dd>
                      </xsl:for-each>
                      <xsl:for-each select="accinstr">
                        <dt><span class="element"><res:idAccessInst/></span></dt>
                        <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
                      </xsl:for-each>
                      <xsl:for-each select="oncomp">
                        <dt><span class="element"><res:idOnlineCompOS/></span></dt>
                        <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
						<br /><br />
                      </xsl:for-each>
                    </dl>
                    </dd>
                  </xsl:for-each>

                  <xsl:for-each select="offoptn">
                    <dt><span class="element"><res:idOfflineOpt/></span></dt>
                    <dd>
                    <dl>
                      <xsl:for-each select="offmedia">
                        <dt><span class="element"><res:idOfflineMedia/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="reccap">
                        <dt><span class="element"><res:idRecordCap/></span></dt>
                        <dd>
                        <dl>
                          <xsl:for-each select="recden">
                            <dt><span class="element"><res:idRecordDensity/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                          </xsl:for-each>
                          <xsl:for-each select="recdenu">
                            <dt><span class="element"><res:idRecordDensityUnits/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                          </xsl:for-each>
                        </dl>
                        </dd>
                      </xsl:for-each>
                      <xsl:for-each select="recfmt">
                        <dt><span class="element"><res:idRecordFormat/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
                      </xsl:for-each>
                      <xsl:for-each select="compat">
                        <dt><span class="element"><res:idCompatInfo/></span></dt>
                        <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
                      </xsl:for-each>
                    </dl>
                    </dd><br />
                  </xsl:for-each>
                </dl>
                </dd>
              </xsl:for-each>
            </dl>
            </dd>
          </xsl:for-each>

          <xsl:for-each select="fees">
            <dt><span class="element"><res:idFees_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="ordering">
              <dt><span class="element"><res:idOrderInst/></span></dt>
              <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
          </xsl:for-each>
          <xsl:for-each select="turnarnd">
            <dt><span class="element"><res:idTurnaround_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
		  <xsl:if test="fees or ordering or turnaround"><br /><br /></xsl:if>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="custom">
          <dt><span class="element"><res:idCustOrderProc/></span></dt>
          <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
      </xsl:for-each>
      <xsl:for-each select="techpreq">
        <dt><span class="element"><res:idTechPrereqs/></span></dt>
        <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
      </xsl:for-each>
      <xsl:for-each select="availabl">
        <dt><span class="element"><res:idAvailTimePeriod/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="timeinfo" mode="fgdc"/>
        </dl>
        </dd>
      </xsl:for-each>
	  <xsl:if test="custom or techpreq or availabl"><br /><br /></xsl:if>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- Metadata -->
<xsl:template match="metainfo" mode="fgdc">
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="metd">
        <dt><span class="element"><res:idMetaDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
      </xsl:for-each>
      <xsl:for-each select="metrd">
        <dt><span class="element"><res:idMetaRevDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
      </xsl:for-each>
      <xsl:for-each select="metfrd">
        <dt><span class="element"><res:idMetaFutureRevDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
      </xsl:for-each>

      <xsl:for-each select="metc">
        <dt><span class="element"><res:idMetaContact/></span></dt>
        <dd>
        <dl>
          <xsl:apply-templates select="cntinfo" mode="fgdc"/>
        </dl>
        </dd>
      </xsl:for-each>

      <xsl:for-each select="metstdn">
        <dt><span class="element"><res:idMetaStdName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
      </xsl:for-each>
      <xsl:for-each select="metstdv">
        <dt><span class="element"><res:idMetaStdVers/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
      </xsl:for-each>
      <xsl:for-each select="mettc">
        <dt><span class="element"><res:idMetaTimeConvention/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
      </xsl:for-each>
	  <xsl:if test="metstdn or metstdv or mettc"><br /><br /></xsl:if>
	  
      <xsl:for-each select="metac">
        <dt><span class="element"><res:idMetaAccConst/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
      </xsl:for-each>
      <xsl:for-each select="metuc">
        <dt><span class="element"><res:idMetaUseConst/></span></dt>
        <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
      </xsl:for-each>

      <xsl:for-each select="metsi">
        <dt><span class="element"><res:idMetaSecInfo/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="metscs">
            <dt><span class="element"><res:idMetaSecClassSys/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="metsc">
            <dt><span class="element"><res:idMetaSecClass/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
          <xsl:for-each select="metshd">
            <dt><span class="element"><res:idMetaSecHandDesc/></span></dt>
            <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
          </xsl:for-each>
        </dl>
        </dd><br />
      </xsl:for-each>

      <xsl:for-each select="metextns">
        <dt><span class="element"><res:idMetaExts/></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="onlink">
            <dt><span class="element"><res:idOnlineLinkage/></span>&#x2003;<span class="textOld"><xsl:call-template name="urlType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
          </xsl:for-each>
          <xsl:for-each select="metprof">
            <dt><span class="element"><res:idProfileName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
          </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl><br />
</xsl:template>

<!-- Citation -->
<xsl:template match="citeinfo" mode="fgdc">
  <dt><span class="element"><res:idCitationInfo/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="origin">
      <dt><span class="element"><res:idOriginator/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>

    <xsl:for-each select="pubdate">
      <dt><span class="element"><res:idPublicationDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
    <xsl:for-each select="pubtime">
      <dt><span class="element"><res:idPublicationTime/></span>&#x2003;<span class="textOld"><xsl:call-template name="timeType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>

    <xsl:for-each select="title">
      <dt><span class="element"><res:idTitle_FGDC/></span></dt>
      <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
    </xsl:for-each>
    <xsl:for-each select="edition">
      <dt><span class="element"><res:idEdition_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>

    <xsl:for-each select="geoform">
      <dt><span class="element"><res:idGeoDataPresentationForm/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>

    <xsl:for-each select="serinfo">
      <dt><span class="element"><res:idSeriesInfo/></span></dt>
      <dd>
      <dl>
        <xsl:for-each select="sername">
          <dt><span class="element"><res:idSeriesName/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="issue">
          <dt><span class="element"><res:idIssueID/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
      </dl>
      </dd>
    </xsl:for-each>

    <xsl:for-each select="pubinfo">
      <dt><span class="element"><res:idPublicationInfo/></span></dt>
      <dd>
      <dl>
        <xsl:for-each select="pubplace">
          <dt><span class="element"><res:idPublicationPlace/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="publish">
          <dt><span class="element"><res:idPublisher/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
      </dl>
      </dd>
    </xsl:for-each>

    <xsl:for-each select="othercit">
      <dt><span class="element"><res:idOtherCitationDetails_FGDC/></span></dt>
      <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
    </xsl:for-each>

    <xsl:for-each select="onlink">
      <dt><span class="element"><res:idOnlineLinkage_FGDC/></span>&#x2003;<a target="viewer">
        <xsl:attribute name="href"><xsl:value-of select = "." /></xsl:attribute>
        <span class="textOld"><xsl:value-of select = "." /></span></a>
      </dt>
    </xsl:for-each>

    <xsl:for-each select="lworkcit">
      <dt><span class="element"><res:idLargerWorkCitation/></span></dt>
      <dd>
      <dl>
        <xsl:apply-templates select="citeinfo" mode="fgdc"/>
      </dl>
      </dd>
    </xsl:for-each>
  </dl>
  </dd><br />
</xsl:template>

<!-- Contact -->
<xsl:template match="cntinfo" mode="fgdc">
  <dt><span class="element"><res:idContactInfo/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="cntperp">
      <dt><span class="element"><res:idContactPersonPrimary/></span></dt>
      <dd>
      <dl>
        <xsl:for-each select="cntper">
          <dt><span class="element"><res:idContactPerson/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="cntorg">
          <dt><span class="element"><res:idContactOrg/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
      </dl>
      </dd>
    </xsl:for-each>
    <xsl:for-each select="cntorgp">
      <dt><span class="element"><res:idContactOrgPrimary/></span></dt>
      <dd>
      <dl>
        <xsl:for-each select="cntorg">
          <dt><span class="element"><res:idContactOrg_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="cntper">
          <dt><span class="element"><res:idContactPerson_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
      </dl>
      </dd>
    </xsl:for-each>
    <xsl:for-each select="cntpos">
      <dt><span class="element"><res:idContactPosition/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>

    <xsl:for-each select="cntaddr">
      <dt><span class="element"><res:idContactAddr/></span></dt>
      <dd>
      <dl>
        <xsl:for-each select="addrtype">
          <dt><span class="element"><res:idAddrType/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="address">
            <dt><span class="element"><res:idAddr/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="city">
          <dt><span class="element"><res:idCity_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="state">
          <dt><span class="element"><res:idStateProvince/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="postal">
          <dt><span class="element"><res:idPostalCode_FGDC/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="country">
          <dt><span class="element"><res:idCountry_FGDC/></span>&#x2003;<span class="textOld"><xsl:apply-templates select="."  mode="arcgis"/></span></dt>
        </xsl:for-each>
      </dl>
      </dd><br />
    </xsl:for-each>

    <xsl:for-each select="cntvoice">
      <dt><span class="element"><res:idContactVoiceTelephone/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
    <xsl:for-each select="cnttdd">
      <dt><span class="element"><res:idContactTDDTTYTelephone/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
    <xsl:for-each select="cntfax">
      <dt><span class="element"><res:idContactFaxTelephone/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
    <xsl:for-each select="cntemail">
      <dt><span class="element"><res:idContactEmailAddr/></span>&#x2003;<a>
			<xsl:attribute name="href">mailto:<xsl:value-of select="."/>?subject=<xsl:value-of select="/metadata/dataIdInfo/idCitation/resTitle"/></xsl:attribute><xsl:value-of select="."/></a></dt>
    </xsl:for-each>

    <xsl:for-each select="hours">
      <dt><span class="element"><res:idHrsSvc/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
    <xsl:for-each select="cntinst">
      <dt><span class="element"><res:idContactInst/></span></dt>
      <dl><dd><pre class="wrap"><span class="textOld"><xsl:value-of select = "." /></span></pre></dd></dl>
    </xsl:for-each>
  </dl>
  </dd><br />
</xsl:template>

<!-- language code list from ISO 639 -->
<xsl:template match="country" mode="arcgis">
    <xsl:call-template name="ISO3166_CountryCode">
		<xsl:with-param name="code" select="." />
	</xsl:call-template>
</xsl:template>

<!-- Time Period Info -->
<xsl:template match="timeinfo" mode="fgdc">
  <dt><span class="element"><res:idTimePeriodInfo/></span></dt>
  <dd>
  <dl>
    <xsl:apply-templates select="sngdate" mode="fgdc"/>
    <xsl:apply-templates select="mdattim" mode="fgdc"/>
    <xsl:apply-templates select="rngdates" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<!-- Single Date/Time -->
<xsl:template match="sngdate" mode="fgdc">
  <dt><span class="element"><res:idSingleDateTime/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="caldate">
      <dt><span class="element"><res:idCalendarDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
    <xsl:for-each select="time">
      <dt><span class="element"><res:idTimeDay/></span>&#x2003;<span class="textOld"><xsl:call-template name="timeType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<!-- Multiple Date/Time -->
<xsl:template match="mdattim" mode="fgdc">
  <dt><span class="element"><res:idMultDatesTimes/></span></dt>
  <dd>
  <dl>
    <xsl:apply-templates select="sngdate" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<!-- Range of Dates/Times -->
<xsl:template match="rngdates" mode="fgdc">
  <dt><span class="element"><res:idRangeDatesTimes/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="begdate">
      <dt><span class="element"><res:idBeginDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
    <xsl:for-each select="begtime">
      <dt><span class="element"><res:idBeginTime/></span>&#x2003;<span class="textOld"><xsl:call-template name="timeType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
    <xsl:for-each select="enddate">
      <dt><span class="element"><res:idEndDate/></span>&#x2003;<span class="textOld"><xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
    <xsl:for-each select="endtime">
      <dt><span class="element"><res:idEndTime/></span>&#x2003;<span class="textOld"><xsl:call-template name="timeType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></span></dt>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<!-- G-Ring -->
<xsl:template match="grngpoin" mode="fgdc">
  <dt><span class="element"><res:idGRingPoint/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="gringlat">
      <dt><span class="element"><res:idGRingLat/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
        </xsl:for-each>
        <xsl:for-each select="gringlon">
      <dt><span class="element"><res:idGRingLong/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>
<xsl:template match="gring" mode="fgdc">
  <dt><span class="element"><res:idGRing/></span></dt>
  <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
</xsl:template>


<!-- Map Projections -->
<xsl:template match="albers | equicon | lambertc" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="stdparll" mode="fgdc"/>
    <xsl:apply-templates select="longcm" mode="fgdc"/>
    <xsl:apply-templates select="latprjo" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="gnomonic | lamberta | orthogr | stereo | gvnsp" mode="fgdc">
  <dd>
  <dl>
    <xsl:for-each select="../gvnsp">
      <xsl:apply-templates select="heightpt" mode="fgdc"/>
    </xsl:for-each>
    <xsl:apply-templates select="longpc" mode="fgdc"/>
    <xsl:apply-templates select="latprjc" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="azimequi | polycon | transmer" mode="fgdc">
  <dd>
  <dl>
    <xsl:for-each select="../transmer">
      <xsl:apply-templates select="sfctrmer" mode="fgdc"/>
    </xsl:for-each>
    <xsl:apply-templates select="longcm" mode="fgdc"/>
    <xsl:apply-templates select="latprjo" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="miller | sinusoid | vdgrin" mode="fgdc">
  <dd>
  <dl>
    <xsl:for-each select="../equirect">
      <xsl:apply-templates select="stdparll" mode="fgdc"/>
    </xsl:for-each>
    <xsl:for-each select="../mercator">
      <xsl:apply-templates select="stdparll" mode="fgdc"/>
      <xsl:apply-templates select="sfequat" mode="fgdc"/>
    </xsl:for-each>
    <xsl:apply-templates select="longcm" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="equirect" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="stdparll" mode="fgdc"/>
    <xsl:apply-templates select="longcm" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="mercator" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="stdparll" mode="fgdc"/>
    <xsl:apply-templates select="sfequat" mode="fgdc"/>
    <xsl:apply-templates select="longcm" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="polarst" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="svlong" mode="fgdc"/>
    <xsl:apply-templates select="stdparll" mode="fgdc"/>
    <xsl:apply-templates select="sfprjorg" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="obqmerc" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="sfctrlin" mode="fgdc"/>
    <xsl:apply-templates select="obqlazim" mode="fgdc"/>
    <xsl:apply-templates select="obqlpt" mode="fgdc"/>
    <xsl:apply-templates select="latprjo" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="spaceobq" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="landsat" mode="fgdc"/>
    <xsl:apply-templates select="pathnum" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="robinson" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="longpc" mode="fgdc"/>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="modsak" mode="fgdc">
  <dd>
  <dl>
    <xsl:apply-templates select="feast" mode="fgdc"/>
    <xsl:apply-templates select="fnorth" mode="fgdc"/>
  </dl>
  </dd>
</xsl:template>


<!-- Map Projection Parameters -->
<xsl:template match="stdparll" mode="fgdc">
  <dt><span class="element"><res:idStdParallel/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="longcm" mode="fgdc">
  <dt><span class="element"><res:idLongCentMeridian/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="latprjo" mode="fgdc">
  <dt><span class="element"><res:idLatProjOrigin/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="feast" mode="fgdc">
  <dt><span class="element"><res:idFalseEasting/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="fnorth" mode="fgdc">
  <dt><span class="element"><res:idFalseNorthing/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="sfequat" mode="fgdc">
  <dt><span class="element"><res:idScaleFactEquator/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="heightpt" mode="fgdc">
  <dt><span class="element"><res:idHeightPerspectivePtAboveSurf/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="longpc" mode="fgdc">
  <dt><span class="element"><res:idLongProjCenter/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="latprjc" mode="fgdc">
  <dt><span class="element"><res:idLatProjCenter/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="sfctrlin" mode="fgdc">
  <dt><span class="element"><res:idScaleFactCenterLine/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="obqlazim" mode="fgdc">
  <dt><span class="element"><res:idObliqueLineAzimuth/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="azimangl">
      <dt><span class="element"><res:idAzimuthAngle/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
    <xsl:for-each select="azimptl">
      <dt><span class="element"><res:idAzimuthMeasurePtLong/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="obqlpt" mode="fgdc">
  <dt><span class="element"><res:idObliqueLinePt/></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="obqllat">
      <dt><span class="element"><res:idObliqueLineLat/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
    <xsl:for-each select="obqllong">
       <dt><span class="element"><res:idObliqueLineLong/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
    </xsl:for-each>
  </dl>
  </dd>
</xsl:template>

<xsl:template match="svlong" mode="fgdc">
  <dt><span class="element"><res:idStraightVertLongPole/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="sfprjorg" mode="fgdc">
  <dt><span class="element"><res:idScaleFactProjOrigin/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="landsat" mode="fgdc">
  <dt><span class="element"><res:idLandsatNum/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="pathnum" mode="fgdc">
  <dt><span class="element"><res:idPathNum/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="sfctrmer" mode="fgdc">
  <dt><span class="element"><res:idScaleFactCentMeridian/></span>&#x2003;<span class="textOld"><xsl:value-of select = "." /></span></dt>
</xsl:template>

<xsl:template match="otherprj" mode="fgdc">
  <dt><span class="element"><res:idOtherProjDef/></span></dt>
  <dd><span class="textOld"><xsl:value-of select = "." /></span></dd>
</xsl:template>

</xsl:stylesheet>