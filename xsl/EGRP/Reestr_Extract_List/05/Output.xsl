<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Value">
    <xsl:param name="Node"/>
    <xsl:call-template name="Replace">
      <xsl:with-param name="Old" select="'&#10;'"/>
      <xsl:with-param name="New">
        <br/>
      </xsl:with-param>
      <xsl:with-param name="Text">
        <xsl:call-template name="Replace">
          <xsl:with-param name="Old" select="';'"/>
          <xsl:with-param name="New" select="'; '" />
          <xsl:with-param name="Text">
            <xsl:call-template name="Replace">
              <xsl:with-param name="Old" select="','"/>
              <xsl:with-param name="New" select="', '" />
              <xsl:with-param name="Text" select="$Node" />
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="Panel">
    <xsl:param name="Text"/>
    <xsl:copy-of select="$Text"/>
  </xsl:template>
  <xsl:template name="Replace">
    <xsl:param name="Text"/>
    <xsl:param name="Old"/>
    <xsl:param name="New"/>
    <xsl:choose>
      <xsl:when test="contains($Text, $Old)">
        <xsl:variable name="Before" select="substring-before($Text, $Old)"/>
        <xsl:value-of select="$Before"/>
        <xsl:choose>
          <xsl:when test="string($New)">
            <xsl:value-of select="$New"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$New"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="Replace">
          <xsl:with-param name="Text">
            <xsl:choose>
              <xsl:when test="string-length($Before) > 0 and $Before = substring-before($Text, $New)">
                <xsl:value-of select="substring-after($Text, $New)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after($Text, $Old)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="Old" select="$Old"/>
          <xsl:with-param name="New" select="$New"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
