var dataForGraph = [{
    "renderInDiv":"chart_div_epa_nonepa",
    "graphTitle":"EPA/Non-EPA",
    "data":null
	}, {
    "renderInDiv":"chart_div_metadata",
    "graphTitle":"Metadata Standard",
    "data":null
	}, {
    "renderInDiv":"chart_div_aclvl",
    "graphTitle":"Data.gov Access Level",
    "data":null
	}, {
    "renderInDiv":"chart_div_license-status",
    "graphTitle":"License Status",
    "data":null
}
];
google.load("visualization", "1", {
    packages:["corechart"]
});
//google.setOnLoadCallback(drawCharts);

var helpIconAdded = false;
var expandAllStatus = false;
var totalNoOfRecords = 0;

/*
 *This function is required for CSV export
 *@param 
 *  fieldsToDisplay     json    is {field_name:display_label,..} collection
 */
function submitFrom(fieldsToDisplay){
    var set         = exhibit.getDefaultCollection().getRestrictedItems();
    var db          = exhibit._uiContext.getDatabase();
    var docuuids    = new Array();
    var count=0;
	var values,
	valStr,
	docuuid;
    var headings    = new Array();
    
    set.visit(function(itemID) {
        values = db.getObjects(itemID, "docuuid");
        docuuid = values.toArray().join(",");
        docuuids[count++]="'"+docuuid+"'";
    });
    
    for (var key in fieldsToDisplay) {
        headings[headings.length]=key+":"+fieldsToDisplay[key];
    }
    
    var obj = document.forms["csvForm"];
    obj["docuuids"].value = docuuids.join(',');
    obj["headings"].value = headings.join(",");
    obj.submit();
}

/*
 *This function opens a window in a new page
 *@param 
 *  link    string    URL to open
 */
function openLink(link){
    var re = /^((http\:)|(https\:))/;
    if(re.test(link)){
        window.open(link,'detailedInventoryLinkWindow','scrollbars=1, width=1200,height=1000');
    }
}

function contains(haystack,needle){
    return haystack.indexOf(needle, 0)==-1?false:true;
}

/*
 *This function toggles the +/- sign in box container in view panel 
 *@param 
 *  obj    Element Object    image object
 */
function toggleSign(obj){
    var abstractField;
    var parent = obj.parentNode.parentNode.parentNode;
    if(contains($(obj).attr("src"),"images/bullet-toggle-minus-icon.png")){
        $(parent).find(".box_content").hide(1000,function (){
            $(obj).attr("src","images/bullet-toggle-plus-icon.png");
        });

    }else{
        $(parent).find(".box_content").show(1000,function(){
            $(obj).attr("src","images/bullet-toggle-minus-icon.png");
            abstractField = $(parent).find('span[class|="abstract_content"]');
            if(""==abstractField.html() && "undefined"!=abstractField.html()){
                callAjax(abstractField.attr("label"));
                
            }
        });

    }
}

function hideorshow(obj){
	var display=obj.nextElementSibling.style.display;
	
	obj.nextElementSibling.style.display=(display=='block')?'none':'block';
}

/*
 *This function collapses all the box view in view panel 
 */
function collapseAll(){
    
    var view = document.getElementById('view');
    var toggleElements = view.getElementsByTagName("img");
    var obj;
    var parent;
    for(var i=0;i<toggleElements.length;i++){
        obj = toggleElements[i];
        if(contains($(obj).attr("src"),"images/bullet-toggle-minus-icon.png")){
           
            parent = obj.parentNode.parentNode.parentNode;
            $(parent).find(".box_content").hide(1000);
            $(obj).attr("src","images/bullet-toggle-plus-icon.png");
        }
        expandAllStatus = false;
    }
}

/*
 *This function expands all the box view in view panel 
 */
function expandAll(){
    
    var view = document.getElementById('view');
    var toggleElements = view.getElementsByTagName("img");
    var obj;
    var parent;
    var docuuid;
    var abstractField;
    
    for(var i=0;i<toggleElements.length;i++){
        obj = toggleElements[i];
        
        if(contains($(obj).attr("src"),"images/bullet-toggle-plus-icon.png")){
            parent = obj.parentNode.parentNode.parentNode;
			console.log(parent);
            /*$(parent).find(".box_content").show(1000);*/
            $(obj).attr("src","images/bullet-toggle-minus-icon.png");
            
            abstractField = $(parent).find('span[class|="abstract_content"]');
            if(""==abstractField.html() && "undefined"!=abstractField.html()){
                callAjax(abstractField.attr("label"));
                
            }
        }
    }
    expandAllStatus = true;
    
}

function callAjax(docuuid){
    if(docuuid!="undefined"){
		console.log("docuuid"+docuuid);
        $.ajax({
            url: encodeURI('tools/getGptResourceData.jsp?field=abstract&docuuid='+docuuid),
			//console.log("print data"+data);
            success: function( data ) {
				console.log("print data"+data);
                document.getElementById("abs_"+docuuid).innerHTML = data;
            }
        });
    }
}

function exhibit_is_loaded() {
    /*
    *This function overrides the paging re-construct method to 
    *enable auto collapse/expand 
    */
    Exhibit.OrderedViewFrame.prototype.reconstruct = (function(fn){
        return function(){
            retValue = fn.call(this);
            if(expandAllStatus){
                expandAll();
            }else{
                collapseAll();
            }
        }
    })(Exhibit.OrderedViewFrame.prototype.reconstruct);
    
    /*
    *This function overrides the view re-construct method to 
    *add the help balloon
    */
    Exhibit.TileView.prototype._reconstruct = (function(fn){

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
            refreshGraph();
        }
    })(Exhibit.TileView.prototype._reconstruct );

 //DISABLE REPORTING WHEN USER MOVES FROM ONE PAGE TO ANOTHER WITHOUT COMPLETELY LOADING THE CONTENT
	Exhibit.UI.showJsonFileValidation = function (message, url) {
		return null;
	};
}

function is_exhibit_loaded() {
	setTimeout(function () {
		if (Exhibit.signals["exhibitConfigured.exhibit"]) {
			exhibit_is_loaded();
		} else {
			is_exhibit_loaded();
		}
	}, 300);
}
is_exhibit_loaded();
    
function refreshGraph() {
    var datasByEpaNonEpa      = {};
    var datasByMetadataStandard = {};
    var datasByDataGovAcLvl      = {};
    var datasByLicenseStatus            = {};
    
    var set = exhibit.getDefaultCollection().getRestrictedItems();
    var db = exhibit._uiContext.getDatabase();
	var values,
	valStr;
    
    set.visit(function(itemID) {
        values = db.getObjects(itemID, "epapub");
        valStr = values.toArray().join(",");
        valStr = Exhibit.CSVExporter._cleanData(valStr);
        
        if(datasByEpaNonEpa[valStr]){
            datasByEpaNonEpa[valStr]++;
        }else{
            datasByEpaNonEpa[valStr]=1;
        }
        
        values = db.getObjects(itemID, "schema_key");
        valStr = values.toArray().join(",");
        valStr = Exhibit.CSVExporter._cleanData(valStr);
        
        if(datasByMetadataStandard[valStr]){
            datasByMetadataStandard[valStr]++;
        }else{
            datasByMetadataStandard[valStr]=1;
        }
        
        values = db.getObjects(itemID, "accesslevel");
        valStr = values.toArray().join(",");
        valStr = Exhibit.CSVExporter._cleanData(valStr);
        
        if(datasByDataGovAcLvl[valStr]){
            datasByDataGovAcLvl[valStr]++;
        }else{
            datasByDataGovAcLvl[valStr]=1;
        }
        
        values = db.getObjects(itemID, "licensestatus");
        valStr = values.toArray().join(",");
        valStr = Exhibit.CSVExporter._cleanData(valStr);
        if(datasByLicenseStatus[valStr]){
            datasByLicenseStatus[valStr]++;
        }else{
            datasByLicenseStatus[valStr]=1;
        }
    });
    
    for(var i=0;i<dataForGraph.length;i++){
        var totalRecords = 0
        var data = null;
        var tmpArr = new Array();
        var keys = new Array();
        
        if(dataForGraph[i].renderInDiv=='chart_div_epa_nonepa'){
            data = datasByEpaNonEpa;
        }else if(dataForGraph[i].renderInDiv=='chart_div_metadata'){
            data = datasByMetadataStandard;
        }else if(dataForGraph[i].renderInDiv=='chart_div_aclvl'){
            data = datasByDataGovAcLvl;
        }else if(dataForGraph[i].renderInDiv=='chart_div_license-status'){
            data = datasByLicenseStatus;
        }
        
        for (var key in data) {
            keys[keys.length] = key;
        }
        
        for(var k=0;k<keys.length;k++){
            var curKey = keys[k];
            var max = data[curKey];
            for(var j=k+1;j<keys.length;j++){
                if(data[keys[j]]>max){
                    var tmpKey = keys[j];
                    max = data[tmpKey];
                    keys[j]=keys[k];
                    keys[k]=tmpKey;
                }
            }
        }
        for(k=0;k<keys.length;k++){
            tmpArr[tmpArr.length]='{"label":"'+keys[k]+'", "value":'+data[keys[k]]+'}';
            totalRecords+=data[keys[k]];
        }
        var json = eval('['+tmpArr.join(",")+']');
        drawChart(json,dataForGraph[i].renderInDiv,dataForGraph[i].graphTitle);
    }
    var newDiv = document.getElementById("total_count");
    newDiv.innerHTML = totalRecords;
   
}


/*
*This function draws google graph 
*@param jsonCollection          json            collection containing all the data needed for graph
*@param idOfDivToRengerGraph    String            collection containing all the data needed for graph
*@param displayTitle            String          title to display for graph
*/
function drawChart(jsonCollection,idOfDivToRengerGraph,displayTitle){
    totalNoOfRecords = 0;
    var newDiv = document.getElementById(idOfDivToRengerGraph);
    
    var width =300;
    var height =200;
    var data = new google.visualization.DataTable();
    var noOfRecords = jsonCollection.length;
    
    data.addColumn('string', displayTitle);
    data.addColumn('number', 'Count');
    data.addRows(noOfRecords);
    for(var i=0;i<noOfRecords;i++){
        data.setValue(i, 0, jsonCollection[i].label);
        data.setValue(i, 1, jsonCollection[i].value);
        totalNoOfRecords+=jsonCollection[i].value;
    }
    
    var chart = new google.visualization.PieChart(newDiv);
    chart.draw(data, {
        "width": width, 
        "height": height, 
        "title":"Record distribution by \""+displayTitle+"\"",
        "sliceVisibilityThreshold":0,
        "chartArea":{
            left:10, 
            width:"100%"
        }
        
    });
}

/*
*This function displays the help bubble for all the lables
*/
function showItem(elmt) {
    
    var itemID = Exhibit.getAttribute(elmt, "title");   
    var uiContext = exhibit.getUIContext();
    var heading = elmt.getElementsByTagName("span");
    heading = heading[0].innerHTML;
    itemID = '<b>'+heading+'</b><br>'+itemID;
	//console.log(itemID);
    //Exhibit.UI.showItemInPopup(itemID, elmt, exhibit.getUIContext());
    Exhibit.UI.showItemInPopup = function(itemID, elmt, uiContext, opts) {
		//SimileAjax.WindowManager.popAllLayers();

        opts = opts || {};
        opts.coords = opts.coords || Exhibit.UI.calculatePopupPosition(elmt);

        var itemLensDiv = document.createElement("div");
        itemLensDiv.innerHTML=itemID;
		/*var close = function () {
			//console.log("Trying to close ");
			//console.log(itemLensDiv);
			//console.log(bubble);
			//document.body.removeChild(itemLensDiv);
		};*/
		//console.log(SimileAjax.WindowManager._layers);
		//var layer = SimileAjax.WindowManager.pushLayer(close, true, itemLensDiv);
		//console.log(SimileAjax.WindowManager._layers);
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
			uiContext.getSetting("bubbleWidth"));
    }(itemID, elmt, exhibit.getUIContext());
	
	/*Exhibit.UI.showItemInPopup = function(itemID, elmt, uiContext, opts) {
    var itemLensDiv, lensOpts;

    $(document).trigger("closeAllModeless.exhibit");

    opts = opts || {};
    opts.coords = opts.coords || Exhibit.UI.calculatePopupPosition(elmt);
    
    //itemLensDiv = $("<div>");
	var itemLensDiv = document.createElement("div");
	itemLensDiv.innerHTML=itemID;
	console.log("in show item popup"+itemID);
    lensOpts = {
        inPopup: true,
        coords: opts.coords
    };

    if (opts.lensType === "normal") {
        lensOpts.lensTemplate = uiContext.getLensRegistry().getNormalLens(itemID, uiContext);
    } else if (opts.lensType === "edit") {
        lensOpts.lensTemplate = uiContext.getLensRegistry().getEditLens(itemID, uiContext);
    } else if (opts.lensType) {
        Exhibit.Debug.warn(Exhibit._("%general.error.unknownLensType", opts.lensType));
    }

    uiContext.getLensRegistry().createLens(itemID, itemLensDiv, uiContext, lensOpts);
    
    $.simileBubble("createBubbleForContentAndPoint",
        itemLensDiv, 
        opts.coords.x,
        opts.coords.y, 
        uiContext.getSetting("bubbleWidth")
    );
}(itemID, elmt, exhibit.getUIContext());*/
} 

function showDetails(docuuid){
    var link = document.getElementById("toggle_link_"+docuuid).getElementsByTagName("a");
    var abstractField = document.getElementById("abstract_"+docuuid);
    var obj=link[0];
    
    var displayOpt = obj.getAttribute("displayopt");
    if(displayOpt==0){
        $(abstractField).hide("slow");
        var data = abstractField.innerHTML;
        abstractField.innerHTML = data.substr(0, 200);
        $(abstractField).show("slow");
        obj.setAttribute("displayopt", 1);
        obj.innerHTML="";
        obj.appendChild(document.createTextNode("more"));
    }else{
        $.ajax({
            url: 'tools/getGptResourceData.jsp?field=abstract&docuuid='+docuuid,
            success: function( data ) {
                $(abstractField).hide("slow");
                abstractField.innerHTML = data;
                $(abstractField).show("slow");
                var displayOpt = obj.getAttribute("displayopt");
                if(displayOpt==1){
                    //means show more
                    obj.innerHTML="";
                    obj.setAttribute("displayopt", 0);
                    obj.appendChild(document.createTextNode("less"));
                }
            }
        });
    }
}

function filterDropdown() {
	//This code changes the DOM element attribute "data-ex-expressions"
	//but that's only evaluated on pageload - the facet as stored in the Exhibit registry
	//is unaffected. So somehow we need to update the facet. In theory the documentation suggests
	//that there's a method to update the facet, but the documentation is so poor, it's not clear
	//how we reference the facet we need and how we specify the setting to change. If we can
	//figure that out, the code below should tell us how to get the right values.
	//https://github.com/simile-widgets/exhibit/wiki/Developer-Scripted-API
	//document.getElementById("anytext").value = "";
	//Exhibit.History._registry._idCache.anytext.setExpressionString
	var textEle = document.getElementById("anytext").childNodes[1].childNodes[0];
	textEle.value = "";
	document.getElementById("anytext").setAttribute("data-ex-expressions", "");
	if ("createEvent" in document) {
		var evt = document.createEvent("HTMLEvents");
		evt.initEvent("keyup", false, true);

		textEle.dispatchEvent(evt);
	} else {
		//textEle.setAttribute("data-ex-expressions", defaultDataPath);
		textEle.fireEvent("onkeyup");
	}
	document.getElementById("anytext").setAttribute("data-ex-expressions",
		document.getElementById("sel").value);
}
