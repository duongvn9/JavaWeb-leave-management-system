<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="asm.model.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    @SuppressWarnings("unchecked")
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách nhân viên phòng ban</title>
</head>
<body>
<h2>Danh sách nhân viên</h2>
<table border="1" cellpadding="6" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Họ tên</th>
        <th>Email</th>
        <th>Phòng ban</th>
    </tr>
    <c:forEach var="u" items="${users}">
        <tr>
            <td>${u.id}</td>
            <td>${u.fullName}</td>
            <td>${u.email}</td>
            <td>${u.deptId}</td>
        </tr>
    </c:forEach>
</table>

<p><a href="${pageContext.request.contextPath}/app/dashboard">← Dashboard</a></p>
</body>
</html>
