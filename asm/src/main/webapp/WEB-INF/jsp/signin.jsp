<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: #f5f5f5;
            margin: 0;
        }
        .card{
            background: #ffffff;
            padding: 2rem 3rem;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,.1);
            text-align: center;
        }
        .btn{
            display: inline-block;
            margin-top: 1.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            background: #4285F4;  
            color: #fff;
            text-decoration: none;
        }
        .btn:hover{
            box-shadow: 0 2px 8px rgba(0,0,0,.2);
        }
    </style>
</head>
<body>
    <section class="card">
        <h2>Đăng nhập hệ thống</h2>

        <!-- Link chuyển tới servlet xử lý OAuth -->
        <a class="btn" href="${pageContext.request.contextPath}/oauth2/google">
            Sign-in with Google
        </a>
    </section>
</body>
</html>
