<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">

    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Listing Proof</title>
				<style type="text/css">
          div.letterPage   { position:relative; top:0; left:0; width:918px; height:1200px; vertical-align:top; font-size:15px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden; page-break-after: always; }
          td               { vertical-align:top; }
          table.header     { display:table;table-layout:auto;width:100%; }
          table.header td  { padding:2px 0; }
          .disclaimer      { padding:12px 4px; border-top:1px solid #000; border-bottom:1px solid #000;}
          .red             { color:#cc0000; }
          .symbols         { font-family:"15TGSymbols"; font-weight:normal; }
          .symbols.large   { font-size:22px; letter-spacing:-0.6px; }
          .large           { font-size:19px; letter-spacing:-0.6px; }
          .medium          { font-size:17px; }
          .extraMedium     { font-size:18px; }
          .bold            { font-weight:bold; }
          .courier         { font-family:courier; }
          table.icon_list  { display:table;table-layout:fixed;width:100%;margin-bottom:12px; }
          table.icon_list td  { font-size:14px; white-space:nowrap; }

          ul           { list-style-type:none; margin:0; padding:0; }
          ul li        { list-style-type:none; margin:0 0 6px; padding:0; }
          .checkbox    { font-size:15px; border:1px solid #000; margin-right:4px; }
          .dotted_box  { border:1px dotted #000; }
          .clearboth   { clear:both; display:block; }
          .clearfix:after { visibility:hidden; display:block; font-size:0; content:" "; clear:both; height:0; }
          * html .clearfix             { zoom:1; } /* IE6 */
          *:first-child+html .clearfix { zoom:1; } /* IE7 */
          .pagebreakhere {page-break-before: always;}
        </style>
      </head>

      <xsl:variable name="nextYear">
        <xsl:value-of select="products/myDates/nextYear"/>
      </xsl:variable>
      
      <body style="background-color:#fff;margin:0;padding:0;">
        <xsl:for-each select="products/product">
					<div class="letterPage">
						<table cellpadding="0" cellspacing="0" border="0" class="header">
							<tr>
								<td style="width:45%;">
									<span class="large bold"><xsl:value-of select="$nextYear"/></span> &#160; <span class="large">NS Doers' &amp; Dreamers' Guide</span>
								</td>
								<td style="padding-left:12px;">
									&#160;<span class="large bold">
										Listing Proof
									</span>&#160;
								</td>
								<td style="text-align:right;">
									<span class="large bold">
										<xsl:value-of select="region"/>&#160;<xsl:value-of select="productId"/>
									</span>
								</td>
							</tr>
						</table>

						<div style="margin:0 4px;padding:12px 0 0; border-top:1px solid #000;height:621px;">
								<table cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td style="width:140px;padding-right:22px;" rowspan="3" class="large bold">
											<xsl:value-of select="communityName"/>&#160;<xsl:value-of select="communityMapIndex"/>
										</td>
										<td>
											<span class="large bold">
												<xsl:value-of select="productName"/>
											</span>
											&#160;&#160;&#160;&#160;&#160;
											<span class="symbols extraMedium">
												<xsl:value-of select="symbolString"/>
											</span>
										</td>
									</tr>
									<tr>
										<td class="bold extraMedium" style="padding-top:24px;">
												<xsl:value-of select="productContactString"/>
										</td>
									</tr>
									<tr>
										<td style="line-height:39px;" class="medium">
												<xsl:value-of select="listingBody" disable-output-escaping="yes"/>
										</td>
									</tr>
								</table>
						</div>

            <div style="margin:0 4px 12px;">
              Listing character count:
              <xsl:if test="characterCount>450">
                <b class="red">
                  <xsl:value-of select="characterCount"/>
                </b>.
              </xsl:if>
              <xsl:if test="450>=characterCount" >
                <b>
                  <xsl:value-of select="characterCount"/>
                </b>.
              </xsl:if>
              All listings are limited to 450 characters (property name, symbols, punctuation and spaces are not counted).
            </div>

						<div style="margin:0 4px 12px;">
							<span class="large bold">Important: Final Proof</span>
							<p style="margin:0 0 24px;">
								Please verify that this proof accurately reflects your information for <xsl:value-of select="$nextYear"/>. The rates shown should be for one or two people in peak season, before tax. Your updates have been edited to conform to our standard order and format. We will only correct errors in critical information (e.g. incorrect rates, contact number, or electronic address), or make deletions to reduce the length. <b>No other changes will be accepted.</b>
							</p>
							<p style="margin:0 0 24px;">Memberships and ratings will be verified by the organisations and may be changed before printing.</p>

							<span class="large bold">Please sign and return by fax within 5 days to 902-424-0629.</span>
							<p style="margin:0 0 12px;">If verification is not received within 5 days the listing content will be presumed correct and printed as on this proof.</p>
							<table cellpadding="0" cellspacing="0" border="0" class="icon_list">
								<tr>
									<td style="padding-left:100px;">
										<ul>
											<li>
												<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> proof accepted as is OR
											</li>
											<li>
												<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> corrections required
											</li>
										</ul>
									</td>
								</tr>
							</table>
							
							<p style="margin:200px 0 0;">
								<span style="border-top:1px solid #000;">Signature &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span>
								&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
								<span style="border-top:1px solid #000;">Date &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span>
							</p>

							<p style="margin:24px 0 0;font-size:10px;">Date Printed: <xsl:value-of select="currentDate"/> </p>
						</div>
          </div>
          
        </xsl:for-each>  
          
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
