<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/reportFile">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Occupancy by Product Report</title>
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
        <div class="letterPage">
          <h4>
            Nova Scotia Tourism Agency<br/>
            Fixed Roof Occupancy by License Number Report<br/><br/>
          </h4>
          <table cellpadding="0" cellspacing="0" border="0" class="header">
            <tr>
              <td>
                <span class="bold">License Number</span>  
              </td>
              <td>
                <span class="bold">Product Name</span>
              </td>
            </tr>
            <xsl:for-each select="products/product">
              <tr>
                <td>
                  <xsl:value-of select="licenseNumber"/>
                </td>
                <td>
                  <xsl:value-of select="productName"/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </div>
          <xsl:for-each select="reports/report">
            <div class="letterPage">
              <h3>
                Client: <xsl:value-of select="$myClientName"/><br></br>
                Year(s): <xsl:value-of select="$myYears"/><br></br>
                Description: <xsl:value-of select="$myDescription"/><br></br>
                
                
              </h3>
              <h4>
                Year:<xsl:value-of select="@id"/>
              </h4>
              
              <table cellpadding="0" cellspacing="0" border="0" class="header">
                <tr>
                  <td>
                    <span class="bold">Month</span>
                  </td>
                  <td>
                    <span class="bold">Occupancy <br/>Rate</span>
                  </td>
                  <td>
                    <span class="bold">Projected <br/>Units Sold</span>
                  </td>
                  <xsl:choose>
                    <xsl:when test ="$myDisplayActuals = 'true'">
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
                    <span class="bold">Total Units <br/>Available</span>
                  </td>
                  <td>
                    <span class="bold">Reporting <br/>Rate</span>
                  </td>
                  <td>
                    <span class="bold">Properties <br/>Reported</span>
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
                          <xsl:when test ="$myDisplayActuals = 'true'">
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
                          <xsl:when test ="$myDisplayActuals = 'true'">
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
                      <xsl:value-of select="summary/occupancyRateAvg"/>
                    </span>
                  </td>
                  <td>
                    <span class="bold">
                      <xsl:value-of select="summary/projectedUnitsSoldSum"/>
                    </span>
                  </td>
                  <xsl:choose>
                    <xsl:when test ="$myDisplayActuals = 'true'">
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
            </div>
          </xsl:for-each>
     </body>
    </html>
  </xsl:template>
</xsl:stylesheet>