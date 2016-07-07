<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/reportFile">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Confidential Report</title>
        <style type="text/css">
          div.letterPage   { position:relative; top:0; left:0; width:918px; height:1230px; vertical-align:top; font-size:15px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden;  }
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

      <xsl:variable name="myProductName">
        <xsl:value-of select="metaData/productName"/>
      </xsl:variable>
      <xsl:variable name="myLicenseNumber">
        <xsl:value-of select="metaData/licenseNumber"/>
      </xsl:variable>
      <xsl:variable name="myYears">
        <xsl:value-of select="metaData/years"/>
      </xsl:variable>

      <body style="background-color:#fff;margin:0;padding:0;">
         <xsl:for-each select="reports/report">
            <div class="letterPage">
              <h4>
                Nova Scotia Tourism Agency<br/>
                Campground Confidential Report<br/><br/>
                Product Name: <xsl:value-of select="$myProductName"/><br></br>
                License Number: <xsl:value-of select="$myLicenseNumber"/><br></br>
                Year(s): <xsl:value-of select="$myYears"/><br></br>
              </h4>
              <h4>
                Year: <xsl:value-of select="@id"/>
              </h4>
              <table cellpadding="0" cellspacing="0" border="0" class="header">
                <tr>
                  <td>
                    <span class="bold">Month</span>
                  </td>
                  <td>
                    <span class="bold">Status</span>
                  </td>
                  <td>
                    <span class="bold">Est. Seasonal Site Nights</span>
                  </td>
                  <td>
                    <span class="bold">Seasonal Occ Rate %</span>
                  </td>
                  <td>
                    <span class="bold">Actual Seasonal<br/>Site Nights</span>
                  </td>
                  <td>
                    <span class="bold">
                      Est. Short Term<br/>Sites Sold
                    </span>
                  </td>
                  <td>
                    <span class="bold">Short Term Occ Rate %</span>
                  </td>
                  <td>
                    <span class="bold">
                      Short Term<br/>Actuals
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      Estimated Total<br/>Sites Sold
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      Total Site<br/>Actuals
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      Occupancy<br/>Rate
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
                          <xsl:value-of select="status"/>
                        </td>
                        <td>
                          <xsl:value-of select="projectedSeasonalSold"/>
                        </td>
                        <td>
                          <xsl:value-of select="seasonalOccupancyRate"/>
                        </td>
                        <td>
                          <xsl:value-of select="seasonalSold"/>
                        </td>
                        <td>
                          <xsl:value-of select="projectedShortTermSold"/>
                        </td>
                        <td>
                          <xsl:value-of select="shortTermOccupancyRate"/>
                        </td>
                        <td>
                          <xsl:value-of select="shortTermSold"/>
                        </td>
                        <td>
                          <xsl:value-of select="projectedUnitsSold"/>
                        </td>
                        <td>
                          <xsl:value-of select="totalUnitsSold"/>
                        </td>
                        <td>
                          <xsl:value-of select="occupancyRate"/>
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
                        <td><xsl:value-of select="@shortName"/></td>
                        <td>
                          <xsl:value-of select="status"/>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
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
                    <span class="bold"></span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/projectedSeasonalSoldSum"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/seasonalOccupancyRateAvg"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/totalSeasonalSoldSum"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/projectedShortTermSoldSum"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/shortTermOccupancyRateAvg"/>
                    </span>
                  </td>
                  <td class="bold">
                    <xsl:value-of select="summary/totalShortTermSoldSum"/>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/projectedUnitsSoldSum"/>
                    </span>
                  </td>
                  <td class="bold">
                     <xsl:value-of select="summary/totalUnitsSoldSum"/>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/occupancyRateAvg"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/reportingRateAvg"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/openPropertiesReportedSum"/>
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