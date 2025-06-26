<%@ page contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Thao tác thất bại</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }

            .container {
                max-width: 600px;
                margin-top: 100px;
                text-align: center;
            }

            .card {
                padding: 2rem;
                border-radius: 1rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.07);
                border: none;
            }

            .icon-wrapper {
                font-size: 3rem;
                color: #dc3545;
            }

            .back-link {
                margin-top: 1.5rem;
                display: inline-block;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="card">
                <div class="icon-wrapper mb-3">
                    <i class="fa-solid fa-circle-xmark"></i>
                </div>
                <h1 class="card-title h3">Thao tác không thể thực hiện</h1>
                <p class="card-text text-muted">${errorMessage}</p>
                <a href="${pageContext.request.contextPath}/app/leave/reviewlist" class="btn btn-primary back-link">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>
    </body>

    </html>