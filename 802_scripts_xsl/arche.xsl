<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:output encoding="UTF-8" media-type="text/xml" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="constants">
            <xsl:for-each select=".//node()[parent::acdh:RepoObject]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="TopColId">
            <xsl:value-of select="data(.//acdh:TopCollection/@rdf:about)"/>
        </xsl:variable>
        <rdf:RDF xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#">
            <acdh:TopCollection>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select=".//acdh:TopCollection/@rdf:about"/>
                </xsl:attribute>
                <xsl:for-each select=".//node()[parent::acdh:TopCollection]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </acdh:TopCollection>
            
            <xsl:for-each select=".//node()[parent::acdh:MetaAgents]">
                <xsl:copy-of select="."/>
            </xsl:for-each>

            <xsl:for-each select=".//acdh:Collection">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <xsl:copy-of select="$constants"/>
                    <xsl:for-each select=".//acdh:*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </acdh:Collection>
            </xsl:for-each>

            <xsl:for-each select="collection('../data/editions')//tei:TEI">
                <!--TEIs-->
                <xsl:variable name="partOf">
                    <xsl:value-of select="concat(@xml:base, '/editions')"/>
                </xsl:variable>
                <xsl:variable name="id">
                    <xsl:value-of select="concat($TopColId, '/', @xml:id)"/>
                </xsl:variable>
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasPid>create</acdh:hasPid>
                    <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:hasDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="concat(.//tei:sourceDesc//tei:date/@when, '-01-01')"/></acdh:hasDate>
                    <acdh:hasTitle xml:lang="de"><xsl:value-of select="concat(.//tei:titleStmt/tei:title[@type='main'], ' ', .//tei:sourceDesc//tei:edition/@n, '. Auflage', ' (', .//tei:sourceDesc//tei:date/@when, ')')"/></acdh:hasTitle>
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:isPartOf rdf:resource="{$partOf}"/>
                    <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                    <acdh:hasContributor rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                    <acdh:hasContributor rdf:resource="https://orcid.org/0000-0003-2436-0361"/>
                    <xsl:copy-of select="$constants"/>
                </acdh:Resource>
                <!-- facsimiles -->
                <xsl:if test=".//tei:facsimile and @xml:id != 't__02_VMS_1858_TEI_AW_26-01-21-TEI-P5.xml' and @xml:id != 't__03_VMS_1865_TEI_AW_26-01-21-TEI-P5.xml'">
                    <xsl:for-each select=".//tei:facsimile/tei:surface/tei:graphic">
                        <xsl:variable name="facsId">
                            <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                        </xsl:variable>
                        <xsl:variable name="facsUrl">
                            <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                        </xsl:variable>
                        <acdh:Resource rdf:about="{$facsUrl}">
                            <acdh:hasPid>create</acdh:hasPid>
                            <acdh:isPartOf rdf:resource="{concat($TopColId, '/facs')}"/>
                            <acdh:hasTitle xml:lang="und">
                                <xsl:value-of select="concat(
                                    'Scan der Seite ',
                                    replace(tokenize($facsId, '_')[last()], '.tif', ''))
                                "/>
                            </acdh:hasTitle>
                            <acdh:hasDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="concat(.//tei:sourceDesc//tei:date/@when, '-01-01')"/></acdh:hasDate>
                            <acdh:isSourceOf rdf:resource="{$id}"/>
                            <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                            <acdh:hasDigitisingAgent rdf:resource="http://d-nb.info/gnd/1033827401"/>
                            <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc0-1-0"/>
                            <xsl:copy-of select="$constants"/>
                        </acdh:Resource>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>   
</xsl:stylesheet>