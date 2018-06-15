<%@page import="java.util.Set"%><%@page import="java.net.URL"%><%@ include file="jsonServer.jsp" %><%@page import="java.io.Writer"%><%!    
class jsonDataProvider {

        private jsonServer jsonServerObj;

        public jsonDataProvider(jsonServer jsonServerObj) {
            this.jsonServerObj = jsonServerObj;
        }

        public jsonDataProvider() {
            this.jsonServerObj = new jsonServer(1);
        }

        public String cleanData(String str) {
            str = str.replaceAll("\"", "&quot;");
            str = str.replaceAll("<", "&lt;");
            str = str.replaceAll(">", "&gt;");
            str = str.replaceAll("\n", " ");
            str = str.replaceAll("\r", " ");
			str = str.replaceAll("\t", " ");
            return str;
        }

        public String[][] returnReportHeader(String headers) {
            String[] headTitles = headers.split(",");
            String[][] returnTitle = new String[2][(headTitles.length)];
            String tmp;
            String[] tmpSplit;

            int len = headTitles.length;
            for (int i = 0; i < len; i++) {
                tmp = headTitles[i];
                tmpSplit = tmp.split(":");

                returnTitle[0][i] = tmpSplit[0];
                returnTitle[1][i] = tmpSplit[1];

            }
            return returnTitle;
        }

        public ResultSet getAccessDetailsData(HashMap filters, boolean forExport) {
            ArrayList params = new ArrayList();
            String sql = new String();

            sql = "SELECT mraw.uuid ,(CASE WHEN mraw.uid IS NULL OR trim(mraw.uid)='' THEN 'Unknown' ELSE mraw.uid END) as uid,mraw.ip_address,mraw.organization ,mraw.cntry_code,mraw.rgn_code,mraw.city";
            sql += " ,mraw.zip_code,mraw.latitude,mraw.longitude,mraw.metro_code,mraw.area_code,mraw.isp,mraw.domain_name,coalesce(mraw.linkage,'Unknown') as linkage";
            sql += " ,cntr.cntry_name as country_name,coalesce(rgn.rgn_name,'Unknown') as region_name,(CASE WHEN gres.title IS NULL OR trim(gres.title)='' THEN 'Unknown' ELSE gres.title END) as title  ";
            sql += " ,TO_CHAR(mraw.access_date,'YYYY-MM-DD HH24:MI:SS') as access_date,to_char(mraw.access_date,'YYYY-MM-DD') as access_date_part,to_char(mraw.access_date,'HH24:MI:SS') as access_time_part";
            sql += " ,(CASE WHEN gres.title IS NULL OR trim(gres.title)='' THEN 'Unknown' ELSE gres.title END)||CASE WHEN (count((CASE WHEN gres.title IS NULL OR trim(gres.title)='' THEN 'Unknown' ELSE gres.title END)) OVER (PARTITION BY (CASE WHEN gres.title IS NULL OR trim(gres.title)='' THEN 'Unknown' ELSE gres.title END)))=1 THEN ' ' ELSE '-'||(row_number() OVER (PARTITION BY (CASE WHEN gres.title IS NULL OR trim(gres.title)='' THEN 'Unknown' ELSE gres.title END))) END as label";
            sql += " FROM metrics_raw mraw LEFT OUTER JOIN gpt_resource gres  ON (mraw.uuid = gres.docuuid)";
            sql += " LEFT OUTER JOIN countries cntr ON (mraw.cntry_code=cntr.cntry_code)";
            sql += " LEFT OUTER JOIN regions rgn ON (mraw.cntry_code=rgn.cntry_code AND mraw.rgn_code=rgn.rgn_code)";
            sql += " WHERE 1=1 ";
            if (filters.containsKey("acl") && (filters.get("acl") != null && filters.get("acl") != "" && filters.get("acl").toString().equalsIgnoreCase("public"))) {
                sql += " AND (CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END)='public'";
            }
            if (filters.containsKey("fromDate") && (filters.get("fromDate") != null && filters.get("fromDate") != "")
                    && (filters.get("toDate") != null && filters.get("toDate") != "")) {
                params.add(filters.get("fromDate"));
                params.add(filters.get("toDate"));

                sql += (" AND date(mraw.access_date)>= ");
                sql += ("to_date(");
                sql += ("?");

                sql += (",'MM/DD/YYYY')");
                sql += (" AND date(mraw.access_date) <= ");
                sql += ("to_date(");
                sql += ("?");

                sql += (",'MM/DD/YYYY')");

            } else if (filters.containsKey("fromDate") && filters.get("fromDate") != null && filters.get("fromDate") != "") {
                params.add(filters.get("fromDate"));
                sql += (" AND date(mraw.access_date) >= ");
                sql += ("to_date(");
                sql += ("?");
                sql += (",'MM/DD/YYYY')");
            } else if (filters.containsKey("toDate") && filters.get("toDate") != null && filters.get("toDate") != "") {
                params.add(filters.get("toDate"));

                sql += (" AND date(mraw.access_date) <= ");
                sql += ("to_date(");
                sql += ("?");
                sql += (",'MM/DD/YYYY')");
            }
            
            return this.jsonServerObj.executeQuery(sql, params);
        }

        public ResultSet getDetailedInventoryData(HashMap filters, boolean forExport) {
            ArrayList params = new ArrayList();

            String sql = new String();
            sql = "SELECT gres.docuuid,gres.title,gres.owner,gres.inputdate,gres.updatedate,gres.id,coalesce(gres.approvalstatus,'not approved') as approvalstatus,gres.pubmethod,CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN 'unknown' ELSE gres.siteuuid END as siteuuid,gres.sourceuri ";
            sql += ",coalesce(linkage.val,'unknown') as pri_linkage";
            if (forExport) {
                sql += ", coalesce(metadata.val,'unknown') as abstract";
            }

            sql += ",gres.fileidentifier,gres.acl, coalesce(gres.host_url,'unknown') as host_url,coalesce(gres.protocol_type,'unknown') as protocol_type,coalesce(gres.protocol,'unknown') as protocol,coalesce(gres.frequency,'unknown') as frequency,coalesce(gres.send_notification,'false') as send_notification,coalesce(gres.findable,'unknown') as findable,coalesce(gres.searchable,'unknown') as searchable";
            sql += ",coalesce(substring(gres.acl from 32 for (char_length(gres.acl)-49)),'unknown') as acl_content";
            sql += ",(CASE WHEN gres.pubmethod='upload' THEN ";
            sql += " CASE WHEN (gres.sourceuri IS NULL OR trim(gres.sourceuri)='') THEN ";
            sql += " 'Metadata file \"unknown\" uploaded by \"'||gusr.username||'\"' ";
            sql += " ELSE 'Metadata file \"'||substring(gres.sourceuri FROM position('/' in gres.sourceuri)+1)||'\" uploaded by \"'||gusr.username||'\"' ";
            sql += " END";
            sql += " ELSE ";
            sql += " CASE WHEN (gres.sourceuri IS NULL OR trim(gres.sourceuri)='') THEN 'unknown' ELSE gres.sourceuri END";
            sql += " END) as sourceuri_str";
            sql += " ,CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END as acl_opt ";
            sql += ",coalesce(gres.synchronizable,'unknown') as synchronizable,gres.lastsyncdate,gusr.userid,gusr.dn,gusr.username";
            sql += ",(CASE WHEN gres.schema_key='bestpractice' THEN 'FGDC best practice' WHEN gres.schema_key='dataGov' THEN 'data.gov' WHEN gres.schema_key='dc' THEN 'Dublin Core' WHEN gres.schema_key='fgdc' THEN 'FGDC' ELSE gres.schema_key END) as schema_key";
            sql += ",coalesce(lower(gres.content_type),'unknown') as content_type";
            sql += ",(CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN 'unknown' ELSE gres1.title||'('||coalesce(gres1.host_url,'unknown')||')' END) as source ";
            sql += ",gres1.title site_title, gres1.host_url site_host_url";
            sql += " FROM gpt_resource gres LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
            sql += " LEFT OUTER JOIN gpt_resource gres1 ON (gres.siteuuid=gres1.docuuid)";
            sql += " LEFT OUTER JOIN (select * FROM metrics_md_summary WHERE xpath IN ('/metadata[1]/idinfo[1]/descript[1]/abstract[1]','/dataGov[1]/basic[1]/description[1]')) metadata ON (gres.docuuid=metadata.uuid)";
            sql += " LEFT OUTER JOIN (select * FROM metrics_md_summary WHERE xpath IN ('/metadata[1]/idinfo[1]/citation[1]/citeinfo[1]/onlink[1]','/dataGov[1]/downloadableFile[1]/accessPoint[1]')) linkage ON (gres.docuuid=linkage.uuid)";
            sql += " WHERE 1=1 ";
            if (filters.containsKey("acl") && (filters.get("acl") != null && filters.get("acl") != "" && filters.get("acl").toString().equalsIgnoreCase("public"))) {
                sql += " AND (CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END)='public'";
            }
            if (filters.containsKey("docuuids") && (filters.get("docuuids") != null && filters.get("docuuids") != "")) {
                sql += " AND gres.docuuid IN (" + filters.get("docuuids") + ")";
            }
            return this.jsonServerObj.executeQuery(sql, params);
        }

        public ResultSet getInventoryData(HashMap filters, boolean forExport) {
            ArrayList params = new ArrayList();

            String sql = new String();
            sql = "SELECT DISTINCT ON (gres.docuuid) gres.title,gusr.username,gres.docuuid,gres.fileidentifier";
            sql += ",coalesce(linkage.val,'# No Primary Link Provided') as pri_linkage";
            if (forExport) {
                sql += ", coalesce(left(metadata.val,255),'# No Abstract Provided') as abstract";
            }
																				  
			 
            sql += ",(CASE WHEN gres.pubmethod='uVpload' THEN ";
            sql += " (CASE WHEN (gres.sourceuri IS NULL OR trim(gres.sourceuri)='') THEN ";
            sql += " 'Metadata file \"unknown\" uploaded by \"'||gusr.username||'\"' ";
            sql += " ELSE 'Metadata file \"'||substring(gres.sourceuri FROM position('/' in gres.sourceuri)+1)||'\" uploaded by \"'||gusr.username||'\"' ";
            sql += " END)";
            sql += " ELSE ";
            sql += " (CASE WHEN (gres.sourceuri IS NULL OR trim(gres.sourceuri)='') THEN '# Unknown Source URI' ELSE gres.sourceuri END)";
            sql += " END) as sourceuri_str";
            sql += ",coalesce(lower(gres.content_type),'# No Content Type Provided') as content_type";
            sql += " ,CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END as acl_opt ";
            sql += ",(CASE WHEN gres.schema_key='bestpractice' THEN 'FGDC' WHEN gres.schema_key='dcat' THEN 'Project Open data' WHEN gres.schema_key='iso-19115' THEN 'ISO Metadata' WHEN gres.schema_key='esri-arcgis' THEN 'ArcGIS Metadata' WHEN gres.schema_key='dataGov' THEN 'data.gov' WHEN gres.schema_key='dc' THEN 'Dublin Core' WHEN gres.schema_key='fgdc' THEN 'FGDC' ELSE 'Unknown Schema' END) as schema_key";
            sql += ",date(gres.inputdate) as inputdate,date(gres.updatedate) as updatedate";
            sql += ",coalesce(gres.approvalstatus,'not approved') as approvalstatus,gres.pubmethod";
			sql += ",CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN '# Unknown Source URI' ELSE gres.siteuuid END as siteuuid,gres.sourceuri ";
            sql += ",(CASE WHEN gres.siteuuid IS NULL OR gres.siteuuid='' THEN '# Unknown Harvest Source' ELSE gres1.title||'('||coalesce(gres1.host_url,'# Unknown Harvest Source')||')' END) as source ";
            sql += ",gres1.title site_title, gres1.host_url site_host_url";
			sql += ",coalesce(compilation.parenttitle,'# Not Part of a Compilation') as cmpparenttitle";
			sql += ",coalesce(collection.parenttitle,'# Not Part of a Collection') as colparenttitle";
            sql += ",coalesce(initcap(isokey1.val),'') as iso_kwd1";
            sql += ",coalesce(initcap(place.val),'') as placekey";
            sql += ",coalesce(initcap(publisher.val),'# No Publisher Provided') as publisher";
            sql += ",(CASE WHEN ((publisher.val LIKE 'U.S.%' OR publisher.val like 'US%' OR publisher.val like 'Environmental Protection Agency') AND (publisher.val LIKE '%Environmental%' OR publisher.val like '%EPA%') AND NOT (publisher.val LIKE '%Extract%')) THEN 'U.S. EPA' ELSE 'Non-EPA' END) as epapub";
            sql += ",(CASE WHEN lower(podAccessLevel.val) IN ('high confidentiality','non-public','non-public','secret','top secret') THEN 'non-public' WHEN lower(podAccessLevel.val) IN ('medium confidentiality','restricted','confidential','sensitive') THEN 'restricted public' ELSE 'public' END) as accesslevel";
            sql += ",(CASE WHEN lower(REGEXP_REPLACE(licenseField.val, '[\\n\\r\\s]+', '','g')) IN ('http://edg.epa.gov/epa_data_license.htm','http://edg.epa.gov/epa_data_license.html','https://edg.epa.gov/epa_data_license.htm','https://edg.epa.gov/epa_data_license.html') THEN 'EPA Standard License' ELSE 'Other' END) as licensestatus";
            sql += ",coalesce(left(lower(licenseField.val),48),'# No License Provided') as licenseurl";
            sql += ",(CASE WHEN left(lower(rightsField.val),13) = 'epa category:' THEN 'Valid EPA CUI Statement' ELSE 'Other' END) as rightsstatus";
            sql += ",coalesce(left(rightsField.val,42),'# No rights statement provided') as rightsnote";
            sql += ",coalesce(left(progress.val,42),'# No progress status provided') as progressstatus";
            sql += ",cleanFloat(coalesce(ebc.val,'')) as eastbc";
            sql += ",cleanFloat(coalesce(wbc.val,'')) as westbc";
            sql += ",cleanFloat(coalesce(nbc.val,'')) as northbc";
            sql += ",cleanFloat(coalesce(sbc.val,'')) as southbc";
            sql += " FROM gpt_resource gres LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
            sql += " LEFT OUTER JOIN gpt_resource gres1 ON (gres.siteuuid=gres1.docuuid)";
            sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath LIKE '/dataGov[_]/basic[_]/description[_]' OR xpath LIKE '%dcat:dataset[_]/dct:description%' OR xpath LIKE '/metadata[_]/idinfo[_]/descript[_]/abstract[_]' OR xpath LIKE '%gmd:MD_DataIdentification[_]/gmd:abstract[_]/gco:CharacterString[_]' OR xpath LIKE '/metadata[_]/dataIdInfo[_]/idAbs[_]') metadata ON (gres.docuuid=metadata.uuid)";
            sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath IN ('/metadata[1]/idinfo[1]/citation[1]/citeinfo[1]/onlink[1]','/dataGov[1]/downloadableFile[1]/accessPoint[1]','/gmd:MD_Metadata[1]/gmd:distributionInfo[1]/gmd:MD_Distribution[1]/gmd:distributor[1]/gmd:MD_Distributor[1]/gmd:distributorTransferOptions[1]/gmd:MD_DigitalTransferOptions[1]/gmd:onLine[1]/gmd:CI_OnlineResource[1]/gmd:linkage[1]/gmd:URL[1]')) linkage ON (gres.docuuid=linkage.uuid)";
	    sql += " LEFT OUTER JOIN ( SELECT m1.uuid, m2.val FROM gptlv10.metrics_md_summary m1, gptlv10.metrics_md_summary m2 WHERE m1.uuid = m2.uuid and m1.xpath like '%themekt%' and m1.val = 'ISO 19115 Topic Category' and m2.xpath like '%themekey%' and m1.xpath = replace(m2.xpath, '/themekey[', '/themekt[') UNION ALL SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%/specializedDataCategoryDesignation[1]%' ) isokey1 ON (gres.docuuid=isokey1.uuid)";
	    sql += " LEFT OUTER JOIN ( SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%placekey%' UNION ALL SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%/geographicScope[%' ) place ON (gres.docuuid=place.uuid)";
	    sql += " LEFT OUTER JOIN ( SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%/eastbc[1]%' OR xpath like '%/eastBL[1]%' ) ebc ON (gres.docuuid=ebc.uuid)";
	    sql += " LEFT OUTER JOIN ( SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%/westbc[1]%' OR xpath like '%/westBL[1]%' ) wbc ON (gres.docuuid=wbc.uuid)";
	    sql += " LEFT OUTER JOIN ( SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%/northbc[1]%' OR xpath like '%/northBL[1]%' ) nbc ON (gres.docuuid=nbc.uuid)";
	    sql += " LEFT OUTER JOIN ( SELECT uuid, val FROM gptlv10.metrics_md_summary WHERE xpath like '%/southbc[1]%' OR xpath like '%/southBL[1]%' ) sbc ON (gres.docuuid=sbc.uuid)";
        sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath LIKE '/metadata[_]/idinfo[_]/citation[_]/citeinfo[_]/pubinfo[_]/publish[_]' OR xpath LIKE '%/gmd:MD_DataIdentification[_]/gmd:pointOfContact[_]/gmd:CI_ResponsibleParty[_]/gmd:organisationName[_]/gco:CharacterString[_]' OR xpath LIKE '%agencyName%' OR xpath LIKE '%foaf:name%' or xpath LIKE '/metadata[1]/dataIdInfo[1]/idPoC[1]/rpOrgName[1]') publisher ON (gres.docuuid=publisher.uuid)";
        sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath like '%secclass%' OR xpath like '%/gmd:MD_DataIdentification[_]/gmd:resourceConstraints[_]/gmd:MD_SecurityConstraints[_]/gmd:useLimitation[_]/gco:CharacterString[_]' or xpath LIKE '%pod:accessLevel%' OR xpath LIKE '%SecConsts[_]/class[_]/ClasscationCd%') podAccessLevel ON (gres.docuuid=podAccessLevel.uuid)";  
        sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath LIKE '%distliab%' OR xpath like '%/gmd:MD_DataIdentification[_]/gmd:resourceConstraints[_]/gmd:MD_LegalConstraints[_]/gmd:otherConstraints[_]/gco:CharacterString[_]' OR xpath LIKE '%dct:license%' OR (xpath LIKE '/metadata[_]/dataIdInfo[_]/resConst[_]/LegConsts[_]/othConsts[_]' and val like 'http%')) licenseField ON (gres.docuuid=licenseField.uuid)"; 
        sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath LIKE '%accconst%' OR xpath like '%/gmd:MD_DataIdentification[_]/gmd:resourceConstraints[_]/gmd:MD_LegalConstraints[_]/gmd:otherConstraints[_]/gco:CharacterString[_]' OR xpath LIKE '%dct:rights%' OR xpath LIKE '/metadata[_]/dataIdInfo[_]/resConst[_]/SecConsts[_]/userNote[_]') rightsField ON (gres.docuuid=rightsField.uuid)"; 
        sql += " LEFT OUTER JOIN (select uuid, val FROM metrics_md_summary WHERE xpath LIKE '/metadata[_]/idinfo[_]/status[_]/progress[_]') progress ON (gres.docuuid=progress.uuid)"; 
        sql += " LEFT OUTER JOIN (SELECT inno_collection_member.child_docuuid childuuid, gpt_resource.title parenttitle FROM gptlv10.inno_collection_member, gptlv10.gpt_resource WHERE gpt_resource.docuuid = inno_collection_member.docuuid) compilation ON (gres.docuuid=compilation.childuuid)"; 
        sql += " LEFT OUTER JOIN (SELECT metrics_md_summary.uuid uuid, metrics_md_summary.val val, gpt_resource.title parenttitle FROM gptlv10.metrics_md_summary, gptlv10.gpt_resource WHERE (xpath LIKE '/metadata[_]/idinfo[_]/citation[_]/citeinfo[_]/lworkcit[_]/citeinfo[_]/othcit[_]' OR xpath like '%/gmd:MD_DataIdentification[_]/gmd:aggregationInfo[_]/gmd:MD_AggregateInformation[_]/gmd:aggregateDataSetIdentifier[_]/gco:MD_Identifier[_]/gmd:code[_]/gco:CharacterString[_]' OR xpath LIKE '%pod:isPartOf%' OR xpath LIKE '/metadata[_]/dataIdInfo[_]/aggrInfo[_]/aggrDSIdent[_]/identCode[_]') AND gpt_resource.docuuid = ('{' || metrics_md_summary.val || '}')) collection ON (gres.docuuid=collection.uuid)"; 
        sql += " WHERE lower(gres.pubmethod)!='registration'";
            if (filters.containsKey("acl") && (filters.get("acl") != null && filters.get("acl") != "" && filters.get("acl").toString().equalsIgnoreCase("public"))) {
                sql += " AND (CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END)='public'";
            }
            if (filters.containsKey("docuuids") && (filters.get("docuuids") != null && filters.get("docuuids") != "")) {
                sql += " AND gres.docuuid IN (" + filters.get("docuuids") + ")";
            }
            return this.jsonServerObj.executeQuery(sql, params);
        }

        public String getCSV(String[][] headings, ResultSet rs) {
            StringBuffer out = new StringBuffer();
            String val;
            for (int i = 0; i < headings[1].length; i++) {
                out.append(headings[1][i]);
                if (i != headings[1].length) {
                    out.append(",");
                }
            }
            try {
                while (rs.next()) {
                    out.append("\n");
                    for (int i = 0; i < headings[0].length; i++) {
                        val = rs.getString(headings[0][i]);
                        if (val == null) {
                            out.append(' ');
                        } else {
                            out.append('"' + this.cleanData(val) + '"');
                        }
                        if (i != headings[1].length) {
                            out.append(",");
                        }
                    }
                }
            } catch (Exception e) {
            }
            return out.toString();
        }
    }%>
