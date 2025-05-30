<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

  <xsl:output method="xhtml" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//*:work"/>
  </xsl:template>
  
  <xsl:template match="*:work">
    <html>
      <head>
        <title>
          <xsl:value-of select="*:title[@xml:lang='en'][position() = 1]"/>
        </title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="concat(*:title[@xml:lang='en' and @type='main'], ': ',  *:title[@xml:lang='en' and @type='subordinate'])"/>
        </h1>
        <h2>
          <xsl:value-of select="concat(*:title[@xml:lang='da' and @type='main'], ': ',  *:title[@xml:lang='da' and @type='subordinate'])"/>
        </h2>

        <h2>Identifier(s)</h2>
        <ul>
          <xsl:for-each select="*:identifier">
            <li>
              <xsl:value-of select="concat(., ' (', @label, ')')"/>
            </li>
          </xsl:for-each>
        </ul>
        
        <xsl:apply-templates select="
          *:composer, *:author,
          *:creation,
          *:history,
          *:biblList[*:head[. eq 'Bibliography']]"/>

      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="*:work/*:composer | *:work/*:author | *:work/*:creation">
    <xsl:variable name="heading2name">
      <xsl:value-of select="local-name()"/>
      <!--<xsl:value-of
        select="concat(upper-case(substring(local-name(), 1, 1)), substring(local-name(), 2))"
      />-->
    </xsl:variable>
    <h2>
      <!-- Value of the variable (which is its local name with the first letter capitalized) -->
      <xsl:value-of select="$heading2name"/>
    </h2>
    <p>
      <!--Default: copy text (of the matched node) -->
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="*:work/*:history"></xsl:template>
  
  <xsl:template match="*:work/*:biblList"></xsl:template>
 
</xsl:stylesheet>
