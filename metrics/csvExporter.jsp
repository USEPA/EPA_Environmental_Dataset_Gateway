<%@ include file="jspClasses/jsonDataProvider.jsp" %><%@ include file="jspClasses/login.jsp"%><%@page import="java.util.Calendar"%><%
    /*
     * This JSP file will output the CSV file
     * The CSV content is returned from a form, look submitFrom function in inventory.js file
     */

    login loginObj = new login(getServletContext());
    String[] ret = loginObj.verify(request);
    if (!(ret[0].equals("true"))) {
        out.println(ret[1]);
        out.close();
    }


    jsonDataProvider jdpObj = new jsonDataProvider();

    String filename = (request.getParameter("filename") != null) ? request.getParameter("filename") + "_" : "EDG_Inventory_";
    String report = request.getParameter("report");
    ResultSet rs = null;

    Calendar today = Calendar.getInstance();

    HashMap filters = new HashMap();
    filters.put("acl", request.getParameter(ret[1]));

    String year = ((Integer) (today.get(Calendar.YEAR))).toString();
    String day = today.get(Calendar.DATE) < 10 ? "0" + ((Integer) (today.get(Calendar.DATE))).toString() : ((Integer) (today.get(Calendar.DATE))).toString();
    String month = today.get(Calendar.MONTH) < 10 ? "0" + ((Integer) (today.get(Calendar.MONTH) + 1)).toString() : ((Integer) (today.get(Calendar.MONTH) + 1)).toString();
    String hours = today.get(Calendar.HOUR) < 10 ? "0" + ((Integer) (today.get(Calendar.HOUR))).toString() : ((Integer) (today.get(Calendar.HOUR))).toString();
    String minutes = today.get(Calendar.MINUTE) < 10 ? "0" + ((Integer) (today.get(Calendar.MINUTE))).toString() : ((Integer) (today.get(Calendar.MINUTE))).toString();


    filename += year + "" + month + "" + day + "_" + hours + "" + minutes + ".csv";

    response.setContentType("text/csv");
    response.addHeader("Content-Disposition", "attachment; filename=" + filename);

    if (report.equalsIgnoreCase("detailedInventory")) {
        String headings[][] = jdpObj.returnReportHeader(request.getParameter("headings"));
        filters.put("docuuids", request.getParameter("docuuids"));
        rs = jdpObj.getDetailedInventoryData(filters, true);
        out.print(jdpObj.getCSV(headings, rs));
    } else if (report.equalsIgnoreCase("inventory")) {
        String headings[][] = jdpObj.returnReportHeader(request.getParameter("headings"));
        filters.put("docuuids", request.getParameter("docuuids"));
        rs = jdpObj.getInventoryData(filters, true);
        out.print(jdpObj.getCSV(headings, rs));
    } else if (report.equalsIgnoreCase("accessDetails")) {
        out.print(request.getParameter("csv"));
    }


   
%>