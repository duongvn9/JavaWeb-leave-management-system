<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    User u = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    java.util.Set<String> roles = (java.util.Set<String>) session.getAttribute("roles");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>
    <h1>Xin chào, <%= u.getFullName() %>!</h1>
    <p>Email: <%= u.getEmail() %></p>

    <ul>
        <li><a href="<%= request.getContextPath() %>/app/leave/create">Tạo đơn nghỉ phép</a></li>
        <li><a href="<%= request.getContextPath() %>/app/leave/list">Danh sách đơn của tôi</a></li>
        <c:if test="${roles != null && (roles.contains('LEADER') || roles.contains('ADMIN'))}">
            <li><a href="<%= request.getContextPath() %>/app/leave/reviewlist">Duyệt đơn nhân viên</a></li>
        </c:if>
        <c:if test="${roles != null && roles.contains('ADMIN')}">
            <li><a href="<%= request.getContextPath() %>/admin/users">Quản lý user</a> (chưa làm)</li>
        </c:if>
        <li><a href="<%= request.getContextPath() %>/logout">Đăng xuất</a></li>
    </ul>
</body>
</html>
