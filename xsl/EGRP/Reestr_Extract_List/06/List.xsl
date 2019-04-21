<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="ExtractCount" select="count(//ReestrExtract/ExtractObjectRight)"/>
  <xsl:variable name="NoticeCount" select="count(//ReestrExtract/NoticelObj)"/>
  <xsl:variable name="RefusalCount" select="count(//ReestrExtract/RefusalObj)"/>
  <xsl:template match="Extract[eDocument[@Version='06']]">
    <html>
      <head>
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
        <title>Выписка из ЕГРП о переходе прав на объект (версия 06)</title>
        <style type="text/css">
          html, body, table { font: 12pt Times New Roman }
          p, .t { margin: 10pt 0 10pt 0 }
          tr, .note { vertical-align: top }
          table, .file { text-align: justify }
          .file { width: 17cm }
          .edoc, .ndoc, .rdoc { margin-bottom: 2cm }
          <xsl:if test="$ExtractCount = 1 and ($NoticeCount + $RefusalCount) > 0">
            .edoc { page-break-after: always }
          </xsl:if>
          <xsl:if test="($NoticeCount + $RefusalCount) = 2">
            .ndoc { page-break-after: always }
          </xsl:if>
          .vc { vertical-align: middle }
          .ul, .ful, .note, .c { text-align: center }
          .ul, .ful { vertical-align: bottom; border-bottom: solid 1pt black }
          .ful { font-size: 85% }
          .note { font-size: 50%; line-height: normal }
          .sr { padding: 0 5pt 0 0 }
          .NoticeHeaderMargin, .NoticeHeaderHeight, .ExtractHeaderMargin { display: none }
          @media print
          {
          body { margin: 0 }
          .file { width: 100% }
          .edoc, .ndoc, .rdoc { margin-bottom: 0 }
          }
        </style>
      </head>
      <body>
        <div class="file">
          <xsl:apply-templates />
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="ExtractObjectRight">
    <div class="edoc">
      <xsl:call-template name="Header">
        <xsl:with-param name="Header" select="HeadContent"/>
      </xsl:call-template>
      <xsl:call-template name="Extract">
        <xsl:with-param name="Extract" select="ExtractObject"/>
      </xsl:call-template>
      <xsl:call-template name="Footer">
        <xsl:with-param name="Footer" select="FootContent" />
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="NoticelObj">
    <div class="ndoc">
      <xsl:call-template name="Header">
        <xsl:with-param name="Header" select="HeadContent"/>
        <xsl:with-param name="ExtractExists" select="$ExtractCount > 0"/>
        <xsl:with-param name="Recipient" select="parent::ReestrExtract/DeclarAttribute/ReceivName"/>
        <xsl:with-param name="Agent" select="parent::ReestrExtract/DeclarAttribute/Representativ"/>
        <xsl:with-param name="Address" select="parent::ReestrExtract/DeclarAttribute/ReceivAdress"/>
      </xsl:call-template>
      <xsl:call-template name="Notice">
        <xsl:with-param name="Notice" select="NoticeObj"/>
      </xsl:call-template>
      <xsl:call-template name="Footer">
        <xsl:with-param name="Footer" select="FootContent" />
        <xsl:with-param name="IsDuplicate" select="$ExtractCount > 0"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="RefusalObj">
    <div class="rdoc">
      <xsl:call-template name="Header">
        <xsl:with-param name="Header" select="HeadContent"/>
        <xsl:with-param name="ExtractExists" select="$ExtractCount > 0"/>
        <xsl:with-param name="NoticeExists" select="$NoticeCount > 0"/>
        <xsl:with-param name="Recipient" select="parent::ReestrExtract/DeclarAttribute/ReceivName"/>
        <xsl:with-param name="Agent" select="parent::ReestrExtract/DeclarAttribute/Representativ"/>
        <xsl:with-param name="Address" select="parent::ReestrExtract/DeclarAttribute/ReceivAdress"/>
      </xsl:call-template>
      <xsl:call-template name="Refusal">
        <xsl:with-param name="Refusal" select="RefusalObj"/>
      </xsl:call-template>
      <xsl:call-template name="Footer">
        <xsl:with-param name="Footer" select="FootContent" />
        <xsl:with-param name="IsDuplicate" select="($ExtractCount + $NoticeCount) > 0"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="DeclarAttribute" />
</xsl:stylesheet>
