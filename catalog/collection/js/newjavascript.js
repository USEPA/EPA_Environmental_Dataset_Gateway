var labelType, useGradients, nativeTextSupport, animate,v_col_id=null;
    
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
    var maxNodeLength = function(){
        var leaf = data.children[0].children;
        var max = 0,widthPerChar = 6;
        for(var i=0;i<leaf.length;i++){
            if(leaf[i].name.length>max){
                max = leaf[i].name.length;
            }
        }
        return max*widthPerChar;
    }();
        
    //set the div height depending on number of child nodes
    var childNodeLen = data.children[0].children.length;
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
    var scrollToMiddle = (myDiv[0].scrollHeight - myDiv.height()) / 2; 
    myDiv.animate({
        scrollTop:  scrollToMiddle
    });

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
                    x: posX, 
                    y: posY
                }, width, height, canvas);  
                this.nodeHelper.rectangle.render('stroke', {
                    x: posX, 
                    y: posY
                }, width, height, canvas);  
            }  
        }  
    });  
    
    //end
    //init Spacetree
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
            //canvas specific styles  
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
        //Log.write("loading " + node.name);
        },
        
        onAfterCompute: function(){
            var m = {
                offsetX: (width/2)-200,
                offsetY: ($("#infovis-canvas").height()/2)-(myDiv.height()/2)
            };
            st.onClick(st.root, {Move: m}); 
        },
        
        //This method is called on DOM label creation.
        //Use this method to add event handlers and styles to
        //your node.
        onCreateLabel: function(label, node){
            var style = label.style;
            
            label.id = node.id;            
            label.innerHTML = node.name;
            label.onmouseover = function(){
                style.color = '#369';
            }
            label.onmouseout = function(){
                style.color = '#333';
            }
            label.onclick = function(){
                if(node.data["type"]=="child" || node.data["type"]=="parent"){
                    var url = "/gptlv10/catalog/search/resource/details.page?uuid="+label.id;
                    window.open(url);
                }
            //if(normal.checked) {
            //    st.onClick(node.id);
            //} else {
            //    st.setRoot(node.id, 'animate');
            //}
            };
            //set label styles
            
            if(node.data.type == 'child'){
                style.width = maxNodeLength+ 'px';   
            }
            
            //style.width = (node.name.toString().length*widthPerChar)+ 'px';    
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
            if (node.selected) {
                node.data.$color = "#ff7";
            }
            else {
                delete node.data.$color;
                //if the node belongs to the last plotted level
                if(!node.anySubnode("exist")) {
                    //count children number
                    var count = 0;
                    node.eachSubnode(function(n) {
                        count++;
                    });
                    //assign a node color based on
                    //how many children it has
                    node.data.$color = ['#aaa', '#baa', '#caa', '#daa', '#eaa', '#faa'][count];                    
                }
            }
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
    st.loadJSON(json);
    //compute node positions and layout
    st.compute();
    //optional: make a translation of the tree
    st.geom.translate(new $jit.Complex(-200, 0), "current");
    //emulate a click on the root node.
    st.onClick(st.root);
    //end
    //Add event handlers to switch spacetree orientation.
    
    //top.onchange = left.onchange = bottom.onchange = right.onchange = changeHandler;
    //end
    $( "#infovis").css({
        "width":$(window).width()-100,
        "height":$(window).height()-200
    });
}

$(function() {
    // a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
    $( "#dialog:ui-dialog" ).dialog( "destroy" );
		
    var name = $( "#vr_title" ),
    allFields = $( [] ).add( name ),
    tips = $( ".validateTips" );

    function updateTips( t ) {
        tips
        .text( t )
        .addClass( "ui-state-highlight" );
        setTimeout(function() {
            tips.removeClass( "ui-state-highlight", 1500 );
        }, 500 );
    }

    function checkLength( o, n, min, max ) {
        if ( o.val().length > max || o.val().length < min ) {
            o.addClass( "ui-state-error" );
            updateTips( "Length of " + n + " must be between " +
                min + " and " + max + "." );
            return false;
        } else {
            return true;
        }
    }

    function checkRegexp( o, regexp, n ) {
        if ( !( regexp.test( o.val() ) ) ) {
            o.addClass( "ui-state-error" );
            updateTips( n );
            return false;
        } else {
            return true;
        }
    }
		
    $( "#dialog-form" ).dialog({
        autoOpen: false,
        height: 250,
        width: 350,
        modal: true,
        buttons: {
            "Create resource": function() {
                    
                var col_id = document.forms["virtual_resource_form"].vr_col_id.value;
                var parent = document.forms["virtual_resource_form"].vr_is_parent.checked?"Y":"N";
                var title = document.forms["virtual_resource_form"].vr_title.value;
                var bValid = true;
                var ajaxURL = encodeURI("/gptlv10/catalog/collection/ajax/addVirtualResource.jsp?col_id="+col_id+"&parent="+parent+"&title="+title);
                allFields.removeClass( "ui-state-error" );

                bValid = bValid && checkLength( name, "username", 1, 128 );
                bValid = bValid && checkRegexp( name, /^[a-z]([\s0-9a-z_])+$/i, "Resource name may consist of a-z, 0-9, underscores, begin with a letter." );
                   
                if ( bValid ) {
                    //make ajax request to add resource
                    $.ajax({
                        type: "GET",
                        url: ajaxURL,
                        async : true,
                        success: function(data){
                            $("#virtual_resource_form_response").html(data);
                        }
                    });
                }
            },
            Close: function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
            allFields.val( "" ).removeClass( "ui-state-error" );
        }
    });

    $( ".add_virtual_resource").button().click(function() {
        document.forms["virtual_resource_form"].vr_col_id.value = $(this).attr("col_id");
        $( "#dialog-form" ).dialog( "open" );
    });
        
        
       
        
    $( "#dialog-form-delete" ).dialog({
        autoOpen: false,
        height: 190,
        width: 350,
        modal: true,
        buttons: {
            "Delete": function() {
                if(document.forms["virtual_resource_delete_form"].del_virtual_resource.checked){
                    document.forms["collectionForm"].delete_orphaned_virtual_resource.value="Y";
                }else{
                    document.forms["collectionForm"].delete_orphaned_virtual_resource.value="N";
                }
                document.forms["collectionForm"].action.value='delete';
                document.forms["collectionForm"].submit();
            },
            Close: function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
               
        }
    });
    $( "#dialog-form-member-tree" ).dialog({
        autoOpen: false,
        height: $(window).height(),
        width: $(window).width()-50,
        modal: true,
        buttons: {
            Close: function() {
                $( this ).dialog( "close" );
                v_col_id = null;
            }
        },
        close: function() {
               
        }
    });
        
        
});
                            
function performAction(action,obj){
    var col_id = obj.getAttribute("col_id");
    if(action=="delete"){
        document.forms["collectionForm"].col_id.value=col_id;
        $("#collection-name").html(obj.getAttribute("col_name"));
        $( "#dialog-form-delete" ).dialog( "open" );
    }else if(action=="manage"){
        window.location = "/gptlv10/catalog/collection/manage.page?setCollection="+col_id;
    }
}
    
function goToPage(pageNo){
    var colForm = document.forms["collectionForm"];
    colForm["frm:page"].value = pageNo;
    colForm["action"].value = "changePage";
    colForm.submit();
//var url = "/gptlv10/catalog/collection/home.page";
//url = url+"?page="+pageNo;
//window.location = url;
}
    
function addCollection(){
    //validate form
    var valid = true;
    var colForm = document.forms["collectionForm"];
    if(colForm.name.value.replace(/\s/g,"")==""){
        valid = false;
        alert("Please provide name of the compilation.");
    }
    if(valid){
        if(colForm.owner.value==""){
            valid = false;
            alert("Please select owner for the compilation.");
        }
    }
        
    if(valid){
        colForm.action.value='add';
        colForm.submit();
    }
}
    
function sortBy(sortField){
    var direction = "asc";
    var colForm = document.forms["collectionForm"];
    if(colForm["frm:sortField"].value == sortField){
        direction = direction==colForm["frm:sortDirection"].value?"desc":"asc";
    }
    colForm["frm:sortField"].value = sortField;
    colForm["frm:sortDirection"].value = direction;
    colForm.submit();
}
    
function changeStatus(col_id,obj){
    var url="/gptlv10/catalog/collection/ajax/updateCollectionStatus.jsp?col_id="+col_id;
    dojo.xhrGet({
        url: url,
        preventCache: true,
        handleAs: "text",
        load: function(data) {
            obj.innerHTML = data;
        },
        error: function(err) {
        //alert("error: "+error);
        }
    });
}
    
function openTreeChart(col_id){
    v_col_id = col_id;
    var json = {};
    $.ajax({
        type: "GET",
        url: "/gptlv10/catalog/collection/ajax/getCollectionMemberJson.jsp?col_id="+col_id+"&ErrorRedirect=101",
        dataType: 'json',
        async : false,
        success: function(data){
            json = data;
        }
    });
    $( "#dialog-form-member-tree" ).dialog( "option",{
        height: $(window).height()-50,
        width: $(window).width()-50
    } );
        
    $( "#dialog-form-member-tree" ).css({
        "overflow":"hidden"
    }).dialog( "open" );
    init(json);
        
}
   
$(window).resize(function() {
    if(v_col_id!=null){
        openTreeChart(v_col_id);
    }
});
