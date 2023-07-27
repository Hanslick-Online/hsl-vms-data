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
                        <acdh:hasDigitisingAgent rdf:resource="https://id.acdh.oeaw.ac.at/memir"/>
                        <acdh:hasDescription xml:lang="de"><xsl:value-of select="concat('Digitale Edition der 10 Auflagen (1854–1902) von Eduard Hanslicks Traktat „Vom Musikalisch-Schönen. Ein Beitrag zur Revision der Ästhetik der Tonkunst“, der sich mit dem Wesen der Musik, dem Verhältnis von Musik und Gefühl, aber auch der psychologischen und physiologischen Verarbeitung von Musik im Hörer befasst. Die Auflage ', .//tei:sourceDesc//tei:edition/@n, ' wurde digitalisiert und als Faksimiles im TIF-Format gespeichert.')"/></acdh:hasDescription>
                        <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                        <acdh:hasLifeCycleStatus rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelifecyclestatus/completed"/>
                        <acdh:isPartOf rdf:resource="{concat($TopColId, '/facsimiles')}"/>
                        <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc0-1-0"/>
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
                            <acdh:hasDigitisingAgent rdf:resource="https://id.acdh.oeaw.ac.at/memir"/>
                            <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc0-1-0"/>
                            <xsl:copy-of select="$constantsImg"/>
                        </acdh:Resource>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-rweigel-1854">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1854-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">112 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Rudolph Weigel
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>1. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__01_VMS_1854_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-rweigel-1858">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1858-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">118 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Rudolph Weigel
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>2. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <acdh:hasUrl>https://www.digitale-sammlungen.de/de/view/bsb10598668</acdh:hasUrl>
                <acdh:hasNonLinkedIdentifier>urn:nbn:de:bvb:12-bsb10598668-3</acdh:hasNonLinkedIdentifier>
                <acdh:relation rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms/t__02_VMS_1858_TEI_AW_26-01-21-TEI-P5.xml"/>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-rweigel-1865">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1865-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">140 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Rudolph Weigel
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>3. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <acdh:hasUrl>https://www.digitale-sammlungen.de/de/view/bsb10598670</acdh:hasUrl>
                <acdh:hasNonLinkedIdentifier>urn:nbn:de:bvb:12-bsb10598670-4</acdh:hasNonLinkedIdentifier>
                <acdh:relation rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms/t__03_VMS_1865_TEI_AW_26-01-21-TEI-P5.xml"/>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1874">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1874-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">138 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>4. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__04_VMS_1874_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1876">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1876-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">138 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>5. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__05_VMS_1876_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1881">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1881-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">198 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>6. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__06_VMS_1881_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1885">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1885-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">201 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>7. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__07_VMS_1885_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1891">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1891-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">201 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>8. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__08_VMS_1891_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1896">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1896-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">238 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>9. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__09_VMS_1896_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Publication rdf:about="https://id.acdh.oeaw.ac.at/pub-vms-jabarth-1902">
                <acdh:hasTitle xml:lang="de">
                    Vom Musikalisch-Schönen: Ein Beitrag zur Revision der Aesthetik der Tonkunst
                </acdh:hasTitle>
                <acdh:hasAuthor rdf:resource="http://d-nb.info/gnd/118545825"/>
                <acdh:hasIssuedDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">1902-01-01</acdh:hasIssuedDate>
                <acdh:hasPages xml:lang="de">232 Seiten</acdh:hasPages>
                <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                <acdh:hasPublisher xml:lang="de">
                    Johann Ambrosius Barth
                </acdh:hasPublisher>
                <acdh:hasSeriesInformation>10. Auflage</acdh:hasSeriesInformation>
                <acdh:hasCity xml:lang="de">Leipzig</acdh:hasCity>
                <xsl:for-each select="document('../data/editions/t__10_VMS_1902_TEI_AW_26-01-21-TEI-P5.xml')//tei:facsimile/tei:surface/tei:graphic">
                    <xsl:variable name="facsId">
                        <xsl:value-of select="tokenize(@url, '/')[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="facsUrl">
                        <xsl:value-of select="concat($TopColId, '/', $facsId)"/>
                    </xsl:variable>
                    <acdh:isSourceOf rdf:resource="{$facsUrl}"/>
                </xsl:for-each>
            </acdh:Publication>
            <acdh:Resource rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms/logo_font_blau.svg">
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms"/>
                <acdh:hasTitle xml:lang="de">Hanslick Online Logo</acdh:hasTitle>
                <acdh:hasPid>create</acdh:hasPid>
                <acdh:hasIdentifier rdf:resorce="https://id.acdh.oeaw.ac.at/main-title-logo-hanslick"/>
                <acdh:hasLicensor rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasContact rdf:resource="http://d-nb.info/gnd/1033827401"/>
                <acdh:hasOwner rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasDepositor rdf:resource="http://d-nb.info/gnd/1033827401"/>
                <acdh:hasCurator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                <acdh:hasMetadataCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                <acdh:hasRightsHolder rdf:resource="https://id.acdh.oeaw.ac.at/oeaw"/>
                <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                <acdh:hasFormat>image/svg</acdh:hasFormat>
                <acdh:isTitleImageOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/image"/>
                <acdh:hasCreator rdf:resource="https://id.acdh.oeaw.ac.at/oreichl"/>
                <acdh:hasFunder rdf:resource="https://id.acdh.oeaw.ac.at/org-ma7"/>
            </acdh:Resource>
            <acdh:Metadata rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms/vms.odd">
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms/editions"/>
                <acdh:hasTitle xml:lang="de">TEI/XML Schema ODD für "Vom Musikalisch-Schönen"</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">TEI/XML Schema ODD für "Vom Musikalisch-Schönen"</acdh:hasDescription>
                <acdh:hasPid>create</acdh:hasPid>
                <acdh:hasLicensor rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasOwner rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasDepositor rdf:resource="http://d-nb.info/gnd/1033827401"/>
                <acdh:hasCurator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                <acdh:hasMetadataCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                <acdh:hasRightsHolder rdf:resource="https://id.acdh.oeaw.ac.at/oeaw"/>
                <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                <acdh:hasCreatedStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-19</acdh:hasCreatedStartDate>
                <acdh:hasCreatedEndDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-20</acdh:hasCreatedEndDate>
                <acdh:isMetadataFor rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms/editions"/>
                <acdh:hasCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
            </acdh:Metadata>
            <acdh:Metadata rdf:about="https://id.acdh.oeaw.ac.at/hanslick-vms/vms.rng">
                <acdh:isPartOf rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms/editions"/>
                <acdh:hasTitle xml:lang="de">TEI/XML Schema RNG für "Vom Musikalisch-Schönen"</acdh:hasTitle>
                <acdh:hasDescription xml:lang="de">TEI/XML Schema RNG für "Vom Musikalisch-Schönen"</acdh:hasDescription>
                <acdh:hasPid>create</acdh:hasPid>
                <acdh:hasLicensor rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasOwner rdf:resource="https://id.acdh.oeaw.ac.at/acdh"/>
                <acdh:hasDepositor rdf:resource="http://d-nb.info/gnd/1033827401"/>
                <acdh:hasCurator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                <acdh:hasMetadataCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
                <acdh:hasRightsHolder rdf:resource="https://id.acdh.oeaw.ac.at/oeaw"/>
                <acdh:hasLicense rdf:resource="https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"/>
                <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                <acdh:hasCreatedStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-19</acdh:hasCreatedStartDate>
                <acdh:hasCreatedEndDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2023-07-20</acdh:hasCreatedEndDate>
                <acdh:isMetadataFor rdf:resource="https://id.acdh.oeaw.ac.at/hanslick-vms/editions"/>
                <acdh:hasCreator rdf:resource="https://orcid.org/0000-0002-0636-4476"/>
            </acdh:Metadata>
        </rdf:RDF>
    </xsl:template>   
</xsl:stylesheet>