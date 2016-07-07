<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/reportFiles">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Occupancy By Geography Report</title>
        <style type="text/css">
          div.letterPage   { position:relative; top:0; left:0; width:918px; height:1230px; vertical-align:top; font-size:15px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden; page-break-after: always; }
          td               { vertical-align:top; }
          table.header     { display:table;table-layout:auto;width:98%;margin:0 auto; }
          table.header td  { padding:2px 0; }
          .disclaimer      { padding:12px 4px; border-top:1px solid #000; border-bottom:1px solid #000;}
          .red             { color:#cc0000; }
          .large           { font-size:19px; letter-spacing:-0.6px; }
          .extraMedium     { font-size:18px; }
          .medium          { font-size:17px; }
          .bold            { font-weight:bold; }

          ul           { list-style-type:none; margin:0; padding:0; }
          ul li        { list-style-type:none; margin:0 0 6px; padding:0; }
          .checkbox    { font-size:15px; border:1px solid #000; margin-right:4px; }
          .dotted_box  { border:1px dotted #000; }
          .clearboth   { clear:both; display:block; }
          .clearfix:after { visibility:hidden; display:block; font-size:0; content:" "; clear:both; height:0; }
          * html .clearfix             { zoom:1; } /* IE6 */
          *:first-child+html .clearfix { zoom:1; } /* IE7 */
        </style>
      </head>

      <body style="background-color:#fff;margin:0;padding:0;">
       
        <xsl:for-each select="reportFile/reports/report">
          <div class="letterPage">
            <h4>
              Nova Scotia Tourism Agency<br/>
              Fixed Roof Occupancy by Geography Report<br/><br/>
              
              Client: <xsl:value-of select="../../metaData/clientName"/><br></br>
              Year(s): <xsl:value-of select="../../metaData/years"/><br></br>
              Description: <xsl:value-of select="../../metaData/description"/><br></br>
              Geography Type: <xsl:value-of select="../../metaData/geographyTypeLabel"/><br></br>
              Geography Areas: <xsl:value-of select="../../metaData/geographicAreas"/><br></br>
            </h4>
            <h4>
              Year:<xsl:value-of select="@id"/>
            </h4>
            <table cellpadding="0" cellspacing="0" border="0" class="header">
              <tr>
                <td>
                  <span class="bold">Month</span>
                </td>
                <td>
                  <span class="bold">Occupancy Rate</span>
                </td>
                <td>
                  <span class="bold">Projected Units Sold</span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Actual <br/>Units Sold
                      </span>
                    </td>
                    <td>
                      <span class="bold">
                        Total Units <br/>Available Reported
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Actual <br/>Units Sold
                      </span>
                    </td>
                    <td style="display:none;">
                      <span class="bold">
                        Total Units <br/>Available Reported
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">Total Units Available</span>
                </td>
                <td>
                  <span class="bold">Reporting Rate</span>
                </td>
                <td>
                  <span class="bold">Properties Reported</span>
                </td>
              </tr>


              <xsl:for-each select="month">
                <xsl:choose>
                  <xsl:when test="displayRow = 'true'">
                    <tr>
                      <td>
                        <xsl:value-of select="@shortName"/>
                      </td>
                      <td>
                        <xsl:value-of select="occupancyRate"/>
                      </td>
                      <td>
                        <xsl:value-of select="projectedUnitsSold"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="totalUnitsSold"/>
                          </td>
                          <td>
                            <xsl:value-of select="totalUnitsAvailableReported"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="totalUnitsAvailable"/>
                      </td>
                      <td>
                        <xsl:value-of select="reportingRate"/>
                      </td>
                      <td>
                        <xsl:value-of select="openPropertiesReported"/>
                      </td>
                    </tr>
                  </xsl:when>
                  <xsl:otherwise>
                    <tr>
                      <td>
                        <xsl:value-of select="@shortName"/>
                      </td>
                      <td>
                        ---
                      </td>
                      <td>
                        ---
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            ---
                          </td>
                          <td>
                            ---
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        ---
                      </td>
                      <td>
                        <xsl:value-of select="reportingRate"/>
                      </td>
                      <td>
                        <xsl:value-of select="openPropertiesReported"/>
                      </td>
                    </tr>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <tr>
                <td colspan="8">
                  <span class="bold">
                    <hr></hr>
                  </span>
                </td>

              </tr>

              <tr>
                <td>
                  <span class="bold"></span>
                </td>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/occupancyRateAvg"/>
                  </span>
                </td>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/projectedUnitsSoldSum"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        <xsl:value-of select="summary/totalUnitsSoldSum"/>
                      </span>
                    </td>
                    <td>
                      <span class="bold">
                        <xsl:value-of select="summary/totalUnitsAvailableReportedSum"/>
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/totalUnitsAvailableSum"/>
                  </span>
                </td>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/reportingRateAvg"/>
                  </span>
                </td>
                <td>
                  <span class="bold"></span>
                </td>
                <td>
                  <span class="bold"></span>
                </td>
              </tr>
            </table>
            <br/>
            <table cellpadding="0" cellspacing="0" border="0" class="header">
              <tr>
                <td>
                  <span class="bold">Classes Included:</span>
                </td>
                <td>
                  <span class="bold">
                    <xsl:value-of select="../../metaData/geographyTypeLabel"/> Included:</span>
                </td>
              </tr>
              <tr>
                <td>
                    <xsl:value-of select="../../metaData/accommodationTypes"/>
                    <br></br>
                </td>
                <td>
                  <xsl:value-of select="../../metaData/geographicAreas"/>
                    <br></br>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <span class="bold">Star Classes included:</span>
                  <xsl:value-of select="../../metaData/starClasses"/>
                </td>
              </tr>
            </table>
          </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>