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
        <xsl:variable name="constantsImg">
            <xsl:for-each select=".//node()[parent::acdh:ImgObject]">
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

            <xsl:for-each select=".//acdh:Collection[@rdf:about='https://id.acdh.oeaw.ac.at/hanslick-vms/editions']">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <acdh:hasCreator rdf:resource="http://d-nb.info/gnd/1033827401"/>
                    <acdh:hasCreator rdf:resource="https://orcid.org/0009-0000-5226-5252"/>
                    <acdh:hasCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                    <acdh:hasContributor rdf:resource="https://orcid.org/0000-0003-2436-0361"/>
                    <xsl:copy-of select="$constants"/>
                    <xsl:for-each select=".//acdh:*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </acdh:Collection>
            </xsl:for-each>

            <xsl:for-each select=".//acdh:Collection[@rdf:about='https://id.acdh.oeaw.ac.at/hanslick-vms/facsimiles']">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <acdh:hasCreator rdf:resource="http://d-nb.info/gnd/1033827401"/>
                    <acdh:hasCreator rdf:resource="https://orcid.org/0009-0000-5226-5252"/>
                    <acdh:hasCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                    <xsl:copy-of select="$constantsImg"/>
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
                <xsl:variable name="facs-col">
                    <xsl:value-of select="concat($TopColId, '/facsimiles/', 'vom-musikalisch-schoenen-', .//tei:sourceDesc//tei:edition/@n, '-auflage-', .//tei:sourceDesc//tei:date/@when)"/>
                </xsl:variable>
                <xsl:variable name="rc-title">
                    <xsl:value-of select="concat(.//tei:titleStmt/tei:title[@type='main'], ' ', .//tei:sourceDesc//tei:edition/@n, '. Auflage', ' (', .//tei:sourceDesc//tei:date/@when, ')')"/>
                </xsl:variable>
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasPid>create</acdh:hasPid>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:hasTitle xml:lang="de">
                        <xsl:value-of select="concat('TEI/XML: ', .//tei:titleStmt/tei:title[@type='main'], ' ', .//tei:sourceDesc//tei:edition/@n, '. Auflage', ' (', .//tei:sourceDesc//tei:date/@when, ')')"/>
                        </acdh:hasTitle>
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:isPartOf rdf:resource="{$partOf}"/>
                    <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                    <acdh:hasCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                    <acdh:hasContributor rdf:resource="https://orcid.org/0000-0003-2436-0361"/>
                    <acdh:hasCreator rdf:resource="http://d-nb.info/gnd/1033827401"/>
                    <acdh:hasCreator rdf:resource="https://orcid.org/0009-0000-5226-5252"/>
                    <xsl:copy-of select="$constants"/>
                </acdh:Resource>
                
                <!-- facsimiles -->
                <xsl:if test=".//tei:facsimile and @xml:id != 't__02_VMS_1858_TEI_AW_26-01-21-TEI-P5.xml' and @xml:id != 't__03_VMS_1865_TEI_AW_26-01-21-TEI-P5.xml'">
                    <acdh:Collection>
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="$facs-col"/>
                        </xsl:attribute>
                        <acdh:hasPid>create</acdh:hasPid>
                        <acdh:hasTitle xml:lang="de">
                            <xsl:value-of select="$rc-title"/>
                        </acdh:hasTitle>
                        <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                        <acdh:hasDigitisingAgent rdf:resource="http://d-nb.info/gnd/1033827401"/>
                        <acdh:hasDescription xml:lang="de"><xsl:value-of select="concat('Digitale Edition der 10 Auflagen (1854–1902) von Eduard Hanslicks Traktat „Vom Musikalisch-Schönen. Ein Beitrag zur Revision der Ästhetik der Tonkunst“, der sich mit dem Wesen der Musik, dem Verhältnis von Musik und Gefühl, aber auch der psychologischen und physiologischen Verarbeitung von Musik im Hörer befasst. Die Auflage ', .//tei:sourceDesc//tei:edition/@n, ' wurde digitalisiert und als Faksimiles im TIF-Format gespeichert.')"/></acdh:hasDescription>
                        <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                        <acdh:hasLifeCycleStatus rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelifecyclestatus/completed"/>
                        <acdh:isPartOf rdf:resource="{concat($TopColId, '/facsimiles')}"/>
                        <xsl:copy-of select="$constantsImg"/>
                    </acdh:Collection>
                    <xsl:for-each select=".//tei:facsimile/tei:surface/tei:graphic">
                        <xsl:variable name="facsId">
                            <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                        </xsl:variable>
                        <xsl:variable name="facsUrl">
                            <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                        </xsl:variable>
                        <acdh:Resource rdf:about="{$facsUrl}">
                            <acdh:hasPid>create</acdh:hasPid>
                            <acdh:isPartOf rdf:resource="{$facs-col}"/>
                            <acdh:hasTitle xml:lang="und">
                                <xsl:value-of select="concat(
                                    $rc-title,
                                    ', Seite ' ,
                                    replace(tokenize($facsId, '_')[last()], '.tif', ''),
                                    '.'
                                )"/>
                            </acdh:hasTitle>
                            <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                            <acdh:isSourceOf rdf:resource="{$id}"/>
                            <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                            <acdh:hasDigitisingAgent rdf:resource="http://d-nb.info/gnd/1033827401"/>
                            <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc0-1-0"/>
                            <xsl:copy-of select="$constantsImg"/>
                        </acdh:Resource>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>   
</xsl:stylesheet>