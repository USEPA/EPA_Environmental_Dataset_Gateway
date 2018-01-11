<?xml version="1.0" ?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" />

		<xsl:template match="/">
				<H2>WAFer<BR/><BR/>Available WAF Folders:</H2>
				<xsl:apply-templates select="SOURCES" />
		</xsl:template>
		
		<xsl:template match="SOURCES">
				<xsl:for-each select="SOURCE">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="./@shortName"/>/</xsl:attribute>
						<xsl:value-of select="./@longName"/> [<xsl:value-of select="./@type"/>]
					</A><BR/>
				</xsl:for-each>
		</xsl:template>
</xsl:stylesheet>
