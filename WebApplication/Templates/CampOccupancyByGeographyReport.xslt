﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/reportFiles">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Occupancy By Geography Report</title>
        <style type="text/css">
          div.letterPage   { position:relative; top:0; left:0; width:1918px; height:1230px; vertical-align:top; font-size:15px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden; page-break-after: always; }
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

      <xsl:variable name="myClientName">
        <xsl:value-of select="metaData/clientName"/>
      </xsl:variable>
      <xsl:variable name="myDescription">
        <xsl:value-of select="metaData/description"/>
      </xsl:variable>
      <xsl:variable name="myYears">
        <xsl:value-of select="metaData/years"/>
      </xsl:variable>
      <xsl:variable name="myDisplayActuals">
        <xsl:value-of select="metaData/displayActuals"/>
      </xsl:variable>
      
      <body style="background-color:#fff;margin:0;padding:0;">
       
        <xsl:for-each select="reportFile/reports/report">
          <div class="letterPage">
            <h4>
              Nova Scotia Tourism Agency<br/>
              Campground Occupancy by Geography Report<br/><br/>
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
                  <span class="bold">Seasonal Occ Rate %</span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Reported Seasonal<br/>Nights Sold
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Reported Seasonal<br/>Nights Sold
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">Est. Seasonal Nights Sold</span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Reported Seasonal<br/>Available
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Reported Seasonal<br/>Available
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">Total Seasonal Available</span>
                </td>
                
                <td>
                  <span class="bold">Short Term Occ Rate %</span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Reported Short Term<br/>Sold
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Reported Short Term<br/>Sold
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    Est. Short Term<br/>Sold
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Reported Short Term<br/>Available
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Reported Short Term<br/>Available
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    Total Short Term<br/>Available
                  </span>
                </td>
                
                <td>
                  <span class="bold">
                    Total Occupancy<br/>Rate
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Reported Total<br/>Sold
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Reported Total<br/>Sold
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    Est. Total<br/>Sold
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td>
                      <span class="bold">
                        Reported Total<br/>Available
                      </span>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                      <span class="bold">
                        Reported Total<br/>Available
                      </span>
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    Total<br/>Available
                  </span>
                </td>

                <td>
                  <span class="bold">
                    Reporting<br/>Rate
                  </span>
                </td>
                <td>
                  <span class="bold">
                    Properties <br/>Reported
                  </span>
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
                        <xsl:value-of select="seasonalOccupancyRate"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="seasonalSold"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="projectedSeasonalSold"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="seasonalAvailable"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="seasonalAvailableEstimated"/>
                      </td>
                      
                      <td>
                        <xsl:value-of select="shortTermOccupancyRate"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="shortTermSold"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="projectedShortTermSold"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="shortTermAvailable"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="shortTermAvailableEstimated"/>
                      </td>
                      
                      <td>
                        <xsl:value-of select="occupancyRate"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="totalUnitsSold"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                            
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="projectedUnitsSold"/>
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            <xsl:value-of select="unitsAvailableReported"/>
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:value-of select="unitsAvailableEstimated"/>
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
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            ---
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        ---
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            ---
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
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
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        ---
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            ---
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
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
                        </xsl:when>
                        <xsl:otherwise>
                          <td style="display:none;">
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        ---
                      </td>
                      <xsl:choose>
                        <xsl:when test ="../../../metaData/displayActuals = 'true'">
                          <td>
                            ---
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
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
                <td colspan="13">
                  <span class="large bold">
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
                    <xsl:value-of select="summary/seasonalOccupancyRateAvg"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td class="bold">
                      <xsl:value-of select="summary/totalSeasonalSoldSum"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/projectedSeasonalSoldSum"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td class="bold">
                      <xsl:value-of select="summary/seasonalAvailableSum"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/seasonalAvailableEstimatedSum"/>
                  </span>
                </td>
                
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/shortTermOccupancyRateAvg"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td class="bold">
                      <xsl:value-of select="summary/totalShortTermSoldSum"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/projectedShortTermSoldSum"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td class="bold">
                      <xsl:value-of select="summary/shortTermAvailableSum"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/shortTermAvailableEstimatedSum"/>
                  </span>
                </td>
                
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/occupancyRateAvg"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td class="bold">
                      <xsl:value-of select="summary/totalUnitsSoldSum"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/projectedUnitsSoldSum"/>
                  </span>
                </td>
                <xsl:choose>
                  <xsl:when test ="../../metaData/displayActuals = 'true'">
                    <td class="bold">
                      <xsl:value-of select="summary/unitsAvailableReportedSum"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td style="display:none;">
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/unitsAvailableEstimatedSum"/>
                  </span>
                </td>
                
                <td>
                  <span class="bold">
                    <xsl:value-of select="summary/reportingRateAvg"/>
                  </span>
                </td>
                <td>
                  <span class="bold">

                  </span>
                </td>
              </tr>
            </table>
          </div>
          
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>