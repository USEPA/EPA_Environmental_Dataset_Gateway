<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%><%@page import="java.util.ArrayList,java.util.List,java.util.Collections,java.io.IOException, java.util.logging.FileHandler, java.util.Iterator, java.util.Set, java.util.HashMap,java.sql.ResultSet,java.sql.PreparedStatement, java.sql.SQLException, java.sql.DriverManager, java.sql.Connection, java.util.Enumeration, java.text.SimpleDateFormat, java.util.Date, java.text.DateFormat, java.util.logging.Logger"%><%!
    public String getQuoteEnclosedTerm(String str) {
        if (str.indexOf(" ") != -1) {
            return "\"" + str + "\"";
        }
        return str;
    }

    /**
     * Round a double value to a specified number of decimal places.
     *
     * @param val the value to be rounded.
     * @param places the number of decimal places to round to.
     * @return val rounded to places decimal places.
     */
    public double round(double val, int places) {
        long factor = (long) Math.pow(10, places);

        // Shift the decimal the correct number of places
        // to the right.
        val = val * factor;

        // Round to the nearest integer.
        long tmp = Math.round(val);

        // Shift the decimal the correct number of places
        // back to the left.
        return (double) tmp / factor;
    }
%><%
    FileHandler handler = null;
    Logger log = Logger.getLogger("OntologyServlet");
    try {
        Date dNow = new Date();
        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
        String fileName = "OntologyServlet" + ft.format(dNow) + ".log";
        handler = new FileHandler(System.getProperty("catalina.base") + "\\logs\\" + fileName, 8096, 1, true);
        log.addHandler(handler);
    } catch (IOException e) {
    }


    //default weights
    HashMap ontologyTerms = new HashMap();
    HashMap weights = new HashMap();
    weights.put("BT", "0.75");
    weights.put("RT", "0.60");
    weights.put("NT", "0.75");
    weights.put("UF", "0.90");
    weights.put("AF", "0.95");
    weights.put("AB", "0.95");
    weights.put("SY", "0.95");
    weights.put("FNTT", "0.00");
    weights.put("ATT", "0.00");
    weights.put("USE", "0.90");
    weights.put("CF", "0.95");
    weights.put("CB", "0.95");

    //has weight values from the URL param
    HashMap urlWeights = new HashMap();
    if (request.getParameter("weights") != null) {
        String singleWeight[];
        String allWeights[] = request.getParameter("weights").toString().split(",");
        for (int i = 0, len = allWeights.length; i < len; i++) {
            singleWeight = allWeights[i].split(":");
            urlWeights.put(singleWeight[0].toUpperCase(), singleWeight[1]);
        }
    }


    String rel = null;
    Set keys = weights.keySet();
    Iterator it = keys.iterator();
    while (it.hasNext()) {
        rel = it.next().toString();
        if (urlWeights.containsKey(rel)) {
            //first priorty to get parameter
            weights.put(rel, urlWeights.get(rel));
        } else if (getServletContext().getInitParameter(rel + "_WEIGHT") != null) {
            weights.put(rel, getServletContext().getInitParameter(rel + "_WEIGHT"));
        }
    }
    try {
        Class.forName("org.postgresql.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        return;
    }

    boolean esriAPI = false;
    if (request.getParameter("subclassof") != null || request.getParameter("seealso") != null) {
        esriAPI = true;
        if (request.getParameter("subclassof") != null) {
            weights.put("NT", request.getParameter("subclassof"));
        }
        if (request.getParameter("seealso") != null) {
            weights.put("RT", request.getParameter("subclassof"));
        }
    }
    if (esriAPI && request.getParameter("weights") != null) {
        out.print("Please check your request, it has components of esri api along with weights parameter. You cannot have both in same request.");
        out.close();
    }

    String driverClass = getServletContext().getInitParameter("driverClass");
    String username = getServletContext().getInitParameter("username");
    String password = getServletContext().getInitParameter("password");
    int decimal_precision = (request.getParameter("precision") != null) ? Integer.parseInt(request.getParameter("precision")) : (getServletContext().getInitParameter("WEIGHT_DECIMAL_PRECISION") != null ? Integer.parseInt(getServletContext().getInitParameter("WEIGHT_DECIMAL_PRECISION")) : 5);
    decimal_precision = decimal_precision <= 0 ? 5 : decimal_precision;

    Connection connection = null;
    try {
        connection = DriverManager.getConnection(driverClass, username, password);
    } catch (SQLException e) {
        out.println("Connection Failed! Check output console");
        e.printStackTrace();
        return;

    }

    String term = request.getParameter("term");
    String level = request.getParameter("level");
    String threshold = request.getParameter("threshold");
    int _depth = 5;//default to highest
    double _weight = 0.00;
    int count = 0;

    if (term != null) {
        term = term.toLowerCase();
        String returnStr = getQuoteEnclosedTerm(term) + " ";
        String SQL = "SELECT target,path FROM ontology WHERE source=? AND depth<=? ORDER BY depth";

        if (esriAPI) {
            SQL = "SELECT target,path FROM ontology WHERE source=? AND depth<=? ";
            keys = weights.keySet();
            it = keys.iterator();
            while (it.hasNext()) {
                rel = it.next().toString();
                if (rel != "NT" && rel != "RT") {
                    SQL += " AND path NOT LIKE ('%" + rel + "%')";
                }
            }
        }

        if (level != null) {
            try {
                _depth = Integer.parseInt(level);
            } catch (Exception e) {
            }
        }

        if (threshold != null) {
            try {
                _weight = Double.parseDouble(threshold);
            } catch (Exception e) {
            }
        }

        PreparedStatement sql = connection.prepareStatement(SQL);
        sql.setString(1, term);
        sql.setInt(2, _depth);

        ResultSet rs = sql.executeQuery();
        while (rs.next()) {
            count++;
            Double weight = new Double("1.00");
            String path[] = rs.getString("path").toString().split(",");
            for (int i = 0, len = path.length; i < len; i++) {
                weight = weight * Double.parseDouble(weights.get(path[i]).toString());
            }
            weight = round(weight, decimal_precision);
            if (weight >= _weight && weight > 0) {
                ontologyTerms.put(weight + "___" + rs.getString("target").toString(), 1);
            }
        }
       
        String indx;
        List sortedKeys = new ArrayList(ontologyTerms.keySet());
        Collections.sort(sortedKeys);
        Collections.reverse(sortedKeys);
        it = sortedKeys.iterator();
        while (it.hasNext()) {
            indx = it.next().toString();
            String[] tmp = indx.split("___");
            returnStr += getQuoteEnclosedTerm(tmp[1]) + "^" + tmp[0]+ " ";
        }
        out.print(returnStr);
    }
    connection.close();

    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    Date date = new Date();


    log.info("Ontology service service called at " + dateFormat.format(date) + " with following query parameters : ");
    Enumeration e = request.getParameterNames();
    while (e.hasMoreElements()) {
        String name = e.nextElement().toString();
        log.info(name + " = " + request.getParameter(name));
    }
    log.info("Ontology service returned " + count + " terms");
    handler.close();
%>