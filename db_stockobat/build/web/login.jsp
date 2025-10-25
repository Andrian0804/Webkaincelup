<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (request.getParameter("login") != null) {
    String user = request.getParameter("username");
    String pass = request.getParameter("password");

    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM user WHERE username=? AND password=?");
    ps.setString(1, user);
    ps.setString(2, pass);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        session.setAttribute("username", user);
        session.setAttribute("role", rs.getString("role"));
        response.sendRedirect("dashboard.jsp");
    } else {
        out.println("<script>alert('Login gagal! Username atau password salah');</script>");
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Sistem Stok Obat Kimia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #007bff, #6610f2);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-card {
            background-color: #fff;
            border-radius: 20px;
            box-shadow: 0px 8px 30px rgba(0, 0, 0, 0.1);
            width: 380px;
            padding: 40px 35px;
            animation: fadeInUp 0.8s ease;
        }

        .login-card h3 {
            text-align: center;
            color: #343a40;
            margin-bottom: 25px;
            font-weight: bold;
        }

        .form-control {
            height: 45px;
            border-radius: 10px;
        }

        .btn-primary {
            background: linear-gradient(90deg, #007bff, #6610f2);
            border: none;
            height: 45px;
            border-radius: 10px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-primary:hover {
            background: linear-gradient(90deg, #6610f2, #007bff);
            transform: translateY(-2px);
        }

        .footer-text {
            text-align: center;
            font-size: 13px;
            color: #888;
            margin-top: 20px;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="login-card">
        <h3>Login Sistem Stok</h3>
        <form method="post">
            <div class="mb-3">
                <input class="form-control" type="text" name="username" placeholder="Username" required>
            </div>
            <div class="mb-3">
                <input class="form-control" type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" name="login" class="btn btn-primary w-100">Masuk</button>
        </form>

        <div class="footer-text">
            © 2025 Sistem Stok Obat Kimia Kain Celup
        </div>
    </div>

</body>
</html>
