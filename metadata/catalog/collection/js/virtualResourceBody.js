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
        height: 200,
        width: 350,
        modal: true,
        buttons: {
            "Update record": function() {
                    
                var docuuid = document.forms["virtual_resource_form"].vr_docuuid.value;
                var title = document.forms["virtual_resource_form"].vr_title.value;
                var owner = document.forms["virtual_resource_form"].vr_owner.value;
                
                var bValid = true;
                var ajaxURL = encodeURI(contextPath+"/catalog/collection/ajax/updateVirtualResource.jsp?docuuid="+docuuid+"&title="+title+"&owner="+owner);
                allFields.removeClass( "ui-state-error" );

                bValid = bValid && checkLength( name, "username", 1, 128 );
                bValid = bValid && checkRegexp( name, /([\s0-9a-z_])+$/i, "Resource name may consist of a-z, 0-9, underscores." );
                   
                if ( bValid ) {
                    var curObj = this;
                    //make ajax request to add resource
                    $.ajax({
                        type: "GET",
                        url: ajaxURL,
                        async : true,
                        success: function(data){
                            $("#title_"+docuuid.replace("{", "\\{").replace("}", "\\}")).html($.trim(data));
                            $( curObj ).dialog( "close" );
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

    $( ".edit_virtual_resource").click(function() {
        tips.text( "All form fields are required." );
        document.forms["virtual_resource_form"].vr_docuuid.value = $(this).attr("docuuid");
        document.forms["virtual_resource_form"].vr_owner.value = $(this).attr("owner");
        $("#virtual_resource_form_response").html("");
        $( "#dialog-form" ).dialog( "open" );
    });
});
    
function performAction(action,obj){
    var docuuid = obj.getAttribute("docuuid");
    if(action=="delete"){
        if(confirm("Any child records associated with this record in any collection will also be deleted, are you sure?")){
            document.forms["collectionForm"].action.value=action;
            document.forms["collectionForm"].docuuid.value=docuuid;
            document.forms["collectionForm"].submit();
        }
    }else if(action=="manage"){
        window.location = contextPath+"/catalog/collection/manage.page?setCollection="+col_id;
    }
}
    
function goToPage(pageNo){
    var colForm = document.forms["collectionForm"];
    colForm["frm:page"].value = pageNo;
    colForm["action"].value = "changePage";
    colForm.submit();
}
    
function addResource(){
    //validate form
    var valid = true;
    var colForm = document.forms["collectionForm"];
    if(colForm.name.value.replace(/\s/g,"")==""){
        valid = false;
        alert("Please provide name of the virtual resource.");
    }
    if(valid){
        if(colForm.owner.value=="-1"){
            valid = false;
            alert("Please select owner for the collection.");
        }
    }  
    if(valid){
        colForm.action.value='add';
        colForm.submit();
    }
}
    
function sortBy(sortField){
    var direction = "desc";
    var colForm = document.forms["collectionForm"];
    if(colForm["frm:sortField"].value == sortField){
        direction = direction==colForm["frm:sortDirection"].value?"":"desc";
    }
    colForm["frm:sortField"].value = sortField;
    colForm["frm:sortDirection"].value = direction;
    colForm.submit();
}
    
function openDetails(role,uuid){
    var r = role.toString().toLowerCase();
    var url = null;
    if(r=="orphan"){
        return false;
    }else if(r=="parent"){
        url = contextPath+"/catalog/search/resource/details.page?uuid="+uuid;
        window.open(url);
    }else if(r=="child"){
        url = contextPath+"/rest/find/document?xsl=metadata_to_html_full&f=html&parentof="+uuid;
        window.open(url);
    }
}

document.getElementById("frmPrimaryNavigation:collection").setAttribute("class", "current");
$("#svSecondaryNavigation\\:frmSecondaryNavigationForCollection\\:collectionManage").removeAttr("onclick").attr("href","javascript:void(0);");