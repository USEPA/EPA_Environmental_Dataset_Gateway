<%@page import="java.util.Set,java.util.Enumeration,java.util.Iterator,java.sql.PreparedStatement,java.util.ArrayList,java.sql.ResultSet,java.sql.Statement,java.util.HashMap,java.sql.SQLException,java.sql.DriverManager,java.sql.Connection"%><%!
    class db {

        protected Connection connection = null;
        protected String tableName;
        protected HashMap columns;
        protected HashMap dataColumns;
        protected Statement stmt = null;

        public db(ServletContext servletContext) {
            this.setConnection(servletContext);
        }
        /*
         * does the connection to the EME-Downloads.mdb
         * @param : hardWiredFilePath   String  Path to the "WEB-INF\EME_files folder"/path where the mdb file is stored
         */

        public final void setConnection(ServletContext servletContext) {
            /* code snippet from http://www.mkyong.com/jdbc/how-do-connect-to-postgresql-with-jdbc-driver-java/ */
            try {
                Class.forName("org.postgresql.Driver");
            } catch (ClassNotFoundException e) {
                System.out.println("Where is your PostgreSQL JDBC Driver? " + "Include in your library path!");
                e.printStackTrace();
                return;
            }

            Connection connection = null;
            try {
                this.connection = DriverManager.getConnection(servletContext.getInitParameter("driverClass").toString(), servletContext.getInitParameter("username").toString(), servletContext.getInitParameter("password").toString());
            } catch (SQLException e) {
                System.out.println("Connection Failed! Check output console");
                e.printStackTrace();
                return;
            }

            if (this.connection != null) {
                System.out.println("You made it, take control your database now!");
            } else {
                System.out.println("Failed to make connection!");
            }


        }

        /*
         * Execute an sql query
         * @param  : sql   String  SQL to process 
         * @return : VOID
         */
        public ResultSet executeQuery(String sql, ArrayList params) {

            PreparedStatement ps = null;
            int indx = 1;
            try {
                ps = this.connection.prepareStatement(sql);
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

        public ResultSet executeQuery(String sql,String limit,String offset) {
            return this.executeQuery(sql+" LIMIT "+limit+" OFFSET "+offset, new ArrayList());
        }
        
        public ResultSet executeQuery(String sql) {
            return this.executeQuery(sql, new ArrayList());
        }
    }
%>
