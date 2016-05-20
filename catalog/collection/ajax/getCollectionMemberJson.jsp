
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="com.innovateteam.gpt.innoCollection"%>
<% 
    
    response.setContentType("application/json");
    String col_id = request.getParameter("col_id").toString();
    innoCollection obj = new innoCollection(RequestContext.extract(request));
    String json = "", collection_name = null, parent_description = null, parent_resource_name = null, parent_resource_id = null, docuuid = null, childDocuuid = null;
    int count = 0;
    HashMap childResources = new HashMap();
    HashMap childDesription = new HashMap();
    ArrayList docuuids = new ArrayList();
    HashMap param = new HashMap();
    param.put("col_id", col_id);
    ResultSet rs = obj.fnListCollection(param, null, null);
    while (rs.next()) {
        collection_name = rs.getString("name");
    }
    rs.close();
    
    ResultSet rst = obj.fnListCollectionMember(col_id);
    while (rst.next()) {
        count++;
        if(rst.getString("child_docuuid")!=null)
            docuuids.add(rst.getString("child_docuuid"));
        parent_resource_name = rst.getString("parent_title");
        parent_resource_id = rst.getString("docuuid");
        parent_description = obj.getDescriptionByUUID(parent_resource_id);
        if(rst.getString("child_docuuid")!=null){
            childResources.put(rst.getString("child_docuuid"), rst.getString("child_title"));
            String descript = obj.getDescriptionByUUID(rst.getString("child_docuuid"));
            childDesription.put(rst.getString("child_docuuid"), descript);
        }
        
    }
    rst.close();
    
    if (count == 0) {
        json = "{\"id\": \"-1\",\"name\": \"Collection '"+collection_name+"' has no members\",\"data\": {\"type\":\"collection\"},\"children\":[]}";
    } else {
        json = "{\"id\": \"id_" + col_id + "\",\"name\": \"" + collection_name + "\",\"data\": {\"type\":\"collection\"},\"children\":[";
        if (parent_resource_id != null) {
            //json += "{\"id\": \"id_" + parent_resource_id + "\",\"name\": \"" + parent_resource_name + "\",\"data\": {\"type\":\"parent\"},\"children\":[";
            json += "{\"id\": \"id_" + parent_resource_id + "\",\"name\": \"" + parent_resource_name + "\",\"desription\": \"" + parent_description + "\",\"data\": {\"type\":\"parent\"},\"children\":[";
        }
        int i = 0, j = docuuids.size();
        while (i < j) {
            if (docuuid != null) {
                json += ",";
            }
            docuuid = docuuids.get(i++).toString();

            //docuuid = it.next().toString();
            //json += "{\"id\": \"id_" + docuuid + "\",\"name\": \"" + childResources.get(docuuid) + "\",\"data\": {\"type\":\"child\"},\"children\":[]}";
            json += "{\"id\": \"id_" + docuuid + "\",\"name\": \"" + childResources.get(docuuid) +  "\",\"description\": \"" + childDesription.get(docuuid) + "\",\"data\": {\"type\":\"child\"},\"children\":[]}";
        }
        if (parent_resource_id != null) {
            json += "]}";
        }
        json += "]}";
    }
    //String jsonFormat = obj.formatJSON(json);
    out.print(json);

    obj.closeConnection();
%>