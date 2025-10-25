<%@ include file="db.jsp" %>
<div class="container mt-4">
<h2>Daftar Supplier</h2>
<a href="supplier_tambah.jsp" class="btn btn-primary mb-3">Tambah Supplier</a>
<table class="table table-striped">
<thead>
<tr>
<th>#</th><th>Nama Supplier</th><th>Kontak</th>
</tr>
</thead>
<tbody>
<%
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM supplier");
int no=1;
while(rs.next()){
%>
<tr>
<td><%=no++%></td>
<td><%=rs.getString("nama_supplier")%></td>
<td><%=rs.getString("kontak")%></td>
</tr>
<% } %>
</tbody>
</table>
</div>