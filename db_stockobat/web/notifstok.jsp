<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Notifikasi Stok Hampir Habis</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3>Notifikasi Stok Hampir Habis</h3>
<a href="dashboard.jsp" class="btn btn-secondary mb-3">Kembali</a>

<table class="table table-bordered">
  <thead class="table-danger">
    <tr>
      <th>ID</th>
      <th>Nama Bahan</th>
      <th>Stok</th>
      <th>Satuan</th>
    </tr>
  </thead>
  <tbody>
  <%
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM bahan_kimia WHERE stok < 10 ORDER BY stok ASC");
    boolean kosong = true;
    while (rs.next()) {
      kosong = false;
  %>
    <tr>
      <td><%= rs.getInt("id") %></td>
      <td><%= rs.getString("nama_bahan") %></td>
      <td><%= rs.getInt("stok") %></td>
      <td><%= rs.getString("satuan") %></td>
    </tr>
  <% } 
  if (kosong) { %>
    <tr><td colspan="4" class="text-center text-muted">Semua stok aman ?</td></tr>
  <% } %>
  </tbody>
</table>

</body>
</html>
