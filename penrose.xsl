<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
  xmlns:penrose="https://penrose.cs.cmu.edu/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.jonmsterling.com/jms-005P.xml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:html="http://www.w3.org/1999/xhtml">

  <xsl:template match="penrose:diagram">
    <xsl:copy>
      <xsl:attribute name="uid">
        <xsl:value-of select="generate-id(.)"/>
      </xsl:attribute>
    </xsl:copy>
    <script type="module">
      <xsl:text>import { compile, optimize, toSVG, showError } from "@penrose/core";
      </xsl:text>

      <xsl:text>const trio = {</xsl:text>
        <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
      <xsl:text>
        const compiled = await compile(trio);
        if (compiled.isErr()) console.error(showError(compiled.error));
        const optimized = optimize(compiled.value);
        if (optimized.isErr()) console.error(showError(optimized.error));
        document
          .getElementById("</xsl:text><xsl:value-of select="generate-id(.)"></xsl:value-of><xsl:text>").appendChild(await toSVG(optimized.value));
      </xsl:text>

    </script>

    <div>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id(.)"/>
      </xsl:attribute>
    </div>

  </xsl:template>

  <xsl:template match="penrose:substance">
    <xsl:text>substance: `</xsl:text>
      <xsl:value-of select="."/>
    <xsl:text>`,</xsl:text>
  </xsl:template>

  <xsl:template match="penrose:style">
    <xsl:text>style: `</xsl:text>
      <xsl:value-of select="."/>
    <xsl:text>`,</xsl:text>
  </xsl:template>

  <xsl:template match="penrose:domain">
    <xsl:text>domain: `</xsl:text>
      <xsl:value-of select="."/>
    <xsl:text>`</xsl:text>
  </xsl:template>

</xsl:stylesheet>
