<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="products/product">

    <xsl:if test="productTypeId=5 or productTypeId=6">
    <div style="font-size:18px; letter-spacing:-0.6px;font-weight:bold;margin-bottom:12px;">
      <xsl:value-of select="guideSection"/>
    </div>
    </xsl:if>

      
      <xsl:if test="productTypeId!=4 and productTypeId!=7">
      <div>
      <span style='font-size:18px; letter-spacing:-0.6px;font-weight:bold;'>
        <xsl:value-of select="productName"/>
      </span>
      &#160;&#160;&#160;&#160;&#160;
      <span style='font-size:18px; font-family:"15TGSymbols"; font-weight:normal'>
        <xsl:value-of select="symbolString"/>
      </span>
    </div>
    </xsl:if>

    <xsl:if test="productTypeId=4">
      <div style="margin-bottom:6px;font-size:18px; letter-spacing:-0.6px;font-weight:bold;">
        <xsl:value-of select="productName"/>
        <xsl:if test="proprietor!=''">
        &#8226; <em>
          <xsl:value-of select="proprietor"/>
        </em>
        </xsl:if>
        &#160;&#160;&#160;&#160;&#160;
        <span style='font-size:18px; font-family:"15TGSymbols"; font-weight:normal'>
          <xsl:value-of select="symbolString"/>
        </span>
      </div>
      <div style="margin-bottom:6px;">
        <xsl:value-of select="exhibitType"/>
      </div>
      <div style="margin-bottom:6px;">
        <xsl:value-of select="fineArtsTypeDescription"/>
      </div>
    </xsl:if>

    <xsl:if test="productTypeId=7">
      <div>
        <span style='font-size:18px; letter-spacing:-0.6px;font-weight:bold;'>
          <xsl:value-of select="productName"/>
        </span>
        &#160;&#160;&#160;&#160;&#160;
        <span style='font-size:18px; font-family:"15TGSymbols"; font-weight:normal'>
          <xsl:value-of select="symbolString"/>
        </span>
      </div>
      <div style="margin-bottom:6px;">
        <xsl:value-of select="restaurantSubLine"/>
      </div>
    </xsl:if>

    <div style="height:274px;overflow:hidden;">
      <div style="font-size:14px;line-height:normal;font-weight:bold;">
        <xsl:value-of select="productContactString"/>
      </div>
      <div style="font-size:14px;line-height:28px;">
        <xsl:value-of select="listingBody" disable-output-escaping="yes"/>&#160;
      </div>
    </div>
    

    <div style="margin:0 4px 12px;">
      Listing character count: 
      <xsl:if test="characterCount>450">
      <b style="color:#cc0000;">
        <xsl:value-of select="characterCount"/>
      </b>.
    </xsl:if>
    <xsl:if test="450>=characterCount" >
      <b>
        <xsl:value-of select="characterCount"/>
      </b>.
    </xsl:if> All listings are limited to 450 characters (property name, symbols, punctuation and spaces are not counted.)
    </div>
    

  </xsl:template>
</xsl:stylesheet>
