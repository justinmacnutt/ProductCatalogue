<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">

    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
        <title>Outdoor Confirmation Form</title>
        <style type="text/css">
          h1,h2,h3,h4,h5,h6 { margin:0 0 12px; }
          div.letterPage   { position:relative; top:0; left:0; width:918px; vertical-align:top; font-size:14px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden; page-break-after: always;}
          div.webDescPage  { position:relative; top:0; left:0; width:918px; vertical-align:top; font-size:14px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden; page-break-after: always;}
          td               { vertical-align:top; font-size:14px; }
          table.header     { display:table;table-layout:auto;width:98%;margin:0 auto; }
          table.header td  { padding:2px 0; }
          .disclaimer      { margin:0 4px; padding:12px 4px; border-top:1px solid #000; border-bottom:1px solid #000;}
          .address 		   { padding:12px 4px; }
          .red             { color:#cc0000; }
          .symbols         { font-family:"15TGSymbols"; font-weight:normal; }
          .symbols.large   { font-size:18px; letter-spacing:-0.6px; }
          .large           { font-size:19px; letter-spacing:-0.6px; }
          .extraMedium     { font-size:18px; }
          .medium          { font-size:17px; }
          .heading         { font-size:19px; padding-bottom:4px; margin-bottom:12px; border-bottom:1px solid #000; }
          .bold            { font-weight:bold; }
          table.icon_list  { display:table;table-layout:fixed;width:100%;margin-bottom:12px; }
          table.icon_list td{ font-size:14px; white-space:nowrap; }
          p 	           { margin:0 0 12px; }
          ul           { list-style-type:none; margin:0; padding:0; }
          ul li        { list-style-type:none; margin:0 0 6px; padding:0; }

          .webDescription ul           { list-style-type:disc; margin:1em; padding:0; }
          .webDescription ul li        { list-style-type:disc; margin:0 0 6px 1em; padding:0; }

          .checkbox    { font-size:12px; border:1px solid #000; margin-right:4px; }
          .dotted_box  { border:1px dotted #000; }
          .clearboth   { clear:both; display:block; }
          .clearfix:after { visibility:hidden; display:block; font-size:0; content:" "; clear:both; height:0; }
          * html .clearfix             { zoom:1; } /* IE6 */
          *:first-child+html .clearfix { zoom:1; } /* IE7 */
          p.pagebreakhere {page-break-before: always;}
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
                  <span class="bold">
                    <xsl:value-of select="$nextYear"/>
                  </span> &#160; <span class="">NS Doers' &amp; Dreamers' Guide Confirmation</span>
                </td>
                <td style="padding-left:12px;">
                  &#160;<span class="bold">
                    <xsl:value-of select="productType"/>
                  </span>&#160;
                </td>
                <td style="text-align:right;">
                  <span class="bold">
                    <xsl:value-of select="region"/>&#160;<xsl:value-of select="productId"/>
                  </span>
                </td>
              </tr>
            </table>

            <div class="disclaimer">
              <strong>
                These are your current print and web listings on record in our database. <u>Print descriptions will be included only in enhanced listings ($150 plus HST for English, $100 plus HST for French).</u> You may use the existing description or write a new one. The maximum length is 150 characters.
              </strong>
              <span class="red">
                Forms must be returned by <xsl:value-of select="confirmationFormDueDate"/>
              </span>, or your changes may not be included in the printed travel guides. For your web listing: email all description changes, photos and YouTube video links to novascotia.com@gmail.com by <xsl:value-of select="confirmationFormDueDate"/>.
            </div>
            
            <div class="address">
              <div class="courier">
                Confirm this contact information. This is for internal use only and is <b>NOT</b> used to update your listing.
              </div>

              <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                  <td style="padding:45px 0px 0 41px;width:50%;font-weight:bold;letter-spacing:0;line-height:20px;">
                    <xsl:value-of select="contactMailingAddress" disable-output-escaping="yes"/>
                  </td>
                  <td style="padding:45px 0px 0 41px;width:50%;font-weight:bold;letter-spacing:0;line-height:20px;">
                    <b>Tel:&#160;</b>
                    <xsl:value-of select="contactTelephone" />
                    <br />
                    <b>Fax:&#160;</b>
                    <xsl:value-of select="contactFax" />
                    <br />
                    <b>Mobile:&#160;</b>
                    <xsl:value-of select="contactMobile" />
                    <br />
                    <b>Off-Season:&#160;</b>
                    <xsl:value-of select="contactOffSeason" />
                    <br />
                    <b>Home:&#160;</b>
                    <xsl:value-of select="contactHomePhone" />
                    <br />
                    <b>Email:&#160;</b>
                    <xsl:value-of select="contactEmail" />
                  </td>
                 </tr>
              </table>
            </div>
            
            <div style="margin:12px 4px 40px;">
              <h2 class="heading"><xsl:value-of select="productName"/></h2>

              <table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
                <tr>
                  <td style="padding:10px 0px 0 41px;width:50%;">
                    <p>
                      <b>Community: </b>
                      <xsl:value-of select="communityName"/>
                    </p>
                    <p>
                      <b>Civic Address: </b>
                      <xsl:value-of select="addressLine1"/>
                    </p>
                    <p>
                      <b>Phone: </b>
                      <xsl:value-of select="phone"/>
                    </p>
                    <p>
                      <b>Toll Free Phone: </b>
                      <xsl:value-of select="tollfree"/>
                    </p>
                    <p>
                      <b>Fax: </b>
                      <xsl:value-of select="fax"/>
                    </p>
                    <p>
                      <b>Secondary Phone: </b>
                      <xsl:value-of select="secondaryPhone"/>
                    </p>
                    <p>
                      <b>Off Season Phone: </b>
                      <xsl:value-of select="offSeasonPhone"/>
                    </p>
                    <p>
                      <b>Email: </b>
                      <xsl:value-of select="email"/>
                    </p>
                    <p>
                      <b>Website: </b>
                      <xsl:value-of select="web"/>
                    </p>
                    <p>
                      <b>Facebook URL: </b>
                      <xsl:value-of select="facebookUrl"/>
                    </p>
                    <p>
                      <b>Twitter URL: </b>
                      <xsl:value-of select="twitterUrl"/>
                    </p>
                  </td>
                  <td style="padding:10px 0px 0 41px;width:50%;">
                    <p>
                      <b>Region: </b>
                      <xsl:value-of select="region"/>
                    </p>
                    <p>
                      <b>GPS Coordinates: </b>
                      <xsl:value-of select="gpsString"/>
                    </p>
                    <p>
                      <b>Primary Guide Section: </b>
                      <xsl:value-of select="guideSection"/>
                    </p>
                    <p>
                      <b>Open &amp; Close dates: </b>
                      <xsl:value-of select="openCloseDates"/>
                    </p>
                    <p>
                      <b>Date Details: </b>
                      <xsl:value-of select="dateDetails"/>
                    </p>
                    <p>
                      <b>Payment Options: </b>
                      <xsl:value-of select="paymentOptions"/>
                    </p>
                    <p>
                      <b>Symbols: </b>
                      <span class="symbols">
                        <xsl:value-of select="symbolString"/>
                      </span>
                    </p>
                  </td>
                </tr>
              </table>

            </div>

            <div style="margin:0 4px 12px;">
              <p>Please check any of the following that apply</p>
              <table cellpadding="0" cellspacing="0" border="0" class="icon_list">
                <tr>
                  <td>
                    <ul>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">a</span> Bienvenue member
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">v</span> NS Government
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">P</span> Parks Canada
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">W</span> Wheelchair accessible
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">;</span> Partially accessible
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">></span> 4-wheeling
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">Y</span> Birds &amp; Wildlife
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">|</span> Camping
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">{</span> Canoeing
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">K</span> Cycling
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">D</span> Diving
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">&lt;</span> Fossils
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">G</span> Golf
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">L</span> Hiking
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">}</span> Kayaking
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">b</span> Sailing Charters or Cruises
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">t</span> Sightseeing Tour
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">S</span> Skiing
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">s</span> Snowmobiling
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">y</span> Snowshoeing
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">f</span> Sports Fishing
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">w</span> Whale Watching
                      </li>
                    </ul>
                  </td>
                </tr>
              </table>
            </div>

            <div style="margin:12px 4px 24px;line-height: 2em;">
              <h2 class="heading">
                Print Description <small style="font-weight:normal;">(enhanced listing only; will be edited to fit if needed)</small>
              </h2>
              <table cellpadding="0" cellspacing="0" border="0" style="display:table;table-layout:fixed;width:100%;">

                <tr>
                  <td style="padding:10px 10px 0 10px;height:100px;width:140px;letter-spacing:0;line-height:20px;border:2px dotted #CCCCCC;">
                    <ul>
                      <li style="font-weight:bold;">Listing Type</li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Basic (free)
                      </li>
                      <li>
                        <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Enhanced (*)
                      </li>
                      <li>
                        <small>(*) $150 + HST for English, $100 + HST for French</small>
                      </li>
                    </ul>
                  </td>
                  <td style="padding:0px 0px 0px 10px;vertical-align:top; line-height: 2em;">
                    <p>
                      <xsl:value-of select="printDescription"/>
                    </p>
                  </td>
                </tr>
              </table>
            </div>

            <div style="margin:12px 4px 24px;">
              <h2 class="heading">X-Ref Sections</h2>
              <xsl:for-each select="xrefs/xref">
                <p>
                  <strong>
                    <xsl:value-of select="xrefGuideSection"/>:
                  </strong>
                  <xsl:value-of select="xrefDescription"/>
                </p>
              </xsl:for-each>
            </div>

            <div class="webDescription" style="margin:12px 4px;">
              <h2 class="heading">Web Description</h2>
              <p>
                <xsl:value-of select="webDescription" disable-output-escaping="yes"/>
              </p>
            </div>

            <div style="margin:40px 4px; padding-top:4px;border-top:1px solid #000;">
              <table cellpadding="0" cellspacing="0" border="0" style="display:table;table-layout:fixed;width:100%;">
                <tr>
                  <td width="60%">
                    <div style="margin:2px 0 32px;">I certify that the information provided is correct.</div>
                    <span style="border-top:1px dotted #000;">Signature &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="border-top:1px dotted #000;">Date &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span>
                  </td>
                  <td>
                    <div style="width:349px;font-size:12px;letter-spacing:0;padding:6px;border: 1px solid #CCCCCC;" class="clearfix">
                      <div style="display:inline;float:right;width:112px;padding:2px;border:2px dotted #CCCCCC;background-color:#fff;">
                        <h4 style="margin:0;width:112px;font-size:12px;font-weight:normal;text-align:center;">For office use only.</h4>
                        <h4 style="margin:40px 0 0 2px;padding-top:2px;width:108px;text-align:center;border-top:2px dotted #CCCCCC;" class="courier">
                          <xsl:value-of select="contactId" />
                        </h4>
                      </div>
                      Doers' &amp; Dreamers' Guide<br />
                      Tourism Nova Scotia<br />
                      PO Box 667, Windsor, NS   B0N 2T0<br />
                      Ph: 902-424-4709 &#160;&#160;<br />
                      Fax: 902-798-6600<br />
                      email: doersndreamers@novascotia.ca
                    </div>
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
