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
        .container { max-width: 1400px; margin: 40px auto; }
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
        .table thead th.col-edited { width: 110px; }
        .table thead th.col-from { width: 140px; }
        .table thead th.col-to { width: 140px; }
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
        .table tbody td.col-edited { width: 110px; }
        .table tbody td.col-from { width: 140px; }
        .table tbody td.col-to { width: 140px; }
        .table.table-hover tbody tr:hover {
            background: #f0f2ff !important;
            transition: background 0.2s;
        }

        .action-btn { margin-right: 0.5rem; }
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
        <h2 class="mb-0"><i class="fa-solid fa-list"></i> Danh sách đơn nghỉ phép của tôi</h2>
        <form method="get" action="${pageContext.request.contextPath}/app/leave/list" class="row g-2 align-items-center">
            <div class="col-auto">
                <label for="status" class="col-form-label"><i class="fa-solid fa-filter"></i> Trạng thái:</label>
            </div>
            <div class="col-auto">
                <select name="status" id="status" class="form-select" onchange="this.form.submit()">
                    <option value="" <c:if test="${empty param.status}">selected</c:if>>Tất cả</option>
                    <option value="APPROVED" <c:if test="${param.status == 'APPROVED'}">selected</c:if>>Đã đồng ý</option>
                    <option value="REJECTED" <c:if test="${param.status == 'REJECTED'}">selected</c:if>>Đã từ chối</option>
                    <option value="INPROGRESS" <c:if test="${param.status == 'INPROGRESS'}">selected</c:if>>Chưa duyệt</option>
                    <option value="CANCELLED" <c:if test="${param.status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                </select>
            </div>
        </form>
    </div>
    <!-- Toast thông báo -->
    <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 9999;">
        <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header bg-success text-white">
                <i class="fa-solid fa-check-circle me-2"></i>
                <strong class="me-auto">Thành công</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${successMessage}
            </div>
        </div>
        <!-- Toast thông báo lỗi -->
        <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header bg-danger text-white">
                <i class="fa-solid fa-circle-xmark me-2"></i>
                <strong class="me-auto">Lỗi</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${errorMessage}
            </div>
        </div>
    </div>

    <div class="table-wrapper">
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>STT</th>
                <th>ID</th>
                <th>Nhân viên</th>
                <th class="col-from">Từ ngày</th>
                <th class="col-to">Đến ngày</th>
                <th>Lý do</th>
                <th>Trạng thái</th>
                <th class="col-edited">Đã sửa?</th>
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
                <td class="col-from">${r.fromDate}</td>
                <td class="col-to">${r.toDate}</td>
                <td>${r.reason}</td>
                <td>
                    <c:choose>
                        <c:when test="${r.status eq 'INPROGRESS'}">
                            <span class="badge bg-primary">Chưa duyệt</span>
                        </c:when>
                        <c:when test="${r.status eq 'APPROVED'}">
                            <span class="badge bg-success">Đã đồng ý</span>
                        </c:when>
                        <c:when test="${r.status eq 'REJECTED'}">
                            <span class="badge bg-danger">Đã từ chối</span>
                        </c:when>
                        <c:when test="${r.status eq 'CANCELLED'}">
                            <span class="badge bg-warning text-dark">Đã hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">${r.status}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td class="col-edited">
                    <c:if test="${r.edited}">
                        <i class="fa-solid fa-check text-success"></i>
                    </c:if>
                </td>
                <td>${r.createdAt}</td>
                <td>
                    <c:if test="${r.status eq 'INPROGRESS'}">
                        <a href="${pageContext.request.contextPath}/app/leave/edit?id=${r.id}" class="btn btn-sm btn-primary action-btn"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                        <button type="button" class="btn btn-sm btn-danger action-btn cancel-btn"
                                data-request-id="${r.id}">
                            <i class="fa-solid fa-ban"></i> Huỷ
                        </button>
                    </c:if>
                </td>
            </tr>
            <c:set var="stt" value="${stt + 1}" />
        </c:forEach>
        </tbody>
    </table>
    </div>
</div>

<!-- Modal xác nhận hủy -->
<div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cancelModalLabel"><i class="fa-solid fa-exclamation-triangle text-warning"></i> Xác nhận huỷ đơn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn huỷ đơn nghỉ phép này không?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Không</button>
                <form id="cancelForm" method="post" action="${pageContext.request.contextPath}/app/leave/cancel" style="display:inline;">
                    <input type="hidden" name="id" id="requestIdToCancel">
                    <button type="submit" class="btn btn-danger"><i class="fa-solid fa-ban"></i> Xác nhận huỷ</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Hiển thị toast nếu có thông báo thành công
        var successMessage = '${successMessage}';
        if (successMessage && successMessage.trim() !== '') {
            var successToastEl = document.getElementById('successToast');
            var successToast = new bootstrap.Toast(successToastEl);
            successToast.show();
        }

        // Hiển thị toast nếu có thông báo lỗi
        var errorMessage = '${errorMessage}';
        if (errorMessage && errorMessage.trim() !== '') {
            var errorToastEl = document.getElementById('errorToast');
            var errorToast = new bootstrap.Toast(errorToastEl);
            errorToast.show();
        }

        // Xử lý sự kiện click cho nút Huỷ
        var cancelModal = new bootstrap.Modal(document.getElementById('cancelModal'));
        var cancelButtons = document.querySelectorAll('.cancel-btn');
        cancelButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var requestId = this.getAttribute('data-request-id');
                document.getElementById('requestIdToCancel').value = requestId;
                cancelModal.show();
            });
        });
    });
</script>

</body>
</html>
