<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.LeaveRequest" %>
<%
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leaveRequest");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sửa đơn nghỉ phép</title>
    </head>
    <body>
        <h2>Sửa đơn nghỉ phép</h2>
        <form method="post" action="${pageContext.request.contextPath}/app/leave/edit?id=<%= lr.getId() %>">
            <label>Từ ngày: <input type="date" name="from_date" value="<%= lr.getFromDate() %>" required></label><br>
            <label>Đến ngày: <input type="date" name="to_date" value="<%= lr.getToDate() %>" required></label><br>
            <label>Lý do:<br><textarea name="reason" rows="3" cols="40"><%= lr.getReason() %></textarea></label><br>
            <button type="submit">Lưu thay đổi</button>
        </form>

        <p><a href="${pageContext.request.contextPath}/app/leave/list">← Quay lại danh sách</a></p>
    </body>
</html>
