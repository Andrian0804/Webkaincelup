<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}

Statement st = conn.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM obat");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daftar Obat Kimia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        /* Background cantik ala laboratorium */
        body {
            background: linear-gradient(135deg, #e0f7fa, #ffffff);
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Molekul transparan sebagai dekorasi */
        .molecule-bg {
            position: absolute;
            width: 120px;
            height: 120px;
            background: radial-gradient(circle at 30px 30px, #26a69a, #004d40);
            border-radius: 50%;
            opacity: 0.1;
            animation: float 10s infinite alternate;
        }
        .molecule-bg:nth-child(1) { top: 50px; left: 30px; }
        .molecule-bg:nth-child(2) { top: 200px; right: 50px; }
        .molecule-bg:nth-child(3) { bottom: 100px; left: 150px; }

        @keyframes float {
            0% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(20deg); }
            100% { transform: translateY(0) rotate(0deg); }
        }

        .container {
            margin-top: 50px;
            position: relative;
            z-index: 2; /* agar di atas molekul */
        }
        h2 {
            color: #00796b;
            text-align: center;
            margin-bottom: 30px;
        }
        .card-table {
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 25px;
            background: #ffffffee;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }
        th {
            background-color: #00796b;
            color: white;
            padding: 12px;
            border-radius: 10px 10px 0 0;
        }
        td {
            background: #f1fdfd;
            padding: 12px;
            border-radius: 10px;
        }
        tr:hover td {
            background: #e0f7fa;
        }
        a.btn-custom {
            border-radius: 12px;
            padding: 5px 12px;
            text-decoration: none;
            color: white;
            transition: 0.3s;
        }
        a.edit-btn { background-color: #0288d1; }
        a.edit-btn:hover { background-color: #01579b; }
        a.delete-btn { background-color: #d32f2f; }
        a.delete-btn:hover { background-color: #b71c1c; }
        .top-links {
            margin-bottom: 20px;
        }
        .top-links a {
            margin-right: 10px;
        }
    </style>
</head>
<body>

<!-- Molekul dekoratif -->
<div class="molecule-bg"></div>
<div class="molecule-bg"></div>
<div class="molecule-bg"></div>

<div class="container">
    <h2>Daftar Obat Kimia</h2>
    <div class="top-links">
        <a href="dashboard.jsp" class="btn btn-secondary btn-custom"><i class="bi bi-house-door"></i> Dashboard</a>
        <a href="obattambah.jsp" class="btn btn-primary btn-custom"><i class="bi bi-plus-circle"></i> Tambah Obat</a>
    </div>

    <div class="card-table">
        <table class="table table-borderless">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama Obat</th>
                    <th>Jenis</th>
                    <th>Jumlah</th>
                    <th>Keterangan</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
            <%
            while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nama_obat") %></td>
                    <td><%= rs.getString("jenis") %></td>
                    <td><%= rs.getInt("jumlah") %></td>
                    <td><%= rs.getString("keterangan") %></td>
                    <td>
                        <a href="obatedit.jsp?id=<%= rs.getInt("id") %>" class="btn-custom edit-btn"><i class="bi bi-pencil-square"></i> Edit</a>
                        <a href="obathapus.jsp?id=<%= rs.getInt("id") %>" class="btn-custom delete-btn"><i class="bi bi-trash"></i> Hapus</a>
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
