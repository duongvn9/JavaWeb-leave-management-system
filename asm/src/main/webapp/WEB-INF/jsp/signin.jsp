<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Raleway', sans-serif;
            background: #fff;
        }
        body {
            width: 100vw;
            height: 100vh;
            min-height: 100vh;
            min-width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .center {
            background: #fff;
            border-radius: 28px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.10);
            padding: 48px 36px 32px 36px;
            min-width: 340px;
            max-width: 95vw;
            display: flex;
            flex-direction: column;
            align-items: center;
            animation: fadeIn 1s cubic-bezier(.4,0,.2,1);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(40px) scale(0.95); }
            to { opacity: 1; transform: none; }
        }
        .login-header {
            text-align: center;
            margin-bottom: 28px;
        }
        .login-icon {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 18px;
            box-shadow: 0 6px 18px rgba(67,233,123,0.18);
        }
        .login-icon i {
            font-size: 2rem;
            color: #fff;
        }
        .login-title {
            font-size: 1.7rem;
            font-weight: 700;
            color: #222;
            margin-bottom: 8px;
        }
        .login-subtitle {
            font-size: 1.05rem;
            color: #666;
            font-weight: 400;
        }
        .google-btn {
            width: 100%;
            padding: 16px 0;
            background: linear-gradient(90deg, #4285f4 0%, #34a853 40%, #fbbc05 70%, #ea4335 100%);
            border: none;
            border-radius: 12px;
            color: #fff;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: box-shadow 0.2s, transform 0.2s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.7rem;
            box-shadow: 0 4px 18px rgba(66,133,244,0.18);
            margin-top: 10px;
            margin-bottom: 10px;
        }
        .google-btn:hover {
            box-shadow: 0 8px 32px rgba(66,133,244,0.25);
            transform: translateY(-2px) scale(1.03);
            text-decoration: none;
        }
        .google-btn i {
            font-size: 1.3rem;
        }
        .footer-text {
            text-align: center;
            margin-top: 18px;
            color: #a0aec0;
            font-size: 0.95rem;
        }
        @media (max-width: 480px) {
            .center {
                padding: 28px 8vw 20px 8vw;
                min-width: unset;
            }
            .login-title {
                font-size: 1.2rem;
            }
            .login-icon {
                width: 54px;
                height: 54px;
            }
        }
    </style>
</head>
<body>
    <div class="center">
        <div class="login-header">
            <div class="login-icon">
                <i class="fas fa-building"></i>
            </div>
            <h2 class="login-title">Đăng nhập</h2>
            <p class="login-subtitle">Hệ thống quản lý nghỉ phép</p>
        </div>
        <a href="${pageContext.request.contextPath}/oauth2/google" class="google-btn" id="googleBtn">
            <i class="fab fa-google"></i>
            <span>Đăng nhập với Google</span>
        </a>
        <div class="footer-text">
            <i class="fas fa-shield-alt"></i>
            Bảo mật bằng OAuth 2.0
        </div>
    </div>
    <script>
        document.getElementById('googleBtn').addEventListener('click', function() {
            this.classList.add('loading');
            this.querySelector('span').textContent = 'Đang chuyển hướng...';
        });
    </script>
</body>
</html>
