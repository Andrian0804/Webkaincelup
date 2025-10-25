<%@ page import="java.sql.*" %>

<%
    // --- Koneksi ke database ---
    String url = "jdbc:mysql://localhost:3306/db_stockobat";
    String user = "root";
    String pass = "";
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(url, user, pass);

    // --- Proses tambah data ---
    if(request.getParameter("btnTambah") != null){
        String nama = request.getParameter("nama_obat");
        String jenis = request.getParameter("jenis");
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String ket = request.getParameter("keterangan");

        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO obat(nama_obat,jenis,jumlah,keterangan) VALUES(?,?,?,?)"
        );
        ps.setString(1, nama);
        ps.setString(2, jenis);
        ps.setInt(3, jumlah);
        ps.setString(4, ket);
        ps.executeUpdate();

        response.sendRedirect("obatlist.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Tambah Obat</title>
    <style>
        /* Reset dan font */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body {
            background: linear-gradient(135deg, #e0f7fa, #ffffff);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Card utama */
        .card {
            background: #ffffffee;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 400px;
            position: relative;
        }

        /* Header */
        .card h2 {
            text-align: center;
            color: #00796b;
            margin-bottom: 30px;
            font-size: 28px;
        }

        /* Input fields */
        .card input[type="text"],
        .card input[type="number"] {
            width: 100%;
            padding: 12px 15px;
            margin: 10px 0 20px 0;
            border: 2px solid #00796b;
            border-radius: 10px;
            outline: none;
            transition: 0.3s;
        }

        .card input[type="text"]:focus,
        .card input[type="number"]:focus {
            border-color: #004d40;
            box-shadow: 0 0 8px #004d40;
        }

        /* Button */
        .card input[type="submit"] {
            width: 100%;
            padding: 12px;
            background: #00796b;
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        .card input[type="submit"]:hover {
            background: #004d40;
        }

        /* Ilustrasi kimia (molekul) */
        .molecule {
            position: absolute;
            top: -40px;
            right: -40px;
            width: 80px;
            height: 80px;
            background: radial-gradient(circle at 20px 20px, #26a69a, #004d40);
            border-radius: 50%;
            opacity: 0.3;
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
        <h2>Tambah Obat</h2>
        <form method="post">
            <input type="text" name="nama_obat" placeholder="Nama Obat" required>
            <input type="text" name="jenis" placeholder="Jenis Obat" required>
            <input type="number" name="jumlah" placeholder="Jumlah" required>
            <input type="text" name="keterangan" placeholder="Keterangan">
            <input type="submit" name="btnTambah" value="Simpan">
        </form>
    </div>
</body>
</html>
