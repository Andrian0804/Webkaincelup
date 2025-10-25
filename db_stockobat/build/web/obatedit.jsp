<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
}

int id = Integer.parseInt(request.getParameter("id"));
PreparedStatement ps = conn.prepareStatement("SELECT * FROM obat WHERE id=?");
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();
rs.next();

if (request.getParameter("btnUpdate") != null) {
    String nama = request.getParameter("nama_obat");
    String jenis = request.getParameter("jenis");
    int jumlah = Integer.parseInt(request.getParameter("jumlah"));
    String ket = request.getParameter("keterangan");

    PreparedStatement psu = conn.prepareStatement("UPDATE obat SET nama_obat=?, jenis=?, jumlah=?, keterangan=? WHERE id=?");
    psu.setString(1, nama);
    psu.setString(2, jenis);
    psu.setInt(3, jumlah);
    psu.setString(4, ket);
    psu.setInt(5, id);
    psu.executeUpdate();

    response.sendRedirect("obatlist.jsp");
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Obat</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #e0f7fa, #ffffff);
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .card {
            background: #ffffffee;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 450px;
            position: relative;
        }

        h2 {
            text-align: center;
            color: #00796b;
            margin-bottom: 30px;
        }

        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 12px 15px;
            margin: 10px 0 20px 0;
            border: 2px solid #00796b;
            border-radius: 10px;
            outline: none;
            transition: 0.3s;
        }

        input[type="text"]:focus, input[type="number"]:focus {
            border-color: #004d40;
            box-shadow: 0 0 8px #004d40;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background: #00796b;
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        input[type="submit"]:hover {
            background: #004d40;
        }

        /* Molecule decoration */
        .molecule {
            position: absolute;
            width: 80px;
            height: 80px;
            background: radial-gradient(circle at 20px 20px, #26a69a, #004d40);
            border-radius: 50%;
            opacity: 0.2;
            transform: rotate(45deg);
        }
        .molecule::before, .molecule::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: radial-gradient(circle at 20px 20px, #26a69a, #004d40);
        }
        .molecule::before { top: 10px; left: 50px; }
        .molecule::after { top: 50px; left: 10px; }
    </style>
</head>
<body>
    <div class="card">
        <div class="molecule"></div>
        <h2>Edit Data Obat</h2>
        <form method="post">
            <input type="text" name="nama_obat" placeholder="Nama Obat" value="<%= rs.getString("nama_obat") %>" required>
            <input type="text" name="jenis" placeholder="Jenis Obat" value="<%= rs.getString("jenis") %>" required>
            <input type="number" name="jumlah" placeholder="Jumlah" value="<%= rs.getInt("jumlah") %>" required>
            <input type="text" name="keterangan" placeholder="Keterangan" value="<%= rs.getString("keterangan") %>">
            <input type="submit" name="btnUpdate" value="Update">
        </form>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
