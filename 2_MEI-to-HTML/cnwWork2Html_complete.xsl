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
          <xsl:value-of select="*:title[@xml:lang = 'en'][position() = 1]"/>
        </title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="
              concat(*:title[@type = 'main' and @xml:lang = 'en'], ': ',
              *:title[@type = 'subordinate' and @xml:lang = 'en'])"/>
        </h1>
        <h2>
          <xsl:value-of select="
              concat(*:title[@type = 'main' and @xml:lang = 'da'], ': ',
              *:title[@type = 'subordinate' and @xml:lang = 'da'])"/>
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
    <xsl:variable name="label">
      <xsl:value-of
        select="concat(upper-case(substring(local-name(), 1, 1)), substring(local-name(), 2))"
      />
    </xsl:variable>
    <h2>
      <xsl:value-of select="$label"/>
    </h2>
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="*:work/*:history">
    <h2>History</h2>
    <div>
      <xsl:apply-templates select="*:p"/>
    </div>
  </xsl:template>

  <xsl:template match="*:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="*:work/*:biblList">
    <h2>
      <xsl:value-of select="*:head"/>
    </h2>
    <ul>
      <xsl:apply-templates select="*:bibl[*:genre = 'book']"/>
    </ul>
  </xsl:template>

  <xsl:template match="*:bibl">
    <li>
      <xsl:value-of select="*:author"/>
      <xsl:text>. </xsl:text>
      <xsl:if test="*:title[@level = 'a']">
        <xsl:value-of select="*:title[@level = 'a']"/>
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:if test="*:title[@level = 'm']">
        <xsl:if test="*:title[@level = 'a']">
          <xsl:text>In </xsl:text>
        </xsl:if>
        <xsl:value-of select="*:title[@level = 'm']"/>
      </xsl:if>
      <xsl:if test="*:editor">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="*:editor"/>
        <xsl:text>, ed</xsl:text>
      </xsl:if>
      <xsl:text>. </xsl:text>
      <xsl:choose>
        <xsl:when test="*:imprint/*:pubPlace">
          <xsl:value-of select="*:imprint/*:pubPlace"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>s.l.</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="*:imprint/*:publisher">
          <xsl:value-of select="*:imprint/*:publisher"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>s.n.</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="*:imprint/*:date"/>
      <xsl:if test="*:biblScope">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="*:biblScope"/>
      </xsl:if>
      <xsl:text>.</xsl:text>
    </li>
  </xsl:template>

  <xsl:template match="*:ref">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@target"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="*[@fontstyle = 'italic']">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

</xsl:stylesheet>
