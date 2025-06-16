<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.User" %>
<%
    User u = (User) request.getAttribute("user");
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
        <li><a href="<%= request.getContextPath() %>/logout">Đăng xuất</a></li>
    </ul>
</body>
</html>
