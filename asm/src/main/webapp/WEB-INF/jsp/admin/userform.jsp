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
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title><c:choose><c:when test="${edit}">Sửa</c:when><c:otherwise>Thêm</c:otherwise></c:choose> người dùng</title>
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
            <h2><i class="fa-solid fa-user-edit"></i> <c:choose><c:when test="${edit}">Sửa</c:when><c:otherwise>Thêm</c:otherwise></c:choose> người dùng</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin/users/form">
                <c:if test="${edit}">
                    <input type="hidden" name="id" value="${user.id}" />
                </c:if>
                <div class="mb-3">
                    <label class="form-label">Email:</label>
                    <input type="email" class="form-control" name="email"
                        value="<c:out value='${edit || not empty error ? user.email : ""}'/>"
                        <c:if test="${edit}">readonly</c:if>
                        required/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Họ tên:</label>
                    <input type="text" class="form-control" name="full_name" 
                        value="<c:out value='${edit || not empty error ? user.fullName : ""}'/>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phòng ban:</label>
                    <select class="form-select" name="deptId">
                        <option value="">-- Không --</option>
                        <c:forEach var="d" items="${depts}">
                            <option value="${d.id}" <c:if test="${(edit || not empty error) && user.deptId == d.id}">selected</c:if>>${d.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Vai trò:</label>
                    <select class="form-select" name="roleId">
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hiển thị modal lỗi nếu có
            document.addEventListener('DOMContentLoaded', function() {
                var errorModalElement = document.getElementById('errorModal');
                if (errorModalElement) {
                    var errorModal = new bootstrap.Modal(errorModalElement);
                    errorModal.show();
                }
            });
        </script>
    </body>
</html>
