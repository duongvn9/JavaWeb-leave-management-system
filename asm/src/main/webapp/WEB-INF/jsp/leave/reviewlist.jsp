<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="asm.model.LeaveRequest" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
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
        .container { max-width: 95vw; width: 95vw; margin: 0 auto; padding: 0; }
        .table-wrapper { width: 95vw; max-width: 95vw; margin: 0 auto; padding: 0; }
        .table { width: 95vw; min-width: 95vw; }
        .table thead {
            background: #6C7AE0;
            color: #fff;
        }
        .table thead th {
            background: #6C7AE0 !important;
            color: #fff !important;
            padding: 0.75rem;
            font-weight: 500;
            text-align: center;
            border-right: 1px solid #dee2e6;
            border-bottom: 1px solid #dee2e6;
        }
        .table thead th:first-child { border-top-left-radius: 8px; }
        .table thead th:last-child { border-top-right-radius: 8px; border-right: none; }
        .table thead th, .table tbody td {
            white-space: nowrap;
            border-right: 1px solid #dee2e6;
            border-bottom: 1px solid #dee2e6;
            text-align: center;
        }
        .table thead th:last-child, .table tbody td:last-child {
            border-right: none;
        }
        @media (max-width: 900px) {
            .table { min-width: 600px; }
        }
        @media (max-width: 600px) {
            .table { min-width: 400px; font-size: 0.95rem; }
            .table thead th, .table tbody td { padding: 0.5rem; }
        }
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
        document.addEventListener('DOMContentLoaded', function() {
            // Xử lý rút gọn lý do
            document.querySelectorAll('td .reason-cell').forEach(function(cell) {
                var btn = cell.parentElement.querySelector('.reason-toggle');
                if (btn) {
                    btn.addEventListener('click', function() {
                        if (cell.style.whiteSpace === 'nowrap') {
                            cell.style.whiteSpace = 'normal';
                            cell.style.overflow = 'visible';
                            cell.style.textOverflow = 'unset';
                            btn.textContent = 'Ẩn bớt';
                        } else {
                            cell.style.whiteSpace = 'nowrap';
                            cell.style.overflow = 'hidden';
                            cell.style.textOverflow = 'ellipsis';
                            btn.textContent = 'Xem thêm';
                        }
                    });
                }
            });
        });
    </script>
</head>
<body>
<div class="container">
    <div class="d-flex justify-content-end align-items-center mb-4" style="gap:1rem;">
        <form method="get" class="d-flex align-items-center" style="gap:0.5rem; background:#e3f0ff; border:2px solid #4285F4; border-radius:8px; padding:0.5rem 1rem; box-shadow:0 2px 8px rgba(66,133,244,0.08);">
            <label for="status" class="form-label mb-0" style="font-weight:600; color:#4285F4;"><i class="fa-solid fa-filter"></i> Trạng thái:</label>
            <select name="status" id="status" class="form-select" style="min-width:120px; border:1.5px solid #4285F4; font-weight:600; color:#232946; background:#fff;">
                <option value="" ${empty param.status ? 'selected' : ''}>Tất cả</option>
                <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Chờ duyệt</option>
                <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Bị từ chối</option>
                <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
            </select>
            <button type="submit" class="btn btn-primary" style="font-weight:600; margin-left:0.5rem;"><i class="fa-solid fa-filter"></i> Lọc</button>
        </form>
    </div>
    <div class="table-wrapper table-responsive">
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
                <th>Người duyệt</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty requests}">
                <tr>
                    <td colspan="11" class="text-center text-muted">Không có kết quả phù hợp với bộ lọc.</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:set var="stt" value="1" />
                <c:forEach var="r" items="${requests}">
                    <tr>
                        <td>${stt}</td>
                        <td>${r.id}</td>
                        <td>${r.employeeName} (ID: ${r.employeeId})</td>
                        <td>${r.fromDate}</td>
                        <td>${r.toDate}</td>
                        <td>
                            <div class="reason-cell" style="max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: inline-block; vertical-align: middle;">
                                <span class="reason-text">${r.reason}</span>
                            </div>
                            <c:if test="${fn:length(r.reason) >= 20}">
                                <button type="button" class="btn btn-link btn-sm p-0 ms-1 reason-toggle">Xem thêm</button>
                            </c:if>
                        </td>
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
                            <c:choose>
                                <c:when test="${r.approverType eq 'AI'}">Tự động</c:when>
                                <c:when test="${r.approverType eq 'USER'}">${r.approvedBy}</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${r.status eq 'INPROGRESS'}">
                                <a href="${pageContext.request.contextPath}/app/leave/review?id=${r.id}" class="btn btn-sm btn-primary action-btn"><i class="fa-solid fa-eye"></i> Xem &amp; Duyệt</a>
                            </c:if>
                        </td>
                    </tr>
                    <c:set var="stt" value="${stt + 1}" />
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
    </div>
</div>
</body>
</html>
