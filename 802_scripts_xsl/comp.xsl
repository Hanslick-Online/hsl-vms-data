<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:_="urn:acdh"
    exclude-result-prefixes="xs _"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:param name="collection" select="'../102_derived_tei/102_02_tei-simple_refactored'"/>
    <xsl:param name="docsCorpus" select="'../102_derived_tei/102_03_collation_docs.xml'"/>
    <xsl:param name="compOutput" select="'../../102_derived_tei/102_05_comp_refactored'"/>

    <xsl:function name="_:witness-label" as="xs:string">
        <xsl:param name="witness" as="element(tei:TEI)"/>
        <xsl:sequence select="
            if ($witness//tei:idno[@type = 'collation-label'][1]) then
                normalize-space(string(($witness//tei:idno[@type = 'collation-label'][1])[1]))
            else if ($witness//tei:sourceDesc//tei:edition[1]/@n) then
                concat('VMS ', replace(string(($witness//tei:sourceDesc//tei:edition[1]/@n)[1]), '^0+', ''))
            else
                normalize-space(string(($witness//tei:titleStmt/tei:title[1])[1]))
        "/>
    </xsl:function>

    <xsl:function name="_:witness-sort-key" as="xs:double">
        <xsl:param name="witness" as="element(tei:TEI)"/>
        <xsl:variable name="value" select="
            if ($witness//tei:idno[@type = 'collation-sort'][1]) then
                normalize-space(string(($witness//tei:idno[@type = 'collation-sort'][1])[1]))
            else
                replace(string(($witness//tei:sourceDesc//tei:edition[1]/@n)[1]), '^0+', '')
        "/>
        <xsl:sequence select="if ($value castable as xs:double) then xs:double($value) else 999"/>
    </xsl:function>

    <xsl:function name="_:witness-file" as="xs:string">
        <xsl:param name="witness" as="element(tei:TEI)"/>
        <xsl:sequence select="
            if ($witness//tei:idno[@type = 'collation-target'][1]) then
                normalize-space(string(($witness//tei:idno[@type = 'collation-target'][1])[1]))
            else
                replace(string($witness/@xml:id), '\.xml$', '.html')
        "/>
    </xsl:function>

    <xsl:function name="_:link-target" as="xs:string">
        <xsl:param name="file" as="xs:string"/>
        <xsl:param name="anchor" as="xs:string?"/>
        <xsl:sequence select="if (normalize-space($anchor) != '') then concat($file, '#', $anchor) else $file"/>
    </xsl:function>

    <xsl:template match="node() | @*" mode="pre">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    <xsl:output method="xml" indent="yes"/>
    

    <xsl:template match="tei:p[@n != '']" mode="pre">
            <xsl:variable name="witness" select="ancestor::tei:TEI[1]" as="element(tei:TEI)"/>
        <xsl:variable name="prev" select="preceding::tei:p[@n != ''][1]/@n"/>
        <xsl:variable name="next" select="following::tei:p[@n != ''][1]/@n"/>
            <xsl:variable name="file" select="_:witness-file($witness)"/>
            <xsl:variable name="anchor" select="
                if ($witness//tei:idno[@type = 'collation-target'][1]) then
                    replace(normalize-space(@corresp), '^#', '')
                else if (@corresp) then
                    replace(normalize-space(@corresp), '^#', '')
                else
                    string(@xml:id)
            "/>
        <xsl:copy>
                <xsl:attribute name="source" select="_:witness-label($witness)"/>
                <xsl:attribute name="sortKey" select="_:witness-sort-key($witness)"/>
            <xsl:attribute name="prev" select="$prev"/>
            <xsl:attribute name="next" select="$next"/>
            <!-- <xsl:attribute name="file" select="tokenize(base-uri(.),'/')[last()]"/> -->
            <xsl:attribute name="file" select="$file" />
                <xsl:if test="normalize-space($anchor) != ''">
                    <xsl:attribute name="anchor" select="$anchor"/>
                </xsl:if>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:note" mode="pre"/>
    
    <xsl:template match="/">
        <xsl:variable name="baseWitnesses" select="collection($collection)//tei:TEI" as="element(tei:TEI)*"/>
        <xsl:variable name="docWitnesses" select="if (doc-available($docsCorpus)) then doc($docsCorpus)//tei:TEI else ()" as="element(tei:TEI)*"/>
        <xsl:variable name="allParagraphs" select="($baseWitnesses, $docWitnesses)//tei:p[@n != '']" as="element(tei:p)*"/>
        <xsl:for-each-group select="$allParagraphs" group-by="@n">
            <xsl:variable name="pre" as="element()+">
                <xsl:apply-templates select="current-group()" mode="pre"/>
            </xsl:variable>
            <xsl:result-document href="{$compOutput}/diff_{current-grouping-key()}.xml">
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Konkordanz <xsl:value-of select="replace(current-grouping-key(), 'xyz', '')"/></title>
                            </titleStmt>
                            <publicationStmt>
                                <p>nicht veröffentlicht</p>
                            </publicationStmt>
                            <sourceDesc>
                                <p>born digital</p>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
<!--                            <xsl:if test="exists($prev) or exists($next)">-->
                                <list type="navigation">
                                   
                                    <item>
                                        <list type="selectPar">
                                            <head>Paragraph auswählen</head>
                                            <xsl:for-each select="distinct-values($allParagraphs/@n[. != ''])">
                                                <item><xsl:value-of select="."/></item>
                                            </xsl:for-each>
                                        </list>
                                    </item>
                                </list>
                            <!--</xsl:if>-->
                            <table>
                                <row role="label">
                                    <xsl:for-each-group select="$pre" group-by="normalize-space(.)">
                                        <xsl:sort select="xs:double(@sortKey)" order="ascending"/>
                                        <cell>
                                            <xsl:for-each select="current-group()">
                                                <xsl:sort select="xs:double(@sortKey)" order="ascending"/>
                                                <seg type="sourceNav">
                                                    <xsl:if test="@prev != ''">
                                                         <ref type="prevLink" target="diff_{@prev}.html"><xsl:value-of select="replace(@prev, 'xyz', '')"/></ref>
                                                     </xsl:if>
                                                     <ref target="{_:link-target(@file, @anchor)}"><xsl:value-of select="@source"/></ref>
                                                     <xsl:if test="@next != ''">
                                                         <ref type="nextLink" target="diff_{@next}.html"><xsl:value-of select="replace(@next, 'xyz', '')"/></ref>
                                                     </xsl:if>
                                                </seg>
                                            </xsl:for-each>
                                        </cell>
                                    </xsl:for-each-group>
                                </row>
                                <row role="data">
                                    <xsl:for-each-group select="$pre" group-by="normalize-space(.)">
                                        <xsl:sort select="xs:double(@sortKey)" order="ascending"/>
                                        <cell xml:id="v{position()}"><xsl:value-of select="normalize-space(.)"/></cell>
                                    </xsl:for-each-group>
                                </row>
                            </table>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each-group>    
    </xsl:template>
</xsl:stylesheet>