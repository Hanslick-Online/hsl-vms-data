<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="collection" select="'../102_derived_tei/102_02_tei-simple_refactored'"/>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>VMS Work Index</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>unpublished</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>born digital</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:for-each-group select="collection($collection)//tei:body//tei:rs[@type='bibl']" group-by="substring(normalize-space(upper-case((@key,.)[.!=''][1])),1,1)">
                        <xsl:sort select="current-grouping-key()" order="ascending"/>
                        <xsl:if test="matches(current-grouping-key(),'[A-ZÖÜÄ]')">
                            <div>
                                <head rendition="#b"><xsl:value-of select="current-grouping-key()"/></head>
                                <list>
                                    <xsl:for-each-group select="current-group()" group-by="normalize-space((@key,.)[.!=''][1])">
                                        <xsl:sort select="normalize-space(current-grouping-key())" order="ascending"/>
                                        <item>
                                            <name><xsl:value-of select="normalize-space(current-grouping-key())"/></name>
                                            <list type="index-references">
                                                <xsl:for-each select="current-group()">
                                                    <xsl:sort select="root()//tei:sourceDesc//tei:edition/xs:integer(replace(@n,'^0+',''))"/> 
                                                    <xsl:variable name="uri" select="base-uri(.)"/>
                                                    <xsl:variable name="filename" select="tokenize($uri, '/')[last()]"/>
                                                    <xsl:variable name="edition" select="root()//tei:sourceDesc//tei:edition/replace(@n,'^0+','')"/>
                                                    <xsl:variable name="contextID" select="ancestor-or-self::*[@xml:id][1]/@xml:id"/>
                                                    <xsl:variable name="pageNo" select="(preceding::tei:pb)[1]/@n"/>
                                                    <item><ref target="{replace($filename,'\.xml$','.html')}#{$contextID}">VMS <xsl:value-of select="$edition"/>, <xsl:value-of select="$pageNo"/></ref></item>
                                                </xsl:for-each>
                                            </list>
                                        </item>
                                    </xsl:for-each-group>
                                </list>
                            </div>
                        </xsl:if>
                    </xsl:for-each-group>    
                    
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>