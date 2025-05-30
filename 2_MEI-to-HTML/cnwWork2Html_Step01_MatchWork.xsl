<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

  <xsl:output method="xhtml" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no"/>
  <xsl:strip-space elements="*"/>

  <!-- Apply template to work -->
  <xsl:template match="/">
    <xsl:apply-templates select="//*:work"/>
  </xsl:template>
  
  <!-- Template that matches work -->
  <xsl:template match="*:work">
    <html>
      <head></head>
      <body></body>
    </html>
  </xsl:template>

</xsl:stylesheet>
