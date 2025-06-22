<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List, asm.model.User, asm.model.Department, java.util.Map, java.util.Set" %>
<%
    List<User>        users   = (List<User>)        request.getAttribute("users");
    List<Department>  depts   = (List<Department>)  request.getAttribute("depts");     // null nếu Leader
    Integer selectedDept          = (Integer)           request.getAttribute("selectedDept");
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
        .container { max-width: 1200px; margin: 40px auto; }
        .table-wrapper {
            background: #fff;
            border-radius: 12px;
            box-shadow: none;
            overflow: hidden;
        }
        .table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
        }
        .table thead {
            background: #6C7AE0;
            color: #fff;
        }
        .table thead th {
            background: #6C7AE0 !important;
            color: #fff !important;
            padding: 1rem;
            font-weight: 500;
            text-align: left;
        }
        .table thead th:first-child { border-top-left-radius: 8px; }
        .table thead th:last-child { border-top-right-radius: 8px; }

        .table tbody tr {
            border-bottom: 1px solid #f0f0f0;
        }
        .table tbody tr:last-child {
            border-bottom: none;
        }
        .table tbody td {
            padding: 1rem;
        }
        .table.table-hover tbody tr:hover {
            background: #f0f2ff !important;
            transition: background 0.2s;
        }
        .filter-form { margin-bottom: 1.5rem; }
        .back-link { color: #4285F4; text-decoration: none; margin-top: 1.5rem; display: inline-block; }
        .back-link:hover { text-decoration: none; }
        .dashboard-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: 1.5px solid #6C7AE0;
            border-radius: 8px;
            padding: 0.4rem 1.1rem 0.4rem 0.9rem;
            background: #fff;
            color: #6C7AE0;
            font-weight: 500;
            font-size: 1rem;
            text-decoration: none;
            margin-bottom: 1.5rem;
            margin-top: 1.2rem;
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(108,122,224,0.04);
        }
        .dashboard-link:hover {
            background: #6C7AE0;
            color: #fff;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/app/dashboard" class="dashboard-link">
        <i class="fa-solid fa-house"></i> Dashboard
    </a>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="fa-solid fa-users"></i> Danh sách nhân viên</h2>
        <c:if test="${not empty depts}">
            <form method="get" action="${pageContext.request.contextPath}/app/department/users" class="row g-2 align-items-center">
                <div class="col-auto">
                    <label for="deptId" class="col-form-label"><i class="fa-solid fa-filter"></i> Lọc phòng ban:</label>
                </div>
                <div class="col-auto">
                    <select name="deptId" id="deptId" class="form-select">
                        <option value="" <c:if test="${selectedDept == null}">selected</c:if>>Tất cả</option>
                        <c:forEach var="d" items="${depts}">
                            <option value="${d.id}" <c:if test="${selectedDept != null && selectedDept == d.id}">selected</c:if>>
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
    </div>
    <div class="table-wrapper">
    <table class="table table-hover align-middle">
        <thead>
            <tr><th>STT</th><th>ID</th><th>Họ tên</th><th>Email</th><th>Phòng ban</th></tr>
        </thead>
        <tbody>
        <c:set var="stt" value="1" />
        <c:forEach var="u" items="${users}">
            <c:set var="userRoles" value="${rolesOfUserMap[u.id]}" />
            <c:choose>
                <c:when test="${userRoles != null && userRoles.contains('LEADER')}">
                    <tr class="table-warning" title="Trưởng phòng" data-bs-toggle="tooltip">
                </c:when>
                <c:otherwise>
                    <tr>
                </c:otherwise>
            </c:choose>
                <td>${stt}</td>
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
            <c:set var="stt" value="${stt + 1}" />
        </c:forEach>
        </tbody>
    </table>
    </div>
    <script>
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl);
        });
    </script>
</div>
</body>
</html>
