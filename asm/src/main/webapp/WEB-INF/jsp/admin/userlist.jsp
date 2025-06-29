<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List,asm.model.User,asm.model.Department" %>
<%@ page import="java.util.Map,java.util.Set" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    List<User> list = (List<User>) request.getAttribute("users");
    List<Department> depts = (List<Department>) request.getAttribute("depts");
    Map<Integer, Set<String>> rolesOfUserMap = (Map<Integer, Set<String>>) request.getAttribute("rolesOfUserMap");
    boolean showInactive = (boolean) request.getAttribute("showInactive");
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
        .container { max-width: 1200px; margin: 40px auto; }
        .table-wrapper {
            background: #fff;
            border-radius: 12px;
            box-shadow: none;
            overflow: hidden;
            margin-top: 1.5rem;
        }
        .table {
            border-collapse: collapse;
            border-spacing: 0;
            width: 100%;
        }
        .table th, .table td {
            border: 1px solid #e0e0e0;
            text-align: center;
            vertical-align: middle;
        }
        .table thead th {
            background: #6C7AE0 !important;
            color: #fff !important;
            padding: 1rem;
            font-weight: 500;
            text-align: center;
            vertical-align: middle;
        }
        .table tbody td {
            padding: 1rem;
            text-align: center;
            vertical-align: middle;
        }
        .table.table-hover tbody tr:hover {
            background: #f0f2ff !important;
            transition: background 0.2s;
        }

        .btn-add { background: #28a745; color: #fff; border-radius: 8px; }
        .btn-add:hover { background: #218838; }
        .action-btn { margin-right: 0.5rem; }
        .back-link { color: #4285F4; text-decoration: none; margin-top: 1.5rem; display: inline-block;}
        .back-link:hover { text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="${pageContext.request.contextPath}/admin/users/form" class="btn btn-add"><i class="fa-solid fa-user-plus"></i> Thêm user</a>
        <div>
            <c:choose>
                <c:when test="${showInactive}">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-eye-slash"></i> Ẩn user deactive
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/users?showInactive=true" class="btn btn-outline-warning">
                        <i class="fa-solid fa-eye"></i> Hiện user deactive
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Toast thông báo thành công ở góc trên bên phải -->
    <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 9999;">
        <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header bg-success text-white">
                <i class="fa-solid fa-check-circle me-2"></i>
                <strong class="me-auto">Thành công</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                <span id="toastMessage"></span>
            </div>
        </div>
    </div>
    
    <div class="table-wrapper">
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>STT</th>
                <th>ID</th><th>Tên</th><th>Email</th><th>Phòng</th><th>Active</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
        <c:set var="stt" value="1" />
        <c:forEach var="u" items="${users}">
            <c:set var="userRoles" value="${rolesOfUserMap[u.id]}" />
            <tr>
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
                <td>
                    <c:choose>
                        <c:when test="${u.active}">
                            <span class="badge bg-success">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger">Deactive</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/users/form?id=${u.id}" class="btn btn-sm btn-primary action-btn"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                    <c:choose>
                        <c:when test="${u.active}">
                            <button type="button" class="btn btn-sm btn-danger action-btn delete-btn" 
                                    data-user-id="${u.id}" 
                                    data-user-name="${u.fullName}" 
                                    data-user-email="${u.email}">
                                <i class="fa-solid fa-trash"></i> Xoá
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-sm btn-success action-btn reactivate-btn" 
                                    data-user-id="${u.id}" 
                                    data-user-name="${u.fullName}" 
                                    data-user-email="${u.email}">
                                <i class="fa-solid fa-user-check"></i> Kích hoạt
                            </button>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <c:set var="stt" value="${stt + 1}" />
        </c:forEach>
        </tbody>
    </table>
    </div>
</div>

<!-- Modal xác nhận xóa user -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">
                    <i class="fa-solid fa-exclamation-triangle text-warning"></i> Xác nhận xóa
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa mềm user này?</p>
                <div class="alert alert-info">
                    <strong>ID:</strong> <span id="deleteUserId"></span><br>
                    <strong>Tên:</strong> <span id="deleteUserName"></span><br>
                    <strong>Email:</strong> <span id="deleteUserEmail"></span>
                </div>
                <p class="text-warning"><i class="fa-solid fa-info-circle"></i> User sẽ bị deactive và có thể kích hoạt lại sau!</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                    <i class="fa-solid fa-trash"></i> Xác nhận xóa
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Modal xác nhận kích hoạt lại user -->
<div class="modal fade" id="reactivateModal" tabindex="-1" aria-labelledby="reactivateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="reactivateModalLabel">
                    <i class="fa-solid fa-user-check text-success"></i> Xác nhận kích hoạt
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn kích hoạt lại user này?</p>
                <div class="alert alert-info">
                    <strong>ID:</strong> <span id="reactivateUserId"></span><br>
                    <strong>Tên:</strong> <span id="reactivateUserName"></span><br>
                    <strong>Email:</strong> <span id="reactivateUserEmail"></span>
                </div>
                <p class="text-success"><i class="fa-solid fa-check-circle"></i> User sẽ được kích hoạt lại và có thể đăng nhập!</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" style="display: inline;">
                    <input type="hidden" name="id" id="reactivateUserIdInput" />
                    <button type="submit" class="btn btn-success">
                        <i class="fa-solid fa-user-check"></i> Xác nhận kích hoạt
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Hiển thị toast thông báo thành công nếu có
    var successMessage = '${successMessage}';
    if (successMessage && successMessage.trim() !== '') {
        document.addEventListener('DOMContentLoaded', function() {
            showSuccessToast(successMessage);
        });
    }
    
    // Xử lý sự kiện click cho các nút xóa
    document.addEventListener('DOMContentLoaded', function() {
        var deleteButtons = document.querySelectorAll('.delete-btn');
        deleteButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var userId = this.getAttribute('data-user-id');
                var userName = this.getAttribute('data-user-name');
                var userEmail = this.getAttribute('data-user-email');
                
                showDeleteModal(userId, userName, userEmail);
            });
        });
        
        // Xử lý sự kiện click cho các nút kích hoạt
        var reactivateButtons = document.querySelectorAll('.reactivate-btn');
        reactivateButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var userId = this.getAttribute('data-user-id');
                var userName = this.getAttribute('data-user-name');
                var userEmail = this.getAttribute('data-user-email');
                
                showReactivateModal(userId, userName, userEmail);
            });
        });
    });
    
    function showDeleteModal(userId, userName, userEmail) {
        // Cập nhật thông tin user trong modal
        document.getElementById('deleteUserId').textContent = userId;
        document.getElementById('deleteUserName').textContent = userName;
        document.getElementById('deleteUserEmail').textContent = userEmail;
        
        // Cập nhật link xóa
        document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/admin/users/delete?id=' + userId;
        
        // Hiển thị modal
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }
    
    function showReactivateModal(userId, userName, userEmail) {
        // Cập nhật thông tin user trong modal
        document.getElementById('reactivateUserId').textContent = userId;
        document.getElementById('reactivateUserName').textContent = userName;
        document.getElementById('reactivateUserEmail').textContent = userEmail;
        
        // Cập nhật input hidden
        document.getElementById('reactivateUserIdInput').value = userId;
        
        // Hiển thị modal
        var reactivateModal = new bootstrap.Modal(document.getElementById('reactivateModal'));
        reactivateModal.show();
    }
    
    function showSuccessToast(message) {
        document.getElementById('toastMessage').textContent = message;
        var toast = new bootstrap.Toast(document.getElementById('successToast'), {
            autohide: true,
            delay: 5000
        });
        toast.show();
    }
</script>
</body>
</html>
