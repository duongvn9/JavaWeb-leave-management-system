<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="asm.model.LeaveRequest" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    @SuppressWarnings("unchecked")
    List<LeaveRequest> requests = (List<LeaveRequest>) request.getAttribute("requests");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn nghỉ phép của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .container { max-width: 1000px; margin: 40px auto; }
        .table thead { background: #4285F4; color: #fff; }
        .table tbody tr:hover { background: #e3f0fd; }
        .action-btn { margin-right: 0.5rem; }
        .back-link { color: #4285F4; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4"><i class="fa-solid fa-list"></i> Danh sách đơn nghỉ phép của tôi</h2>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nhân viên</th>
                <th>Từ ngày</th>
                <th>Đến ngày</th>
                <th>Lý do</th>
                <th>Trạng thái</th>
                <th>Đã sửa?</th>
                <th>Ngày tạo</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${requests}">
            <tr>
                <td>${r.id}</td>
                <td>${r.employeeName} (ID: ${r.employeeId})</td>
                <td>${r.fromDate}</td>
                <td>${r.toDate}</td>
                <td>${r.reason}</td>
                <td>
                    <c:choose>
                        <c:when test="${r.status eq 'INPROGRESS'}">
                            <span class="badge bg-primary">Chờ duyệt</span>
                        </c:when>
                        <c:when test="${r.status eq 'APPROVED'}">
                            <span class="badge bg-success">Đã duyệt</span>
                        </c:when>
                        <c:when test="${r.status eq 'REJECTED'}">
                            <span class="badge bg-danger">Bị từ chối</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">${r.status}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:if test="${r.edited}">
                        <i class="fa-solid fa-check text-success"></i>
                    </c:if>
                </td>
                <td>${r.createdAt}</td>
                <td>
                    <c:if test="${r.status eq 'INPROGRESS'}">
                        <a href="${pageContext.request.contextPath}/app/leave/edit?id=${r.id}" class="btn btn-sm btn-primary action-btn"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                        <form method="post" action="${pageContext.request.contextPath}/app/leave/cancel" style="display:inline" onsubmit="return confirm('Xác nhận huỷ?');">
                            <input type="hidden" name="id" value="${r.id}" />
                            <button type="submit" class="btn btn-sm btn-danger action-btn"><i class="fa-solid fa-ban"></i> Huỷ</button>
                        </form>
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
