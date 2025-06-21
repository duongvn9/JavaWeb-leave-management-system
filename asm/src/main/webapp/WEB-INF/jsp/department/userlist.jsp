<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List, asm.model.User, asm.model.Department, java.util.Map, java.util.Set" %>
<%
    List<User>        users   = (List<User>)        request.getAttribute("users");
    List<Department>  depts   = (List<Department>)  request.getAttribute("depts");     // null nếu Leader
    Integer selected          = (Integer)           request.getAttribute("selectedDept");
    Map<Integer, Set<String>> rolesOfUserMap = (Map<Integer, Set<String>>) request.getAttribute("rolesOfUserMap");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .container { max-width: 900px; margin: 40px auto; }
        .table thead { background: #4285F4; color: #fff; }
        .table tbody tr:hover { background: #e3f0fd; }
        .filter-form { margin-bottom: 1.5rem; }
        .back-link { color: #4285F4; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4"><i class="fa-solid fa-users"></i> Danh sách nhân viên</h2>
    <c:if test="${not empty depts}">
        <form method="get" action="${pageContext.request.contextPath}/app/department/users" class="row g-2 align-items-center filter-form">
            <div class="col-auto">
                <label for="deptId" class="col-form-label"><i class="fa-solid fa-filter"></i> Lọc phòng ban:</label>
            </div>
            <div class="col-auto">
                <select name="deptId" id="deptId" class="form-select">
                    <option value="" <c:if test="${selected == null}">selected</c:if>>Tất cả</option>
                    <c:forEach var="d" items="${depts}">
                        <option value="${d.id}" <c:if test="${selected != null && selected == d.id}">selected</c:if>>
                            ${d.name}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
            </div>
        </form>
    </c:if>
    <table class="table table-hover align-middle">
        <thead>
            <tr><th>ID</th><th>Họ tên</th><th>Email</th><th>Phòng ban</th></tr>
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
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/app/dashboard" class="back-link"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
</div>
</body>
</html>
