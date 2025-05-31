<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

  <xsl:output method="text" encoding="UTF-8" indent="yes" media-type="text/xml"
    omit-xml-declaration="no" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <!-- Input file name-->
  <xsl:variable name="inputFilename">
    <xsl:value-of select="tokenize(base-uri(.), '/')[last()]"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:text>MEI Census (</xsl:text>
    <xsl:value-of select="$inputFilename"/>
    <xsl:text>)&#xa;&#xa;</xsl:text>

    <!-- Simple counts -->
    <xsl:text>Number of measures: </xsl:text>
    <xsl:value-of select="count(//*:measure)"/>
    <xsl:text>&#xa;Number of empty measures: </xsl:text>
    <!-- Use case insensitive match to get mRest and mSpace -->
    <xsl:value-of
      select="count(//*:measure[not(descendant::*[matches(local-name(), 'note|chord|rest|space', 'i')])])"/>
    <xsl:text>&#xa;Number of barlines: </xsl:text>
    <xsl:value-of
      select="count(//*:measure[not(@right = 'invis')]) + count(//*:barLine[not(@visible = 'false')])"/>
    <xsl:text>&#xa;Number of chords: </xsl:text>
    <xsl:value-of select="count(//*:chord)"/>
    <xsl:text>&#xa;Number of notes: </xsl:text>
    <xsl:value-of select="count(//*:note) - count(//*:tie) - count(//*:note[@tie])"/>
    <xsl:text>&#xa;Number of noteheads: </xsl:text>
    <xsl:value-of select="count(//*:note)"/>
    <xsl:text>&#xa;Number of rests: </xsl:text>
    <xsl:value-of select="count(//*[matches(local-name(), 'rest|mRest')])"/>
    <xsl:text>&#xa;Number of ties: </xsl:text>
    <xsl:value-of select="count(//*:tie) + count(//*[@tie])"/>
    <xsl:text>&#xa;Number of beams: </xsl:text>
    <xsl:value-of select="count(//*:beam) + count(//*:beamSpan)"/>
    <!-- beamSpan not accounted for! -->
    <xsl:text>&#xa;Number of beamed chords: </xsl:text>
    <xsl:value-of select="count(//*:chord[ancestor::*:beam | @beam])"/>
    <xsl:text>&#xa;Number of beamed notes: </xsl:text>
    <xsl:value-of select="count(//*:note[ancestor::*:beam | @beam])"/>
    <xsl:text>&#xa;Number of beamed rests: </xsl:text>
    <xsl:value-of select="count(//*:rest[ancestor::*:beam | @beam])"/>

    <!-- To find the maximum number of staves and layers: 
      Variables containing a mini-xml document in order to apply 
      sorting and find the minimum and maximum number of something -->
    <xsl:variable name="measuresStaves">
      <xsl:for-each select="//*:measure">
        <xsl:sort select="count(*:staff)"/>
        <measure>
          <xsl:attribute name="staves">
            <xsl:value-of select="count(*:staff)"/>
          </xsl:attribute>
        </measure>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="measuresLayers">
      <xsl:for-each select="//*:measure">
        <xsl:sort select="count(descendant::*:layer)"/>
        <measure>
          <xsl:attribute name="layers">
            <xsl:value-of select="count(descendant::*:layer)"/>
          </xsl:attribute>
        </measure>
      </xsl:for-each>
    </xsl:variable>

    <!-- Results -->
    <xsl:text>&#xa;Maximum number of staves: </xsl:text>
    <xsl:value-of select="$measuresStaves/measure[last()]/@staves"/>
    <xsl:text>&#xa;Maximum number of layers: </xsl:text>
    <xsl:value-of select="$measuresLayers/measure[last()]/@layers"/>

    <!-- To find shortest and longest durations: 
      Variables containing a mini-xml document in order to apply 
      sorting and find the minimum and maximum number of something
      (also use of 'replace' function to facilitate the sorting) -->
    <xsl:variable name="sortedDurations">
      <xsl:for-each select="//*:note[@dur] | //*:chord[@dur]">
        <xsl:sort select="
            replace(replace(replace(replace(replace(
            replace(replace(replace(replace(replace(
            @dur,
            'breve', '.5'),
            'long$', '.25'),
            'longa', '.5'),
            'maxima', '.25'),
            '^brevis', '1'),
            'semibrevis', '2'),
            '^minima', '4'),
            'semiminima', '8'),
            '^fusa', '16'),
            'semifusa', '32')" data-type="number" order="ascending"/>
        <dur dur="{@dur}">
          <!-- breve and long may occur in CMN, others only in Mensural -->
          <xsl:value-of select="
              replace(replace(replace(replace(replace(
              replace(replace(replace(replace(replace(
              @dur,
              'breve', '.5'),
              'long$', '.25'),
              'longa', '.5'),
              'maxima', '.25'),
              '^brevis', '1'),
              'semibrevis', '2'),
              '^minima', '4'),
              'semiminima', '8'),
              '^fusa', '16'),
              'semifusa', '32')"/>
        </dur>
      </xsl:for-each>
    </xsl:variable>

    <!-- Results -->
    <xsl:text>&#xa;Longest note duration: </xsl:text>
    <xsl:value-of select="$sortedDurations/*:dur[1]/@dur"/>
    <xsl:text>&#xa;Shortest note duration: </xsl:text>
    <xsl:value-of select="$sortedDurations/*:dur[last()]/@dur"/>
  </xsl:template>
</xsl:stylesheet>
