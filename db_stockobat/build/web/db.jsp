<%@ page import="java.sql.*" %>
<%
Connection conn = null;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_stokobat", "root", "");
} catch (Exception e) {
    out.println("Koneksi gagal: " + e.getMessage());
}
%>
