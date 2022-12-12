<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--<xsl:param name="collection" select="'../102_derived_tei/102_02_tei-simple_refactored'"/>-->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!--  uncomment to remove xml:id attr  -->
    <!--
    <xsl:template match="//tei:body//tei:rs[@type='person']">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*[not(name(.) = 'xml:id')]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:body//tei:rs[@type='place']">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*[not(name(.) = 'xml:id')]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:body//tei:rs[@type='bibl']">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*[not(name(.) = 'xml:id')]"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:body//tei:rs[@type='org']">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*[not(name(.) = 'xml:id')]"/>
        </xsl:copy>
    </xsl:template>
    -->
    
    <!--  replace with rs  -->
    
    <xsl:template match="//tei:body//tei:persName">
        <rs type="person" ref="#enter-person-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then ('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
    <xsl:template match="//tei:front//tei:persName">
        <rs type="person" ref="#enter-person-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then ('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
    <xsl:template match="//tei:body//tei:placeName">
        <rs type="place" ref="#enter-place-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
    <xsl:template match="//tei:front//tei:placeName">
        <rs type="place" ref="#enter-place-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
    <xsl:template match="//tei:body//tei:bibl">
        <rs type="bibl" ref="#enter-bibl-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
    <xsl:template match="//tei:body//tei:title">
        <rs type="bibl" ref="#enter-bibl-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
    <xsl:template match="//tei:body//tei:orgName">
        <rs type="org" ref="#enter-org-id">
            <xsl:for-each select="@*">
                <xsl:attribute name="{if (name(.) = 'type') then('subtype') else (name(.))}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </rs>
    </xsl:template>
    
</xsl:stylesheet>