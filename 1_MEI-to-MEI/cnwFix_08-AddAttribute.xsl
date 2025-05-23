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

  <!-- Remove empty attributes -->
  <xsl:template match="@*[normalize-space(.) = '']"/>

  <!-- Move element -->
  <!-- Step 1: Copy <address> from <respStmt> to <pubPlace> -->
  <xsl:template match="*:fileDesc/*:pubStmt[*:respStmt/*:corpName/*:address]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
      <pubPlace>
        <xsl:copy-of select="*:respStmt/*:corpName/*:address"/>
      </pubPlace>
    </xsl:copy>
  </xsl:template>
  <!-- Step 2: Delete <address> from <corpName> -->
  <xsl:template match="*:corpName[*:address]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*[not(local-name() eq 'address')]"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Replace "article" with "chapter" when genre = "book" -->
  <xsl:template match="*:bibl/*:genre[. = 'article']">
    <xsl:if test="../*:genre = 'book'">
      <genre>
        <xsl:copy-of select="@*"/>
        <xsl:text>chapter</xsl:text>
      </genre>
    </xsl:if>
  </xsl:template>
  
  <!-- When <contributor> contains more than one <persName>,
    create role-based elements -->
  <xsl:template match="*:contributor[count(*:persName) > 1]">
    <xsl:for-each select="*:persName">
      <xsl:element name="{@role}">
        <xsl:copy-of select="@*[not(local-name() eq 'role')]"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Add type="main" to work titles without @type -->
  <xsl:template match="*:work/*:title[not(@type)]">
    <xsl:copy>
      <xsl:attribute name="type">main</xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Copy Template: DEFAULT TEMPLATE -->
  <xsl:template match="element() | text() | processing-instruction() | comment() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
