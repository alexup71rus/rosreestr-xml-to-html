<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Header">
		<p align="center">
			ФЕДЕРАЛЬНАЯ СЛУЖБА ГОСУДАРСТВЕННОЙ РЕГИСТРАЦИИ,<br/>КАДАСТРА И КАРТОГРАФИИ
		</p>
		<p align="center">
			<xsl:value-of select="eDocument/Sender/@Name" />
		</p>
	</xsl:template>
</xsl:stylesheet>
