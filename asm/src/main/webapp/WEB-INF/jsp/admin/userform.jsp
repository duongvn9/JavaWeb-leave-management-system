<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page import="asm.model.User, java.util.List, asm.model.Department, asm.model.RoleOption" %>
<%
    User u = (User) request.getAttribute("user");
    boolean edit = (u != null);
    List<Department> depts = (List<Department>) request.getAttribute("depts");
    List<RoleOption> roles = (List<RoleOption>) request.getAttribute("roles");
    java.util.Set<String> rolesOfUser = edit ? (java.util.Set<String>) request.getAttribute("rolesOfUser") : java.util.Collections.emptySet();
    String error = (String) request.getAttribute("error");
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
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/admin/users/form">
                <input type="hidden" name="id" value="${user.id != null ? user.id : ''}" />
                <div class="mb-3">
                    <label class="form-label">Email:</label>
                    <input type="email" class="form-control" name="email"
                        value="<c:out value='${user.email}'/>"
                        <c:if test="${not empty user}">readonly</c:if>
                        required/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Họ tên:</label>
                    <input type="text" class="form-control" name="full_name" value="<c:out value='${user.fullName}'/>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Phòng ban:</label>
                    <select class="form-select" name="deptId">
                        <option value="">-- Không --</option>
                        <c:forEach var="d" items="${depts}">
                            <option value="${d.id}" <c:if test="${not empty user && user.deptId == d.id}">selected</c:if>>${d.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Vai trò:</label>
                    <select class="form-select" name="roleId">
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.id}" <c:if test="${not empty user && rolesOfUser != null && rolesOfUser.contains(r.code)}">selected</c:if>>${r.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn btn-save"><i class="fa-solid fa-save"></i> Lưu</button>
            </form>
            <br>
            <a href="${pageContext.request.contextPath}/admin/users" class="back-link"><i class="fa-solid fa-arrow-left"></i> Danh sách</a>
        </div>
    </body>
</html>
