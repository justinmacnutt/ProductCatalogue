<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/reportFile">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Variance Report</title>
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
      <xsl:apply-templates select="report/product"/>
      <xsl:if test="count(report/product) = 0">
        There are no campgrounds with the submitted variance in occupancy.
      </xsl:if>
    </html>
    </xsl:template>
      
    <xsl:template match="report/product[position() mod 35 = 1]">
      <div class="letterPage">
        <h4>
          Nova Scotia Tourism Agency<br/>
          Fixed Roof Variance Report<br/>
          <xsl:value-of select="../../metaData/startDate"/> - <xsl:value-of select="../../metaData/endDate"/><br/>
		  Amount Difference: <xsl:value-of select="../../metaData/amountDifference"/><br/>
		  Percent Difference: <xsl:value-of select="../../metaData/percentageDifference"/>
        </h4>
        
        <table cellpadding="0" cellspacing="0" border="0" class="header">
          <tr>
            <td>
              <span class="bold">License <br/>Number</span>
            </td>
            <td>
              <span class="bold">Product Name</span>
            </td>
            <td>
              <span class="bold">Region</span>
            </td>
            <td>
              <span class="bold"><xsl:value-of select="../../metaData/startDate"/><br/>Units Sold </span>
            </td>
            <td>
              <span class="bold"><xsl:value-of select="../../metaData/endDate"/><br/>Units Sold</span>
            </td>
            <td>
              <span class="bold">Percentage <br/>Difference</span>
            </td>
			<td>
              <span class="bold">Amount <br/>Difference</span>
            </td>
          </tr>
          <xsl:apply-templates mode="proc" select=".|following-sibling::product[not(position() > 34)]" />
        </table>
      </div>
    </xsl:template>

    <xsl:template match="report/product" mode="proc">
        <tr>
           <td>
              <xsl:value-of select="licenseNumber"/>
            </td>
            <td>
              <xsl:value-of select="productName"/>
            </td>
            <td>
              <xsl:value-of select="regionName"/>
            </td>
            <td>
              <xsl:value-of select="startUnitsSold"/>
            </td>
            <td>
              <xsl:value-of select="endUnitsSold"/>
            </td>
            <td>
              <xsl:value-of select="percentageDifference"/>
            </td>
			<td>
              <xsl:value-of select="amountDifference"/>
            </td>
          </tr>
      </xsl:template>
     <xsl:template match="report/product[not(position() mod 35 = 1)]"/>
</xsl:stylesheet>


