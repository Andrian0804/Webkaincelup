<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
String id = request.getParameter("id");
String nama="", alamat="", telepon="";

if (id != null) {
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM supplier WHERE id=?");
    ps.setString(1, id);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        nama = rs.getString("nama_supplier");
        alamat = rs.getString("alamat");
        telepon = rs.getString("telepon");
    }
}

if (request.getParameter("simpan") != null) {
    nama = request.getParameter("nama_supplier");
    alamat = request.getParameter("alamat");
    telepon = request.getParameter("telepon");

    if (id == null) {
        PreparedStatement ps = conn.prepareStatement("INSERT INTO supplier (nama_supplier, alamat, telepon) VALUES (?,?,?)");
        ps.setString(1, nama);
        ps.setString(2, alamat);
        ps.setString(3, telepon);
        ps.executeUpdate();
    } else {
        PreparedStatement ps = conn.prepareStatement("UPDATE supplier SET nama_supplier=?, alamat=?, telepon=? WHERE id=?");
        ps.setString(1, nama);
        ps.setString(2, alamat);
        ps.setString(3, telepon);
        ps.setString(4, id);
        ps.executeUpdate();
    }

    response.sendRedirect("supplierlist.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Form Supplier</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3><%= (id==null) ? "Tambah Supplier" : "Edit Supplier" %></h3>
<a href="supplierlist.jsp" class="btn btn-secondary mb-3">Kembali</a>

<form method="post">
  <div class="mb-3">
    <label>Nama Supplier</label>
    <input type="text" name="nama_supplier" class="form-control" value="<%=nama%>" required>
  </div>
  <div class="mb-3">
    <label>Alamat</label>
    <textarea name="alamat" class="form-control" required><%=alamat%></textarea>
  </div>
  <div class="mb-3">
    <label>Telepon</label>
    <input type="text" name="telepon" class="form-control" value="<%=telepon%>" required>
  </div>
  <button type="submit" name="simpan" class="btn btn-success">Simpan</button>
</form>

</body>
</html>
