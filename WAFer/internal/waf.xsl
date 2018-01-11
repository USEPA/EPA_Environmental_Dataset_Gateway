<?xml version="1.0" ?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="html" />

	<xsl:template match="/">
		<xsl:apply-templates select="datalayers" />
	</xsl:template>
	
	<xsl:template match="datalayers">
		<H2><xsl:value-of select="@longName"/> Metadata:</H2>
		<PRE>
		<xsl:for-each select="datalayer">
			<xsl:text>&#xa;</xsl:text>
			<xsl:value-of select="metadatadate"/>
			<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
			<A>
				<xsl:attribute name="href">get.jsp?folder=<xsl:value-of select="../@folder"/>&amp;id=<xsl:value-of select="datasetid"/>_<xsl:value-of select="layername/@encoded"/></xsl:attribute>
				<xsl:value-of select="layername"/>
			</A>
		</xsl:for-each>
		</PRE>
	</xsl:template>
</xsl:stylesheet>
