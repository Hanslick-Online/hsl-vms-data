<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output method="html" media-type="text/html"  omit-xml-declaration="yes" include-content-type="yes"/>
    
    <xsl:param name="textCollection" select="'../102_derived_tei/102_02_tei-simple_refactored'"/>
    <xsl:param name="filename"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="h:head">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:if test="not(h:meta[@charset])">
                <meta charset="utf-8"/>
            </xsl:if>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>            
            <xsl:apply-templates/> 
            <link href="assets/css/edition.css" rel="stylesheet"/>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="h:body">
        <xsl:copy>
            <nav class="navbar navbar-expand-md navbar-light bg-light mb-4">
                <div class="container-fluid">
                    <!--<a class="navbar-brand" href="index.html">Hanslick VMS</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDarkDropdown" aria-controls="navbarNavDarkDropdown" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>-->
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <ul class="navbar-nav me-auto mb-2 mb-md-0">
                            <!--<li class="nav-item">
                                <a class="nav-link active" aria-current="page" href="introduction.html">Introduction</a>
                            </li>-->
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    VMS Editions
                                </a>
                                <ul class="dropdown-menu dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                                    <xsl:for-each select="collection($textCollection)">
                                        <xsl:sort select=".//tei:TEI//tei:sourceDesc/tei:biblStruct/tei:monogr/tei:edition/xs:integer(@n)"/>
                                        <xsl:variable name="filename" select="tokenize(base-uri(.),'/')[last()]"/>
                                        <xsl:variable name="monogr" select=".//tei:TEI//tei:sourceDesc/tei:biblStruct/tei:monogr"/>
                                        <xsl:variable name="edition" select="$monogr/tei:edition/@n"/>
                                        <xsl:variable name="editionOrdinal" select="concat(replace($edition,'^0+',''),if (ends-with($edition,'1')) then 'st' else if (ends-with($edition,'2')) then 'nd' else if (ends-with($edition,'3')) then 'rd' else 'th')"/>
                                        <xsl:if test="exists($monogr)">
                                            <li>
                                                <a class="dropdown-item" href="{replace($filename,'\.xml$','.html')}"><xsl:value-of select="$editionOrdinal"/> edition (<xsl:value-of select="$monogr//tei:date"/>)</a>
                                            </li>
                                        </xsl:if>
                                    </xsl:for-each>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownIndexesMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Indexes
                                </a>
                                <ul class="dropdown-menu dropdown-menu" aria-labelledby="navbarDropdownIndexesMenuLink">
                                    <li>
                                        <a class="dropdown-item" href="persons.html">Persons</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="institutions.html">Institutions</a>
                                    </li>
                                    <!--<li>
                                        <a class="dropdown-item" href="works.html">Works/Quotes</a>
                                    </li>-->
                                    <li>
                                        <a class="dropdown-item" href="places.html">Places</a>
                                    </li>
                                </ul>
                            </li>
                            <!--<li class="nav-item">
                                <a class="nav-link active" aria-current="page" href="imprint.html">Imprint</a>
                            </li>-->
                        </ul>
                    </div>
                </div>
            </nav>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-10">
                        <div class="column-wrapper">
                            <div id="lh-col">
                                <div id="lh-col-top"><!--top of left-hand column--></div>
                                <div id="lh-col-bottom">
                                    <xsl:for-each select="//h:ul[@class='toc toc_front']">
                                        <div class="tocFront">
                                            <div class="tocContainer"><xsl:apply-templates/></div>
                                        </div>
                                    </xsl:for-each>
                                    <xsl:for-each select="//h:ul[@class='toc toc_body']">            
                                        <div class="tocBody">
                                            <div class="tocContainer">                                                
                                                <p class="toclist0"><a class="toclist" href="#index.xml-titlePage">[Title page]</a></p>
                                                <xsl:for-each select="./h:li">
                                                    <p class="toclist0">
                                                        <a class="toclist">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="./h:a/@href"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="./h:a"/>
                                                        </a>
                                                    </p>                            
                                                </xsl:for-each>
                                            </div>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </div>
                            <div id="rh-col">
                                <div id="rh-col-top"><!--top of left-hand column--></div>
                                <div id="rh-col-bottom">
                                    <xsl:apply-templates/>
                                </div>
                            </div>
                        </div>                        
                    </div>
                </div>
                
                <xsl:if test="contains(base-uri(),'diff_')">
                    <div class="row justify-content-center g-3 border p-3">
                       <div class="col-6">
                           <div class="row align-items-end">
                                 <div class="col-4">
                                     <label for="selectV1">Compare</label>
                                     <select class="form-select" id="selectV1">
                                         <xsl:for-each select="//h:td[@id]">
                                             <xsl:variable name="p" select="position()"/>
                                             <option value="{@id}"><xsl:value-of select="//h:th[not(@id)][$p]//h:a[@class='link_ref']"/></option>
                                         </xsl:for-each>
                                     </select>
                                 </div>
                                 <div class="col-4">
                                     <label for="selectV2">… with </label>
                                     <select class="form-select" id="selectV2">
                                         <xsl:for-each select="//h:td[@id]">
                                             <xsl:variable name="p" select="position()"/>
                                             <option value="{@id}">
                                                 <xsl:if test="position() eq 2">
                                                     <xsl:attribute name="selected">selected</xsl:attribute>
                                                 </xsl:if>
                                                 <xsl:value-of select="//h:th[not(@id)][$p]//h:a[@class='link_ref']"/></option>
                                         </xsl:for-each>
                                     </select>
                                 </div>
                                <div class="col-2">
                                    <label for="diffLevel">Level of Comparison</label>
                                    <select class="form-select" id="diffLevel">
                                        <option value="words">words</option>
                                        <option value="sentences">sentences</option>
                                    </select>
                                </div>
                                 <div class="col-2">
                                     <button class="btn btn-primary" id="compBtn" onclick="compare()">compare</button>
                                 </div>
                           </div>
                           <div class="row p-2"><p id="display"/></div>
                       </div>
                    </div>
                </xsl:if>
                
            </div>
            
            <xsl:if test="not(contains(base-uri(),'diff_'))">
                <script type="text/javascript">
                    var id = window.location.hash.substr(1);
                    if (id !== "") {
                    document.getElementById(id).classList.add("hi");
                    }
                </script>    
            </xsl:if>
            
            <xsl:if test="contains(base-uri(),'diff_')">
                <script type="text/javascript" src="assets/js/diff.js"/>
                <script type="text/javascript" src="assets/js/comp.js"/>
            </xsl:if>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="h:h2/text()[. = 'Table of contents']">
        <!--<xsl:text>[Inhalt]</xsl:text>-->
    </xsl:template>
   
   <xsl:template match="h:span[@class = 'parNo']">
       <xsl:copy>
           <xsl:copy-of select="@*"/>
           <a href="diff_{.}.html"><xsl:value-of select="."/></a>
           <xsl:text> </xsl:text>
       </xsl:copy>
   </xsl:template>
    
   <xsl:template match="h:p[h:span[@class = 'parNo']]">
       <xsl:apply-templates select="h:span[@class='parNo']"/>
       <xsl:copy>
           <xsl:copy-of select="@*"/>
           <xsl:apply-templates select="node() except h:span[@class='parNo']"/>
       </xsl:copy>
   </xsl:template>
    
    <xsl:template match="h:*[@class = 'pagebreak']/text()">
        <xsl:value-of select="replace(replace(replace(.,'\]$',''),'^\[',''), 'Page', '')"/>
    </xsl:template>
    
    <xsl:template match="h:div[@class = 'titlePage']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="id">index.xml-titlePage</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!--<xsl:template match="h:div[@class = 'tocBody']/h:div[@class = 'tocContainer']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <p class="toclist0"><a class="toclist" href="#index.xml-titlePage">[Title page]</a></p>
            <xsl:copy-of select="node()"/>
        </xsl:copy>
    </xsl:template>-->
    <xsl:template match="h:div[starts-with(@id, 'hdr')]"/>
        
    
    <xsl:template match="h:span[@class = 'asterisk']">
        <xsl:copy><xsl:copy-of select="@*"/><xsl:text>***</xsl:text></xsl:copy>
    </xsl:template>
    
    <xsl:template match="h:div[@class='notes']/h:div[@class='noteHeading']">
        <xsl:copy>
            [Fußnoten]
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="h:div[@class='notes']/h:div[@class='note']/h:span[@class='noteLabel']">
        <a href="{concat('#' , parent::h:div/@id, '_return')}">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </a>
    </xsl:template>
    
    <xsl:template match="h:div[@class = 'stdfooter autogenerated']"/>

<!--    <xsl:template match="h:h1[@class = 'maintitle'][contains(base-uri(.),'diff_')]"/>-->
    
    <xsl:template match="h:ul[descendant::h:li/h:a/@id = 'prevLink']/h:li[contains(base-uri(.),'diff_')]">
        <xsl:copy>
            <xsl:copy-of select="@* except @class"/>
            <xsl:attribute name="class">list-inline-item</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="h:ul[descendant::h:li/h:a/@id = 'prevLink'][contains(base-uri(.),'diff_')]">
        <xsl:copy>
            <xsl:copy-of select="@* except @class"/>
            <xsl:attribute name="class">list-inline</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="h:li[h:div[@class = 'listhead'] = 'Select Paragraph'][contains(base-uri(.),'diff_')]" priority="1">
    <xsl:copy>
        <xsl:copy-of select="@* except @class"/>
        <xsl:attribute name="class">list-inline-item</xsl:attribute>
        <div class="dropdown">
            <button class="btn btn-primary btn-sm dropdown-toggle" type="button" id="selectParNoButton" data-bs-toggle="dropdown" aria-expanded="false">
                <xsl:value-of select="h:div[@class = 'listhead']"/>
            </button>
            <ul class="dropdown-menu" id="selPar" aria-labelledby="selectParNoButton">
                <xsl:for-each select="h:ul/h:li[starts-with(.,'V')]">
                    <xsl:sort select="xs:integer(substring-after(substring-before(.,'.'),'V'))"/> 
                    <xsl:copy><a class="dropdown-item"  href="diff_{.}.html"><xsl:value-of select="replace(., 'xyz', '')"/></a></xsl:copy>
                </xsl:for-each>
                <xsl:for-each select="h:ul/h:li[not(starts-with(.,'V'))]">
                    <xsl:sort select="xs:integer(substring-before(.,'.'))"/> 
                    <xsl:copy><a class="dropdown-item"  href="diff_{.}.html"><xsl:value-of select="replace(., 'xyz', '')"/></a></xsl:copy>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:copy>
</xsl:template>
    
    <xsl:template match="h:a[@class = 'link_ref'][ancestor::h:tr/@class = 'label']/@href">
        <xsl:attribute name="href" select="replace(.,'\.xml','.html')"/>
            </xsl:template>

    
    <xsl:template match="h:ul[@class='toc toc_front']">
        
    </xsl:template>
    
    <xsl:template match="h:ul[@class='toc toc_body']">
        
    </xsl:template>
    
    <xsl:template match="h:span[@class='headingNumber']">
        
    </xsl:template>
    
</xsl:stylesheet>