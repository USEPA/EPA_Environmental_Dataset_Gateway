google.load("visualization", "1", {
    packages:["corechart"]
});
//google.setOnLoadCallback(drawCharts);
var helpIconAdded = false;
var expandAllStatus = false;
var totalNoOfRecords = 0;

    
function submitForm(filterBy){
    url="?report_type=";
    fromDate    = new Date();
    toDate      = new Date();
    document.forms['dateFilter'].form_post.value="true";
            
    if(filterBy){
        $( "#fromDate" ).val(null);
        $( "#toDate" ).val(null);
        $( "#toDate" ).val((toDate.getMonth()+1)+'/'+toDate.getDate()+'/'+toDate.getFullYear());

        switch(filterBy){
            case -1:
                $( "#fromDate" ).val(null);
                $( "#toDate" ).val(null);
                break;
            case 7:
                fromDate.setDate(fromDate.getDate()-7);
                $( "#fromDate" ).val((fromDate.getMonth()+1)+'/'+fromDate.getDate()+'/'+fromDate.getFullYear());
                break;
            case 30:
                fromDate.setDate(fromDate.getDate()-30);
                $( "#fromDate" ).val((fromDate.getMonth()+1)+'/'+fromDate.getDate()+'/'+fromDate.getFullYear());
                break;
            case 1:
                        
                $( "#fromDate" ).val((fromDate.getMonth()+1)+'/'+fromDate.getDate()+'/'+fromDate.getFullYear());
                break;
        }
        document.forms["dateFilter"].submit();
        return true;
    }else{
        if( $("#fromDate" ).val() || $("#toDate" ).val()){
            var re = /^(((0)?[1-9]|1[012])\/((0)?[1-9]|1[0-9]|2[0-9]|3[0-1])\/(\d\d\d\d))$/;
            if($("#fromDate" ).val()){
                if(!(re.test($("#fromDate" ).val()))){
                    alert("The date in the \"From Date\" field is invalid. ");
                    return false;
                }
            }
            if($("#toDate" ).val()){
                if(!(re.test($("#toDate" ).val()))){
                    alert("The date in the \"To Date\" field is invalid. ");
                    return false;
                }
            }
            document.forms["dateFilter"].submit();
            return true;
        }else{
            alert("Please enter valid date in either \"From Date\" or \"To Date\" field.")
            return false;
        }

    }
    document.forms["dateFilter"].submit();
    return true;
}

function submitFrom(){
    var chk = document.getElementById("showTimeComponent");
    var fieldsToDisplay;
    if(chk.checked){
        fieldsToDisplay = {
            "title":"Resource title",
            "uid":"User ID",
            "organization":"Organization",
            "city":"City",
            "region_name":"State/Region",
            "zip_code":"Zip Code",
            "country_name":"Country",
            "ip_address":"IP Address",
            "access_date":"Resource access Date",
            "longitude":"Longitude",
            "latitude":"Latitude",
            "area_code":"Area Code",
            "metro_code":"Metro Code",
            "isp":"ISP",
            "domain_name":"Domain Name"
        };
    }else{
        fieldsToDisplay = {
            "title":"Resource title",
            "uid":"User ID",
            "organization":"Organization",
            "city":"City",
            "region_name":"State/Region",
            "zip_code":"Zip Code",
            "country_name":"Country",
            "ip_address":"IP Address",
            "access_date_part":"Resource access Date",
            "longitude":"Longitude",
            "latitude":"Latitude",
            "area_code":"Area Code",
            "metro_code":"Metro Code",
            "isp":"ISP",
            "domain_name":"Domain Name"
        };
    }
    
    var set = exhibit.getDefaultCollection().getRestrictedItems();
    var db = exhibit._uiContext.getDatabase();
    
    obj = document.forms["csvForm"];
    obj["csv"].value = Exhibit.CSVExporter.exportMany(set,db,fieldsToDisplay);
    obj.submit();
    
}
        
function openLink(link){
    window.open(link,'resourceLinkWindow','scrollbars=1, width=1200,height=1000');
}


$(document).ready(function() {
    
    

    Exhibit.TileView.prototype._reconstruct = (function(fn){
        return function(){
            retValue = fn.call(this);
            toggleTimeComponent();
            refreshGraph();
            return retValue;
        }
    })(Exhibit.TileView.prototype._reconstruct );
    
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

 //DISABLE REPORTING WHEN USER MOVES FROM ONE PAGE TO ANOTHER WITHOUT COMPLETELY LOADING THE CONTENT
    Exhibit.UI.showJsonFileValidation = function(message, url) {return null;}; 
        
});

function checkFacetSelected(){
    for (var i = 0; i < exhibit.getDefaultCollection()._facets.length; i++) {
        var facet = exhibit.getDefaultCollection()._facets[i];
        if (facet.hasRestrictions()) {
            return true; 
        }
    }
    return false;
}



/*
 *This function toggles the +/- sign in box container in view panel 
 *@param 
 *  obj    Element Object    image object
 */
function toggleSign(obj){
    var parent = obj.parentNode.parentNode.parentNode;
    if(contains($(obj).attr("src"),"images/bullet-toggle-minus-icon.png")){
        $(parent).find(".box_content").hide(1000,function (){
            $(obj).attr("src","images/bullet-toggle-plus-icon.png");
        });

    }else{
        $(parent).find(".box_content").show(1000,function(){
            $(obj).attr("src","images/bullet-toggle-minus-icon.png");
        });

    }
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
    for(var i=0;i<toggleElements.length;i++){
        obj = toggleElements[i];
        
        if(contains($(obj).attr("src"),"images/bullet-toggle-plus-icon.png")){
            parent = obj.parentNode.parentNode.parentNode;
            $(parent).find(".box_content").show(1000);
            $(obj).attr("src","images/bullet-toggle-minus-icon.png");
        }
    }
    expandAllStatus = true;
    
}

function contains(haystack,needle){
    return haystack.indexOf(needle, 0)==-1?false:true;
}


function toggleTimeComponent(){
    var obj = document.getElementById("showTimeComponent");
    var dispStyle = obj.checked?"display:inline;":"display:none;"
           
    var allElements = document.getElementsByTagName("span");
   
    for(var i=0;i<allElements.length;i++){
        if($(allElements[i]).attr('name')=='time_part'){
            $(allElements[i]).attr("style",dispStyle);
        }
    }
           
}

function refreshGraph(){
    var totalRecords=0;
    var datasByCountry  = {};
    var datasByState    = {};
    
    if(checkFacetSelected()){
       
    
        var set = exhibit.getDefaultCollection().getRestrictedItems();
        var db = exhibit._uiContext.getDatabase();
        var values,valStr;
    
    
        set.visit(function(itemID) {
            values = db.getObjects(itemID, "country_name");
            valStr = values.toArray().join(",");
            valStr = Exhibit.CSVExporter._cleanData(valStr);
            
        
            if(datasByCountry[valStr]){
                datasByCountry[valStr]++;
            }else{
                datasByCountry[valStr]=1;
            }
        
            values = db.getObjects(itemID, "region_name");
            valStr = values.toArray().join(",");
            valStr = Exhibit.CSVExporter._cleanData(valStr);
            
            if(datasByState[valStr]){
                datasByState[valStr]++;
            }else{
                datasByState[valStr]=1;
            }
        });
    
        for(var i=0;i<dataForGraph.length;i++){
            
            totalRecords=0;
            var data = null;
            var tmpArr = new Array();
            var keys = new Array();
        
            if(dataForGraph[i].renderInDiv=='chart_div_country'){
                data = datasByCountry;
            }else if(dataForGraph[i].renderInDiv=='chart_div_state'){
                data = datasByState;
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
                tmpArr[tmpArr.length]='{"label":"'+keys[k]+'", "value":'+data[keys[k]]+'}'
                totalRecords+=data[keys[k]];
            }
            var json = eval('['+tmpArr.join(",")+']');
            
            drawChart(json,dataForGraph[i].renderInDiv,dataForGraph[i].graphTitle);
        }
    }else{
        
        for(i=0;i<dataForGraph.length;i++){
            totalRecords=0;
            drawChart(dataForGraph[i].data,dataForGraph[i].renderInDiv,dataForGraph[i].graphTitle);
            var len = dataForGraph[i].data.length;
            for(var z=0;z<len;z++){
                totalRecords+=dataForGraph[i].data[z]["value"];
            }
        }
    }
    var newDiv = document.getElementById("total_count");
    newDiv.innerHTML = totalRecords;
}

/*
*This function draws google graph 
*@param jsonCollection          json            collection containing all the data needed for graph
*@param idOfDivToRenderGraph    String            collection containing all the data needed for graph
*@param displayTitle            String          title to display for graph
*/
function drawChart(jsonCollection,idOfDivToRenderGraph,displayTitle){
    
    var newDiv = document.getElementById(idOfDivToRenderGraph);
    
    
    var width =500;
    var height =200;
    var data = new google.visualization.DataTable();
    var noOfRecords = jsonCollection.length;
    
    data.addColumn('string', displayTitle);
    data.addColumn('number', 'Count');
    
    data.addRows(noOfRecords);
    for(var i=0;i<noOfRecords;i++){
        data.setValue(i, 0, jsonCollection[i].label);
        data.setValue(i, 1, jsonCollection[i].value);
        
    }
    
    var chart = new google.visualization.PieChart(newDiv);
    chart.draw(data, {
        "width": width, 
        "height": height, 
        "title":"Record distribution by \""+displayTitle+"\"",
        "sliceVisibilityThreshold":0,
        "chartArea":{
            width:"100%"
        }
    });
}