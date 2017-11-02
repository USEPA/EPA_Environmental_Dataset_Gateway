<%@include file="../jspClasses/jsonServer.jsp" %><%@ include file="../jspClasses/login.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../javaScripts/jquery-ui/js/jquery-1.5.1.min.js" type="text/javascript"></script>
        <title>JSP Page</title>
    </head>
    <body>
        <h1 id="head_title">Parsing XML</h1>
        <%
            jsonServer obj = new jsonServer(1);
            String sql;

            sql = "TRUNCATE TABLE metrics_md_summary";
            obj.executeQuery(sql);
            sql = "TRUNCATE TABLE metrics_md_xpath";
            obj.executeQuery(sql);

            int recCount = 0;
            sql = "SELECT count(*) as records FROM gpt_resource_data";

            ResultSet rs = obj.executeQuery(sql);
            while (rs.next()) {
                recCount = rs.getInt(1);
            }



        %>
    </body>
    <script type="text/javascript">
        var ajaxCallCount = 0;
        $(document).ready(function() {
            var totalRecords = <% out.print(recCount);%>;
            
            if(totalRecords){
                var limit = 20;
            
                var totalLoopCount = Math.ceil(totalRecords/limit);
                var processed = 0;
                for(processed=0;processed<totalRecords; processed+=limit){
                    $.ajax({
                        url: 'xmlParseService.jsp?limit='+limit+'&offset='+processed,
                        success: function(data) {
                            ajaxCallCount++;
                            if(ajaxCallCount==totalLoopCount){
                                $('#head_title').html("Moving XML data to the DB tables have been completed.");
                            }
                        }
                    });
                }
            }
            
        });
    </script>
</html>