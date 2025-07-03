<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page import="asm.model.User, java.util.List, asm.model.Department, asm.model.RoleOption" %>
<%
    User u = (User) request.getAttribute("user");
    boolean edit = (Boolean) request.getAttribute("edit");
    List<Department> depts = (List<Department>) request.getAttribute("depts");
    List<RoleOption> roles = (List<RoleOption>) request.getAttribute("roles");
    java.util.Set<String> rolesOfUser = edit ? (java.util.Set<String>) request.getAttribute("rolesOfUser") : java.util.Collections.emptySet();
    String error = (String) request.getAttribute("error");
    Integer selectedRoleId = (Integer) request.getAttribute("selectedRoleId");
    Integer defaultRoleId = (Integer) request.getAttribute("defaultRoleId");
    boolean reactivate = (Boolean) request.getAttribute("reactivate");
    User deactivatedUser = (User) request.getAttribute("deactivatedUser");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title><c:choose><c:when test="${edit}">Sửa</c:when><c:otherwise>Thêm</c:otherwise></c:choose> nhân viên</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body { background: #f8fafc; }
            .form-card {
                max-width: 480px;
                margin: 60px auto;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(0,0,0,0.08);
                background: #fff;
                padding: 2.5rem 2.5rem 2rem 2.5rem;
            }
            .form-card h2 {
                font-size: 1.7rem;
                font-weight: 700;
                color: #4285F4;
            }
            .form-label { font-weight: 500; }
            .btn-save {
                background: #4285F4;
                color: #fff;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 600;
            }
            .btn-save:hover { background: #2a65c4; }
            .back-link { color: #4285F4; text-decoration: none; }
            .back-link:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <div class="form-card">
            <h2><i class="fa-solid fa-user-edit"></i> <c:choose><c:when test="${edit}">Sửa</c:when><c:otherwise>Thêm</c:otherwise></c:choose> nhân viên</h2>
            <form id="userForm" method="post" action="${pageContext.request.contextPath}/admin/users/form">
                <c:if test="${edit}">
                    <input type="hidden" name="id" value="${user.id}" />
                </c:if>
                <div class="mb-3">
                    <label class="form-label">Email:</label>
                    <input type="email" class="form-control" name="email" id="email"
                        value="<c:out value='${edit || not empty error ? user.email : ""}'/>"
                        <c:if test="${edit}">readonly</c:if>
                        required/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Họ tên:</label>
                    <input type="text" class="form-control" name="full_name" id="fullName"
                        value="<c:out value='${edit || not empty error ? user.fullName : ""}'/>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phòng ban:</label>
                    <select class="form-select" name="deptId" id="deptId" required>
                        <option value="" disabled selected>Phòng ban</option>
                        <c:forEach var="d" items="${depts}">
                            <option value="${d.id}" <c:if test="${(edit || not empty error) && user.deptId == d.id}">selected</c:if>>${d.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Vai trò:</label>
                    <select class="form-select" name="roleId" id="roleId">
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.id}" 
                                <c:choose>
                                    <c:when test="${edit && rolesOfUser != null && rolesOfUser.contains(r.code)}">selected</c:when>
                                    <c:when test="${selectedRoleId != null && selectedRoleId == r.id}">selected</c:when>
                                    <c:when test="${!edit && defaultRoleId != null && defaultRoleId == r.id && empty error}">selected</c:when>
                                </c:choose>>${r.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn btn-save"><i class="fa-solid fa-save"></i> Lưu</button>
            </form>
            <br>
            <a href="${pageContext.request.contextPath}/admin/users" class="back-link"><i class="fa-solid fa-arrow-left"></i> Danh sách</a>
        </div>

        <!-- Modal xác nhận lưu nhân viên -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmModalLabel">
                            <i class="fa-solid fa-question-circle text-info"></i> Xác nhận <c:choose><c:when test="${edit}">cập nhật</c:when><c:otherwise>thêm mới</c:otherwise></c:choose>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn <c:choose><c:when test="${edit}">cập nhật</c:when><c:otherwise>thêm mới</c:otherwise></c:choose> nhân viên này?</p>
                        <div class="alert alert-info">
                            <c:if test="${edit}">
                                <strong>ID:</strong> <span id="confirmUserId">${user.id}</span><br>
                            </c:if>
                            <strong>Email:</strong> <span id="confirmUserEmail"></span><br>
                            <strong>Họ tên:</strong> <span id="confirmUserName"></span><br>
                            <strong>Phòng ban:</strong> <span id="confirmUserDept"></span><br>
                            <strong>Vai trò:</strong> <span id="confirmUserRole"></span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" id="confirmSaveBtn" class="btn btn-primary">
                            <i class="fa-solid fa-save"></i> Xác nhận <c:choose><c:when test="${edit}">cập nhật</c:when><c:otherwise>thêm mới</c:otherwise></c:choose>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal thông báo lỗi -->
        <c:if test="${not empty error}">
        <div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="errorModalLabel">
                            <i class="fa-solid fa-exclamation-triangle text-warning"></i> Thông báo
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-danger mb-0">
                            <i class="fa-solid fa-times-circle"></i> ${error}
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
        </c:if>

        <!-- Modal thông báo kích hoạt lại nhân viên -->
        <c:if test="${reactivate}">
        <div class="modal fade" id="reactivateModal" tabindex="-1" aria-labelledby="reactivateModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reactivateModalLabel">
                            <i class="fa-solid fa-user-check text-info"></i> Phát hiện nhân viên đã bị deactive
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-info mb-3">
                            <i class="fa-solid fa-info-circle"></i> Email <strong>${deactivatedUser.email}</strong> đã tồn tại trong hệ thống nhưng nhân viên này đã bị deactive.
                        </div>
                        <p>Bạn có muốn kích hoạt lại nhân viên này không?</p>
                        <div class="alert alert-warning">
                            <strong>Thông tin nhân viên sẽ được kích hoạt:</strong><br>
                            <strong>ID:</strong> ${deactivatedUser.id}<br>
                            <strong>Họ tên:</strong> ${deactivatedUser.fullName}<br>
                            <strong>Email:</strong> ${deactivatedUser.email}
                        </div>
                        <p class="text-info"><i class="fa-solid fa-info-circle"></i> Thông tin nhân viên sẽ được giữ nguyên như ban đầu.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form method="post" action="${pageContext.request.contextPath}/admin/users/form" style="display: inline;">
                            <input type="hidden" name="email" value="${deactivatedUser.email}" />
                            <input type="hidden" name="reactivate" value="true" />
                            <button type="submit" class="btn btn-success">
                                <i class="fa-solid fa-user-check"></i> Kích hoạt lại
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hiển thị modal lỗi nếu có
            document.addEventListener('DOMContentLoaded', function() {
                var errorModalElement = document.getElementById('errorModal');
                if (errorModalElement) {
                    var errorModal = new bootstrap.Modal(errorModalElement);
                    errorModal.show();
                }
                
                // Hiển thị modal kích hoạt lại nhân viên nếu có
                var reactivateModalElement = document.getElementById('reactivateModal');
                if (reactivateModalElement) {
                    var reactivateModal = new bootstrap.Modal(reactivateModalElement);
                    reactivateModal.show();
                }
                
                // Xử lý sự kiện submit form
                var userForm = document.getElementById('userForm');
                userForm.addEventListener('submit', function(e) {
                    // Nếu đang hiển thị modal kích hoạt lại, không submit form
                    var reactivateModalElement = document.getElementById('reactivateModal');
                    if (reactivateModalElement && reactivateModalElement.classList.contains('show')) {
                        return;
                    }
                    e.preventDefault();
                    showConfirmModal();
                });
                
                // Xử lý sự kiện click nút xác nhận
                document.getElementById('confirmSaveBtn').addEventListener('click', function() {
                    userForm.submit();
                });
            });
            
            function showConfirmModal() {
                // Lấy thông tin từ form
                var email = document.getElementById('email').value;
                var fullName = document.getElementById('fullName').value;
                var deptSelect = document.getElementById('deptId');
                var roleSelect = document.getElementById('roleId');
                
                var deptText = deptSelect.options[deptSelect.selectedIndex].text;
                var roleText = roleSelect.options[roleSelect.selectedIndex].text;
                
                // Cập nhật thông tin trong modal
                document.getElementById('confirmUserEmail').textContent = email;
                document.getElementById('confirmUserName').textContent = fullName;
                document.getElementById('confirmUserDept').textContent = deptText;
                document.getElementById('confirmUserRole').textContent = roleText;
                
                // Hiển thị modal
                var confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
                confirmModal.show();
            }
        </script>
    </body>
</html>
