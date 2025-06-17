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
    <title><%= edit ? "Sửa" : "Thêm" %> người dùng</title>
</head>
<body>
<h2><%= edit ? "Sửa" : "Thêm" %> người dùng</h2>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/admin/users/form">
    <c:if test="${edit}">
        <input type="hidden" name="id" value="${u.id}" />
    </c:if>

    Email:
    <input type="email" name="email" value="<%= edit ? u.getEmail() : "" %>" <%= edit ? "readonly" : "" %> required><br>

    Họ tên:
    <input type="text" name="full_name" value="<%= edit ? u.getFullName() : "" %>" required><br>

    Phòng ban:
    <select name="deptId">
        <option value="">-- Không --</option>
        <c:forEach var="d" items="${depts}">
            <option value="${d.id}" <c:if test="${edit && u.deptId == d.id}">selected</c:if>>${d.name}</option>
        </c:forEach>
    </select><br>

    Vai trò:
    <select name="roleId">
        <c:forEach var="r" items="${roles}">
            <option value="${r.id}" <c:if test="${edit && rolesOfUser.contains(r.code)}">selected</c:if>>${r.name}</option>
        </c:forEach>
    </select><br><br>

    <button type="submit">Lưu</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/admin/users">← Danh sách</a>
</body>
</html>
