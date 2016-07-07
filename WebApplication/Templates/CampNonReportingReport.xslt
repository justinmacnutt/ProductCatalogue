<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/reportFile">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Non-Reporting Report</title>
        <style type="text/css">
          div.letterPage   { position:relative; top:0; left:0; width:918px; height:1230px; vertical-align:top; font-size:15px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden;  }
          td               { vertical-align:top; }
          table.header     { display:table;table-layout:auto;width:98%;margin:0 auto; }
          table.header td  { padding:6px 20px 6px 0; font-size:12px; vertical-align:top; border-bottom:1px solid #dedede;}
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
      <xsl:apply-templates select="reports/report/product"/>
      <xsl:if test="count(reports/report/product) = 0">
        There are no missing reports for the submitted date range.
      </xsl:if>
    </html>
    </xsl:template>
      
    <xsl:template match="reports/report/product[position() mod 17 = 1]">
      <div class="letterPage">
        <h4>
          Nova Scotia Tourism Agency<br/>
          Non-Reporting Properties<br/><br/>
          <xsl:value-of select="../../../metaData/startDate"/> - <xsl:value-of select="../../../metaData/endDate"/>
        </h4>
        Year: <xsl:value-of select="../@id"/>
        <table cellpadding="0" cellspacing="0" border="0" class="header">
          <tr>
            <td>
              <span class="bold">License Number</span>
            </td>
            <td>
              <span class="bold">Product</span>
            </td>
            <td>
              <span class="bold">Work Phone</span>
            </td>
            <td>
              <span class="bold">Mobile Phone</span>
            </td>
            <td>
              <span class="bold">Email</span>
            </td>
            <td>
              <span class="bold">Year Round</span>
            </td>
            <td>
              <span class="bold"># Units</span>
            </td>
          </tr>
          <xsl:apply-templates mode="proc" select=".|following-sibling::product[not(position() > 16)]" />
        </table>
      </div>
    </xsl:template>

    <xsl:template match="reports/report/product" mode="proc">
        <tr>
           <td>
              <xsl:value-of select="licenseNumber"/>
            </td>
            <td>
              <b>
                <xsl:value-of select="productName"/>
              </b>
              <br/>
              <xsl:value-of select="contactName"/>
              <br/>
              <xsl:value-of select="nonReportingMonths"/>
            </td>
            <td>
              <p>
                <xsl:value-of select="officePhone"/>
              </p>
            </td>
            <td>
              <p>
                <xsl:value-of select="mobilePhone"/>
              </p>
            </td>
            <td>
              <p>
                <xsl:value-of select="email"/>
              </p>
            </td>
            <td>
              <p>
              <xsl:value-of select="isOpenAllYear"/>
              </p>
            </td>
            <td>
              <p>
                <xsl:value-of select="totalUnits"/>
              </p>
            </td>
          </tr>
          
      </xsl:template>

     <xsl:template match="reports/report/product[not(position() mod 17 = 1)]"/>
</xsl:stylesheet>


