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
        .action-btn { margin-right: 0.5rem; }
        .back-link { color: #4285F4; text-decoration: none; margin-top: 1.5rem; display: inline-block; }
        .back-link:hover { text-decoration: none; }
        .filter-form { margin-bottom: 1.5rem; }
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
    <script>
        function submitOnChange() {
            document.getElementById('filterForm').submit();
        }
    </script>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/app/dashboard" class="dashboard-link">
        <i class="fa-solid fa-house"></i> Dashboard
    </a>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="fa-solid fa-inbox"></i> Duyệt đơn nghỉ phép</h2>
        <form method="get" action="${pageContext.request.contextPath}/app/leave/reviewlist" class="row g-2 align-items-center">
            <div class="col-auto">
                <label for="status" class="col-form-label"><i class="fa-solid fa-filter"></i> Trạng thái:</label>
            </div>
            <div class="col-auto">
                <select name="status" id="status" class="form-select">
                    <option value="" <c:if test="${empty param.status}">selected</c:if>>Tất cả</option>
                    <option value="INPROGRESS" <c:if test="${param.status == 'INPROGRESS'}">selected</c:if>>Chờ duyệt</option>
                    <option value="APPROVED" <c:if test="${param.status == 'APPROVED'}">selected</c:if>>Đã duyệt</option>
                    <option value="REJECTED" <c:if test="${param.status == 'REJECTED'}">selected</c:if>>Từ chối</option>
                    <option value="CANCELLED" <c:if test="${param.status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                </select>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
            </div>
        </form>
    </div>
    <div class="table-wrapper">
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
                        <c:when test="${r.status eq 'CANCELLED'}">
                            <span class="badge bg-warning text-dark">Đã hủy</span>
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
        </c:forEach>
        </tbody>
    </table>
    </div>
</div>
</body>
</html>
