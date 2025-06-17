<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.LeaveRequest" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leave");
    long days = (Long) request.getAttribute("days");
    int remain = (Integer) request.getAttribute("remain");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Duyệt đơn #<%= lr.getId() %></title>
    </head>
    <body>
        <h2>Chi tiết đơn nghỉ phép #<%= lr.getId() %></h2>
        <p><b>Nhân viên:</b> <%= lr.getEmployeeName() %> (ID: <%= lr.getEmployeeId() %>)</p>
        <p><b>Thời gian:</b> <%= lr.getFromDate() %> → <%= lr.getToDate() %> ( <%= days %> ngày )</p>
        <p><b>Lý do:</b> <%= lr.getReason() %></p>
        <p><b>Số ngày còn lại:</b> <%= remain %> / 12</p>

        <form method="post" action="${pageContext.request.contextPath}/app/leave/review">
            <input type="hidden" name="id" value="<%= lr.getId() %>" />
            <label>Ghi chú:<br><textarea name="note" rows="3" cols="50" maxlength="255"></textarea></label><br><br>
            <button type="submit" name="action" value="APPROVE">Duyệt</button>
            <button type="submit" name="action" value="REJECT">Từ chối</button>
        </form>

        <p><a href="${pageContext.request.contextPath}/app/leave/reviewlist">← Danh sách đơn</a></p>
    </body>
</html>
