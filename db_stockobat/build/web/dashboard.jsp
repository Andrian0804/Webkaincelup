<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

int totalBahan = 0, totalSupplier = 0, totalPembelian = 0;
String bahanLabels = "";
String bahanValues = "";

try {
    // Total data
    PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM bahan_kimia");
    ResultSet rs1 = ps1.executeQuery();
    if (rs1.next()) totalBahan = rs1.getInt(1);
    rs1.close(); ps1.close();

    PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM supplier");
    ResultSet rs2 = ps2.executeQuery();
    if (rs2.next()) totalSupplier = rs2.getInt(1);
    rs2.close(); ps2.close();

    PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM pembelian");
    ResultSet rs3 = ps3.executeQuery();
    if (rs3.next()) totalPembelian = rs3.getInt(1);
    rs3.close(); ps3.close();

    // Data untuk grafik stok bahan kimia
    PreparedStatement ps4 = conn.prepareStatement("SELECT nama_bahan, stok FROM bahan_kimia LIMIT 6");
    ResultSet rs4 = ps4.executeQuery();
    StringBuilder labels = new StringBuilder();
    StringBuilder values = new StringBuilder();
    while (rs4.next()) {
        labels.append("'").append(rs4.getString("nama_bahan")).append("',");
        values.append(rs4.getInt("stok")).append(",");
    }
    rs4.close(); ps4.close();

    if (labels.length() > 0) {
        bahanLabels = labels.substring(0, labels.length() - 1);
        bahanValues = values.substring(0, values.length() - 1);
    }

} catch (SQLException e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Dashboard - Sistem Stok Obat </title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    background-color: #f8fafc;
    font-family: 'Segoe UI', sans-serif;
    margin: 0;
    overflow-x: hidden;
}
.sidebar {
    width: 230px;
    height: 100vh;
    position: fixed;
    background: linear-gradient(180deg, #0d6efd, #0047ab);
    color: white;
    padding-top: 30px;
}
.sidebar h4 {
    font-weight: 700;
    text-align: center;
    margin-bottom: 40px;
}
.sidebar a {
    color: white;
    display: block;
    padding: 10px 20px;
    margin: 6px 10px;
    border-radius: 8px;
    text-decoration: none;
}
.sidebar a:hover, .sidebar a.active {
    background-color: rgba(255,255,255,0.2);
}
.main-content {
    margin-left: 250px;
    padding: 30px;
}
.card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    transition: transform 0.2s ease;
}
.card:hover { transform: scale(1.02); }
.chart-container {
    background: #fff;
    border-radius: 15px;
    padding: 20px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
}
footer {
    margin-top: 40px;
    text-align: center;
    color: #6c757d;
}
</style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4><i class="bi bi-capsule"></i> Stok Obat kain celup</h4>
    <a href="dashboard.jsp" class="active"><i class="bi bi-house-door"></i> Dashboard</a>
    <a href="bahanlist.jsp"><i class="bi bi-beaker"></i> Data Bahan</a>
    <a href="supplierlist.jsp"><i class="bi bi-truck"></i> Supplier</a>
    <a href="pembelianlist.jsp"><i class="bi bi-cart"></i> Pembelian</a>
    <a href="laporan.jsp"><i class="bi bi-bar-chart"></i> Laporan</a>
    <a href="notifstok.jsp"><i class="bi bi-bell"></i> Notifikasi</a>
    <a href="riwayatstok.jsp"><i class="bi bi-clock-history"></i> Riwayat</a>
    <% if ("admin".equals(role)) { %>
        <a href="userlist.jsp"><i class="bi bi-people"></i> Manajemen User</a>
    <% } %>
    <hr style="border-color: rgba(255,255,255,0.3);">
    <a href="logout.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- Main -->
<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold text-primary mb-0">Dashboard</h3>
            <small>Selamat datang, <strong><%= username %></strong> (Role: <%= role %>)</small>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <i class="bi bi-beaker text-primary" style="font-size:40px;"></i>
                <h5 class="mt-3">Total Bahan</h5>
                <h3 class="fw-bold"><%= totalBahan %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <i class="bi bi-truck text-success" style="font-size:40px;"></i>
                <h5 class="mt-3">Total Supplier</h5>
                <h3 class="fw-bold"><%= totalSupplier %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <i class="bi bi-cart text-warning" style="font-size:40px;"></i>
                <h5 class="mt-3">Total Pembelian</h5>
                <h3 class="fw-bold"><%= totalPembelian %></h3>
            </div>
        </div>
    </div>

    <!-- Grafik Stok -->
    <div class="chart-container mb-5">
        <h5 class="fw-bold mb-3"><i class="bi bi-bar-chart-line"></i> Grafik Stok Bahan Kimia</h5>
        <canvas id="stokChart" height="110"></canvas>
    </div>

    <!-- Aktivitas Terakhir -->
    <div class="card p-4">
        <h5 class="fw-bold mb-3"><i class="bi bi-clock-history"></i> Aktivitas Terakhir</h5>
        <table class="table table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>Tanggal</th>
                    <th>Aksi</th>
                    <th>Bahan</th>
                    <th>Jumlah</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        PreparedStatement psAct = conn.prepareStatement(
                            "SELECT r.tanggal, r.aksi, b.nama_bahan, r.jumlah FROM riwayat_stok r JOIN bahan_kimia b ON r.id_bahan=b.id ORDER BY r.tanggal DESC LIMIT 5");
                        ResultSet rsAct = psAct.executeQuery();
                        while (rsAct.next()) {
                %>
                    <tr>
                        <td><%= rsAct.getTimestamp("tanggal") %></td>
                        <td><%= rsAct.getString("aksi") %></td>
                        <td><%= rsAct.getString("nama_bahan") %></td>
                        <td><%= rsAct.getInt("jumlah") %></td>
                    </tr>
                <%
                        }
                        rsAct.close();
                        psAct.close();
                    } catch (SQLException e) {
                %>
                    <tr><td colspan="4" class="text-center text-muted">Tidak ada data</td></tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</div>

<!-- Chart.js -->
<script>
const ctx = document.getElementById('stokChart');
new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [<%= bahanLabels %>],
        datasets: [{
            label: 'Jumlah Stok',
            data: [<%= bahanValues %>],
            backgroundColor: 'rgba(13, 110, 253, 0.6)',
            borderColor: '#0d6efd',
            borderWidth: 1,
            borderRadius: 8
        }]
    },
    options: {
        scales: { y: { beginAtZero: true } }
    }
});
</script>

</body>
</html>
