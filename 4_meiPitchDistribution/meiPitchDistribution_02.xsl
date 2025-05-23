<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

  <xsl:output method="text" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <!-- By default, column headings are shown -->
  <xsl:param name="showHeader" select="'yes'"/>

  <!-- input file name-->
  <xsl:variable name="inputFilename">
    <xsl:value-of select="tokenize(base-uri(.), '/')[last()]"/>
  </xsl:variable>

  <xsl:template match="/">
    <!-- Add pitch class -->
    <xsl:variable name="notesWithPitchClass">
      <xsl:for-each select="//*:note[@pname]">
        <note>
          <xsl:variable name="pclass">
            <xsl:value-of select="
                replace(replace(
                replace(replace(replace(replace(replace(
                @pname, 'c', '0'), 'd', '2'), 'e', '4'),
                'f', '5'), 'g', '7'), 'a', '9'), 'b', '11')"/>
          </xsl:variable>
          <xsl:copy-of select="@pname"/>
          <xsl:attribute name="accid">
            <xsl:choose>
              <xsl:when test="@accid">
                <xsl:value-of select="replace(@accid, 'ns', 's')"/>
              </xsl:when>
              <xsl:when test="@accid.ges">
                <xsl:value-of select="replace(@accid.ges, 'ns', 's')"/>
              </xsl:when>
              <xsl:when test="*:accid/@accid">
                <xsl:value-of select="replace(*:accid/@accid, 'ns', 's')"/>
              </xsl:when>
              <xsl:when test="*:accid/@accid.ges">
                <xsl:value-of select="replace(*:accid/@accid.ges, 'ns', 's')"/>
              </xsl:when>
              <xsl:otherwise>n</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:copy-of select="@oct"/>
          <xsl:variable name="accidOffset">
            <xsl:choose>
              <xsl:when
                test="@accid = 'f' or @accid.ges = 'f' or *:accid/@accid = 'f' or *:accid/@accid.ges = 'f'"
                >-1</xsl:when>
              <xsl:when
                test="@accid = 'ff' or @accid.ges = 'ff' or *:accid/@accid = 'ff' or *:accid/@accid.ges = 'ff'"
                >-2</xsl:when>
              <xsl:when
                test="@accid = 's' or @accid.ges = 's' or *:accid/@accid = 's' or *:accid/@accid.ges = 's'"
                >1</xsl:when>
              <xsl:when test="
                  @accid = 'ss' or @accid.ges = 'ss' or *:accid/@accid = 'ss'
                  or *:accid/@accid.ges = 'ss' or @accid = 'x' or @accid.ges = 'x' or
                  *:accid/@accid = 'x' or *:accid/@accid.ges = 'x'"
                >2</xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="accidOffset">
            <xsl:value-of select="$accidOffset"/>
          </xsl:attribute>
          <xsl:attribute name="pnum">
            <xsl:value-of select="$pclass + $accidOffset + (@oct * 12)"/>
          </xsl:attribute>
          <xsl:attribute name="pclass">
            <xsl:value-of select="($pclass + $accidOffset) mod 12"/>
          </xsl:attribute>
        </note>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="pitchDistribution">
      <!-- Count pitch classes -->
      <xsl:for-each-group select="$notesWithPitchClass/*:note" group-by="@pnum">
        <xsl:variable name="pnum">
          <xsl:value-of select="current-grouping-key()"/>
        </xsl:variable>
        <xsl:for-each-group select="current-group()" group-by="@pname">
          <pitch>
            <count>
              <xsl:value-of select="count(current-group())"/>
            </count>
            <pclass>
              <xsl:value-of select="@pclass"/>
            </pclass>
          </pitch>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:variable>

    <xsl:if test="$showHeader eq 'yes'">
      <!-- Created header row -->
      <xsl:variable name="header">
        <!--<xsl:value-of select="concat('MEI Pitch Class Distribution (', $inputFilename, ')&#xa;')"/>-->
        <xsl:text>Pitch Class Num</xsl:text>
        <xsl:text>&#x9;Pitch Class Name</xsl:text>
        <xsl:text>&#x9;Pitch Class Count&#xa;</xsl:text>
      </xsl:variable>
      <xsl:value-of select="$header"/>
    </xsl:if>

    <xsl:for-each-group select="$pitchDistribution/*:pitch" group-by="*:pclass">
      <!-- Calculate frequency of pitch classes -->
      <xsl:sort select="sum(current-group()/*:count)" order="descending"/>
      <xsl:value-of select="current-grouping-key()"/>
      <xsl:text>&#x9;</xsl:text>
      <!-- Display normalized pitch class "name" -->
      <xsl:choose>
        <xsl:when test="current-grouping-key() = '0'">
          <xsl:text>C♮/B#</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '1'">
          <xsl:text>C#/D♭</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '2'">
          <xsl:text>D♮</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '3'">
          <xsl:text>D#/E♭</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '4'">
          <xsl:text>E♮/F♭</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '5'">
          <xsl:text>E#/F♮</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '6'">
          <xsl:text>F#/G♭</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '7'">
          <xsl:text>G♮</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '8'">
          <xsl:text>G#/A♭</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '9'">
          <xsl:text>A♮</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '10'">
          <xsl:text>A#/B♭</xsl:text>
        </xsl:when>
        <xsl:when test="current-grouping-key() = '11'">
          <xsl:text>B♮</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text>&#x9;</xsl:text>
      <xsl:value-of select="sum(current-group()/*:count)"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each-group>

  </xsl:template>

</xsl:stylesheet>
