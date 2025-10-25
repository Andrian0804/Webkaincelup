<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%
if(session.getAttribute("username") == null){
    response.sendRedirect("login.jsp");
}

// Proses form jika disubmit
if(request.getMethod().equalsIgnoreCase("POST")){
    try{
        int obat_id = Integer.parseInt(request.getParameter("obat_id"));
        int supplier_id = Integer.parseInt(request.getParameter("supplier_id"));
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String tanggal = request.getParameter("tanggal");

        // Update stok obat
        Statement stmt = conn.createStatement();
        stmt.executeUpdate("UPDATE obat SET jumlah = jumlah + "+jumlah+" WHERE id = "+obat_id);

        // Insert ke tabel pembelian (log stok masuk)
        stmt.executeUpdate("INSERT INTO pembelian(obat_id,supplier_id,jumlah,tanggal) VALUES("
            +obat_id+","+supplier_id+","+jumlah+",'"+tanggal+"')");

        out.println("<div class='alert alert-success'>Stok berhasil ditambahkan!</div>");
    }catch(Exception e){
        out.println("<div class='alert alert-danger'>Error: "+e.getMessage()+"</div>");
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stok Masuk Obat</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Tambah Stok Obat</h2>
    <form method="post">
        <!-- Pilih Obat -->
        <div class="mb-3">
            <label>Obat</label>
            <select name="obat_id" class="form-select" required>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM obat ORDER BY nama_obat ASC");
                    while(rs.next()){
                %>
                <option value="<%=rs.getInt("id")%>"><%=rs.getString("nama_obat")%></option>
                <% } %>
            </select>
        </div>

        <!-- Pilih Supplier -->
        <div class="mb-3">
            <label>Supplier</label>
            <select name="supplier_id" class="form-select" required>
                <%
                    ResultSet rsSup = stmt.executeQuery("SELECT * FROM supplier ORDER BY nama_supplier ASC");
                    while(rsSup.next()){
                %>
                <option value="<%=rsSup.getInt("id")%>"><%=rsSup.getString("nama_supplier")%></option>
                <% } %>
            </select>
        </div>

        <!-- Jumlah -->
        <div class="mb-3">
            <label>Jumlah Masuk</label>
            <input type="number" name="jumlah" class="form-control" required>
        </div>

        <!-- Tanggal -->
        <div class="mb-3">
            <label>Tanggal Masuk</label>
            <input type="date" name="tanggal" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-success">Simpan Stok Masuk</button>
    </form>
</div>
</body>
</html>