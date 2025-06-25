<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>400 Bad Request</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #f8f8f8;
            font-family: 'Arvo', serif;
        }
        .page_400 {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f8f8;
        }
        .content_wrapper_400 {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 40px 32px 32px 32px;
            max-width: 420px;
            width: 100%;
            text-align: center;
        }
        .four_zero_zero_bg {
            background-image: url(https://cdn.dribbble.com/users/285475/screenshots/2083086/dribbble_1.gif);
            height: 220px;
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            margin-bottom: 16px;
        }
        .four_zero_zero_bg h1 {
            font-size: 72px;
            margin: 0;
            color: #222;
            font-weight: bold;
            letter-spacing: 2px;
            text-shadow: 2px 2px 8px #fff;
        }
        .contant_box_400 h3 {
            font-size: 28px;
            margin: 16px 0 8px 0;
            color: #222;
            font-weight: 600;
        }
        .contant_box_400 p {
            color: #666;
            font-size: 16px;
            margin-bottom: 24px;
        }
        .link_400 {
            color: #fff!important;
            padding: 12px 32px;
            background: #e74c3c;
            border-radius: 24px;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: background 0.2s;
            box-shadow: 0 2px 8px rgba(231,76,60,0.12);
        }
        .link_400:hover {
            background: #c0392b;
        }
        @media (max-width: 600px) {
            .content_wrapper_400 {
                padding: 24px 8px 16px 8px;
            }
            .four_zero_zero_bg {
                height: 140px;
            }
        }
    </style>
</head>
<body>
<div class="page_400">
    <div class="content_wrapper_400">
        <div class="four_zero_zero_bg">
            <h1>400</h1>
        </div>
        <div class="contant_box_400">
            <h3>Yêu cầu không hợp lệ</h3>
            <p>Yêu cầu của bạn gửi lên máy chủ không đúng định dạng hoặc bị thiếu thông tin cần thiết.<br>Vui lòng kiểm tra lại và thử lại sau.</p>
            <a href="javascript:window.history.back();" class="link_400">Quay lại trang trước</a>
        </div>
    </div>
</div>
</body>
</html> 