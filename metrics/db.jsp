<%@page import="java.util.Properties"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%  try {
                    Class.forName("org.postgresql.Driver").newInstance();
                    } catch (Exception e) {
                        out.println("Could not find the class in given library path!");
                        e.printStackTrace();
                    }
                    try {
                        final Properties properties = new Properties();
                        String database = "jdbc:postgresql://localhost:5432/postgres";
                        properties.setProperty("user", "postgres");
                        properties.setProperty("password", "Innovate4fun!");
                        Connection con = null;
                        con = DriverManager.getConnection(database, properties);
                        //this.con = DriverManager.getConnection(this.dbCredentials.getInitParameter("database"), this.dbCredentials.getInitParameter("username"), this.dbCredentials.getInitParameter("password"));
                    } catch (SQLException e) {
                        out.println("Connection Failed!  output console");
                        e.printStackTrace();
                    }
                    
            
%>