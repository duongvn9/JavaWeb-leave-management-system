<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head><meta charset="UTF-8"><title>Tài khoản chưa được cấp quyền</title></head>
    <body>
        <h2 style="color:red">Không thể đăng nhập</h2>
        <p>${loginError}</p>
        <p><a href="${pageContext.request.contextPath}/logout">Quay lại trang đăng nhập</a></p>
    </body>
</html>
