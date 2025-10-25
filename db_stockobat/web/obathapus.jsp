<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}

int id = Integer.parseInt(request.getParameter("id"));
PreparedStatement ps = conn.prepareStatement("DELETE FROM obat WHERE id=?");
ps.setInt(1, id);
ps.executeUpdate();

response.sendRedirect("obatlist.jsp");
%>
