<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
		<title>Tour Operators Application Form</title>
		<style type="text/css">
			div.letterPage   { position:relative; top:0; left:0; width:918px; vertical-align:top; font-size:15px; font-family:arial,sans-serif; color:#000000; font-weight:normal; line-height:normal; letter-spacing:-0.2px; overflow:hidden;  }
			td               { vertical-align:top; }
			table.header     { display:table;table-layout:auto;width:100%; }
			table.header td  { padding:2px 0; border-bottom:1px solid #000; }
			.disclaimer      { margin-top:10px; padding:10px; border:1px solid #000;}
			.red             { color:#cc0000; }
			.symbols         { font-family:"15TGSymbols"; font-weight:normal; }
			.symbols.large   { font-size:22px; letter-spacing:-0.6px; }
			.large           { font-size:19px; letter-spacing:-0.6px; }
			.medium          { font-size:17px; }
			.bold            { font-weight:bold; }
			table.icon_list  { display:table;table-layout:fixed;width:100%;margin-bottom:12px; }
			table.icon_list td  { font-size:14px; white-space:nowrap; }
			
			table.app_form   { display:table;table-layout:auto;width:100%; }
			table.app_form td  { vertical-align:top; padding:3px 3px 3px 0; }
			table.app_form td .dotted_box { display:block; width:100%; height:100%; }
			
			ul           { list-style-type:none; margin:0; padding:0; }
			ul li        { list-style-type:none; margin:0 0 6px; padding:0; }
			.checkbox    { font-size:15px; border:1px solid #000; margin-right:4px; }
			.dotted_box  { border:1px dotted #000; line-height:24px; }
			.clearboth   { clear:both; display:block; }
			.clearfix:after { visibility:hidden; display:block; font-size:0; content:" "; clear:both; height:0; }
			* html .clearfix             { zoom:1; } /* IE6 */
			*:first-child+html .clearfix { zoom:1; } /* IE7 */
			p.pagebreakhere {page-break-before: always;}
		</style>
	</head>

	<body style="background-color:#fff;margin:0;padding:0;">
			<div class="letterPage">
				<table cellpadding="0" cellspacing="0" border="0" class="header">
					<tr>
						<td style="width:50%;">
              <span class="large bold"><xsl:value-of select="myDates/nextYear"/></span> &#160; <span class="large">NS Doers' &amp; Dreamers' Guide Application</span>
						</td>
						<td style="text-align:right;">
							<span class="large bold">Tour Operators</span>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="border-bottom:0;vertical-align:middle;padding:0.5em 0;">
							<span class="large">Tour category (1) <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Multi&#8211;day &#160;&#160;&#160;&#160;&#160;
							<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Outdoor* &#160;&#160;&#160;&#160;&#160;
							<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Sightseeing &#160;&#160;&#160;&#160;&#160;
							<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Step-on &#160;&#160;&#160;&#160;&#160;
							<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Walking
              </span>
						</td>
					</tr>
          <tr>
            <td colspan="2" style="border-bottom:0;vertical-align:middle;padding:0.5em 0;">
              <span>*Outdoor Sub-category 
              </span>
            </td>
          </tr>
          <tr>
            <td colspan="2" style="border-bottom:0;vertical-align:middle;padding:0.5em 0;">
              <span>
                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Boat Tours &amp; Charters &#160;&#160;&#160;&#160;&#160;
                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Multi-Activity Adventure &#160;&#160;&#160;&#160;&#160;
                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Nature &amp; Wildlife &#160;&#160;&#160;&#160;&#160;
                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Outdoor Adventure &#160;&#160;&#160;&#160;&#160;
              </span>
            </td>
          </tr>

        </table>

				<div class="disclaimer">
					Please enter your information below. Your entry will be edited and formatted to our standard.
				</div>

				<div style="margin:12px 4px 2px; border-bottom:1px solid #000;">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="width:50%;padding-right:20px;">
								<table cellpadding="0" cellspacing="0" border="0" class="app_form">
									<tr>
										<td style="width:25%;">Business</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Address</td>
										<td><span class="dotted_box">&#160;<br /><br /><br /><br /></span></td>
									</tr>
									<tr>
										<td>GPS Coordinates</td>
										<td><span class="dotted_box">&#160;<br /><br /><br /><br /></span></td>
									</tr>
									<tr>
										<td>Description</td>
										<td><span class="dotted_box">&#160;<br /><br /><br /><br /><br /><br /><br /></span></td>
									</tr>
									
									<tr>
										<td style="width:25%;">Dates</td>
										<td>
											<table cellpadding="0" cellspacing="0" border="0" style="display:table;table-layout:fixed;width:90%;">
												<tr>
													<td>Open</td>
													<td><span class="dotted_box">&#160;</span></td>
													<td><span class="dotted_box">&#160;</span></td>
													<td style="text-align:right;">Close</td>
													<td><span class="dotted_box">&#160;</span></td>
													<td><span class="dotted_box">&#160;</span></td>
												</tr>
												<tr>
													<td></td>
													<td style="text-align:center;"><small>month</small></td>
													<td style="text-align:center;"><small>day</small></td>
													<td></td>
													<td style="text-align:center;"><small>month</small></td>
													<td style="text-align:center;"><small>day</small></td>
												</tr>
											</table>
											<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Year-round
											&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
										<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Seasonal
										</td>
									</tr>
									<tr>
										<td>Date Notes</td>
										<td><span class="dotted_box">&#160;<br /><br /><br /><br /></span></td>
									</tr>
									<tr>
										<td>Tel N°</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Fax N°</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Toll&#8211;free N°</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Credit Cards</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Email</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Website</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
                  <tr>
                    <td>Facebook URL</td>
                    <td>
                      <span class="dotted_box">&#160;</span>
                    </td>
                  </tr>
                  <tr>
                    <td>Twitter URL</td>
                    <td>
                      <span class="dotted_box">&#160;</span>
                    </td>
                  </tr>
								</table>
								
							</td>
							<td>
								<p>Mark the items that apply to your listing.</p>
								
								<fieldset style="margin-bottom:12px;"><legend>Features</legend>
									<table cellpadding="0" cellspacing="0" border="0" class="icon_list" style="margin-bottom:0;width:250px;">
										<tr>
											<td>
												<ul>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">W</span> Wheelchair accessible</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">;</span> Partially accessible</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">a</span> Bienvenue member</li>
												</ul>
											</td>
										</tr>
									</table>
								</fieldset>
								
								<fieldset style="margin-bottom:12px;"><legend>Regions of Operation</legend>
									<table cellpadding="0" cellspacing="0" border="0" class="icon_list" style="margin-bottom:0;line-height:18px;">
										<tr>
											<td style="padding-right:10px;">
												<ul>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;</span> All of Nova Scotia
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Bras d'Or Lake Scenic Drive
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Ceilidh Trail
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Fleur-de-Lis-Marconi-Sydney<br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;CB
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Halifax Metro
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> South Shore
													</li>
												</ul>
											</td>
											<td>
												<ul>
													<li>&#160;</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Cabot Trail
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Eastern Shore
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Bay of Fundy &amp; Annapolis<br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Valley
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Northumberland Shore
													</li>
													<li>
														<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Yarmouth &amp; Acadian Shores
													</li>
												</ul>
											</td>
										</tr>
									</table>
								</fieldset>
								
								<fieldset style="margin-bottom:12px;"><legend>Symbols for <b>Outdoor</b> Tours Only:</legend>
									<table cellpadding="0" cellspacing="0" border="0" class="icon_list" style="margin-bottom:0;">
										<tr>
											<td>
												<ul>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">></span> 4-wheeling</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">Y</span> Birds &amp; Wildlife</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">{</span> Canoeing</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">K</span> Cycling</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">D</span> Diving</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">L</span> Hiking</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">}</span> Kayaking</li>
												</ul>
											</td>
											<td>
												<ul>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">b</span> Sailing Charters/Cruises</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">t</span> Sightseeing Tour</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">S</span> Skiing</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">s</span> Snowmobiling</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">y</span> Snowshoeing</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">f</span> Sports Fishing</li>
													<li><span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">w</span> Whale Watching</li>
												</ul>
											</td>
										</tr>
									</table>
									</fieldset>
									<p>A link for e-mail and website will be provided on the Nova Scotia Tourism website&#160;&#8211;&#160;<strong>www.novascotia.com</strong></p>
							</td>
						</tr>
					</table>
				</div>

				<table cellpadding="0" cellspacing="5" border="0">
					<tr>
						<td style="width:50%;padding:4px;border:1px solid #000;">
							<p>Contact information: this is for our use only and does not get entered in the listing.</p>
							
							<table cellpadding="0" cellspacing="0" border="0" class="app_form">
								<tr>
									<td style="width:25%;">Contact</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
								<tr>
									<td>Title/Position</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
								<tr>
									<td>Company</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
								<tr>
									<td>Mailing Addr</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
								<tr>
									<td>Telephone</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
								<tr>
									<td>Fax</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
								<tr>
									<td>Contact Email</td>
									<td><span class="dotted_box">&#160;</span></td>
								</tr>
							</table>
						
						</td>
						<td>
							<div style="margin:0; padding:4px;border:1px solid #000;">
								<div style="margin:2px 0 32px;">I certify that the information provided is correct.</div>
								<span style="border-top:1px dotted #000;">Signature &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="border-top:1px dotted #000;">Date &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span>
							</div>
							
							<p>This form MUST be received by <strong>Sept. 4, <xsl:value-of select="myDates/currentYear"/></strong> to be considered for inclusion in the <xsl:value-of select="myDates/nextYear"/> Doers' &amp; Dreamers' Guide.</p>
							
							<div style="width:349px;margin-left:100px;font-size:12px;letter-spacing:0;padding:6px;border: 1px solid #CCCCCC;" class="clearfix">
								<div style="display:inline;float:right;width:112px;padding:2px;border:2px dotted #CCCCCC;background-color:#fff;">
									<h4 style="margin:0;width:112px;font-size:12px;font-weight:normal;text-align:center;">For office use only.</h4>
									<h4 style="margin:40px 0 0 2px;padding-top:2px;width:108px;text-align:center;border-top:2px dotted #CCCCCC;" class="courier">
										<xsl:value-of select="contactId" />
									</h4>
								</div>
                Doers' &amp; Dreamers' Guide<br />
                Tourism Nova Scotia<br />
                PO Box 667, Windsor, NS B0N 2T0<br />
                Ph: 902-424-4709 &#160;&#160;Fax: 902-798-6600<br />
                email: doersndreamers@novascotia.ca
              </div>
						</td>
					</tr>
				</table>
			</div>
	</body>
</html>
  </xsl:template>
</xsl:stylesheet>