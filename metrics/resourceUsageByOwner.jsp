<%@page import="java.util.Set"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="jspClasses/jsonServer.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%!    public String getRandomHex() {
        Random rand = new Random();
        int min = 0, max = 999999, randomNum;
        randomNum = rand.nextInt(max - min + 1) + min;
        return String.format("%6s", Integer.toString(randomNum)).replace(' ', '0');
    }
%>
<%
    String jsonUrl, sql;
    Calendar today;

    today = Calendar.getInstance();
    long now = today.getTimeInMillis();

    jsonUrl = "json/jsonResourceUsage.jsp?cacheClr=" + now;

    String hex;
    HashMap colorCoders = new HashMap();
    jsonServer obj = new jsonServer(1);
    sql = "SELECT DISTINCT gusr.username FROM gpt_resource gres LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
    ResultSet rs = obj.executeQuery(sql);
    while (rs.next()) {
        do {
            hex = getRandomHex();
        } while (colorCoders.containsKey(hex));
        colorCoders.put(rs.getString(1), hex);
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <!-- TemplateBeginEditable name="doctitle" -->
        <title>Timeline</title>
        <link href="main.css" rel="stylesheet" type="text/css" /> 
        <link href="<% out.print(jsonUrl);%>" type="application/json" rel="exhibit/data" />
        <script src="/simile_new/exhibit/api/exhibit-api.js?bundle=false" type="text/javascript"></script>
        <script src="/simile_new/exhibit/api/extensions/time/time-extension.js?bundle=false" type="text/javascript"></script>
        <link href='javaScripts/jquery-ui/development-bundle/themes/base/jquery.ui.all.css' rel='stylesheet' type='text/css' />


        <script type="text/javascript">
            var timelineConfig = {
                timelineConstructor: function (div, eventSource) {
                    div.style.height="400px";
                    var theme = Timeline.ClassicTheme.create();
                    theme.event.label.width = 200; // px
                    theme.event.bubble.width = 400;
                    theme.event.bubble.height = 600;

                    //var date = "Fri Nov 22 2000 13:00:00 GMT-0600"
                    var date = "Jan 11 2003";
                    var bandInfos = [
                        Timeline.createBandInfo({
                            width:          "50%",
                            intervalUnit: Timeline.DateTime.DAY,
                            intervalPixels: 50,
                            eventSource:    eventSource,
                            date:           date,
                            theme:          theme
                        }),
                        Timeline.createBandInfo({
                            width:          "50%",
                            intervalUnit: Timeline.DateTime.MONTH,
                            intervalPixels: 50,
                            eventSource:    eventSource,
                            date:           date,
                            showEventText:  false,
                            theme:          theme,
                            trackHeight: 0.5,
                            trackGap: 0.2
                        })
                    ];

                    bandInfos[1].syncWith = 0;
                    bandInfos[1].highlight = true;
                    //bandInfos[1].eventPainter.setLayout(bandInfos[0].eventPainter.getLayout());


                    tl = Timeline.create(div, bandInfos, Timeline.HORIZONTAL);

                    return tl;
                }

            }

            var helpIconAdded = false;
            
            function submitFrom(obj){
                var set = exhibit.getDefaultCollection().getRestrictedItems();
                var db = exhibit._uiContext.getDatabase();

                obj = document.forms["csvForm"];
                obj["csv"].value = Exhibit.CSVExporter.exportMany(set,db);
                obj.submit();
            }
        
            $(document).ready(function() {
            
                Exhibit.TimelineView.prototype._reconstruct = (function(fn){
                    return function(){
                        retValue = fn.call(this);
                    
                        if(!helpIconAdded){
                        
                            var content;
                            var patt=/^(Text based search on)/gi;
                            elements = $('span.exhibit-facet-header-title');
                        
                            for(i=0;i<elements.length;i++){
                                content = elements[i].innerHTML;
                                if(!(content.match(patt))){
                            
                                    span = document.createElement("span");
                                    span.setAttribute("title", elements[i].parentNode.parentNode.title);
                            
                                    img = document.createElement("img");
                                    img.setAttribute("src", "images/Help-icon.png");
                                    img.setAttribute("onclick", "showItem(this.parentNode)");
                                    img.setAttribute("class", "hlpImg");
                            
                                    anotherSpan = document.createElement("span");
                                    anotherSpan.setAttribute("class", "title");
                                    text = document.createTextNode(content);
                                    anotherSpan.appendChild(text);
                             
                                    span.appendChild(img);
                                    span.appendChild(anotherSpan);
                            
                                    elements[i].innerHTML = '';
                                    elements[i].appendChild(span);
                                }
                            }
                            helpIconAdded = true;
                        }
                    }
                })(Exhibit.TimelineView.prototype._reconstruct);
            });
            
            function showItem(elmt) {
                var itemID = Exhibit.getAttribute(elmt, "title");   
                var uiContext = exhibit.getUIContext();
                var heading = elmt.getElementsByTagName("span");
                heading = heading[0].innerHTML;
                itemID = '<b>'+heading+'</b><br>'+itemID;
                
                //Exhibit.UI.showItemInPopup(itemID, elmt, exhibit.getUIContext());
                Exhibit.UI.showItemInPopup = function(itemID, elmt, uiContext, opts) {
                    SimileAjax.WindowManager.popAllLayers();
    
                    opts = opts || {};
                    opts.coords = opts.coords || Exhibit.UI.calculatePopupPosition(elmt);
    
                    var itemLensDiv = document.createElement("div");
                    itemLensDiv.innerHTML=itemID;
    
                    var lensOpts = {
                        inPopup: true,
                        coords: opts.coords
                    };

                    if (opts.lensType == 'normal') {
                        lensOpts.lensTemplate = uiContext.getLensRegistry().getNormalLens(itemID, uiContext);
                    } else if (opts.lensType == 'edit') {
                        lensOpts.lensTemplate = uiContext.getLensRegistry().getEditLens(itemID, uiContext);
                    } else if (opts.lensType) {
                        SimileAjax.Debug.warn('Unknown Exhibit.UI.showItemInPopup opts.lensType: ' + opts.lensType);
                    }

                    uiContext.getLensRegistry().createLens(itemID, itemLensDiv, uiContext, lensOpts);
    
                    SimileAjax.Graphics.createBubbleForContentAndPoint(
                    itemLensDiv, 
                    opts.coords.x,
                    opts.coords.y, 
                    uiContext.getSetting("bubbleWidth")
                );
                }(itemID, elmt, exhibit.getUIContext());
                
              
            }     
        </script>
        <style>
            .facet_div{
                float:left; 
                width: 320px;
                margin: 10px;
                padding: 10px;
                background-color: #ccc;

                -moz-border-radius: 5px;
                -webkit-border-radius: 5px;
                border-radius: 5px;
                border: 2px solid #CCC;
            }

            .facet_div:hover{
                background-color: #FFF;
            }
            .timeline-event-label{
                white-space: nowrap;
            }
        </style>

    </head>

    <body>

        <div id="body_container">
            <div id="header"></div>
            <%@ include file="menu.jsp" %>
            <div class="container">

                <h1>Timeline</h1>
                <div ex:role="lens"  style="display: none;" id="subLens"></div>
                <div style="float:right;">
                    <form method="post" target="_blank" action="json/downloadCSV.jsp" name="csvForm">
                        <textarea name="csv" id="csv" style="display:none;"  ></textarea>
                        <a href="javascript:void(0)" onClick="submitFrom();"><img src="images/document_excel_csv.png" border="0" /> [ Generate CSV ] </a>
                    </form>
                </div>
                <div ex:role="viewPanel">    
                    <div ex:role="coder" ex:coderClass="Color" id="owner-colors">
                        <%
                            String key;
                            Set keys = colorCoders.keySet();
                            Iterator it = keys.iterator();
                            while (it.hasNext()) {
                                key = it.next().toString();
                                out.print("<span ex:color=\"#" + colorCoders.get(key) + "\">" + key + "</span>");
                            }
                        %>
                    </div>
                    <div id="dashboard-timeline" 
                         ex:role="view"
                         ex:viewClass="Timeline"
                         ex:caption=".username"
                         ex:durationEvent="true"
                         ex:start=".updatedate"
                         ex:end=".updatedate_to"
                         ex:colorCoder="owner-colors"
                         ex:colorKey=".username"
                         ex:configuration="timelineConfig"
                         ex:label="Timeline"
                         ></div>
                </div>
                <div>
                    <!-- FACET -->

                    <fieldset>
                        <legend>Filters</legend>
                        <div class="facet_div">
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".username" ex:facetLabel="Text based search on &quot;Owner&quot;"> </div>
                            <div ex:role="facet" ex:expression=".username" ex:facetLabel="Owner :" title="Name of the user who has ownership of the document." <% if (request.getParameter("owner") != null && request.getParameter("owner") != "") {
                                    out.print("ex:selection=\"" + request.getParameter("owner") + "\"");
                                }%>></div>
                        </div>
                        <div class="facet_div">
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".docuuid" ex:facetLabel="Text based search on &quot;Document UUID&quot;"> </div>
                            <div ex:role="facet" ex:expression=".docuuid" ex:facetLabel="Document UUID :" title="Unique string associated with each resource."></div>
                        </div>
                        <div class="facet_div">
                            <div ex:role="facet" ex:facetClass="TextSearch" ex:expressions=".title" ex:facetLabel="Text based search on &quot;Resource Title&quot;"> </div>
                            <div ex:role="facet" ex:expression=".title" ex:facetLabel="Resource Title :" title="Unique string associated with each resource." <% if (request.getParameter("title") != null && request.getParameter("title") != "") {
                                    out.print("ex:selection=\"" + request.getParameter("title") + "\"");
                                }%>></div>
                        </div>

                    </fieldset>

                </div>
            </div>
            <div style="clear:both; background-color: #4A5B63; line-height: 40px; height: 40px;"> </div>
            <div class="footer">
                <table width="1280px" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#4A5B63">
                    <tr>
                        <td bgcolor="#4A5B63" align="center">The EDG is part of <a href="http://www.epa.gov/sor" target="_blank" style="color: #FFFFFF;">EPA's System of Registries</a>. Please read EPA's <a href="http://www.epa.gov/epahome/usenotice2.htm" target="_blank" style="color: #FFFFFF;">Privacy and Security Notice</a>.<img align="center" src="images/seal-bottom.png" alt="" width="82" height="82" border="0" style="padding-left: 10px;"/></td>

                    </tr>
                </table>
            </div>
        </div>

        <!-- end .container --></div>

    </body>
    
</html>