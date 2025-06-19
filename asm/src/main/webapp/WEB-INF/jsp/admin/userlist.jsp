<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List,asm.model.User,asm.model.Department" %>
<%@ page import="java.util.Map,java.util.Set" %>
<%
    List<User> list = (List<User>) request.getAttribute("users");
    List<Department> depts = (List<Department>) request.getAttribute("depts");
    Map<Integer, Set<String>> rolesOfUserMap = (Map<Integer, Set<String>>) request.getAttribute("rolesOfUserMap");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .container { max-width: 900px; margin: 40px auto; }
        .table thead { background: #4285F4; color: #fff; }
        .table tbody tr:hover { background: #e3f0fd; }
        .btn-add { background: #28a745; color: #fff; border-radius: 8px; }
        .btn-add:hover { background: #218838; }
        .action-btn { margin-right: 0.5rem; }
        .back-link { color: #4285F4; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4"><i class="fa-solid fa-users"></i> Danh sách người dùng</h2>
    <a href="${pageContext.request.contextPath}/admin/users/form" class="btn btn-add mb-3"><i class="fa-solid fa-user-plus"></i> Thêm user</a>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th><th>Tên</th><th>Email</th><th>Phòng</th><th>Active</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <c:set var="userRoles" value="${rolesOfUserMap[u.id]}" />
            <tr <c:if test="${userRoles != null && userRoles.contains('LEADER')}">class='table-warning'</c:if>>
                <td>${u.id}</td>
                <td>${u.fullName}</td>
                <td>${u.email}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.deptId == null}">-</c:when>
                        <c:otherwise>
                            <c:forEach var="d" items="${depts}">
                                <c:if test="${d.id == u.deptId}">${d.name}</c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${u.active ? '<i class="fa-solid fa-check text-success"></i>' : ''}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/users/form?id=${u.id}" class="btn btn-sm btn-primary action-btn"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                    <c:if test="${u.active}">
                        <a href="${pageContext.request.contextPath}/admin/users/delete?id=${u.id}" class="btn btn-sm btn-danger action-btn" onclick="return confirm('Xác nhận xoá user này?');"><i class="fa-solid fa-trash"></i> Xoá</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/app/dashboard" class="back-link"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
</div>
</body>
</html>
