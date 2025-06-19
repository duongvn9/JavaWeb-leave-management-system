<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tài khoản chưa được cấp quyền</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(120deg, #f44336 0%, #fbc2eb 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .error-card {
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(244,67,54,0.10);
                padding: 2.5rem 2.5rem 2rem 2.5rem;
                max-width: 420px;
                text-align: center;
            }
            .error-icon {
                font-size: 3rem;
                color: #f44336;
                margin-bottom: 1rem;
            }
            .btn-back {
                margin-top: 1.5rem;
                background: #4285F4;
                color: #fff;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 600;
                text-decoration: none !important;
            }
            .btn-back:hover {
                background: #2a65c4;
                color: #fff;
            }
        </style>
    </head>
    <body>
        <div class="error-card">
            <div class="error-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
            <h2 class="mb-3" style="color:#f44336;">Không thể đăng nhập</h2>
            <div class="mb-3 text-danger">${loginError}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-back"><i class="fa-solid fa-arrow-left"></i> Quay lại trang đăng nhập</a>
        </div>
    </body>
</html>
