<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Footer">
    <xsl:param name="Footer" />
    <xsl:param name="IsDuplicate" />
    <p>
      <xsl:call-template name="Value">
        <xsl:with-param name="Node" select="$Footer/Content"/>
      </xsl:call-template>
    </p>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td width="40%" class="ful">
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="//Extract/eDocument/Sender/@Appointment"/>
            <xsl:with-param name="IsDuplicate" select="$IsDuplicate"/>
          </xsl:call-template>
        </td>
				<td width="1%">&#160;</td>
				<td width="12%" class="ful">&#160;</td>
				<td width="1%">&#160;</td>
				<td class="ful">
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="parent::ReestrExtract/DeclarAttribute/@Registrator"/>
            <xsl:with-param name="IsDuplicate" select="$IsDuplicate"/>
          </xsl:call-template>
        </td>
			</tr>
			<tr>
				<td class="note">(должность уполномоченного должностного лица органа, осуществляющего государственную регистрацию прав)</td>
				<td>&#160;</td>
				<td class="note">(подпись, М.П.)</td>
				<td>&#160;</td>
				<td class="note">(фамилия, инициалы)</td>
			</tr>
		</table>
    <br/>
    <br/>
    <center>
      <div style="font-size: small">
        <span class="sr">
          Получение заявителем выписки из ЕГРП для последующего предоставления в органы государственной власти,
          органы местного самоуправления и органы государственных внебюджетных фондов в целях получения государственных
          и муниципальных услуг
        </span>
        <B>
          <span class="sr">
            не требуется.
          </span>
        </B>
        <span class="sr">
          Данную информацию указанные органы
        </span>
        <B>
          <span class="sr">
            обязаны
          </span>
        </B>
        <span class="sr">
          запрашивать у Росреестра
        </span>
        <B>
          самостоятельно.
        </B>
        (Федеральный закон от 27.07.2010 №210-ФЗ "Об организации предоставления государственных и муниципальных услуг", ч.1, ст.7)
      </div>
    </center>
    <div style="font-size: x-small">
      <xsl:choose>
        <xsl:when test="$Footer/ExtractRegion/Region">
          <br/>
          <xsl:text>Сведения сформированы по информации предоставленной следующими управлениями Росреестра:</xsl:text>
          <br/>
          <xsl:for-each select="$Footer/ExtractRegion/Region">
            <xsl:value-of select="./text()"/>
            <xsl:text>;</xsl:text>
            <br/>
          </xsl:for-each>
          <xsl:text>конец списка.</xsl:text>
        </xsl:when>
        <xsl:otherwise>&#160;</xsl:otherwise>
      </xsl:choose>
    </div>
	</xsl:template>
</xsl:stylesheet>
