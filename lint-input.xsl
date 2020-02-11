<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="h"
  version="1.0">

<!-- Does not work: <xsl:output method="xhtml"/> -->

<!-- IFrames are treated weirdly. If they have a comment inside, Chromium will escape the comment out -->
<xsl:template match="h:iframe[not(node())]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:text> </xsl:text>
  </xsl:copy>
</xsl:template>

<!-- Ensure non-selfclosing elements without children always have a CLOSE TAG -->
<xsl:template match="*[not(node())][not(
      self::h:area or 
      self::h:base or 
      self::h:br or 
      self::h:col or 
      self::h:command or 
      self::h:embed or 
      self::h:hr or 
      self::h:img or 
      self::h:input or 
      self::h:keygen or 
      self::h:link or 
      self::h:meta or 
      self::h:param or 
      self::h:source or 
      self::h:track or 
      self::h:wbr
    )]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
    <!-- Add an empty string to force the element to not be self-closing -->
    <!-- These methods no longer work -->
    <!-- <xsl:text></xsl:text> -->
    <!-- <xsl:value-of select="''"/> -->
    <!-- <xsl:value-of select="'UNIQUE_STRING_TO_SED_OUT_LATER'"/> -->
    <xsl:comment></xsl:comment>
  </xsl:copy>
</xsl:template>

<!-- ensure that these elements are always SELF-CLOSING -->
<xsl:template match="*[
      self::h:area or 
      self::h:base or 
      self::h:br or 
      self::h:col or 
      self::h:command or 
      self::h:embed or 
      self::h:hr or 
      self::h:img or 
      self::h:input or 
      self::h:keygen or 
      self::h:link or 
      self::h:meta or 
      self::h:param or 
      self::h:source or 
      self::h:track or 
      self::h:wbr
    ]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
  </xsl:copy>
</xsl:template>


<!-- Identity transform -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>