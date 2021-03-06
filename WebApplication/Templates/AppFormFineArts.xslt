<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" >
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">



<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1"/>
		<title>Fine Arts Application Form</title>
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
						<td style="width:65%;">
							<span class="large bold"><xsl:value-of select="myDates/nextYear"/></span> &#160; <span class="large">NS Doers' &amp; Dreamers' Guide Application</span>
						</td>
						<td style="text-align:right;">
							<span class="large bold">
								Galleries, Shops, Artists &amp; Artisans
              </span>
						</td>
					</tr>
					<tr>
						<td style="vertical-align:middle;padding:0.5em 0;">Region <span style="border-bottom:1px solid #000;">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span></td>
						<td style="vertical-align:middle;padding:0.5em 0;">
							<ul>
								<li>
									<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Open Studio Artisan (NSDCC&#8211;juried)
                </li>
								<li>
									<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Galleries &amp; Shops (NS made product)
								</li>
							</ul>
						</td>
					</tr>
				</table>

				<div class="disclaimer">
					Please enter your information below. Your entry will be edited and formatted to our standard.
				</div>

				<div style="margin:12px 4px;">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="width:50%;padding-right:20px;">
								<table cellpadding="0" cellspacing="0" border="0" class="app_form">
									<tr>
										<td style="width:25%;">Artist name</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Business name</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Business location</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>GPS Coordinates</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Category<br />(max 2)</td>
										<td style="border-bottom:1px solid #000;">
											<table cellpadding="0" cellspacing="0" border="0" class="icon_list">
												<tr>
													<td>
														<ul>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Accessories
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Bath &amp; body products
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Clothing
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Fine art
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Furniture
															</li>
														</ul>
													</td>
													<td>
														<ul>
                              <li>
                                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Home d&#233;cor
                              </li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Garden accessories
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Jewellery
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Sculpture
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Visual art
															</li>
														</ul>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>Media specialty<br />(max 2)</td>
										<td>
											<table cellpadding="0" cellspacing="0" border="0" class="icon_list">
												<tr>
													<td>
														<ul>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Books &amp; cards
															</li>
                              <li>
                                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Candles
                              </li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Clay
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Fibre
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Glass
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Leather
															</li>
															
														</ul>
													</td>
													<td>
														<ul>
                              <li>
                                <span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Metal
                              </li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Paintings &amp; prints
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Paper
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Photography
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Stone &amp; bone
															</li>
															<li>
																<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> Wood
															</li>
														</ul>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
							<td>
								<p>Mark the items that apply to your listing.</p>

								<table cellpadding="0" cellspacing="0" border="0" class="icon_list">
									<tr>
										<td>
											<ul>
												<li>
													<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">W</span> Wheelchair accessible
												</li>
												<li>
													<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">;</span> Partially accessible
												</li>
												<li>
													<span class="checkbox">&#160;&#160;&#160;&#160;&#160;</span> <span class="symbols large">a</span> Bienvenue member
												</li>
											</ul>
										</td>
									</tr>
								</table>
								<table cellpadding="0" cellspacing="0" border="0" class="app_form">
									<tr>
										<td style="width:25%;">Dates</td>
										<td>
											<table cellpadding="0" cellspacing="0" border="0" style="display:table;table-layout:fixed;width:75%;">
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
										</td>
									</tr>
									<tr>
										<td>Hours of operation</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Credit cards</td>
										<td><span class="dotted_box">&#160;</span></td>
									</tr>
									<tr>
										<td>Telephone N°</td>
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
						</tr>
						<tr>
							<td colspan="2" style="border-bottom:1px solid #000;">
								<table cellpadding="0" cellspacing="0" border="0" class="app_form">
									<tr>
										<td style="width:12%;">Description</td>
										<td><span class="dotted_box">&#160;<br /><br /><br /><br /><br /><br /><br /></span></td>
									</tr>
								</table>
								<table cellpadding="0" cellspacing="0" border="0" class="app_form">
									<tr>
										<td style="width:40%;">What was your attendance for the previous season?</td>
										<td><span class="dotted_box">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span></td>
									</tr>
								</table>	
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
								<div style="margin:2px 0 32px;">I certify that the information provided is correct and that I meet the criteria set for my chosen listing type.</div>
								<span style="border-top:1px dotted #000;">Signature &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <span style="border-top:1px dotted #000;">Date &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</span>
							</div>
							
							<p>This form MUST be received by <strong>Aug. 29, <xsl:value-of select="myDates/currentYear"/></strong> to be considered for inclusion in the <xsl:value-of select="myDates/nextYear"/> Doers' &amp; Dreamers' Guide.</p>
							
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