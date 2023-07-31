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
    
    <xsl:template match="//tei:respStmt//tei:persName[@xml:id='dst']">
        <xsl:copy>
            <xsl:attribute name="ref">
                <xsl:text>https://orcid.org/0000-0002-0636-4476</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:respStmt//tei:persName[@xml:id='ds']">
        <xsl:copy>
            <xsl:attribute name="ref">
                <xsl:text>https://orcid.org/0000-0003-2436-0361</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:respStmt//tei:persName[@xml:id='aw']">
        <xsl:copy>
            <xsl:attribute name="ref">
                <xsl:text>http://d-nb.info/gnd/1033827401</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:publicationStmt//tei:address/tei:addrLine[1]">
        <xsl:copy>
            <xsl:text>Bäckerstraße 13</xsl:text>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:publicationStmt/tei:date">
        <xsl:copy>
            <xsl:attribute name="when">
                <xsl:text>2023</xsl:text>
            </xsl:attribute>
            <xsl:text>2023</xsl:text>
        </xsl:copy>
    </xsl:template>
    <!-- <xsl:template match="//tei:facsimile/tei:surface/tei:graphic">
        <xsl:copy>
            <xsl:attribute name="url">
                <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/hanslick-vms/', tokenize(@url, '/')[last()])"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template> -->
    
</xsl:stylesheet>