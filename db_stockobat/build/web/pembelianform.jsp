<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}

if (request.getParameter("simpan") != null) {
    String id_supplier = request.getParameter("id_supplier");
    String id_bahan = request.getParameter("id_bahan");
    String jumlah = request.getParameter("jumlah");

    // Insert pembelian
    PreparedStatement ps = conn.prepareStatement(
        "INSERT INTO pembelian (id_supplier, id_bahan, jumlah, tanggal) VALUES (?,?,?,CURDATE())");
    ps.setString(1, id_supplier);
    ps.setString(2, id_bahan);
    ps.setString(3, jumlah);
    ps.executeUpdate();

    // Update stok bahan
    PreparedStatement ps2 = conn.prepareStatement("UPDATE bahan_kimia SET stok=stok+?, tanggal_update=CURDATE() WHERE id=?");
    ps2.setString(1, jumlah);
    ps2.setString(2, id_bahan);
    ps2.executeUpdate();

    // Catat riwayat
    PreparedStatement ps3 = conn.prepareStatement("INSERT INTO riwayat_stok (id_bahan, aksi, jumlah, tanggal) VALUES (?,?,?,NOW())");
    ps3.setString(1, id_bahan);
    ps3.setString(2, "Pembelian dari supplier");
    ps3.setString(3, jumlah);
    ps3.executeUpdate();

    response.sendRedirect("pembelianlist.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Form Pembelian</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h3>Tambah Pembelian</h3>
<a href="pembelianlist.jsp" class="btn btn-secondary mb-3">Kembali</a>

<form method="post">
  <div class="mb-3">
    <label>Supplier</label>
    <select name="id_supplier" class="form-select" required>
      <option value="">-- Pilih Supplier --</option>
      <%
        Statement st1 = conn.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT * FROM supplier");
        while (rs1.next()) {
      %>
      <option value="<%=rs1.getInt("id")%>"><%=rs1.getString("nama_supplier")%></option>
      <% } %>
    </select>
  </div>

  <div class="mb-3">
    <label>Bahan Kimia</label>
    <select name="id_bahan" class="form-select" required>
      <option value="">-- Pilih Bahan Kimia --</option>
      <%
        Statement st2 = conn.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT * FROM bahan_kimia");
        while (rs2.next()) {
      %>
      <option value="<%=rs2.getInt("id")%>"><%=rs2.getString("nama_bahan")%></option>
      <% } %>
    </select>
  </div>

  <div class="mb-3">
    <label>Jumlah Pembelian</label>
    <input type="number" name="jumlah" class="form-control" required>
  </div>

  <button type="submit" name="simpan" class="btn btn-success">Simpan</button>
</form>

</body>
</html>
