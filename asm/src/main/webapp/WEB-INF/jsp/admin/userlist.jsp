<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List,asm.model.User" %>
<%
    List<User> list = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="vi">
    <head><meta charset="UTF-8"><title>Quản lý User</title></head>
    <body>
        <h2>Danh sách người dùng</h2>
        <a href="${pageContext.request.contextPath}/admin/users/form">+ Thêm user</a><br><br>
        <table border="1" cellpadding="6">
            <tr><th>ID</th><th>Tên</th><th>Email</th><th>Phòng</th><th>Action</th></tr>
                    <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td><td>${u.fullName}</td><td>${u.email}</td><td>${u.deptId}</td>
                    <td><a href="${pageContext.request.contextPath}/admin/users/form?id=${u.id}">Sửa</a></td>
                </tr>
            </c:forEach>
        </table>
        <br>
        <a href="${pageContext.request.contextPath}/app/dashboard">← Dashboard</a>
    </body></html>