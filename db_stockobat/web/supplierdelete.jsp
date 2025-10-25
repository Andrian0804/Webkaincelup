<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
String id = request.getParameter("id");
if (id != null) {
    PreparedStatement ps = conn.prepareStatement("DELETE FROM supplier WHERE id=?");
    ps.setString(1, id);
    ps.executeUpdate();
}
response.sendRedirect("supplierlist.jsp");
%>
