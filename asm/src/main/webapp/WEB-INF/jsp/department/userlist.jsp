<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="java.util.List, asm.model.User, asm.model.Department" %>
<%
    List<User>        users   = (List<User>)        request.getAttribute("users");
    List<Department>  depts   = (List<Department>)  request.getAttribute("depts");     // null nếu Leader
    Integer selected          = (Integer)           request.getAttribute("selectedDept");
%>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Danh sách nhân viên</title></head>
<body>
<h2>Danh sách nhân viên</h2>

<c:if test="${not empty depts}">
    <form method="get" action="${pageContext.request.contextPath}/app/department/users">
        Lọc phòng ban:
        <select name="deptId">
            <option value="" <c:if test="${selected == null}">selected</c:if>>Tất cả</option>
            <c:forEach var="d" items="${depts}">
                <option value="${d.id}" <c:if test="${selected != null && selected == d.id}">selected</c:if>>
                    ${d.name}
                </option>
            </c:forEach>
        </select>
        <button type="submit">Lọc</button>
    </form><br/>
</c:if>

<table border="1" cellpadding="6" cellspacing="0">
    <tr><th>ID</th><th>Họ tên</th><th>Email</th><th>Phòng ban</th></tr>
    <c:forEach var="u" items="${users}">
        <tr>
            <td>${u.id}</td>
            <td>${u.fullName}</td>
            <td>${u.email}</td>
            <td>${u.deptId}</td>
        </tr>
    </c:forEach>
</table>

<p><a href="${pageContext.request.contextPath}/app/dashboard">← Dashboard</a></p>
</body>
</html>
