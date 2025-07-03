<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.LeaveRequest" %>
<%
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leaveRequest");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sửa đơn nghỉ phép</title>
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
            .btn-save {
                background: #4285F4;
                color: #fff;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 600;
            }
            .btn-save:hover { background: #2a65c4; }
            .back-link { color: #4285F4; text-decoration: none; }
            .back-link:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <div class="form-card">
            <h2><i class="fa-solid fa-pen-to-square"></i> Sửa đơn nghỉ phép</h2>
            <form method="post" action="${pageContext.request.contextPath}/app/leave/edit?id=<%= lr.getId() %>">
                <div class="mb-3">
                    <label class="form-label">Từ ngày:</label>
                    <input type="date" class="form-control" name="from_date" value="<%= lr.getFromDate() %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Đến ngày:</label>
                    <input type="date" class="form-control" name="to_date" value="<%= lr.getToDate() %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Lý do:</label>
                    <textarea name="reason" class="form-control" rows="3"><%= lr.getReason() %></textarea>
                </div>
                <button type="submit" class="btn btn-save"><i class="fa-solid fa-save"></i> Lưu thay đổi</button>
            </form>
            <br>
            <a href="${pageContext.request.contextPath}/app/leave/list" class="back-link"><i class="fa-solid fa-arrow-left"></i> Quay lại danh sách</a>
        </div>
        <!-- Modal báo lỗi ngày -->
        <div id="dateErrorModal" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.25);align-items:center;justify-content:center;">
            <div id="dateErrorModalContent" style="background:#fff;padding:2rem 2.5rem;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,0.12);text-align:center;min-width:320px;">
                <h5 style="margin-bottom:1.5rem;color:#dc3545;"><i class="fa-solid fa-triangle-exclamation"></i> Lỗi nhập ngày</h5>
                <div id="dateErrorMsg" style="margin-bottom:1.5rem;"></div>
                <button id="closeDateError" class="btn btn-danger"><i class="fa-solid fa-xmark"></i> Đóng</button>
            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const leaveForm = document.querySelector('form');
                const modal = document.getElementById('dateErrorModal');
                const msgBox = document.getElementById('dateErrorMsg');
                const closeBtn = document.getElementById('closeDateError');
                const formCard = document.querySelector('.form-card');

                function closeModal() {
                    modal.style.display = 'none';
                    formCard.classList.remove('blur');
                }

                leaveForm.onsubmit = function (e) {
                    const from = document.querySelector('input[name="from_date"]').value;
                    const to = document.querySelector('input[name="to_date"]').value;
                    const reason = document.querySelector('textarea[name="reason"]').value;
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    const fromDate = from ? new Date(from) : null;
                    const toDate = to ? new Date(to) : null;
                    let msg = '';
                    if (!fromDate || fromDate < today) {
                        msg = 'Ngày bắt đầu phải từ hôm nay trở đi!';
                    } else if (!toDate || toDate <= fromDate) {
                        msg = 'Ngày kết thúc phải sau ngày bắt đầu!';
                    } else if (reason.length > 255) {
                        msg = 'Lý do không được vượt quá 255 ký tự!';
                    }
                    if (msg) {
                        msgBox.textContent = msg;
                        modal.style.display = 'flex';
                        formCard.classList.add('blur');
                        e.preventDefault();
                    }
                };

                closeBtn.onclick = closeModal;

                modal.onclick = function (e) {
                    if (e.target === this)
                        closeModal();
                };
            });
        </script>
    </body>
</html>
