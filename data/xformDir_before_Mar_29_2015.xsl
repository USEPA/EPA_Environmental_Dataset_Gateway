<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : xformDir.xsl
    Created on : July 28, 2011, 3:45 PM
    Author     : jsievel
    Description:
        Transform xml entries to html.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <xsl:template match="dir">
        <html>

            <xsl:choose>
                <xsl:when test="@suppressHeader='true'">
                    <table>
                        <xsl:apply-templates select="entry" />
                    </table>
                </xsl:when>
                <xsl:otherwise>

                   <head>
        		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        		<title>EDG Data Downloads</title>
                        <link rel="stylesheet" type="text/css" href="/DataUtils/css/data.css"  />
                        <link rel="stylesheet" type="text/css" href="/message/css/message.css"  />
		        <style type="text/css">
		            body {
			    background-image:url('/DataUtils/images/bgd_body.png');
		                background-repeat: no-repeat;
		                background-color: #4A5B63;
		            }
		        </style>
                        <script type="text/javascript">
                            <xsl:text>
                            function getDirTd(imgNode) {
                                // return the td node in the row below this one
                                var thisRowNode = imgNode.parentNode.parentNode.parentNode;
                                var thisRowIndex = thisRowNode.rowIndex;
                                var table = thisRowNode.parentNode.parentNode;
                                var rowBelow = table.rows[thisRowIndex+1];
                                var tdNode = rowBelow.cells[1];
                                return tdNode;
                            }

                            function getDir(span_clickedNode) {
                                var clickedNode = span_clickedNode.firstChild;
                                var href = clickedNode.getAttribute("href");
                                href += "?suppressHeader=true";
                                var tdNode = getDirTd(clickedNode);
                                var xmlhttp;
                                if (window.XMLHttpRequest)
                                  {// code for IE7+, Firefox, Chrome, Opera, Safari
                                    xmlhttp=new XMLHttpRequest();
                                  }
                                else
                                  {// code for IE6, IE5
                                    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
                                  }
                                xmlhttp.onreadystatechange=function() {
                                    if (xmlhttp.readyState==4) {
                                        var theStatus = xmlhttp.status;
                                        //var theStatus = 403;
                                        if (theStatus != 200) {
                                            handleErrors(theStatus,clickedNode.getAttribute("href"));
                                        } else {
                                            span_clickedNode.onclick = closeFolder;
                                            clickedNode.src = "/DataUtils/images/folderOpened.gif";
                                            tdNode.innerHTML=xmlhttp.responseText;
                                        }
                                    }
                                }
                                xmlhttp.open("GET",href,true);
                                xmlhttp.send();
                            }

                            function closeFolder() {
                                var spanNode = this;
                                var node = spanNode.firstChild;
                                node.src = "/DataUtils/images/folderClosed.gif";
                                var tdNode = getDirTd(node);
                                tdNode.innerHTML = "";
                                spanNode.onclick = function() {getDir(this)};
                            }

                            function handleErrors(status,theHref) {
                                if (status==404) {
                                    innoDisplayMsg(document.getElementById("msg.err.dirNotFound").innerHTML);
                                } else if (status==403) {
                                    var notAuthMsg = document.getElementById("msg.err.dirNotAuthorized").innerHTML;
                                    var makeLoginOk = "/message/message.html?msg="+encodeURIComponent(document.getElementById("msg.ok.login").innerHTML);
                                    var loginHref = "/sso/login?sso_redirect="+encodeURIComponent(makeLoginOk);
                                    var makeNotAuth = "/message/message.html?msg="+notAuthMsg.replace("XXXX",loginHref);
                                    window.open(makeNotAuth,"Login",
                                        "menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no",false);
                                } else {
                                    innoDisplayMsg(document.getElementById("msg.err.unknown").innerHTML.replace("XXXX",status));
                                }
                            }
                            
                            </xsl:text>
                        </script>
                    </head>
		    <body>
                        <center>
			<div class="container">
				<div class="headerMenu">
                                    <xsl:apply-templates select="loginInfo" />
                                </div>
                            <div id="tt" class="content" style="width:980px; height:600px; text-align:left;">
				    <table width="980px" border="0" align="center" cellpadding="0" cellspacing="0">
					    <tr>
						    <td><div class="margin"/></td>
						    <td align="left">
                                                        <br/>
                                                        <font size='3' color='#cc3333' face='Verdana'><b>Download EPA's
                                                        Geospatial Data</b></font><br/><br/>
                                                        <font size='2' color='#9999ab' face='Verdana'>Access geospatial data
                                                        provided by EPA's Program Offices, Regions, and Labs by clicking on
                                                        the folders below.</font>
                                                        <br/>
                                                        <br/>
                                                        <br/>

						    </td>
					    </tr>

                                    <xsl:apply-templates select="entry" />
                                </table>
                            </div>
                            <div class="footer" id="gptFooter">
                                    The EDG is a metadata portal that is part of <a href="http://www.epa.gov/sor">EPA's System of Registries</a>. Please read EPA's <a href="http://www.epa.gov/epahome/usenotice2.htm" target="_blank">Privacy and Security Notice</a>.<br/><br/>
                                    <img src="/DataUtils/images/seal-bottom.png" align="center" alt="" width="82" height="82" border="0"/>
                            </div>
  <!-- end .container --></div>
                         </center>
			 <script>
if (-[1,]) {
	// do non IE-specific things
	document.getElementById('tt').style.overflow='auto';
} else {
	// do IE-specific things
}

			 </script>
                         <!-- the script below is to support innoMsgs -->
                         <script type="text/javascript" src="/message/javascript/message.js">
                         </script>
                         <!-- the html below supports innoMsgs -->
                         <div class="innoMsgDiv" id="innoMsgDiv">
                             <div id="innoMsgText"></div>
                         </div>
                         <!-- the msgs from resources are in the divs below -->
                         <xsl:apply-templates select="resource" />
			    
<!-- Google Tag Manager -->
<iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB" height="0" width="0" style="display:none;visibility:hidden"></iframe>
<!-- End Google Tag Manager -->
			    
                    </body>
                </xsl:otherwise>
            </xsl:choose>
        </html>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:if test="@type!='backLink'">
            <tr>
                <td><div class="margin"/></td>
                <td align="left">
                    <xsl:choose>
                        <xsl:when test="@type='dir'">
                            <span class="clickable" onclick="getDir(this);">
                                <img src="/DataUtils/images/folderClosed.gif">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="A/@HREF" />
                                    </xsl:attribute>
                                </img>
                                <xsl:text> </xsl:text>
                                <span class="fileName">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="A/@HREF" />
                                    </xsl:attribute>
                                    <xsl:apply-templates select="A" />
                                </span>
                            </span>
                        </xsl:when>
                        <xsl:when test="@type='file'">
                            <a target="Downloaded File">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="A/@HREF" />
                                </xsl:attribute>
                                <img src="/DataUtils/images/leaf.gif"/>
                                <xsl:text> </xsl:text>
                                <span class="fileName">
                                    <xsl:value-of select="A" />
                                </span>
                            </a>
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    <span class="details">
                        <xsl:value-of select="date" />
                    </span>
                    <xsl:text> </xsl:text>
                    <span class="details">
                        <xsl:value-of select="time" />
                    </span>
                    <xsl:if test="@type='file'">
                        <xsl:text> </xsl:text>
                        <span class="details">
                            <xsl:apply-templates select="fileSize" />
                        </span>
                    </xsl:if>
                </td>
            </tr>
            <xsl:if test="@type='dir'">
                <tr>
                    <td class="margin"/>
                    <td align="left" colspan="5"/>
                </tr>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="fileSize">
        <xsl:choose>
            <xsl:when test="string-length(.) &lt;= 3">
                <xsl:value-of select="." />
                <xsl:text> B</xsl:text>
            </xsl:when>
            <xsl:when test="(string-length(.) &gt; 3) and (string-length(.) &lt;= 6)">
                <xsl:value-of select="substring(.,1,string-length(.)-3)" />
                <xsl:text> KB</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring(.,1,string-length(.)-6)" />
                <xsl:text> MB</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- map office id in <A> to office name in offices.xml -->
    <xsl:template match="A">
	<xsl:variable name="offices" select="document('webapps/data/offices.xml')/offices/o"/>
        <xsl:variable name="thisId" select="text()" />
	<xsl:choose>
            <xsl:when test="$offices[translate(@dir,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')=translate($thisId,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')]">
                <xsl:value-of select="$offices[translate(@dir,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')=translate($thisId,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')]/text()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$thisId" />
            </xsl:otherwise>
	</xsl:choose>
    </xsl:template>

    <xsl:template match="loginInfo">
        <span class="loginInfo">
        <xsl:choose>
            <xsl:when test="@authenLoc='fixed.public'">
                <xsl:text>Welcome, public user</xsl:text>
            </xsl:when>
            <xsl:when test="@authenLoc='fixed.restricted'">
                <xsl:text>Welcome, unrestricted user</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@authenticated='true'">
                        <xsl:text>Welcome, </xsl:text>
                        <xsl:value-of select="@user"/>
                        <xsl:text> </xsl:text>
                        <a href="/sso/logout?sso_redirect=data/"><xsl:text>Logout</xsl:text></a>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="/sso/login?sso_redirect=data/"><xsl:text>Login</xsl:text></a>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        </span>
    </xsl:template>

    <!-- put resource html into div with id same as props key -->
    <xsl:template match="resource">
        <div style="display:none">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:copy-of select="div"/>
        </div>
    </xsl:template>

</xsl:stylesheet>
