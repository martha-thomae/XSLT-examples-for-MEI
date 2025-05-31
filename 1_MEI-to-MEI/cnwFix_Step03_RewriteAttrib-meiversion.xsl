<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.music-encoding.org/ns/mei"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="3.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" media-type="text/xml" omit-xml-declaration="no"/>
  <xsl:strip-space elements="*"/>

  <!-- Start Template -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Change an attribute's value: Force @meiversion to '5.0' -->
  <xsl:template match="@meiversion">
    <xsl:attribute name="meiversion">5.0</xsl:attribute>
  </xsl:template>

  <!-- Copy Template: DEFAULT TEMPLATE -->
  <xsl:template match="element() | text() | processing-instruction() | comment() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
