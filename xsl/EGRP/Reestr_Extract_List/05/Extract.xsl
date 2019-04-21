<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Extract">
    <xsl:param name="Extract"/>
    <xsl:for-each select="$Extract">
      <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
        <xsl:variable name="Mdf_Obj" select="count(ObjectDesc/MdfDate)"/>
        <tr>
          <td rowspan="{10+$Mdf_Obj}" width="1%">1.</td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>Характеристики объекта недвижимости:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text> </xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>  
          <td colspan="2" width="30%">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <span class="sr">Кадастровый (или</span>
                <xsl:choose>
                  <xsl:when test="ObjectDesc/ConditionalNumber">
                    <u>условный</u>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>условный</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text>) номер объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/CadastralNumber">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/CadastralNumber"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/ConditionalNumber"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>наименование объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectDesc/Name"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>назначение объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/Assignation_Code_Text">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/Assignation_Code_Text"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="ObjectDesc/GroundCategoryText">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="ObjectDesc/GroundCategoryText"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>&#160;</xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>площадь объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/Area/AreaText">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/Area/AreaText"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>инвентарный номер, литер:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/Inv_No">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/Inv_No"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>этажность (этаж):</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/Floor">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/Floor"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>номера на поэтажном плане:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/FloorPlan_No/Explication">
                    <xsl:for-each select="ObjectDesc/FloorPlan_No/Explication">
                      <xsl:if test="not(position()=1)">
                        <xsl:text>; </xsl:text>
                      </xsl:if>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="."/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>адрес (местоположение) объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectDesc/Address/Content"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>состав:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/Complex/Explication">
                    <xsl:for-each select="ObjectDesc/Complex/Explication">
                      <xsl:if test="not(position()=1)">
                        <xsl:text>; </xsl:text>
                      </xsl:if>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="."/>
                      </xsl:call-template>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="ObjectDesc/MdfDate">
            <tr>
              <td colspan="2">
                <i style='mso-bidi-font-style:normal'>
                  <xsl:call-template name="Panel">
                    <xsl:with-param name="Text">
                      <xsl:text>дата модификации:</xsl:text>
                    </xsl:with-param>
                  </xsl:call-template>
                </i>  
              </td>
              <td colspan="2">
                <i style='mso-bidi-font-style:normal'>
                  <xsl:call-template name="Panel">
                    <xsl:with-param name="Text">
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="ObjectDesc/MdfDate"/>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
                </i>  
              </td>
            </tr>
          </xsl:when>
        </xsl:choose>
        <tr>
          <td rowspan="{(count(Owner)+count(Registration)*4+1)}">2.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Зарегистрировано:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <xsl:for-each select="Registration">
          <xsl:variable name="Right" select="."/>
          <xsl:variable name="RightIndex" select="attribute::RegistrNumber" />
          <xsl:variable name="RightOwners" select="../Owner[@OwnerNumber=$RightIndex]" />
          <tr>
            <td width="1%" rowspan="{count($RightOwners)+4}">
              <xsl:text>2.</xsl:text>
              <xsl:value-of select="position()"/>
            </td>
            <td rowspan="{count($RightOwners)}">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>правообладатель:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <xsl:for-each select="$RightOwners[1]">
              <td>
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:if test="count($RightOwners)>1">
                      <xsl:text>1. </xsl:text>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="Person">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Person/Content"/>
                        </xsl:call-template>
                        <xsl:choose>
                          <xsl:when test="Person/MdfDate">
                            <br />
                            <i style='mso-bidi-font-style:normal'>
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Person/MdfDate"/>
                              </xsl:call-template>
                            </i>  
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="Organization">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Organization/Content"/>
                        </xsl:call-template>
                        <xsl:choose>
                          <xsl:when test="Organization/MdfDate">
                            <br />
                            <i style='mso-bidi-font-style:normal'>
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Organization/MdfDate"/>
                              </xsl:call-template>
                            </i>  
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="Governance">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Governance/Content"/>
                        </xsl:call-template>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </xsl:for-each>
          </tr>
          <xsl:for-each select="$RightOwners[position()>1]">
            <tr>
              <td>
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:value-of select="position()+1"/>
                    <xsl:text>. </xsl:text>
                    <xsl:choose>
                      <xsl:when test="Person">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Person/Content"/>
                        </xsl:call-template>
                        <xsl:choose>
                          <xsl:when test="Person/MdfDate">
                            <br />
                            <i style='mso-bidi-font-style:normal'>
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Person/MdfDate"/>
                              </xsl:call-template>
                            </i>  
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="Organization">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Organization/Content"/>
                        </xsl:call-template>
                        <xsl:choose>
                          <xsl:when test="Organization/MdfDate">
                            <br />
                            <i style='mso-bidi-font-style:normal'>
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Organization/MdfDate"/>
                              </xsl:call-template>
                            </i>  
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="Governance">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Governance/Content"/>
                        </xsl:call-template>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <td rowspan="{count(Registration)}">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>вид зарегистрированного права; доля в праве:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
              <td>
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:if test="count(Registration)>1">
                      <xsl:text>1. </xsl:text>
                    </xsl:if>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Right/Name"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
          </tr>
          <tr>
            <td rowspan="{count(Registration)}">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>дата государственной регистрации права:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
              <td>
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:if test="count(Registration)>1">
                      <xsl:text>1. </xsl:text>
                    </xsl:if>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Right/RegDate"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
          </tr>
          <tr>
            <td rowspan="{count(Registration)}">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>номер государственной регистрации права:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
              <td>
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:if test="count(Registration)>1">
                      <xsl:text>1. </xsl:text>
                    </xsl:if>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Right/RegNumber"/>                      
                    </xsl:call-template>
                    <xsl:choose>
                      <xsl:when test="$Right/MdfDate">
                        <br />
                        <i style='mso-bidi-font-style:normal'>
                          <xsl:text>Дата модификации:</xsl:text>
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="$Right/MdfDate"/>
                          </xsl:call-template>
                        </i>  
                      </xsl:when>
                    </xsl:choose>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
          </tr>
            <tr>
              <td rowspan="{count(Registration)}">
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:text>дата, номер и основание государственной регистрации перехода (прекращения) права:</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
                <td>
                  <xsl:call-template name="Panel">
                    <xsl:with-param name="Text">
                      <xsl:if test="count(Registration)>1">
                        <xsl:text>1. </xsl:text>
                      </xsl:if>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="$Right/EndDate"/>
                      </xsl:call-template>
                      <xsl:if test="$Right/EndNumber">
                        <xsl:text>, рег.№ </xsl:text>
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="$Right/EndNumber"/>
                        </xsl:call-template>
                      </xsl:if>  
                      <br/>
                      <xsl:choose>
                      <xsl:when test="DocFound">
                        <xsl:for-each select="DocFound">
                          <xsl:if test="not(position()=1)">
                            <xsl:text>;</xsl:text>
                            <br />
                          </xsl:if>
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Name"/>
                          </xsl:call-template>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:otherwise>&#160;</xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:with-param>
                  </xsl:call-template>
                </td>
            </tr>
        </xsl:for-each>
      </table>
    </xsl:for-each>
    <p>
      <xsl:text>Выписка выдана: </xsl:text>
      <xsl:call-template name="Value">
        <xsl:with-param name="Node" select="FootContent/Recipient"/>
      </xsl:call-template>
    </p>
  </xsl:template>
</xsl:stylesheet>
