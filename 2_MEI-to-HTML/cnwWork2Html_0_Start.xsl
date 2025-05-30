<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

  <xsl:output method="xhtml" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no"/>
  <xsl:strip-space elements="*"/>

  <!-- Start template -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
