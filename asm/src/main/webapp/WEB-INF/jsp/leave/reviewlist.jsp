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
    <title>Duyệt đơn nghỉ phép</title>
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
        .filter-form { margin-bottom: 1.5rem; }
    </style>
    <script>
        function submitOnChange() {
            document.getElementById('filterForm').submit();
        }
    </script>
</head>
<body>
<div class="container">
    <h2 class="mb-4"><i class="fa-solid fa-clipboard-check"></i> Danh sách đơn nghỉ phép của nhân viên</h2>
    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/app/leave/reviewlist" class="row g-2 align-items-center filter-form">
        <div class="col-auto">
            <label for="status" class="col-form-label"><i class="fa-solid fa-filter"></i> Lọc trạng thái:</label>
        </div>
        <div class="col-auto">
            <select name="status" id="status" class="form-select" onchange="submitOnChange()">
                <option value="ALL" ${param.status == null || param.status == 'ALL' ? 'selected' : ''}>Tất cả</option>
                <option value="INPROGRESS" ${param.status == 'INPROGRESS' ? 'selected' : ''}>Chưa duyệt</option>
                <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Bị từ chối</option>
            </select>
        </div>
    </form>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>STT</th>
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
        <c:set var="stt" value="1" />
        <c:forEach var="r" items="${requests}">
            <c:if test="${param.status == null || param.status == 'ALL' || r.status == param.status}">
                <tr>
                    <td>${stt}</td>
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
                            <a href="${pageContext.request.contextPath}/app/leave/review?id=${r.id}" class="btn btn-sm btn-primary action-btn"><i class="fa-solid fa-eye"></i> Xem &amp; Duyệt</a>
                        </c:if>
                    </td>
                </tr>
                <c:set var="stt" value="${stt + 1}" />
            </c:if>
        </c:forEach>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/app/dashboard" class="back-link"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
</div>
</body>
</html>
