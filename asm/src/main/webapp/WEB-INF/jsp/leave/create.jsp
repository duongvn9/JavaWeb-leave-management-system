<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo đơn nghỉ phép</title>
    </head>
    <body>
        <h2>Tạo đơn nghỉ phép</h2>
        <form method="post" action="${pageContext.request.contextPath}/app/leave/create">
            <label>Từ ngày: <input type="date" name="from_date" required></label><br>
            <label>Đến ngày: <input type="date" name="to_date" required></label><br>
            <label>Lý do:<br><textarea name="reason" rows="3" cols="40"></textarea></label><br>
            <button type="submit">Gửi đơn</button>
        </form>

        <p><a href="${pageContext.request.contextPath}/app/dashboard">← Quay lại Dashboard</a></p>
    </body>
</html>
