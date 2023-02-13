<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="facs" select="//tei:facsimile/tei:surface/tei:graphic"/>
    <xsl:variable name="pos2" select="//tei:pb"/>
    
    <xsl:template match="tei:pb">
        <xsl:variable name="idx" select="index-of(($pos2/@n), @n)"/>
        <xsl:copy>
            <xsl:attribute name="facs">
                <xsl:value-of select="$facs[$idx]/@url"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>