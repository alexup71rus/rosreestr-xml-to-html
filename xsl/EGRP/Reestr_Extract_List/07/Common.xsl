<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Header.xsl"/>
  <xsl:include href="Footer.xsl"/>
  <xsl:include href="Extract.xsl"/>
  <xsl:include href="Notice.xsl"/>
  <xsl:include href="Refusal.xsl"/>
  <xsl:include href="Output.xsl"/>
  <xsl:include href="List.xsl"/>
  <xsl:template match="/">
     <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>
