<%@ page import="java.sql.*, java.text.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}

String id = request.getParameter("id");
String nama = "";
String stok = "";
String satuan = "";

if (id != null) {
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM bahan_kimia WHERE id=?");
    ps.setString(1, id);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        nama = rs.getString("nama_bahan");
        stok = rs.getString("stok");
        satuan = rs.getString("satuan");
    }
}

if (request.getParameter("simpan") != null) {
    nama = request.getParameter("nama_bahan");
    stok = request.getParameter("stok");
    satuan = request.getParameter("satuan");

    if (id == null) {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO bahan_kimia (nama_bahan, stok, satuan, tanggal_update) VALUES (?,?,?,CURDATE())");
        ps.setString(1, nama);
        ps.setString(2, stok);
        ps.setString(3, satuan);
        ps.executeUpdate();

        PreparedStatement ps2 = conn.prepareStatement(
            "INSERT INTO riwayat_stok (id_bahan, aksi, jumlah, tanggal) VALUES (LAST_INSERT_ID(),'Tambah',?,NOW())");
        ps2.setString(1, stok);
        ps2.executeUpdate();

    } else {
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE bahan_kimia SET nama_bahan=?, stok=?, satuan=?, tanggal_update=CURDATE() WHERE id=?");
        ps.setString(1, nama);
        ps.setString(2, stok);
        ps.setString(3, satuan);
        ps.setString(4, id);
        ps.executeUpdate();

        PreparedStatement ps2 = conn.prepareStatement(
            "INSERT INTO riwayat_stok (id_bahan, aksi, jumlah, tanggal) VALUES (?,?,?,NOW())");
        ps2.setString(1, id);
        ps2.setString(2, "Update");
        ps2.setString(3, stok);
        ps2.executeUpdate();
    }

    response.sendRedirect("bahanlist.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Form Bahan Kimia</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3><%= (id==null) ? "Tambah Bahan Kimia" : "Edit Bahan Kimia" %></h3>
<a href="bahanlist.jsp" class="btn btn-secondary mb-3">Kembali</a>

<form method="post">
  <div class="mb-3">
    <label>Nama Bahan</label>
    <input type="text" name="nama_bahan" class="form-control" value="<%=nama%>" required>
  </div>
  <div class="mb-3">
    <label>Stok</label>
    <input type="number" name="stok" class="form-control" value="<%=stok%>" required>
  </div>
  <div class="mb-3">
    <label>Satuan</label>
    <input type="text" name="satuan" class="form-control" value="<%=satuan%>" required>
  </div>
  <button type="submit" name="simpan" class="btn btn-success">Simpan</button>
</form>
</body>
</html>
