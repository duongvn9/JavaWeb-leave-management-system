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
    </body>
</html>
