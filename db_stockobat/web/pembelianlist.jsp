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
<title>Data Pembelian</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3>Daftar Pembelian Bahan Kimia</h3>
<a href="dashboard.jsp" class="btn btn-secondary mb-3">Kembali</a>
<a href="pembelianform.jsp" class="btn btn-primary mb-3">+ Tambah Pembelian</a>

<table class="table table-bordered table-striped">
  <thead class="table-dark">
    <tr>
      <th>ID</th>
      <th>Supplier</th>
      <th>Bahan Kimia</th>
      <th>Jumlah</th>
      <th>Tanggal</th>
    </tr>
  </thead>
  <tbody>
  <%
    String sql = "SELECT p.id, s.nama_supplier, b.nama_bahan, p.jumlah, p.tanggal FROM pembelian p JOIN supplier s ON p.id_supplier=s.id JOIN bahan_kimia b ON p.id_bahan=b.id ORDER BY p.id DESC";
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery(sql);
    while (rs.next()) {
  %>
    <tr>
      <td><%= rs.getInt("id") %></td>
      <td><%= rs.getString("nama_supplier") %></td>
      <td><%= rs.getString("nama_bahan") %></td>
      <td><%= rs.getInt("jumlah") %></td>
      <td><%= rs.getDate("tanggal") %></td>
    </tr>
  <% } %>
  </tbody>
</table>

</body>
</html>
