<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Notice">
    <xsl:param name="Notice"/>
    <xsl:for-each select="$Notice">
      <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
        <tr>
          <td width="1%">1.</td>
          <td width="40%">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Вид запрошенной информации:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="TypeInfoText"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>2.</td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Содержание запроса:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDetail">
                    <xsl:text>наименование: </xsl:text>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDetail/Name"/>
                    </xsl:call-template>
                    <xsl:if test="ObjectDetail/ObjectTypeText">
                      <xsl:text>; вид: </xsl:text>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="ObjectDetail/ObjectTypeText"/>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="ObjectDetail/CadastralNumber">
                        <xsl:text>; кадастровый номер: </xsl:text>
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="ObjectDetail/CadastralNumber"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="ObjectDetail/ConditionalNumber">
                            <xsl:text>; условный номер: </xsl:text>
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="ObjectDetail/ConditionalNumber"/>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="ObjectDetail/ObjectAddress/Content">
                      <xsl:text>; адрес (местоположение): </xsl:text>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="ObjectDetail/ObjectAddress/Content"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectInfo"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ContentReqe"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>3.</td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Причины направления уведомления:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="Reason"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>        
        <tr>
          <td>4.</td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Правопритязания:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RightAssert"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>5.</td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Заявленные в судебном порядке права требования, аресты (запрещения):</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ClaimArrests"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
