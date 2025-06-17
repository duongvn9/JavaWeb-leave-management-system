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

            <!-- Leader / Admin: xem nhân viên phòng ban -->
            <c:if test="${roles != null && (roles.contains('LEADER') || roles.contains('ADMIN'))}">
                <li><a href="<%= request.getContextPath() %>/app/department/users">Danh sách nhân viên phòng ban</a></li>
                <li><a href="<%= request.getContextPath() %>/app/leave/reviewlist">Duyệt đơn nhân viên</a></li>
                </c:if>

            <!-- Admin: quản lý user toàn công ty -->
            <c:if test="${roles != null && roles.contains('ADMIN')}">
                <li><a href="<%= request.getContextPath() %>/admin/users">Quản lý người dùng (thêm/sửa/xoá)</a></li>
                </c:if>

            <li><a href="<%= request.getContextPath() %>/logout">Đăng xuất</a></li>
        </ul>
    </body>
</html>
