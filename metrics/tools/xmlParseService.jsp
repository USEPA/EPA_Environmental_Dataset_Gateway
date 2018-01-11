<%@include file="../jspClasses/jsonServer.jsp" %><%@include file="../jspClasses/xmlParser.jsp" %><%@ include file="../jspClasses/login.jsp"%>
<%
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }

    String xml, md_std, key, uuid, value, sql;
    jsonServer obj = new jsonServer(1);
    xmlParser objXmlParser;

    ArrayList xpaths = new ArrayList();
    ArrayList params;
    HashMap tmp = new HashMap();
    HashMap allXpaths = new HashMap();

    PreparedStatement ps1 = obj.getPrepareStatement("INSERT INTO metrics_md_xpath (std,xpath) VALUES (?,?)");
    PreparedStatement ps2 = obj.getPrepareStatement("INSERT INTO metrics_md_summary (uuid,xpath,val) VALUES (?,?,?)");



    if ((request.getParameter("offset") != null && request.getParameter("offset") != "")
            && (request.getParameter("limit") != null && request.getParameter("limit") != "")) {
        sql = "SELECT docuuid,xml FROM gpt_resource_data ORDER BY docuuid LIMIT " + request.getParameter("limit") + " OFFSET " + request.getParameter("offset");
    } else {
        sql = "SELECT docuuid,xml FROM gpt_resource_data";
    }
    ResultSet rs = obj.executeQuery(sql);

    while (rs.next()) {
        uuid = rs.getString("docuuid");

        xml = rs.getString("xml");
        objXmlParser = new xmlParser(xml);
        node root = objXmlParser.traverseNodes();

        if (root.getNode().getNodeName().equalsIgnoreCase("dataGov")) {
            md_std = "dataGov";
        } else {
            md_std = "csdgm";
        }

        writeToDb(out, root, '/' + root.getName() + '[' + root.getIndex() + ']', md_std, uuid, ps1, ps2, obj);

    }
%>
<%!    public void writeToDb(JspWriter o, node n, String xpath, String md_std, String uuid, PreparedStatement ps1, PreparedStatement ps2, jsonServer obj) {
        ArrayList params;
        ArrayList list = n.getChildren();
        Iterator it = list.iterator();
        String val;
        while (it.hasNext()) {
            node sub = (node) it.next();

            val = sub.getVal().trim();
            val = val.replaceAll("\\n|\\r", "");

            if (val.trim() != "" && val.length() != 0) {

                params = new ArrayList();
                params.add(md_std);
                params.add(xpath + '/' + sub.getName() + '[' + sub.getIndex() + ']');
                obj.executePreparedStatement(ps1, params);

                params = new ArrayList();
                params.add(uuid);
                params.add(xpath + '/' + sub.getName() + '[' + sub.getIndex() + ']');
                params.add(sub.getVal());
                obj.executePreparedStatement(ps2, params);


            } else {
                writeToDb(o, sub, xpath + '/' + sub.getName() + '[' + sub.getIndex() + ']', md_std, uuid, ps1, ps2, obj);

            }
        }
    }
%>