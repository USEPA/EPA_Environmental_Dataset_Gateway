
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="com.innovateteam.gpt.innoRequestContext"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.innovateteam.gpt.innoHelperFunctions"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.innovateteam.gpt.innoCollection"%><%
    String col_id = request.getParameter("col_id").toString();
    String title = request.getParameter("title").toString();
    String parent = request.getParameter("parent").toString();
    String owner = request.getParameter("owner").toString();
    
    String virtualResourceID = null;
    String docuuid = null;

    HashMap filter = new HashMap();
    filter.put("title", title);

    innoCollection obj = new innoCollection(RequestContext.extract(request));
    innoHelperFunctions hlpObj = new innoHelperFunctions();
    Boolean isAdminUser = hlpObj.isAdminUser(request);
    
    ResultSet rs = obj.fnListVirtualResource(filter, null, null);
    while (rs.next()) {
        virtualResourceID = rs.getString("docuuid");
    }

    if (virtualResourceID == null) {
        innoRequestContext context = new innoRequestContext(request);
        filter.clear();
        filter.put("title", title);
        filter.put("owner", owner);
        virtualResourceID = obj.fnAddInnoVirtualResource(title,context,null,owner);
    }

    int memberCount = 0;

    filter.clear();
    filter.put("col_id", col_id);
    rs = obj.fnListCollectionMember(col_id);
    while (rs.next()) {
        memberCount++;
        docuuid = rs.getString("docuuid");
    }
    if (parent.equals("Y")) {
        if (memberCount > 0) {
            //SET THE UPADTEDATE TO THE RESOURCE BEING REPLACED TOO, SO THE LUCENE INEX CAN CATCH THE CHANGE
            if(docuuid!=null){
                obj.updateModifiedDateForResources(col_id);
            }
            String sql = "UPDATE inno_collection_member SET docuuid=? WHERE col_id=?";
            PreparedStatement ps = null;
            try {
                ps = obj.getConnection().prepareStatement(sql);
                ps.setString(1, virtualResourceID);
                ps.setString(2, col_id);
                int ret = ps.executeUpdate();
                obj.updateModifiedDateForResources(col_id);
                if (ret > 0) {
                    out.print("Placeholder record has been added as parent to the compilation.");
                }
            } catch (SQLException ex) {
                Logger.getLogger(innoCollection.class.getName()).log(Level.SEVERE, null, " Deewendra - " + ex.toString());
            }
        } else {
            filter.clear();
            filter.put("col_id", col_id);
            filter.put("docuuid", virtualResourceID);
            filter.put("role", "parent-child");
            int ret = obj.fnAddCollectionMember(filter);
            if (ret > 0) {
                out.print("Placeholder record has been added as parent to the compilation.");
            }
        }
    } else {
        filter.clear();
        filter.put("col_id", col_id);
        if (docuuid != null) {
            filter.put("docuuid", docuuid);
        }
        filter.put("role", "parent-child");
        filter.put("child_docuuids", virtualResourceID);
       
        int ret = obj.fnAddCollectionMember(filter);
        if (ret > 0) {
            out.print("Placeholder record has been added as child to the compilation.");
        }
    }
    
    //no need to change the approval status is the user is admin user
    if(!(isAdminUser))
        obj.fnAutoApproveCollection(col_id, hlpObj.getCurrentUserGroups(request));
    
    obj.closeConnection();
%>