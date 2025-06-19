<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body{
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card{
            background: #fff;
            padding: 2.5rem 3.5rem;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(0,0,0,.12);
            text-align: center;
        }
        .btn-google{
            margin-top: 2rem;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            background: linear-gradient(90deg, #EE82EE 0%, #4285F4 100%);
            color: #fff;
            transition: background 0.2s;
            text-decoration: none !important;
        }
        .btn-google:hover{
            background: linear-gradient(90deg, #d16ba5 0%, #4285F4 100%);
            text-decoration: none !important;
        }
        .fa-google {
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <section class="card">
        <h2 class="mb-4"><i class="fa-solid fa-right-to-bracket"></i> Đăng nhập hệ thống quản lý nghỉ phép</h2>
        <a class="btn-google" href="${pageContext.request.contextPath}/oauth2/google">
            <i class="fab fa-google"></i> Đăng nhập với Google
        </a>
    </section>
</body>
</html>
