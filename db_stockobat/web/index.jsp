<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Jika user sudah login, langsung ke dashboard
    if (session.getAttribute("username") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%
if(request.getParameter("btnLogin") != null){
    String user = request.getParameter("username");
    String pass = request.getParameter("password");
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE username='"+user+"' AND password='"+pass+"'");
    if(rs.next()){
        session.setAttribute("username", user);
        response.sendRedirect("dashboard.jsp");
    } else {
        out.println("<script>alert('Login gagal! Username atau password salah');</script>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Stok Obat Kimia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f4f8;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .login-container h2 {
            color: #0d6efd;
            margin-bottom: 25px;
            text-align: center;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
        .btn-login {
            background-color: #0d6efd;
            border: none;
        }
        .btn-login:hover {
            background-color: #084298;
        }
        .footer-text {
            text-align: center;
            margin-top: 20px;
            color: #6c757d;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login Stok Obat</h2>
        <form method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" name="username" placeholder="Masukkan username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" name="password" placeholder="Masukkan password" required>
            </div>
            <div class="d-grid">
                <input type="submit" class="btn btn-login btn-lg" name="btnLogin" value="Login">
            </div>
        </form>
        <div class="footer-text">
            &copy; <%= new java.util.Date().getYear() + 1900 %> - Sistem Stok Obat Kimia
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>