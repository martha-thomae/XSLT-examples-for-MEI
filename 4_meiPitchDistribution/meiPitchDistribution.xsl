<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

  <xsl:output method="text" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <!-- By default, column headings are shown -->
  <xsl:param name="showHeader" select="'yes'"/>

  <!-- By default, MIDI key number is displayed -->
  <xsl:param name="showMidiKeyNum" select="'yes'"/>

  <!-- input file name-->
  <xsl:variable name="inputFilename">
    <xsl:value-of select="tokenize(base-uri(.), '/')[last()]"/>
  </xsl:variable>

  <xsl:template match="/">
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

    <xsl:variable name="sortedNotes">
      <xsl:for-each select="$notesWithPitchClass/*:note">
        <xsl:sort select="@pnum" data-type="number"/>
        <xsl:sort select="@pname" data-type="text"/>
        <xsl:sort select="@accid" data-type="text"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="pitchDistribution">
      <xsl:for-each-group select="$sortedNotes/*:note" group-by="@pnum">
        <xsl:variable name="pnum">
          <xsl:value-of select="current-grouping-key()"/>
        </xsl:variable>
        <xsl:for-each-group select="current-group()" group-by="@pname">
          <pitch>
            <pname>
              <xsl:value-of select="current-grouping-key()"/>
              <xsl:value-of
                select="replace(replace(replace(current-group()[1]/@accid, 's', '♯'), 'f', '♭'), 'n', '♮')"/>
              <xsl:value-of select="current-group()[1]/@oct"/>
            </pname>
            <midiKey>
              <xsl:value-of select="$pnum"/>
            </midiKey>
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
      <xsl:variable name="header">
        <xsl:text>Pitch Name</xsl:text>
        <xsl:if test="$showMidiKeyNum eq 'yes'">
          <xsl:text>&#x9;MIDI key</xsl:text>
        </xsl:if>
        <xsl:text>&#x9;Pitch Class Number</xsl:text>
        <xsl:text>&#x9;Pitch Name Count&#xa;</xsl:text>
      </xsl:variable>
      <xsl:value-of select="$header"/>
    </xsl:if>

    <xsl:for-each select="$pitchDistribution/*:pitch">
      <!-- Uncomment the following line to sort by note frequency -->
      <!--<xsl:sort select="*:count" data-type="number" order="descending"/>-->
      <xsl:sort select="*:midiKey" data-type="number"/>
      <xsl:value-of select="*:pname"/>
      <xsl:text>&#x9;</xsl:text>
      <xsl:if test="$showMidiKeyNum = 'yes'">
        <xsl:value-of select="*:midiKey"/>
        <xsl:text>&#x9;</xsl:text>
      </xsl:if>
      <xsl:value-of select="*:pclass"/>
      <xsl:text>&#x9;</xsl:text>
      <xsl:value-of select="*:count"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
