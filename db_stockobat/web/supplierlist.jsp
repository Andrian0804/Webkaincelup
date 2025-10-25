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
<title>Data Supplier</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3>Daftar Supplier</h3>
<a href="dashboard.jsp" class="btn btn-secondary mb-3">Kembali</a>

<% if ("admin".equals(role)) { %>
  <a href="supplierform.jsp" class="btn btn-primary mb-3">+ Tambah Supplier</a>
<% } %>

<table class="table table-bordered table-striped">
  <thead class="table-dark">
    <tr>
      <th>ID</th>
      <th>Nama Supplier</th>
      <th>Alamat</th>
      <th>Telepon</th>
      <% if ("admin".equals(role)) { %><th>Aksi</th><% } %>
    </tr>
  </thead>
  <tbody>
  <%
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM supplier ORDER BY id DESC");
    while (rs.next()) {
  %>
    <tr>
      <td><%= rs.getInt("id") %></td>
      <td><%= rs.getString("nama_supplier") %></td>
      <td><%= rs.getString("alamat") %></td>
      <td><%= rs.getString("telepon") %></td>
      <% if ("admin".equals(role)) { %>
      <td>
        <a href="supplierform.jsp?id=<%=rs.getInt("id")%>" class="btn btn-sm btn-warning">Edit</a>
        <a href="supplierdelete.jsp?id=<%=rs.getInt("id")%>" onclick="return confirm('Hapus supplier ini?')" class="btn btn-sm btn-danger">Hapus</a>
      </td>
      <% } %>
    </tr>
  <% } %>
  </tbody>
</table>

</body>
</html>
