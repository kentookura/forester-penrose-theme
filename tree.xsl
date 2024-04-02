<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.jonmsterling.com/jms-005P.xml">

  <xsl:key name="tree-with-addr" match="/f:tree/f:mainmatter//f:tree" use="f:frontmatter/f:addr/text()" />

  <xsl:template match="/">
    <html>
      <head>
        <meta name="viewport" content="width=device-width" />
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet" href="katex.min.css" />
        <script type="text/javascript">
          <xsl:if test="/f:tree/f:frontmatter/f:source-path">
            <xsl:text>window.sourcePath = '</xsl:text>
            <xsl:value-of select="/f:tree/f:frontmatter/f:source-path" />
            <xsl:text>'</xsl:text>
          </xsl:if>
        </script>
        <script type="module" src="forester.js"></script>
        <title>
          <xsl:value-of select="/f:tree/f:frontmatter/f:title" />
        </title>
      </head>
      <body>
        <ninja-keys placeholder="Start typing a note title or ID"></ninja-keys>
        <xsl:if test="not(/f:tree[@f:root = 'true'])">
          <header class="header">
            <nav class="nav">
              <div class="logo">
                <a href="index.xml" title="Home">
                  <xsl:text>« Home</xsl:text>
                </a>
              </div>
            </nav>
          </header>
        </xsl:if>
        <div id="grid-wrapper">
          <article>
            <xsl:apply-templates select="f:tree" />
          </article>
          <xsl:if test="f:tree/f:mainmatter/f:tree[not(@f:toc='false')] and not(/f:tree/f:frontmatter/f:meta[@f:name = 'toc']/.='false')">
            <nav id="toc">
              <div class="block">
                <h1>Table of Contents</h1>
                <xsl:apply-templates select="f:tree/f:mainmatter" mode="toc" />
              </div>
            </nav>
          </xsl:if>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="numbered-taxon">
    <span class="taxon">
      <xsl:apply-templates select="f:taxon" />
      <xsl:if test="(not(../@f:numbered='false') and not(../@f:toc='false') and count(../../f:tree) > 1) or f:number">
        <xsl:if test="f:taxon">
          <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="f:number">
            <xsl:value-of select="f:number" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:number format="1.1" count="f:tree[ancestor::f:tree and not(@f:toc='false') and not(@f:numbered='false')]" level="multiple" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="f:taxon or (not(../@f:numbered='false') and not(../@f:toc='false') and count(../../f:tree) > 1) or f:number">
        <xsl:text>.&#160;</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="f:tree" mode="toc">
    <li>
      <xsl:for-each select="f:frontmatter">
        <a href="{f:route}" class="bullet" title="{f:title} [{f:addr}]">■</a>
        <span class="link local" data-target="#tree-{f:anchor}">
          <xsl:call-template name="numbered-taxon" />
          <xsl:apply-templates select="f:title" />
        </span>
      </xsl:for-each>
      <xsl:apply-templates select="f:mainmatter" mode="toc" />
    </li>
  </xsl:template>

  <xsl:template match="f:mainmatter" mode="toc">
    <ul class="block">
      <xsl:apply-templates select="f:tree[not(@f:toc='false')]" mode="toc" />
    </ul>
  </xsl:template>

  <xsl:template match="f:frontmatter/f:title">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="f:mainmatter">
    <div class="f:tree-content">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="f:addr">
    <a class="slug" href="{../f:route}">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>]</xsl:text>
    </a>
  </xsl:template>

  <xsl:template match="f:source-path">
    <a class="edit-button" href="{concat('vscode://file', .)}">
      <xsl:text>[edit]</xsl:text>
    </a>
  </xsl:template>

  <xsl:template match="f:taxon">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="f:frontmatter">
    <header>
      <h1>
        <xsl:call-template name="numbered-taxon" />
        <xsl:apply-templates select="f:title" />
        <xsl:text>&#032;</xsl:text>
        <xsl:apply-templates select="f:addr" />
        <xsl:text>&#032;</xsl:text>
        <xsl:apply-templates select="f:source-path" />
      </h1>
      <div class="metadata">
        <ul>
          <xsl:apply-templates select="f:date" />
          <xsl:if test="not(f:meta[@f:name = 'author']/.='false')">
            <xsl:apply-templates select="f:authors" />
          </xsl:if>
          <xsl:apply-templates select="f:meta[@f:name='position']" />
          <xsl:apply-templates select="f:meta[@f:name='institution']" />
          <xsl:apply-templates select="f:meta[@f:name='venue']" />
          <xsl:apply-templates select="f:meta[@f:name='source']" />
          <xsl:apply-templates select="f:meta[@f:name='doi']" />
          <xsl:apply-templates select="f:meta[@f:name='orcid']" />
          <xsl:apply-templates select="f:meta[@f:name='external']" />
          <xsl:apply-templates select="f:meta[@f:name='slides']" />
          <xsl:apply-templates select="f:meta[@f:name='video']" />
        </ul>
      </div>
    </header>
  </xsl:template>

  <xsl:template match="f:tree" mode="tree-number">
    <xsl:choose>
      <xsl:when test="f:frontmatter/f:number">
        <xsl:value-of select="f:frontmatter/f:number" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:number format="1.1" count="f:tree[ancestor::f:tree and not(@f:toc='false') and not(@f:numbered='false')]" level="multiple" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="f:ref">
    <a class="link local">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="key('tree-with-addr',current()/@f:addr)">
            <xsl:text>#tree-</xsl:text>
            <xsl:value-of select="key('tree-with-addr',current()/@f:addr)/f:frontmatter/f:anchor" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@f:href" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="@f:taxon">
          <xsl:value-of select="@f:taxon" />
        </xsl:when>
        <xsl:otherwise>§</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#160;</xsl:text>
      <xsl:choose>
        <xsl:when test="@f:number">
          <xsl:value-of select="@f:number" />
        </xsl:when>
        <xsl:when test="key('tree-with-addr',current()/@f:addr)[not(@f:numbered='false') and not(@f:toc='false')]">
          <xsl:apply-templates select="key('tree-with-addr',current()/@f:addr)[1]" mode="tree-number" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[</xsl:text>
          <xsl:value-of select="@f:addr" />
          <xsl:text>]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="f:backmatter/f:references" mode="title">
    <xsl:text>References</xsl:text>
  </xsl:template>

  <xsl:template match="f:backmatter/f:context" mode="title">
    <xsl:text>Context</xsl:text>
  </xsl:template>

  <xsl:template match="f:backmatter/f:contributions" mode="title">
    <xsl:text>Contributions</xsl:text>
  </xsl:template>

  <xsl:template match="f:backmatter/f:related" mode="title">
    <xsl:text>Related</xsl:text>
  </xsl:template>

  <xsl:template match="f:backmatter/f:backlinks" mode="title">
    <xsl:text>Backlinks</xsl:text>
  </xsl:template>

  <xsl:template match="f:backmatter/f:references|f:backmatter/f:context|f:backmatter/f:contributions|f:backmatter/f:related|f:backmatter/f:backlinks">
    <xsl:if test="f:tree">
      <section class="block link-list">
        <h2>
          <xsl:apply-templates select="." mode="title" />
        </h2>
        <xsl:apply-templates select="f:tree" />
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/f:tree[not(@root='true')]/f:backmatter">
    <footer>
      <xsl:apply-templates select="f:references" />
      <xsl:apply-templates select="f:context" />
      <xsl:apply-templates select="f:backlinks" />
      <xsl:apply-templates select="f:related" />
      <xsl:apply-templates select="f:contributions" />
    </footer>
  </xsl:template>

  <xsl:template match="/f:tree[@root='true']/f:backmatter">
  </xsl:template>

  <xsl:template match="f:tree">
    <section>
      <xsl:attribute name="lang">
        <xsl:choose>
          <xsl:when test="f:frontmatter/f:meta[@f:name='lang']">
            <xsl:value-of select="f:frontmatter/f:meta[@f:name='lang']" />
          </xsl:when>
          <xsl:otherwise>en</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="@f:show-metadata = 'false'">
          <xsl:attribute name="class">block hide-metadata</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">block</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="f:frontmatter/taxon">
        <xsl:attribute name="data-taxon">
          <xsl:value-of select="f:frontmatter/taxon" />
        </xsl:attribute>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="not(@f:show-heading='false')">
          <details id="{concat('tree-',f:frontmatter/f:anchor)}">
            <xsl:if test="not(@f:expanded = 'false')">
              <xsl:attribute name="open">open</xsl:attribute>
            </xsl:if>
            <summary>
              <xsl:apply-templates select="f:frontmatter" />
            </summary>
            <xsl:apply-templates select="f:mainmatter" />
            <xsl:apply-templates select="f:frontmatter/f:meta[@f:name='bibtex']" />
          </details>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="f:mainmatter" />
        </xsl:otherwise>
      </xsl:choose>
    </section>

    <xsl:apply-templates select="f:backmatter" />
  </xsl:template>

  <xsl:template match="f:backmatter/*/f:tree">
    <section class="block">
      <xsl:if test="f:frontmatter/f:taxon">
        <xsl:attribute name="data-taxon">
          <xsl:value-of select="f:frontmatter/f:taxon" />
        </xsl:attribute>
      </xsl:if>
      <details>
        <summary>
          <xsl:apply-templates select="f:frontmatter" />
        </summary>
        <xsl:apply-templates select="f:mainmatter" />
      </details>
    </section>
  </xsl:template>

</xsl:stylesheet>
