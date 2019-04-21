<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Footer">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td width="44%" align="center" valign="bottom" style="border-bottom: solid 1pt black">Государственный регистратор</td>
				<td width="2%">&#160;</td>
				<td width="15%" style="border-bottom: solid 1pt black">&#160;</td>
				<td width="2%">&#160;</td>
				<td valign="bottom" align="center" style="border-bottom: solid 1pt black"><xsl:value-of select="ReestrExtract/@Registrator"/></td>
			</tr>
			<tr>
				<td valign="top" align="center" style="font-size:8pt">(должность уполномоченного должностного лица органа, осуществляющего государственную регистрацию прав)</td>
				<td>&#160;</td>
				<td valign="top" align="center" style="font-size:8pt">(подпись, М.П.)</td>
				<td>&#160;</td>
				<td valign="top" align="center" style="font-size:8pt">(фамилия, инициалы)</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
