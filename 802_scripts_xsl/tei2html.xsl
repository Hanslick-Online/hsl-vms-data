<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../TEI-Stylesheets/Stylesheets-dev/html/html.xsl"/>
    <!--
    <xsl:template match="/">
        <xsl:param name="skipPre" select="false()"/>
        <xsl:choose>
            <xsl:when test="$skipPre">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="pre">
                    <xsl:apply-templates mode="pre"/>
                </xsl:variable>
               
                <xsl:apply-templates select="$pre">
                    <xsl:with-param name="skipPre" select="true()"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    -->
    <xsl:template match="tei:ref[@type]">
        <a class="{@type}" href="{@target}"><xsl:apply-templates/></a>
    </xsl:template>
    <!--
    <xsl:template match="node() | @*" mode="pre">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="*[tei:list[@type='index-references']]">
        <dl class="row">
            <dt class="col-sm-3"><xsl:value-of select="tei:name"/></dt>
            <xsl:apply-templates select="* except tei:name"/>
        </dl>
    </xsl:template>
            
    <xsl:template match="tei:list[@type='index-references']/tei:item">
        <li class="list-inline-item"><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="tei:list[@type='index-references']" priority="100">
        <dd class="col-sm-9"><xsl:apply-templates/></dd>    
    </xsl:template>
    
    <xsl:template match="tei:pb[exists(preceding-sibling::node()[not(normalize-space(.) = '')]) and exists(following-sibling::node()[not(normalize-space(.) = '')])]">
        <span class="pagebreakIndicator">[/]</span>
        <xsl:next-match/>
    </xsl:template>
    
    
    <xsl:template match="tei:p[@n]">
        <p class="indentedP" id="{@xml:id}">
            <a class="parNum" href="diff_{@n}.html">§ <xsl:value-of select="replace(@n, 'xyz', '')"/> </a>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <table class="table">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="tei:figure/tei:head|tei:notatedMusic/tei:desc">
        <figcaption class="figure-caption text-end"><xsl:apply-templates/></figcaption>
    </xsl:template>
    
    <xsl:template match="tei:figure|tei:notatedMusic">
        <figure class="figure">
            <xsl:apply-templates/>
        </figure>
    </xsl:template>
    
    <xsl:template match="tei:cit">
        <span class="cit">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <span class="quote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit='section']">
        <span class="asterisk">
            ***
        </span>
    </xsl:template>

    <xsl:template match="tei:space">
        <span class="space">
            <xsl:value-of select="string-join((for $i in 1 to @quantity return '&#x00A0;'),'')"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:bibl">
        <span class="bibl" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:rs">
        <span class="{@type} {@subtype} {substring-after(@rendition, '#')}" id="{@xml:id}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
</xsl:stylesheet>