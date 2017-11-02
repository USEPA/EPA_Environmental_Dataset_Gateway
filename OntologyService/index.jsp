<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<% String queryUrl = request.getRequestURL().toString().replaceAll("/[^/]+$", "/") + "query?";%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ontology Service</title>
        <script type="text/javascript">
            var url = "";
            var relations = ["BT","RT","NT","UF","AF","AB","SY","FNTT","ATT","USE","CF","CB"];
            var esriAPI = false;
            
            function trim(str){
                regex = /^(\s)*$/g;
                return str.replace(regex, "");
                
            }
            function evaluateQueryUrl() {
                esriAPI = false;
                var query = "";
                var term = encodeURI(document.getElementById("term").value.replace(/^[ \t]+|[ \t]+$/g, ""));
                if (term.length>0) {
                    query = document.getElementById("queryUrl").value;
                    query += "term="+term;
                    
                    var subclassof = document.getElementById("subclassof").value.replace(/^[ \t]+|[ \t]+$/g, "");
                    subclassof = trim(subclassof);
                    if(subclassof && subclassof!="" && subclassof!=undefined){
                        if (isNaN(subclassof)) {
                            document.getElementById("subclassof").value="";
                            esriAPI = false;
                        }else{
                            esriAPI = true;
                            query += "&subclassof=" + subclassof;
                        }
                    }
                    

                var seealso = document.getElementById("seealso").value.replace(/^[ \t]+|[ \t]+$/g, "");
                seealso = trim(seealso);
                if(seealso && seealso!="" && seealso!=undefined){
                    if (isNaN(seealso)) {
                        document.getElementById("seealso").value="";
                        esriAPI = false;
                    }else{
                        esriAPI = true;
                        query += "&seealso=" + seealso;
                    }
                }
                    
                    
                if(esriAPI){
                    for(var k in relations){
                        document.getElementById(relations[k]).value="";
                        document.getElementById(relations[k]).disabled=true;
                    }
                }else{
                    var weights = "";
                    for(var k in relations){
                        document.getElementById(relations[k]).disabled=false;
                            
                        var weight = document.getElementById(relations[k]).value.replace(/^[ \t]+|[ \t]+$/g, "");
                        weight = trim(weight);
                        if(weight && weight!="" && weight!=undefined){
                            if (isNaN(weight)) {
                                document.getElementById(relations[k]).value="";
                            }else{
                                weights += ","+relations[k]+":" + weight;
                            }
                        }
                    }
                    if(weights!=""){
                        query += "&weights=" + weights.substr(1);
                    }
                }
                var level = eval(document.getElementById("level").value.replace(/^[ \t]+|[ \t]+$/g, ""));
                if (isNaN(level)) {
                    level = 1;
                }
                if (level>=1) {
                    query += "&level=" + level;
                }

                var threshold = eval(document.getElementById("threshold").value.replace(/^[ \t]+|[ \t]+$/g, ""));
                if (isNaN(threshold)) {
                    threshold = 0;
                }
                if (threshold!=0) {
                    query += "&threshold=" + threshold;
                }
                return query;
            }else{
                return null;
            }
                
        }

        function update(e) {
            url = evaluateQueryUrl();
            var rest = document.getElementById("rest");
                
            if(url==null){
                url = document.getElementById('queryUrl').value;
                rest.innerHTML = url;
                rest.href = '#';
            }else{
                rest.href = url;
                rest.innerHTML = url;
            }
                
            if(e.which == 13) {
                onSubmit();
            }
        }

        function onSubmit() {
            if(trim(document.getElementById("term").value)!=""){
                location.href = url;
            }else{
                alert("Please enter search term.")
            }
        }
            
        </script>
        <style>
            .header {
                background-color: #eeeeee;
                border-bottom-style: solid;
                border-bottom-width: 1px;
                border-bottom-color: #666666;
                padding-bottom: 5px;
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .footer {
                background-color: #eeeeee;
                font-size: 12px;
                font-weight: normal;
                border-top-style: solid;
                border-top-width: 1px;
                border-top-color: #666666;
                margin-top: 10px;
                border-bottom-style: solid;
                border-bottom-width: 1px;
                border-bottom-color: #666666;
            }

            .status {

                font-size: 12px;
                font-weight: normal;
            }

            .status .ready {

                color: #009933;
            }

            .status .notready {

                color: #990000;
            }

            .form {

            }
        </style>
    </head>
    <body onload="update(event)">
        <input type="hidden" value="<%=queryUrl%>" id="queryUrl"></input>
        <table class="header" width="100%">
            <tr>
                <td>Ontology Service</td>
                <td align="right" valign="top" class="status"></td>
            </tr>
        </table>
        <table class="form">
            <tr>
                <td>Search term:</td>
                <td><input id="term" onkeyup="update(event);"/></td>
            </tr>
            <tr>
                <td>SubClassOf weight:</td>
                <td>
                    <input id="subclassof" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>SeeAlso weight:</td>
                <td>
                    <input id="seealso" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>Level:</td>
                <td>
                    <input id="level" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>Threshold:</td>
                <td>
                    <input id="threshold" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>BT weight:</td>
                <td>
                    <input id="BT" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>RT weight:</td>
                <td>
                    <input id="RT" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>NT weight:</td>
                <td>
                    <input id="NT" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>UF weight:</td>
                <td>
                    <input id="UF" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>AF weight:</td>
                <td>
                    <input id="AF" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>AB weight:</td>
                <td>
                    <input id="AB" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>SY weight:</td>
                <td>
                    <input id="SY" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>FNTT weight:</td>
                <td>
                    <input id="FNTT" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>ATT weight:</td>
                <td>
                    <input id="ATT" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>USE weight:</td>
                <td>
                    <input id="USE" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>CF weight:</td>
                <td>
                    <input id="CF" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td>CB weight:</td>
                <td>
                    <input id="CB" onkeyup="update(event);"/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><button id="submit" name="Submit" value="Submit" onclick="onSubmit();">Submit</button></td>
            </tr>
        </table>
        <table class="footer" width="100%">
            <tr>
                <td align="left">REST: <a id="rest" href=""></a></td>
            </tr>
        </table>
    </body>
</html>
