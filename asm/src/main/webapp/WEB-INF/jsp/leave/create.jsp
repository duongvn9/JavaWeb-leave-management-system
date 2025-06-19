<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo đơn nghỉ phép</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body { background: #f8fafc; }
            .form-card {
                max-width: 480px;
                margin: 60px auto;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(0,0,0,0.08);
                background: #fff;
                padding: 2.5rem 2.5rem 2rem 2.5rem;
            }
            .form-card h2 {
                font-size: 1.5rem;
                font-weight: 700;
                color: #4285F4;
            }
            .form-label { font-weight: 500; }
            .btn-send {
                background: #28a745;
                color: #fff;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 600;
            }
            .btn-send:hover { background: #218838; }
            .back-link { color: #4285F4; text-decoration: none; }
            .back-link:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <div class="form-card">
            <h2><i class="fa-solid fa-file-circle-plus"></i> Tạo đơn nghỉ phép</h2>
            <form method="post" action="${pageContext.request.contextPath}/app/leave/create" id="leaveForm">
                <div class="mb-3">
                    <label class="form-label">Từ ngày:</label>
                    <input type="date" class="form-control" name="from_date" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Đến ngày:</label>
                    <input type="date" class="form-control" name="to_date" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Lý do:</label>
                    <textarea name="reason" class="form-control" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-send"><i class="fa-solid fa-paper-plane"></i> Gửi đơn</button>
            </form>
            <!-- Modal báo lỗi ngày -->
            <div id="dateErrorModal" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.25);display:flex;align-items:center;justify-content:center;">
                <div style="background:#fff;padding:2rem 2.5rem;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,0.12);text-align:center;min-width:320px;">
                    <h5 style="margin-bottom:1.5rem;color:#dc3545"><i class="fa-solid fa-triangle-exclamation"></i> Lỗi nhập ngày</h5>
                    <div id="dateErrorMsg" style="margin-bottom:1.5rem;"></div>
                    <button id="closeDateError" class="btn btn-danger"><i class="fa-solid fa-xmark"></i> Đóng</button>
                </div>
            </div>
            <script>
                const leaveForm = document.getElementById('leaveForm');
                const modal = document.getElementById('dateErrorModal');
                const msgBox = document.getElementById('dateErrorMsg');
                const closeBtn = document.getElementById('closeDateError');
                const formCard = document.querySelector('.form-card');
                leaveForm.onsubmit = function(e) {
                    const from = document.querySelector('input[name="from_date"]').value;
                    const to = document.querySelector('input[name="to_date"]').value;
                    const today = new Date();
                    today.setHours(0,0,0,0);
                    const fromDate = from ? new Date(from) : null;
                    const toDate = to ? new Date(to) : null;
                    let msg = '';
                    if (!fromDate || fromDate < today) {
                        msg = 'Ngày bắt đầu phải từ hôm nay trở đi!';
                    } else if (!toDate || toDate <= fromDate) {
                        msg = 'Ngày kết thúc phải sau ngày bắt đầu!';
                    }
                    if (msg) {
                        msgBox.textContent = msg;
                        modal.style.display = 'flex';
                        e.preventDefault();
                    }
                };
                closeBtn.onclick = function() {
                    modal.style.display = 'none';
                };
            </script>
            <br>
            <a href="${pageContext.request.contextPath}/app/dashboard" class="back-link"><i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard</a>
        </div>
    </body>
</html>
