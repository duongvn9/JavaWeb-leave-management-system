<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>404 Not Found</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #f8f8f8;
            font-family: 'Arvo', serif;
        }
        .page_404 {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f8f8;
        }
        .content_wrapper_404 {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 40px 32px 32px 32px;
            max-width: 420px;
            width: 100%;
            text-align: center;
        }
        .four_zero_four_bg {
            background-image: url(https://cdn.dribbble.com/users/285475/screenshots/2083086/dribbble_1.gif);
            height: 220px;
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            margin-bottom: 16px;
        }
        .four_zero_four_bg h1 {
            font-size: 72px;
            margin: 0;
            color: #222;
            font-weight: bold;
            letter-spacing: 2px;
            text-shadow: 2px 2px 8px #fff;
        }
        .contant_box_404 h3 {
            font-size: 28px;
            margin: 16px 0 8px 0;
            color: #222;
            font-weight: 600;
        }
        .contant_box_404 p {
            color: #666;
            font-size: 16px;
            margin-bottom: 24px;
        }
        .link_404 {
            color: #fff!important;
            padding: 12px 32px;
            background: #39ac31;
            border-radius: 24px;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: background 0.2s;
            box-shadow: 0 2px 8px rgba(57,172,49,0.12);
        }
        .link_404:hover {
            background: #2e8b25;
        }
        @media (max-width: 600px) {
            .content_wrapper_404 {
                padding: 24px 8px 16px 8px;
            }
            .four_zero_four_bg {
                height: 140px;
            }
        }
    </style>
</head>
<body>
<div class="page_404">
    <div class="content_wrapper_404">
        <div class="four_zero_four_bg">
            <h1>404</h1>
        </div>
        <div class="contant_box_404">
            <h3>Oops! Bạn bị lạc rồi</h3>
            <p>Trang bạn tìm kiếm không tồn tại hoặc đã bị di chuyển.</p>
            <a href="javascript:window.history.back();" class="link_404">Quay lại trang trước</a>
        </div>
    </div>
</div>
</body>
</html> 