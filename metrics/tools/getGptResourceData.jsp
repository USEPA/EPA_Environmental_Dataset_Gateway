<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../jspClasses/jsonServer.jsp" %><%@ include file="../jspClasses/login.jsp" %>
<%
    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }
    jsonServer obj = new jsonServer(1);

    String columnToFetch = (request.getParameter("field") != null) ? request.getParameter("field") : null;
    String docuuid = (request.getParameter("docuuid") != null) ? request.getParameter("docuuid") : null;
    if (columnToFetch != null && docuuid != null) {

        String sql = new String();
        sql = "SELECT gres.docuuid,gres.title,gres.owner,gres.inputdate,gres.updatedate,gres.id,coalesce(gres.approvalstatus,'not approved') as approvalstatus,gres.pubmethod,CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN 'unknown' ELSE gres.siteuuid END as siteuuid,gres.sourceuri ";
        sql += ",coalesce(linkage.val,'unknown') as pri_linkage";
        sql += ",metadata.val as abstract";
        sql += ",gres.fileidentifier,gres.acl, coalesce(gres.host_url,'unknown') as host_url,coalesce(gres.protocol_type,'unknown') as protocol_type,coalesce(gres.protocol,'unknown') as protocol,coalesce(gres.frequency,'unknown') as frequency,coalesce(gres.send_notification,'false') as send_notification,coalesce(gres.findable,'unknown') as findable,coalesce(gres.searchable,'unknown') as searchable";
        sql += ",coalesce(substring(gres.acl from 32 for (char_length(gres.acl)-49)),'unknown') as acl_content";
        sql += ",(CASE WHEN gres.pubmethod='upload' THEN ";
        sql += " CASE WHEN (gres.sourceuri IS NULL OR gres.sourceuri='') THEN ";
        sql += " 'Metadata file \"unknown\" uploaded by \"'||gusr.username||'\"' ";
        sql += " ELSE 'Metadata file \"'||substring(gres.sourceuri FROM position('/' in gres.sourceuri)+1)||'\" uploaded by \"'||gusr.username||'\"' ";
        sql += " END";
        sql += " ELSE ";
        sql += " CASE WHEN (gres.sourceuri IS NULL OR gres.sourceuri='') THEN 'unknown' ELSE gres.sourceuri END";
        sql += " END) as sourceuri_str";
        sql += " ,CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END as acl_opt ";
        sql += ",coalesce(gres.synchronizable,'unknown') as synchronizable,gres.lastsyncdate,gusr.userid,gusr.dn,gusr.username";
        sql += ",(CASE WHEN gres.schema_key='bestpractice' THEN 'FGDC best practice' WHEN gres.schema_key='dataGov' THEN 'data.gov' WHEN gres.schema_key='dc' THEN 'Dublin Core' WHEN gres.schema_key='fgdc' THEN 'FGDC' ELSE gres.schema_key END) as schema_key";
        sql += ",coalesce(lower(gres.content_type),'unknown') as content_type";
        sql += ",(CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN 'unknown' ELSE gres1.title||'('||coalesce(gres1.host_url,'unknown')||')' END) as source ";
        sql += ",gres1.title site_title, gres1.host_url site_host_url";
        sql += " FROM gpt_resource gres LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
        sql += " LEFT OUTER JOIN gpt_resource gres1 ON (gres.siteuuid=gres1.docuuid)";
        sql += " LEFT OUTER JOIN (select * FROM metrics_md_summary WHERE xpath LIKE '/dataGov[_]/basic[_]/description[_]' OR xpath LIKE '%dcat:dataset[_]/dct:description%' OR xpath LIKE '/metadata[_]/idinfo[_]/descript[_]/abstract[_]' OR xpath LIKE '%gmd:MD_DataIdentification[_]/gmd:abstract[_]/gco:CharacterString[_]' OR xpath LIKE '/metadata[_]/dataIdInfo[_]/idAbs[_]') metadata ON (gres.docuuid=metadata.uuid)";
        sql += " LEFT OUTER JOIN (select * FROM metrics_md_summary WHERE xpath IN ('/metadata[1]/idinfo[1]/citation[1]/citeinfo[1]/onlink[1]','/dataGov[1]/downloadableFile[1]/accessPoint[1]')) linkage ON (gres.docuuid=linkage.uuid)";
        sql += " WHERE gres.docuuid=? ";
        if (ret[1].equalsIgnoreCase("public")) {
            sql += " AND (CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END)='" + ret[1].toLowerCase() + "'";
        }
       
        ArrayList params = new ArrayList();
        params.add(docuuid);

        if (columnToFetch.equalsIgnoreCase("abstract")) {

            ResultSet rs = obj.executeQuery(sql, params);
            while (rs.next()) {
                out.print(rs.getString("abstract"));
            }
        }
    }

%>