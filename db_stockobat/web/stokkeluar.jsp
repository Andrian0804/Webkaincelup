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
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String tanggal = request.getParameter("tanggal");
        String keterangan = request.getParameter("keterangan");

        // Cek stok tersisa
        Statement checkStmt = conn.createStatement();
        ResultSet rsCheck = checkStmt.executeQuery("SELECT jumlah, terpakai FROM obat WHERE id="+obat_id);
        if(rsCheck.next()){
            int stokTersisa = rsCheck.getInt("jumlah") - rsCheck.getInt("terpakai");
            if(jumlah > stokTersisa){
                out.println("<div class='alert alert-danger'>Jumlah melebihi stok tersisa ("+stokTersisa+")!</div>");
            } else {
                // Update terpakai
                Statement stmt = conn.createStatement();
                stmt.executeUpdate("UPDATE obat SET terpakai = terpakai + "+jumlah+" WHERE id = "+obat_id);

                // Insert ke stok_keluar
                stmt.executeUpdate("INSERT INTO stok_keluar(obat_id,jumlah,tanggal,keterangan) VALUES("
                    +obat_id+","+jumlah+",'"+tanggal+"','"+keterangan+"')");

                out.println("<div class='alert alert-success'>Stok keluar berhasil dicatat!</div>");
            }
        }
    }catch(Exception e){
        out.println("<div class='alert alert-danger'>Error: "+e.getMessage()+"</div>");
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stok Keluar Obat</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Stok Keluar Obat</h2>
    <form method="post">
        <!-- Pilih Obat -->
        <div class="mb-3">
            <label>Obat</label>
            <select name="obat_id" class="form-select" required>
                <%
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM obat ORDER BY nama_obat ASC");
                    while(rs.next()){
                        int tersisa = rs.getInt("jumlah") - rs.getInt("terpakai");
                %>
                <option value="<%=rs.getInt("id")%>"><%=rs.getString("nama_obat")+" (Tersisa: "+tersisa+")" %></option>
                <% } %>
            </select>
        </div>

        <!-- Jumlah Keluar -->
        <div class="mb-3">
            <label>Jumlah Keluar</label>
            <input type="number" name="jumlah" class="form-control" required>
        </div>

        <!-- Tanggal -->
        <div class="mb-3">
            <label>Tanggal Keluar</label>
            <input type="date" name="tanggal" class="form-control" required>
        </div>

        <!-- Keterangan -->
        <div class="mb-3">
            <label>Keterangan</label>
            <input type="text" name="keterangan" class="form-control" placeholder="Misal: untuk Perusahaan indaxtex">
        </div>

        <button type="submit" class="btn btn-warning">Simpan Stok Keluar</button>
    </form>
</div>
</body>
</html>