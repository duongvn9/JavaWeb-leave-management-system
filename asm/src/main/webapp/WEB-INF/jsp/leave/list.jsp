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
</head>
<body>
<h2>Danh sách đơn nghỉ phép</h2>
<table border="1" cellpadding="6" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Từ ngày</th>
        <th>Đến ngày</th>
        <th>Lý do</th>
        <th>Trạng thái</th>
        <th>Đã sửa?</th>
        <th>Ngày tạo</th>
        <th>Thao tác</th>
    </tr>
    <c:forEach var="r" items="${requests}">
        <tr>
            <td>${r.id}</td>
            <td>${r.fromDate}</td>
            <td>${r.toDate}</td>
            <td>${r.reason}</td>
            <td>${r.status}</td>
            <td><c:out value="${r.edited ? '✔' : ''}"/></td>
            <td>${r.createdAt}</td>
            <td>
                <c:if test="${r.status eq 'INPROGRESS'}">
                    <a href="${pageContext.request.contextPath}/app/leave/edit?id=${r.id}">Sửa</a> |
                    <form method="post" action="${pageContext.request.contextPath}/app/leave/cancel" style="display:inline" onsubmit="return confirm('Xác nhận hủy?');">
                        <input type="hidden" name="id" value="${r.id}" />
                        <button type="submit">Huỷ</button>
                    </form>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>

<p><a href="${pageContext.request.contextPath}/app/dashboard">← Dashboard</a></p>
</body>
</html>
