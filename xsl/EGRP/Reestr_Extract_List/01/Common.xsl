<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:include href="Header.xsl"/>
	<xsl:include href="HeaderNotice.xsl"/>
	<xsl:include href="Footer.xsl"/>
	<xsl:include href="DateNumber.xsl"/>
	<xsl:include href="Request.xsl"/>
	<xsl:include href="Unit.xsl"/>
	<xsl:include href="Assignation.xsl"/>
	<xsl:include href="Area.xsl"/>
	<xsl:include href="Reestr_Extract_List.xsl"/>
	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>
</xsl:stylesheet>
