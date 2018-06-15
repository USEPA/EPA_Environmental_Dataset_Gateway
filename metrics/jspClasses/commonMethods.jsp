<%@page import="java.util.Set"%><%@page import="java.net.URL"%><%@ include file="jsonServer.jsp" %><%@page import="java.net.URL"%><%!    class commonMethods {

        private jsonServer jsonServerObj;
        private JspWriter out;
        private HttpServletRequest request;

        public commonMethods() {
            this.jsonServerObj = new jsonServer(1);
        }

        public void setWriter(JspWriter out) {
            this.out = out;
        }

        public void setHttpServletRequest(HttpServletRequest request) {
            this.request = request;
        }

        public void print(String s) {
            try {
                this.out.println(s);
            } catch (Exception e) {
            }
        }

        public String[] getMetaDataLinks(HttpServletRequest request) {
            String host, resourceLink, metadataLink;
            String[] returnArray = new String[2];

            host = request.getHeader("host");

            if (host.equalsIgnoreCase("dev.innovateteam.com")/*dev.innovateteam.com*/ || host.equalsIgnoreCase("localhost:8080")/*localhost*/) {
                resourceLink = "http://dev.innovateteam.com/gptlv10/rest/document";
                metadataLink = "http://dev.innovateteam.com/gptlv10/catalog/search/resource/details.page";
            } else if (host.equalsIgnoreCase("edg-staging.epa.gov")) {
                resourceLink = "https://edg-staging.epa.gov/metadata/rest/document";
                metadataLink = "https://edg-staging.epa.gov/metadata/catalog/search/resource/details.page";
            } else {
                resourceLink = "https://edg.epa.gov/metadata/rest/document";
                metadataLink = "https://edg.epa.gov/metadata/catalog/search/resource/details.page";
            }
            returnArray[0] = resourceLink;
            returnArray[1] = metadataLink;

            return returnArray;
        }

        public String getAccessControlMetricsJsonSQL(HashMap params, String filter) {
				System.out.println("entering AccessControlMetricsJsonSQL");
            String portion = "";

            String sql = "SELECT ";
        	sql += ",coalesce(initcap(publisher.val),'') as publisher";
            if (filter == "epapub") {
               	portion = ",(CASE WHEN ((publisher.val LIKE 'U.S.%' OR publisher.val like 'US%' OR publisher.val like 'Environmental Protection Agency') AND (publisher.val LIKE '%Environmental%' OR publisher.val like '%EPA%') AND NOT (publisher.val LIKE '%Extract%')) THEN 'U.S. EPA' ELSE 'Non-EPA' END) as epapub";
                //portion = "CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END";
            } else if (filter == "schema_key") {
                portion = "(CASE WHEN gres.schema_key='bestpractice' THEN 'FGDC best practice' WHEN gres.schema_key='dataGov' THEN 'data.gov' WHEN gres.schema_key='dc' THEN 'Dublin Core' WHEN gres.schema_key='fgdc' THEN 'FGDC' ELSE coalesce(gres.schema_key,'unknown') END)";
            } else if (filter == "accesslevel") {
                portion = ",(CASE WHEN lower(podAccessLevel.val) IN ('high confidentiality','non-public','non-public','secret','top secret') THEN 'non-public' WHEN lower(podAccessLevel.val) IN ('medium confidentiality','restricted','confidential','sensitive') THEN 'restricted public' ELSE 'public' END) as accesslevel";
            } else if (filter == "licensestatus") {
                portion = ",(CASE WHEN lower(REGEXP_REPLACE(licenseField.val, '[\\n\\r\\s]+', '','g')) IN ('http://edg.epa.gov/epa_data_license.htm','http://edg.epa.gov/epa_data_license.html','https://edg.epa.gov/epa_data_license.htm','https://edg.epa.gov/epa_data_license.html') THEN 'EPA Standard License' ELSE 'Other' END) as licensestatus";
            } 
            sql += portion;
            sql += " ,count(*)";
            sql += " FROM metrics_raw mraw LEFT OUTER JOIN gpt_resource gres  ON (mraw.uuid = gres.docuuid)";
            //sql += " LEFT OUTER JOIN countries cntr ON (mraw.cntry_code=cntr.cntry_code)";
            //sql += " LEFT OUTER JOIN regions rgn ON (mraw.cntry_code=rgn.cntry_code AND mraw.rgn_code=rgn.rgn_code)";
            sql += " LEFT OUTER JOIN gpt_user gusr  ON (gres.owner = gusr.userid)";
            sql += " WHERE 1=1 ";

            /*String key = null;
            String value = null;
            Set s = params.keySet();
            Iterator it = s.iterator();
            while (it.hasNext()) {
                key = it.next().toString();
                value = (String) params.get(key);

                if (value != null && key.equalsIgnoreCase("cntry_code")) {
                    sql += " AND rgn.cntry_code='" + params.get(key) + "'";
                } else if (value != null && key.equalsIgnoreCase("rgn_code")) {
                    sql += " AND rgn.rgn_code='" + params.get(key) + "'";
                } else if (value != null && key.equalsIgnoreCase("acl")) {
                    sql += " AND (CASE WHEN (gres.acl IS NULL OR trim(gres.acl)='') THEN 'public' ELSE 'restricted' END)='" + params.get(key) + "'";
                }
            }*/
            sql += " GROUP BY " + portion + " ORDER BY count(*) DESC";
            return sql;
        }
        /*
         * This function retuns JSON string to render the graph in the dahboard and the inventory  
         */

        public String getJsonForAccessControlMetrics(HashMap params) {
			System.out.println("entering jsonforaccess");
            String jsonForGraph, tmpData, sql;
            ResultSet rs;

            jsonForGraph = "[{\"renderInDiv\":\"chart_div_epa_nonepa\"";
            jsonForGraph += ",\"graphTitle\":\"EPA and NonEPA\"";
            jsonForGraph += ",\"data\":[";
            tmpData = "";


            sql = this.getAccessControlMetricsJsonSQL(params, "epapub");
            rs = this.jsonServerObj.executeQuery(sql);

            try {
                while (rs.next()) {
                    tmpData += ",{\"label\":\"" + rs.getString(1) + "\", \"value\":" + Integer.parseInt(rs.getString(2)) + "}";
                }
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (tmpData.trim() != "") {
                jsonForGraph += tmpData.substring(1);
            }
            jsonForGraph += "]}";


            jsonForGraph += ",{\"renderInDiv\":\"chart_div_metadata\"";
            jsonForGraph += ",\"graphTitle\":\"Metadata Standard\"";
            jsonForGraph += ",\"data\":[";
            tmpData = "";

            sql = this.getAccessControlMetricsJsonSQL(params, "schema_key");
            rs = this.jsonServerObj.executeQuery(sql);
            try {
                while (rs.next()) {
                    tmpData += ",{\"label\":\"" + rs.getString(1) + "\", \"value\":" + Integer.parseInt(rs.getString(2)) + "}";
                }
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (tmpData.trim() != "") {
                jsonForGraph += tmpData.substring(1);
            }
            jsonForGraph += "]}";

            jsonForGraph += ",{\"renderInDiv\":\"chart_div_aclvl\"";
            jsonForGraph += ",\"graphTitle\":\"Data.gov Access Level\"";
            jsonForGraph += ",\"data\":[";
            tmpData = "";

            sql = this.getAccessControlMetricsJsonSQL(params, "accesslevel");
            rs = this.jsonServerObj.executeQuery(sql);
            try {
                while (rs.next()) {
                    tmpData += ",{\"label\":\"" + rs.getString(1) + "\", \"value\":" + Integer.parseInt(rs.getString(2)) + "}";
                }
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (tmpData.trim() != "") {
                jsonForGraph += tmpData.substring(1);
            }
            jsonForGraph += "]}";

            jsonForGraph += ",{\"renderInDiv\":\"chart_div_license-status\"";
            jsonForGraph += ",\"graphTitle\":\"License Status\"";
            jsonForGraph += ",\"data\":[";
            tmpData = "";

            sql = this.getAccessControlMetricsJsonSQL(params, "licensestatus");
            rs = this.jsonServerObj.executeQuery(sql);
            try {
                while (rs.next()) {
                    tmpData += ",{\"label\":\"" + rs.getString(1) + "\", \"value\":" + Integer.parseInt(rs.getString(2)) + "}";
                }
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }

            if (tmpData.trim() != "") {
                jsonForGraph += tmpData.substring(1);
            }
            jsonForGraph += "]}]";

            return jsonForGraph;
        }

        public String getJsonAccessResourceMetrics(HashMap params) {

            String jsonForGraph, tmpData, sql;
            ResultSet rs;

            jsonForGraph = "[{\"renderInDiv\":\"chart_div_country\"";
            jsonForGraph += ",\"graphTitle\":\"Country\"";
            jsonForGraph += ",\"data\":[";
            tmpData = "";
            sql = this.getAccessControlMetricsJsonSQL(params, "cntry_name");
            rs = this.jsonServerObj.executeQuery(sql);
            try {
                while (rs.next()) {
                    tmpData += ",{\"label\":\"" + rs.getString(1) + "\", \"value\":" + Integer.parseInt(rs.getString(2)) + "}";
                }
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }

            jsonForGraph += tmpData.substring(1);
            jsonForGraph += "]}";


            jsonForGraph += ",{\"renderInDiv\":\"chart_div_state\"";
            jsonForGraph += ",\"graphTitle\":\"Region\\State\"";
            jsonForGraph += ",\"data\":[";
            tmpData = "";
            sql = this.getAccessControlMetricsJsonSQL(params, "rgn_name");
            rs = this.jsonServerObj.executeQuery(sql);
            try {
                while (rs.next()) {
                    tmpData += ",{\"label\":\"" + rs.getString(1) + "\", \"value\":" + Integer.parseInt(rs.getString(2)) + "}";
                }
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }
            jsonForGraph += tmpData.substring(1);


            jsonForGraph += "]}]";

            return jsonForGraph;

        }

        public String getCountryRegion() {
            String json = "";
            String sql = "SELECT cntry.cntry_name, reg.cntry_code,reg.rgn_code,reg.rgn_name FROM regions reg JOIN countries cntry ON (reg.cntry_code=cntry.cntry_code) ORDER BY cntry.cntry_name,reg.rgn_name ";
            ResultSet rs = this.jsonServerObj.executeQuery(sql);
            String previousCountry = null;
            String region = "";
            String country = "";
            int count = 0;
            try {
                while (rs.next()) {
                    if (count == 0) {
                        country = "{\"cntry_code\":\"" + rs.getString("cntry_code") + "\", \"cntry_name\":\"" + rs.getString("cntry_name") + "\", \"regions\" : ";
                        region = ",{\"rgn_code\":\"" + rs.getString("rgn_code") + "\", \"rgn_name\":\"" + rs.getString("rgn_name") + "\"}";
                        previousCountry = rs.getString("cntry_code");
                        count++;
                    } else {
                        if (previousCountry.equals(rs.getString("cntry_code"))) {
                            region += ",{\"rgn_code\":\"" + rs.getString("rgn_code") + "\", \"rgn_name\":\"" + rs.getString("rgn_name") + "\"}";
                        } else {
                            json += "," + country + "[" + region.substring(1) + "]}";

                            country = "{\"cntry_code\":\"" + rs.getString("cntry_code") + "\", \"cntry_name\":\"" + rs.getString("cntry_name") + "\", \"regions\" : ";
                            region = ",{\"rgn_code\":\"" + rs.getString("rgn_code") + "\", \"rgn_name\":\"" + rs.getString("rgn_name") + "\"}";
                            previousCountry = rs.getString("cntry_code");
                        }
                    }
                }
                json += "," + country + "[" + region.substring(1) + "]}";
            } catch (Exception ex) {
                Logger.getLogger(commonMethods.class.getName()).log(Level.SEVERE, null, ex);
            }
            return "{\"countries\" : [" + json.substring(1) + "]}";
        }

        public String getNoAccessPage(String[] errMsg) {
            String page = "<html>";
            page += " <head>"
                    + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"
                    + "<title>Metrics</title>"
                    + "<link href=\"main.css\" rel=\"stylesheet\" type=\"text/css\" /> "
                    + "<body >"
                    + "<div id=\"body_container\"><div id=\"header\"></div>"+this.getMenu()+"<div class=\"container\">"
                    + "<div style=\"padding:50px; font-weight:bold;\">"
                    + "<fieldset>"
                    + "<legend>" + errMsg[2] + "</legend>"
                    + "<div>" + errMsg[1] + "</div>"
                    + "</fieldset>";
            page += "</div></div></div></body></html>";
            return page;
        }

        public String getMenu() {
            StringBuilder ret = new StringBuilder();
            String selectedClass = null, curPage = null, link = null;
            ArrayList menuItems = new ArrayList();
            HashMap items = new HashMap();

            items = new HashMap();
            items.put("label", "Introduction");
            items.put("link", "/metrics/introduction.jsp");
            //menuItems.add(items);

            items = new HashMap();
            items.put("label", "EDG Inventory");
            items.put("link", "/metrics/inventory.jsp");
            menuItems.add(items);

            items = new HashMap();
            items.put("label", "Detailed Inventory");
            items.put("link", "/metrics/detailedInventory.jsp");
            //menuItems.add(items);

            items = new HashMap();
            items.put("label", "Access Metrics");
            items.put("link", "/metrics/resourceAccess.jsp");
            //menuItems.add(items);
            try {
                URL url = new URL(this.request.getRequestURL().toString());
                curPage = url.getFile().toString();
                curPage = curPage.trim().equals("/metrics/") ? "/metrics/inventory.jsp" : curPage;

                ret.append("<div id=\"menu\">");
                ret.append("<ul>");

                for (int i = 0; i < menuItems.size(); i++) {
                    items = (HashMap) menuItems.get(i);
                    link = items.get("link").toString();
                    selectedClass = null;

                    if (link.equals(curPage)) {
                        selectedClass = "class=\"selected\"";
                        link = "javascript:void(0);";
                    }

                    ret.append("<li " + selectedClass + "><a href=\"" + link + "\" >" + items.get("label") + "</a></li>");
                }
                ret.append("</ul>");
                ret.append("</div><div style = \"clear:both;padding-bottom:5px;background-color:#FFF;\" > </div>");

                return ret.toString();
            } catch (Exception e) {
                return null;
            }
        }
    }


%>