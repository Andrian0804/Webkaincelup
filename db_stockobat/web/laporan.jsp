<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String bulan = request.getParameter("bulan");
String tahun = request.getParameter("tahun");

String baseQuery =
    "SELECT b.nama_bahan, SUM(p.jumlah) AS total_pembelian, p.tanggal " +
    "FROM pembelian p JOIN bahan_kimia b ON p.id_bahan=b.id " +
    "WHERE 1=1 ";

List<String> params = new ArrayList<String>();

if (bulan != null && !bulan.trim().isEmpty()) {
    try {
        Integer.parseInt(bulan.trim());
        baseQuery += " AND MONTH(p.tanggal)=? ";
        params.add(bulan.trim());
    } catch (NumberFormatException nf) {}
}
if (tahun != null && !tahun.trim().isEmpty()) {
    try {
        Integer.parseInt(tahun.trim());
        baseQuery += " AND YEAR(p.tanggal)=? ";
        params.add(tahun.trim());
    } catch (NumberFormatException nf) {}
}

baseQuery += " GROUP BY b.nama_bahan, p.tanggal ORDER BY p.tanggal DESC";

PreparedStatement ps = null;
ResultSet rs = null;
try {
    ps = conn.prepareStatement(baseQuery);

    for (int i = 0; i < params.size(); i++) {
        ps.setString(i + 1, params.get(i));
    }

    rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Laporan Stok Bahan Kimia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold text-primary"> 📊 Laporan Stok Bahan Kimia</h4>
        <a href="dashboard.jsp" class="btn btn-secondary btn-sm">← Kembali</a>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form method="get" class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Pilih Bulan</label>
                    <select name="bulan" class="form-select">
                        <option value="">Semua Bulan</option>
                        <% for (int i = 1; i <= 12; i++) { %>
                            <option value="<%=i%>" <%= (bulan != null && bulan.equals(String.valueOf(i))) ? "selected" : "" %>>
                                <%= new java.text.DateFormatSymbols().getMonths()[i-1] %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Pilih Tahun</label>
                    <select name="tahun" class="form-select">
                        <option value="">Semua Tahun</option>
                        <%
                            int[] tahunList = {2024, 2025};
                            for (int t : tahunList) {
                        %>
                            <option value="<%=t%>" <%= (tahun != null && tahun.equals(String.valueOf(t))) ? "selected" : "" %>>
                                <%=t%>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-md-4 text-end">
                    <button type="submit" class="btn btn-primary">Tampilkan</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <h5 class="mb-3">Hasil Laporan</h5>
            <table class="table table-bordered table-striped">
                <thead class="table-primary text-center">
                    <tr>
                        <th>No</th>
                        <th>Nama Bahan</th>
                        <th>Tanggal</th>
                        <th>Total Pembelian</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    int no = 1;
                    boolean adaData = false;
                    while (rs != null && rs.next()) {
                        adaData = true;
                        java.sql.Date tgl = rs.getDate("tanggal");
                    %>
                    <tr>
                        <td class="text-center"><%= no++ %></td>
                        <td><%= rs.getString("nama_bahan") %></td>
                        <td><%= (tgl!=null)? new SimpleDateFormat("dd-MM-yyyy").format(tgl) : "-" %></td>
                        <td class="text-end"><%= rs.getInt("total_pembelian") %></td>
                    </tr>
                    <% }
                    if (!adaData) { %>
                    <tr><td colspan="4" class="text-center text-muted">Tidak ada data untuk periode ini.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%
} catch (SQLException ex) {
    out.println("<div class='container mt-3'><div class='alert alert-danger'>Terjadi error: " + ex.getMessage() + "</div></div>");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
}
%>
</body>
</html>
