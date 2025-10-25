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
<title>Riwayat Stok</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3>Riwayat Perubahan Stok</h3>
<a href="dashboard.jsp" class="btn btn-secondary mb-3">Kembali</a>

<table class="table table-bordered table-striped">
  <thead class="table-dark">
    <tr>
      <th>ID</th>
      <th>Nama Bahan</th>
      <th>Aksi</th>
      <th>Jumlah</th>
      <th>Tanggal</th>
    </tr>
  </thead>
  <tbody>
  <%
    String sql = "SELECT r.id, b.nama_bahan, r.aksi, r.jumlah, r.tanggal FROM riwayat_stok r JOIN bahan_kimia b ON r.id_bahan=b.id ORDER BY r.tanggal DESC";
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery(sql);
    while (rs.next()) {
  %>
    <tr>
      <td><%= rs.getInt("id") %></td>
      <td><%= rs.getString("nama_bahan") %></td>
      <td><%= rs.getString("aksi") %></td>
      <td><%= rs.getInt("jumlah") %></td>
      <td><%= rs.getTimestamp("tanggal") %></td>
    </tr>
  <% } %>
  </tbody>
</table>

</body>
</html>
