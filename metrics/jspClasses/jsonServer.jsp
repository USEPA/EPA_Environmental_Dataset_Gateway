<%@page import="java.io.FileOutputStream"%><%@page import="java.io.IOException"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="java.io.File"%><%@page import="java.util.Properties"%><%@page import="java.io.PrintWriter,java.sql.ResultSet,java.sql.ResultSetMetaData,java.sql.SQLException"%><%@page import="java.util.ArrayList,java.util.HashMap,java.util.Iterator,java.util.logging.Level"%><%@page import="java.util.logging.Logger,java.sql.*,java.util.Collection,java.util.HashMap"%><%@page import="java.util.regex.Matcher,java.util.regex.Pattern"%><%!
    /**
     *
     * @author Deewen
     */
    public class jsonServer {

        private Connection con = null;
        private Statement stmt = null;
        private HashMap hint;
        private Float floatValue;
        private Integer intValue;
        private String[] dbTypes = {"msaccess", "postgre"};
        private int curDBType;
        private ServletContext dbCredentials;
        private boolean pretty = false;

        public void setPretty(boolean pretty) {
            this.pretty = pretty;
        }

        public jsonServer(int dbType) {
            this.dbCredentials = getServletContext();
            if (dbType > this.dbTypes.length) {
                System.out.println("Invalid database chosen!");
                dbType = 0;

            }
            this.setConnection(null, dbType);
            hint = new HashMap();
            this.curDBType = dbType;
        }

        /*
         * does the connection to the EME-Downloads.mdb
         * @param : hardWiredFilePath   String  Path to the "WEB-INF\EME_files folder"/path where the mdb file is stored
         */
        public final void setConnection(String hardWiredFilePath, int dbType) {
            String database = null;
            switch (dbType) {
                case 0:
                    //MS ACCESS WORLD
                    database = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=";
                    //database = "JDBC:ODBC:Driver=Microsoft Access Driver (*.mdb, *.accdb); DBQ=";
                    database += this.dbCredentials.getInitParameter("database") + ";DriverID=22;READONLY=true}"; // add on to the end 
                    try {
                        Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
                        this.con = DriverManager.getConnection(database, this.dbCredentials.getInitParameter("username"), this.dbCredentials.getInitParameter("password"));
                    } catch (ClassNotFoundException ex) {
                        Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (SQLException ex) {
                        Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    break;
                case 1:
                    try {
                        Class.forName("org.postgresql.Driver").newInstance();
                    } catch (Exception e) {
                        System.out.println("Could not find the class in given library path!");
                        e.printStackTrace();
                    }
                    try {
                        final Properties properties = new Properties();
                        database = this.dbCredentials.getInitParameter("database");
                        properties.setProperty("user", this.dbCredentials.getInitParameter("username"));
                        properties.setProperty("password", this.dbCredentials.getInitParameter("password"));

                        this.con = DriverManager.getConnection(database, properties);
                        //this.con = DriverManager.getConnection(this.dbCredentials.getInitParameter("database"), this.dbCredentials.getInitParameter("username"), this.dbCredentials.getInitParameter("password"));
                    } catch (SQLException e) {
                        System.out.println("Connection Failed! Check output console");
                        System.out.println(database);
                        e.printStackTrace();
                    }
                    break;
            }

        }

        /*
         * Replaces some special characters to their encoded form
         * @param  : str   String  String in which the special charaters have to be replaced with encoded equivalent
         * @return : String   Escaped string
         */
        public String escapeSpecialChars(String str) {

            if (str != null) {
                str = str.replace("&", "&amp;");
                str = str.replace("\"", "&quot;");
                str = str.replace("<", "&lt;");
                str = str.replace(">", "&gt;");
                str = str.replace("\n", " ");
                str = str.replace("\r", " ");
				str = str.replace("\t", " ");
            }

            return str;
        }
        
        /*
         * Escapes backward slashes which might cause issues when database field have values like "\\u"
         * because they can cause the json parser to think the data in uniceode value
         * @param  : str   String  
         * @return : String   Escaped string
         */
        public String escapeBackSlash(String str) {
            if (str != null) {
                str = str.replace("\\", "\\\\");
            }
            return str;
        }

        /*
         * Execute an sql query
         * @param  : sql   String  SQL to process 
         * @return : VOID
         */
        public ResultSet executeQuery(String sql) {
            try {
                this.stmt = (Statement) this.con.createStatement();
                ResultSet resultSetObj = stmt.executeQuery(sql);
                return resultSetObj;

            } catch (SQLException ex) {
                Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, null, "SQL:" + sql + " " + ex);
                return null;
            }
        }

        /*
         * Execute an sql query
         * @param  : sql   String  SQL to process 
         * @return : VOID
         */
        public ResultSet executeQuery(String sql, ArrayList params) {
            //Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, "Deewendra: "+sql+" PARAMS "+params);
            PreparedStatement ps = null;
            ResultSet resultSetObj = null;
            int indx = 1;
            try {
                ps = this.getPrepareStatement(sql);
                Iterator it = params.iterator();

                while (it.hasNext()) {
                    ps.setString(indx, it.next().toString());
                    indx++;
                }
                try{
					
                    resultSetObj = ps.executeQuery();
					
                }catch(Exception e){
                    Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, "I was here"+e.toString());
                }
                
                return resultSetObj;

            } catch (SQLException ex) {
                Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, null, "SQL:" + sql + " ERROR IS " + ex.toString());
                return null;
            }

        }

        /*
         * Execute an sql query
         * @param  : sql   String  SQL to process 
         * @return : VOID
         */
        public ResultSet executeQuery(String sql, ArrayList params, ArrayList paramType) {

            PreparedStatement ps = null;
            int indx = 1, i;
            try {
                ps = this.getPrepareStatement(sql);

                for (i = 0; i < params.size(); i++) {
                    if (paramType.get(i).toString() == "int") {
                        ps.setInt(indx, Integer.parseInt(params.get(i).toString()));
                    } else {
                        ps.setString(indx, params.get(i).toString());
                    }
                    indx++;
                }

                ResultSet resultSetObj = ps.executeQuery();
                return resultSetObj;

            } catch (SQLException ex) {
                System.out.println(ex.toString());
                return null;
            }

        }

        public PreparedStatement getPrepareStatement(String sql) {
            try {
                return this.con.prepareStatement(sql);
            } catch (SQLException ex) {
                System.out.println(ex.toString());
                return null;
            }
        }

        public ResultSet executePreparedStatement(PreparedStatement ps, ArrayList params) {
            int indx = 1;
            try {
                Iterator it = params.iterator();

                while (it.hasNext()) {
                    ps.setString(indx, it.next().toString());
                    indx++;
                }


                ResultSet resultSetObj = ps.executeQuery();
                return resultSetObj;

            } catch (SQLException ex) {
                System.out.println(ex.toString());
                return null;
            }
        }

        /*
         * Creates json string from the sql provided
         * @param  : sql   String  SQL to process and generate json from 
         * @return : String   json equivalent of the result from the sql
         */
        public String getJson(String sql) {
            return this.getJson(sql, false);
        }

        public void getJsonWithHeader(HttpServletResponse response, String json) throws Exception {
            response.setContentType("application/json;charset=ISO-8859-1");
            PrintWriter out = response.getWriter();
            out.print(json);
        }

        /*
         * Creates json string from the sql provided
         * @param  : sql             String  SQL to process and generate json from 
         *           autoAddLabel    Boolean if true add an item called label which is auto incremented value
         * @return : String   json equivalent of the result from the sql
         */
        public String getJson(String sql, Boolean autoAddLabel) {
            try {
                this.stmt = (Statement) this.con.createStatement();
                ResultSet resultSetObj = stmt.executeQuery(sql);

                return this.getJson(resultSetObj, autoAddLabel);
            } catch (SQLException ex) {
                Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, null, ex);
                return null;
            }
        }

        /*
         * Creates json string from the ResultSet object
         * @param  : resultSetObj   ResultSet  ResultSet to process and generate json from 
         * @return : String   json equivalent of the result from the sql
         */
        public String getJson(ResultSet resultSetObj) {
            return this.getJson(resultSetObj, false);
        }

        /*
         * Creates json string from the ResultSet object
         * @param  : resultSetObj   ResultSet    ResultSet to process and generate json from 
         autoAddLabel   Boolean      if true add an item called label which is auto incremented value
         * @return : String   json equivalent of the result from the sql
         */
        public String getJson(ResultSet resultSetObj, Boolean autoAddLabel) {
            StringBuilder returnStr = new StringBuilder();
            HashMap columnAttributes;
            ArrayList tableColumns = new ArrayList();
            boolean first = true;
            boolean labelExists = false;
            Boolean isNumber = false;
            int count = 0;
            int recCount = 1;
            String fieldValue, tmpFieldValue, fieldName;

            try {
                ResultSetMetaData metaData = resultSetObj.getMetaData();
                int noOfColumns = metaData.getColumnCount();
                for (int i = 1; i <= noOfColumns; i++) {
                    columnAttributes = new HashMap();
                    columnAttributes.put("COLUMN_NAME", metaData.getColumnName(i).toLowerCase());
                    columnAttributes.put("COLUMN_TYPE", metaData.getColumnTypeName(i).toLowerCase());

                    tableColumns.add(columnAttributes);
                    if (metaData.getColumnName(i).equalsIgnoreCase("label")) {
                        labelExists = true;
                        //label exists
                    }
                }
                if (!labelExists && autoAddLabel) {
                    //THERE IS NO LABEL
                    columnAttributes = new HashMap();
                    columnAttributes.put("COLUMN_NAME", "label");
                    columnAttributes.put("COLUMN_TYPE", "INTEGER");

                    tableColumns.add(columnAttributes);
                }
                if (this.pretty) {
                    returnStr.append("{\n\t\"items\":[\n");
                } else {
                    returnStr.append("{\"items\":[");
                }
                
                while (resultSetObj.next()) {
                    count = 0;
                    if (!first) {
                        returnStr.append(",");
                    } else {
                        first = false;
                    }
                    
                    if (this.pretty) {
                        returnStr.append("\n\t{");
                    }else{
                        returnStr.append("{");
                    }
                    Iterator it = tableColumns.iterator();
                    while (it.hasNext()) {
                        count++;
                        columnAttributes = (HashMap) it.next();
                        fieldName = columnAttributes.get("COLUMN_NAME").toString().toLowerCase();
                        
                        if (this.pretty) {
                            returnStr.append("\n\t\t");
                        }
                        returnStr.append("\"");
                        returnStr.append(fieldName);
                        returnStr.append("\"");
                        returnStr.append(":");

                        if (!labelExists && autoAddLabel && "label".equalsIgnoreCase(fieldName)) {
                            returnStr.append(this.returnFieldValue(fieldName, Integer.toString(recCount)));

                        } else {
                            fieldValue = resultSetObj.getString((String) columnAttributes.get("COLUMN_NAME"));
                            returnStr.append(this.returnFieldValue(fieldName, fieldValue));
                        }

                        if (count != tableColumns.size()) {
                            returnStr.append(", ");
                        }
                    }
                    returnStr.append("}");
                    recCount++;
                }
                if (this.pretty) {
                    returnStr.append("\n]\n}");
                }else{
                    returnStr.append("]}");
                }
                return returnStr.toString();
                
            } catch (SQLException ex) {
                Logger.getLogger(jsonServer.class.getName()).log(Level.SEVERE, null, ex);
                return null;
            }


        }

        public void writeJson(ResultSet resultSetObj, Boolean autoAddLabel, String fileName) {
            try {
                String path = getServletContext().getInitParameter("MetricsFilesPath") + "/../../json/cached_json/" + fileName + ".json";
                File file = new File(path);
                // if file doesnt exists, then create it
                if (file.exists()) {
                    file.delete();
                }
                file.createNewFile();


                FileWriter fw = new FileWriter(file.getAbsoluteFile());
				
                BufferedWriter bw = new BufferedWriter(fw);
				
                bw.write(this.getJson(resultSetObj, autoAddLabel));
				
                bw.close();
				
            } catch (IOException e) {
				
                e.printStackTrace();
            }
        }
        /*
         * this function retuns proper string value after analyzing/processing the hints
         * @param  : fieldName   String    the name of the column of the table 
         fieldValue  String    the value corresponding to the column
         * @return : String   processed value of fieldValue
         */

        public String returnFieldValue(String fieldName, String fieldValue) {
            //CHECK HINT
            StringBuffer returnStr = new StringBuffer();
            boolean appendQuote = true;

            fieldName = fieldName.toLowerCase();

            String tmpFieldValue = null;

            if (!(fieldValue == null || fieldValue.isEmpty())) {
                tmpFieldValue = fieldValue.replaceAll("[^a-zA-Z0-9]+", "");
                if (tmpFieldValue == null || (tmpFieldValue.trim()).length() == 0 || tmpFieldValue.equalsIgnoreCase("null")) {
                    fieldValue = "";
                }
            } else {
                fieldValue = "";
            }
            if (fieldValue == "") {
                returnStr.append("\"");
                returnStr.append("\"");
                return returnStr.toString();
            }

            if (this.hint.containsKey(fieldName)) {

                if (this.hint.get(fieldName).toString().indexOf("ARRAY") != -1) {
                    appendQuote = false;
                } else if (this.hint.get(fieldName).toString().indexOf("STRING") != -1) {
                    appendQuote = true;
                    fieldValue = this.escapeSpecialChars(fieldValue);
                } else if (this.hint.get(fieldName).toString().indexOf("INTEGER") != -1) {
                    appendQuote = false;
                    this.floatValue = Float.parseFloat(fieldValue);
                    this.intValue = floatValue.intValue();
                    fieldValue = intValue.toString();
                } else if (this.hint.get(fieldName).toString().indexOf("FLOAT") != -1) {
                    appendQuote = false;
                }
            } else {
                if (this.isNumber(fieldValue)) {
                    appendQuote = false;
                    fieldValue = this.removeUnwantedDecimals(fieldValue);
                } else {
                    fieldValue = this.escapeSpecialChars(fieldValue);
                    fieldValue = this.escapeBackSlash(fieldValue);
                }
            }

            if (appendQuote) {
                returnStr.append("\"");
            }
            returnStr.append(fieldValue);
            if (appendQuote) {
                returnStr.append("\"");
            }
            return returnStr.toString();
        }

        /*
         * this function checks if the given value is numeric or not
         * priority is given to hint, if the value is not numeric but the hint says that it is numeric
         * then this function will return true   
         * @param  : str         String    some string value corresponding to the value in the column "columnName"
         columnName  String    the column name of table 
         * @return : Boolean   true if the given str is numeric(or the hint says its numeric)
         *                     false otherwise     
         */
        public Boolean isNumber(String str, String columnName) {
            if (this.hint.containsKey(columnName) && this.hint.get(columnName) == "NUMERIC") {
                return true;
            }
            try {
                Double d = Double.parseDouble(str);
                return true;
            } catch (Exception e) {
                return false;
            }
        }

        /*
         * this function checks if the given value is numeric or not
         * @param  : str         String    some string value
         * @return : Boolean   true if the given str is numeric
         *                     false otherwise     
         */
        public Boolean isNumber(String str) {
            try {
                Double d = Double.parseDouble(str);
                return true;
            } catch (Exception e) {
                return false;
            }
        }

        /*
         * this function removes unwanted decimal values, such as frmo 2.0 to 2
         * @param  : number    String    number in string format
         * @return : String    number in string format with un-necessary decimal removed
         */
        public String removeUnwantedDecimals(String number) {
            if (this.isNumber(number)) {
                Float f = Float.parseFloat(number);
                if (f == f.intValue()) {
                    Integer i = f.intValue();
                    return i.toString();
                }
            }
            return number;

        }

        /*
         * this function sets the hint
         * @param  : hint    HashMap    HashMap with key representing table column name
         * @return : VOID
         */
        public void setHint(HashMap hint) {
            this.hint = hint;
        }

        public Connection getConnection() {
            return this.con;
        }
    }
%>