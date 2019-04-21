<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Header">
    <xsl:param name="Header"/>
    <xsl:param name="ExtractExists"/>
    <xsl:param name="NoticeExists"/>
    <xsl:param name="Recipient"/>
    <xsl:param name="Agent"/>
    <xsl:param name="Address"/>
    <div class="c">
      <xsl:choose>
        <xsl:when test="$Recipient">
          <div class="NoticeHeaderMargin">&#160;</div>
          <table class="c" border="0" cellpadding="2" cellspacing="0" width="100%">
            <tr>
              <td class="vc" width="50%">
                <div class="NoticeHeaderHeight">&#160;</div>
                <div class="NoticeHeaderTitle">
                  <p>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Header/Title"/>
                    </xsl:call-template>
                  </p>
                </div>
                <div class="NoticeHeaderDept">
                  <p>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Header/DeptName"/>
                    </xsl:call-template>
                  </p>
                </div>
              </td>
              <td class="vc">
                <p>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="$Recipient"/>
                    <xsl:with-param name="IsDuplicate" select="$NoticeExists > 0"/>
                  </xsl:call-template>
                  <xsl:if test="$Agent">
                    <br/>
                    <xsl:text>(</xsl:text>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Agent"/>
                      <xsl:with-param name="IsDuplicate" select="$NoticeExists > 0"/>
                    </xsl:call-template>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </p>
                <p>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="$Address"/>
                    <xsl:with-param name="IsDuplicate" select="$NoticeExists > 0"/>
                  </xsl:call-template>
                </p>
              </td>
            </tr>
          </table>
          <p>
            <b>
              <xsl:call-template name="Value">
                <xsl:with-param name="Node" select="$Header/ExtractTitle"/>
              </xsl:call-template>
            </b>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <div class="ExtractHeaderMargin">&#160;</div>
          <div class="ExtractHeaderTitle">
            <p>
              <b>
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="$Header/ExtractTitle"/>
                </xsl:call-template>
              </b>
            </p>
            <p>
              <xsl:call-template name="Value">
                <xsl:with-param name="Node" select="$Header/Title"/>
              </xsl:call-template>
            </p>
          </div>
          <div class="ExtractHeaderDept">
            <p>
              <xsl:call-template name="Value">
                <xsl:with-param name="Node" select="$Header/DeptName"/>
              </xsl:call-template>
            </p>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
      <tr>
        <td width="1%">Дата&#160;</td>
        <td width="15%" class="ul">
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="parent::ReestrExtract/DeclarAttribute/@ExtractDate"/>
            <xsl:with-param name="IsDuplicate" select="$ExtractExists > 0 or $NoticeExists > 0"/>
          </xsl:call-template>
        </td>
        <td align="right">№&#160;</td>
        <td width="35%" class="ul">
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="parent::ReestrExtract/DeclarAttribute/@ExtractNumber"/>
            <xsl:with-param name="IsDuplicate" select="$ExtractExists > 0 or $NoticeExists > 0"/>
          </xsl:call-template>
        </td>
      </tr>
    </table>
    <p>
      <xsl:call-template name="Value">
        <xsl:with-param name="Node" select="$Header/Content"/>
      </xsl:call-template>
    </p>
  </xsl:template>
</xsl:stylesheet>
