<%@ include file="db.jsp" %>
<%
if(session.getAttribute("username")==null){
    response.sendRedirect("login.jsp");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Monitoring Stok Obat Kimia</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    body { background: linear-gradient(to right, #e0f7fa, #e8f5e9); font-family: 'Segoe UI', sans-serif; }
    .navbar { background-color: #00796b; }
    .navbar-brand, .nav-link, .logout-btn { color: #ffffff !important; }
    .card { border-radius: 12px; box-shadow: 0 6px 18px rgba(0,0,0,0.12); margin-bottom: 20px;}
    .card h3 { color: #00796b; }
    .table thead { background-color: #00796b; color: white; }
    .low-stock { background-color: #f8d7da !important; }
    .footer { text-align:center; padding:15px 0; background-color:#00796b; color:#fff; margin-top:30px; border-radius:12px 12px 0 0; }
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
<div class="container">
    <a class="navbar-brand fw-bold" href="dashboard.jsp">Sistem Stok Obat Kimia</a>
    <div class="ms-auto">
        <span class="me-3"><i class="bi bi-person-circle"></i> <%=session.getAttribute("username")%></span>
        <a href="logout.jsp" class="btn btn-outline-light logout-btn"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>
</div>
</nav>

<div class="container mt-4">

    <!-- Statistik Kartu -->
    <div class="row g-4 mb-4">
        <%
            Statement stmt = conn.createStatement();

            // Total stok
            ResultSet rsTotal = stmt.executeQuery("SELECT SUM(jumlah) AS total FROM obat");
            int totalObat=0;
            if(rsTotal.next()){ totalObat = rsTotal.getInt("total"); }

            // Obat hampir habis <10
            ResultSet rsHampirHabis = stmt.executeQuery("SELECT COUNT(*) AS habis FROM obat WHERE jumlah - IFNULL(terpakai,0) < 10");
            int hampirHabis=0;
            if(rsHampirHabis.next()){ hampirHabis = rsHampirHabis.getInt("habis"); }

            // Obat tersedia >=10
            ResultSet rsTersedia = stmt.executeQuery("SELECT COUNT(*) AS tersedia FROM obat WHERE jumlah - IFNULL(terpakai,0) >= 10");
            int tersedia=0;
            if(rsTersedia.next()){ tersedia = rsTersedia.getInt("tersedia"); }
        %>
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <i class="bi bi-capsule" style="font-size:40px; color:#00796b;"></i>
                <h3>Total Stok</h3>
                <p class="display-6"><%=totalObat%></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <i class="bi bi-exclamation-triangle" style="font-size:40px; color:#d32f2f;"></i>
                <h3>Hampir Habis</h3>
                <p class="display-6"><%=hampirHabis%></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4 text-center">
                <i class="bi bi-check-circle" style="font-size:40px; color:#388e3c;"></i>
                <h3>Tersedia</h3>
                <p class="display-6"><%=tersedia%></p>
            </div>
        </div>
    </div>

    <!-- Grafik Jumlah Obat per Jenis -->
    <div class="card p-4 mb-4">
        <h3 class="mb-3 text-center"><i class="bi bi-bar-chart-fill"></i> Jumlah Obat per Jenis</h3>
        <canvas id="stokChart"></canvas>
        <%
            ResultSet rsChart = stmt.executeQuery("SELECT jenis, SUM(jumlah - IFNULL(terpakai,0)) AS total FROM obat GROUP BY jenis");
            StringBuilder labels = new StringBuilder();
            StringBuilder data = new StringBuilder();
            while(rsChart.next()){
                labels.append("'").append(rsChart.getString("jenis")).append("',");
                data.append(rsChart.getInt("total")).append(",");
            }
        %>
        <script>
            const ctx = document.getElementById('stokChart').getContext('2d');
            const stokChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: [<%=labels.length()>0 ? labels.substring(0, labels.length()-1) : "" %>],
                    datasets: [{
                        label: 'Jumlah Obat Tersisa',
                        data: [<%=data.length()>0 ? data.substring(0, data.length()-1) : "" %>],
                        backgroundColor: 'rgba(0, 121, 107, 0.7)',
                        borderColor: 'rgba(0, 121, 107, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true } }
                }
            });
        </script>
    </div>

    <!-- Tabel Stok Obat -->
    <div class="card p-4">
        <h3 class="mb-3 text-center"><i class="bi bi-table"></i> Daftar Stok Obat</h3>
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nama Obat</th>
                    <th>Stok Awal</th>
                    <th>Terpakai</th>
                    <th>Stok Tersisa</th>
                    <th>Keterangan</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ResultSet rsList = stmt.executeQuery("SELECT * FROM obat ORDER BY nama_obat ASC");
                    int no=1;
                    while(rsList.next()){
                        int stokAwal = rsList.getInt("jumlah");
                        int terpakai = rsList.getInt("terpakai");
                        if(rsList.wasNull()){ terpakai = 0; }
                        int tersisa = Math.max(stokAwal - terpakai, 0);
                        String lowClass = tersisa < 10 ? "low-stock" : "";
                %>
                <tr class="<%=lowClass%>">
                    <td><%=no++%></td>
                    <td><%=rsList.getString("nama_obat")%></td>
                    <td><%=stokAwal%></td>
                    <td><%=terpakai%></td>
                    <td><%=tersisa%></td>
                    <td><%=rsList.getString("keterangan")%></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</div>

<div class="footer">
    &copy; <%= new java.util.Date().getYear() + 1900 %> - Sistem Stok Obat Kimia
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
