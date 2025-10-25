<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}
String role = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>
<head>
<title>Data Bahan Kimia</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3>Daftar Bahan Kimia</h3>
<a href="dashboard.jsp" class="btn btn-secondary mb-3">Kembali</a>

<% if ("admin".equals(role)) { %>
  <a href="bahanform.jsp" class="btn btn-primary mb-3">+ Tambah Bahan</a>
<% } %>

<table class="table table-bordered table-striped">
  <thead class="table-dark">
    <tr>
      <th>ID</th>
      <th>Nama Bahan</th>
      <th>Stok</th>
      <th>Satuan</th>
      <th>Tanggal Update</th>
      <% if ("admin".equals(role)) { %><th>Aksi</th><% } %>
    </tr>
  </thead>
  <tbody>
  <%
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM bahan_kimia ORDER BY id DESC");
    while (rs.next()) {
        int stok = rs.getInt("stok");
        String warna = (stok < 10) ? "table-danger" : "";
  %>
    <tr class="<%=warna%>">
      <td><%= rs.getInt("id") %></td>
      <td><%= rs.getString("nama_bahan") %></td>
      <td><%= stok %></td>
      <td><%= rs.getString("satuan") %></td>
      <td><%= rs.getDate("tanggal_update") %></td>
      <% if ("admin".equals(role)) { %>
      <td>
        <a href="bahanform.jsp?id=<%=rs.getInt("id")%>" class="btn btn-sm btn-warning">Edit</a>
        <a href="bahandelete.jsp?id=<%=rs.getInt("id")%>" onclick="return confirm('Hapus data ini?')" class="btn btn-sm btn-danger">Hapus</a>
      </td>
      <% } %>
    </tr>
  <% } %>
  </tbody>
</table>
</body>
</html>
