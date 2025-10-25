<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
if (session.getAttribute("username") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String role = (String) session.getAttribute("role");
if (!"admin".equals(role)) {
    response.sendRedirect("dashboard.jsp");
    return;
}

// Hapus user jika ada parameter delete
if (request.getParameter("delete") != null) {
    int id = Integer.parseInt(request.getParameter("delete"));
    PreparedStatement ps = conn.prepareStatement("DELETE FROM user WHERE id=?");
    ps.setInt(1, id);
    ps.executeUpdate();
    response.sendRedirect("userlist.jsp");
}

// Tambah user baru
if (request.getParameter("tambah") != null) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String roleBaru = request.getParameter("role");

    PreparedStatement ps = conn.prepareStatement("INSERT INTO user (username, password, role) VALUES (?, ?, ?)");
    ps.setString(1, username);
    ps.setString(2, password);
    ps.setString(3, roleBaru);
    ps.executeUpdate();
    response.sendRedirect("userlist.jsp");
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manajemen User</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<style>
    body {
        background-color: #f8fafc;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .container {
        margin-top: 50px;
        max-width: 900px;
    }

    .card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }

    .table {
        background-color: #fff;
        border-radius: 10px;
        overflow: hidden;
    }

    .btn {
        border-radius: 8px;
    }

    .form-inline input, .form-inline select {
        margin-bottom: 10px;
    }
</style>
</head>
<body>

<div class="container">
    <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="mb-0"><i class="bi bi-people"></i> Manajemen User</h4>
            <a href="dashboard.jsp" class="btn btn-secondary btn-sm"><i class="bi bi-arrow-left"></i> Kembali</a>
        </div>

        <form method="post" class="border rounded p-3 bg-light mb-4">
            <div class="row g-2">
                <div class="col-md-4">
                    <input type="text" name="username" class="form-control" placeholder="Username" required>
                </div>
                <div class="col-md-4">
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>
                <div class="col-md-3">
                    <select name="role" class="form-select" required>
                        <option value="">Pilih Role</option>
                        <option value="admin">Admin</option>
                        <option value="supervisor">Supervisor</option>
                    </select>
                </div>
                <div class="col-md-1">
                    <button type="submit" name="tambah" class="btn btn-primary w-100"><i class="bi bi-plus-lg"></i></button>
                </div>
            </div>
        </form>

        <table class="table table-striped table-hover text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
            <%
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM user ORDER BY id ASC");
                while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("role") %></td>
                    <td>
                        <% if (!rs.getString("username").equals(session.getAttribute("username"))) { %>
                        <a href="userlist.jsp?delete=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Yakin hapus user ini?')">
                            <i class="bi bi-trash"></i> Hapus
                        </a>
                        <% } else { %>
                        <span class="text-muted">Tidak bisa hapus diri sendiri</span>
                        <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
