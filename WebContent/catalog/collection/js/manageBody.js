var formName = "collection.manage";
var searchItemChange=null,v_col_id=null;


function clearSearch(){
    var f = document.forms["collection.manage"];
    f["mmdTitle"].value="";
    f["mmdUuid"].value="";
    f["mmdOwnerAdmin"].selectedIndex = 0;
    f["mmdCurrentMemebersOnly"].checked = true;
    doSearch();
}
    
function observeChange(){
    if(searchItemChange!=null)
        clearInterval(searchItemChange);
        
    searchItemChange=setInterval("doSearch()",500);
}
    
function doSearch(){
    var f = document.forms["collection.manage"];
    f['frm:action'].value='search';
    f.submit();
}
    
function setDocuuid(field,obj){
    var parent_docuuid = document.forms[formName]["frm:parent_docuuid"];
    var child_docuuid = document.forms[formName]["frm:child_docuuid"];
            
    if(field=="parent"){
            
        dojo.query('input.parent_docuuid').forEach(function(node, index, arr){
            if(node.name!="docuuid_"+obj.value){
                node.checked = false;
            }
        });
                      
        if(parent_docuuid.value.toString().length>0 && document.getElementById("child_docuuid_"+parent_docuuid.value)){
            document.getElementById("child_docuuid_"+parent_docuuid.value).disabled = false;
        }
        document.forms[formName]["frm:parent_docuuid"].value = (obj.checked)?obj.value:"";
        if(obj.checked){
            document.getElementById("child_docuuid_"+obj.value).checked = false;
            document.getElementById("child_docuuid_"+obj.value).disabled = true;
        }else{
            document.getElementById("child_docuuid_"+obj.value).checked = false;
            document.getElementById("child_docuuid_"+obj.value).disabled = false;
        }
            
        //remove parent from child if it exists there
        var child_docuuid_value = child_docuuid.value;
        child_docuuid_value = child_docuuid_value.replace(obj.value+",", "");
            
            
            
    }else{
        var child_docuuid_value = child_docuuid.value;
        if(obj.checked){
            if(child_docuuid_value.indexOf(obj.value)==-1)
                child_docuuid_value = child_docuuid_value+obj.value+",";
        }else{
            child_docuuid_value = child_docuuid_value.replace(obj.value+",", "");
        }
    }
    child_docuuid.value = child_docuuid_value;
}
    
//handle paging
function goToPage(pageNo){
    document.forms[formName]["frm:page"].value = pageNo;
    document.forms[formName]["frm:action"].value = "paging";
    document.forms[formName].submit();
}
    
function collectionChanged(obj){
    document.forms[formName]["frm:action"].value = "collectionChanged";
    document.forms[formName].submit();
}
    
function saveCollectionMember(){
    var form = document.forms[formName],valid = true,messages = [];
    form["frm:action"].value = "save";
    form.submit();
}
    
function sortBy(sortField){
    var direction = "asc";
    var colForm = document.forms[formName];
    if(colForm["frm:sortField"].value == sortField){
        direction = direction==colForm["frm:sortDirection"].value?"desc":"asc";
    }
    colForm["frm:sortField"].value = sortField;
    colForm["frm:sortDirection"].value = direction;
    colForm.submit();
}
    
function toggleNewCollectionDisplay(obj){
    if(obj.options[obj.selectedIndex].value!=""){
        document.getElementById("new_collection").style.display = "none";
    }else{
        document.getElementById("new_collection").value = "";
        document.getElementById("new_collection").style.display = "inline";
    }
}
    
function selectAllChild(obj){
    var checkedVal = obj.checked;
    dojo.query('input.child_docuuid').forEach(function(node, index, arr){
        if(!(node.disabled)){
            node.checked = checkedVal;
            setDocuuid('child',node);
        }
            
    });
}
    
function showDetails(docuuid){
    var url = contextPath+"/catalog/search/resource/details.page?uuid="+docuuid;
    window.open(url);
}

function openTreeChart(col_id){
    var findFormMemberTree = document.getElementById("dialog-form-member-tree");
    if(findFormMemberTree !=null){
        v_col_id = col_id;
        var json = {};
        $.ajax({
            type: "GET",
            url: contextPath+"/catalog/collection/ajax/getCollectionMemberJson.jsp?col_id="+col_id+"&ErrorRedirect=101",
            dataType: 'json',
            async : false,
            success: function(data){
                json = data;
            }
        });
        $( "#dialog-form-member-tree" ).dialog( "option",{
            height: parseInt($(window).height())-50,
            width: parseInt($(window).width())-50
        } );
        
        $( "#dialog-form-member-tree" ).css({
            "overflow":"hidden"
        }).dialog( "open" );
        init(json);
    }else{
        window.open(contextPath+"/catalog/search/visualizeCollection.jsp?"+col_id);
    }
        
}

(function() {
    var ua = navigator.userAgent,
    iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
    typeOfCanvas = typeof HTMLCanvasElement,
    nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
    textSupport = nativeCanvasSupport && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
    //I'm setting this based on the fact that ExCanvas provides text support for IE
    //and that as of today iPhone/iPad current text support is lame
    labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
    nativeTextSupport = labelType == 'Native';
    useGradients = nativeCanvasSupport;
    animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
    elem: false,
    write: function(text){
        if (!this.elem) 
            this.elem = document.getElementById('log');
        this.elem.innerHTML = text;
        this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
    }
};
    
    
function init(data){
    //init data
    var json = data;
    var childNodeLen = null;
    var maxNodeLength = function(){
        var leaf = null;
        if(data.children && data.children.length>0){
            if(data.children[0].children && data.children[0].children.length>0){
                leaf = data.children[0].children;
            }else{
                leaf = data.children;
            }
        }
        //no child elements
        if(leaf==null){
            childNodeLen = 1;
            return 0;
        }
        else{
            childNodeLen = leaf.length;
        }
        
        var max = 0,widthPerChar = 6;
        
        for(var i=0;i<leaf.length;i++){
            if(leaf[i].name.length>max){
                max = leaf[i].name.length;
            }
        }
        return max*widthPerChar;
    }();
        
    //set the div height depending on number of child nodes
    var width = parseInt($(window).width());
    var height = childNodeLen*30;
    height = height<400?400:height;
    height = parseInt(height>$(window).height()?height:$(window).height());
        
    $( "#infovis").css({
        "width":width-100,
        "height":height
    }).empty();
        
        
    //scroll to the middle of the div
    var myDiv = $("#dialog-form-member-tree");    

    //Create a node rendering function that plots a fill  
    //rectangle and a stroke rectangle for borders  
    $jit.ST.Plot.NodeTypes.implement({  
        'stroke-rect': {  
            'render': function(node, canvas) {  
                var width = node.getData('width'),  
                height = node.getData('height'),  
                pos = this.getAlignedPos(node.pos.getc(true), width, height),  
                posX = pos.x + width/2,  
                posY = pos.y + height/2;  
                this.nodeHelper.rectangle.render('fill', {
                    x: posX+3, 
                    y: posY
                }, width, height, canvas);  
                this.nodeHelper.rectangle.render('stroke', {
                    x: posX+3, 
                    y: posY
                }, width, height, canvas);  
            }  
        }  
    });  
    
    //end
    //init Spacetree
    //Create a new ST instance
    //Create a new ST instance  
    var st = new $jit.ST({  
        //id of viz container element  
        injectInto: 'infovis',  
        //set duration for the animation  
        duration: 800,  
        //set animation transition type  
        transition: $jit.Trans.Quart.easeInOut,  
        //set distance between node and its children  
        levelDistance: (2/3)*maxNodeLength,  
        //enable panning  
        Navigation: {  
            enable:true,  
            panning:true  
        },  
        //set node and edge styles  
        //set overridable=true for styling individual  
        //nodes or edges  
        Node: {  
            height: 20,  
            autoWidth : true,
            type: 'stroke-rect',  
            color: '#aaa',  
            overridable: true,
            CanvasStyles: {  
                strokeStyle: '#888',  
                lineWidth: 2  
            }  
        },  
      
        Edge: {  
            type: 'bezier',  
            overridable: true  
        },  
      
        onBeforeCompute: function(node){  
           
        },  
        offsetX: (width/2)-200,
        offsetY: (height/2)-(myDiv.height()/2),
        onAfterCompute: function(){  
            
        },  
      
        //This method is called on DOM label creation.  
        //Use this method to add event handlers and styles to  
        //your node.  
        onCreateLabel: function(label, node){  
            label.id = node.id;              
            label.innerHTML = node.name;  
            label.onclick = function(){  
                if(node.data["type"]=="child" || node.data["type"]=="parent"){
                    if(label.id.indexOf("id_") != -1){
                        label.id=label.id.substring(3);
                    }
                    var url = contextPath+"/catalog/search/resource/details.page?uuid="+label.id;
                    window.open(url);
                }
            };  
            //set label styles  
            var style = label.style;  
            
            label.onmouseover = function(){
                style.color = '#369';
            }
            label.onmouseout = function(){
                style.color = '#333';
            }
            
            if(node.data.type == 'child'){
                style.width = maxNodeLength+ 'px';   
            }
            style.height = 17 + 'px';              
            style.cursor = 'pointer';  
            style.color = '#333';  
            style.fontSize = '0.8em';  
            style.textAlign= 'left';  
            style.paddingTop = '3px';  
            style.paddingLeft = '3px';
        },  
      
        //This method is called right before plotting  
        //a node. It's useful for changing an individual node  
        //style properties before plotting it.  
        //The data properties prefixed with a dollar  
        //sign will override the global node style properties.  
        onBeforePlotNode: function(node){  
            //add some color to the nodes in the path between the  
            //root node and the selected node.  
            if(node.data.type == 'child'){
                node.data.$color = '#AABEE4';
                node.data.$width = maxNodeLength;
            }
            else if(node.data.type == 'parent'){
                node.data.$color = '#6bba70';
            }
            if(node.data.type == 'collection'){
                node.data.$color = '#CCC';
            }
        },  
      
        //This method is called right before plotting  
        //an edge. It's useful for changing an individual edge  
        //style properties before plotting it.  
        //Edge data proprties prefixed with a dollar sign will  
        //override the Edge global style properties.  
        onBeforePlotLine: function(adj){  
            if (adj.nodeFrom.selected && adj.nodeTo.selected) {  
                adj.data.$color = "#eed";  
                adj.data.$lineWidth = 3;  
            }  
            else {  
                delete adj.data.$color;  
                delete adj.data.$lineWidth;  
            }  
        }  
    });  
    //load json data  
    st.loadJSON(data);  
    //compute node positions and layout  
    st.compute();  
    //optional: make a translation of the tree  
    st.geom.translate(new $jit.Complex(-200, 0), "current");  
    //emulate a click on the root node.  
    st.onClick(st.root);  
    
    
}

$(function() {
    $( "#dialog-form-member-tree" ).dialog({
        autoOpen: false,
        height: $(window).height(),
        width: $(window).width()-50,
        modal: true,
        buttons: {
            Close: function() {
                $( this ).dialog( "close" );
                v_col_id = null;
                window.close();
            }
        },
        close: function() {
            v_col_id = null;
            window.close();
        }
    });
              
});

      
window.onload = function () {
    if(v_col_id!=null){
        openTreeChart(v_col_id);
    }
}


$(window).resize(function() {
    if(v_col_id!=null){
        openTreeChart(v_col_id);
    }
});


function highlightCollection(){
    var findfrmPrimaryNavigation = document.getElementById("frmPrimaryNavigation:collection");
    if(findfrmPrimaryNavigation !=null){
        document.getElementById("frmPrimaryNavigation:collection").setAttribute("class", "current");
    }
}

 $("#svSecondaryNavigation\\:frmSecondaryNavigationForCollection\\:collectionManage").removeAttr("onclick").attr("href","javascript:void(0);");


