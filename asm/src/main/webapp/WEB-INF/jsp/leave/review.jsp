<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.LeaveRequest" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    LeaveRequest lr = (LeaveRequest) request.getAttribute("leave");
    long days = (Long) request.getAttribute("days");
    int remain = (Integer) request.getAttribute("remain");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Duyệt đơn #<%= lr.getId() %></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body { background: #f8fafc; }
            .review-card {
                max-width: 540px;
                margin: 60px auto;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(0,0,0,0.08);
                background: #fff;
                padding: 2.5rem 2.5rem 2rem 2.5rem;
            }
            .review-card h2 {
                font-size: 1.5rem;
                font-weight: 700;
                color: #4285F4;
            }
            .review-label { font-weight: 500; }
            .btn-approve {
                background: #28a745;
                color: #fff;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 600;
                margin-right: 1rem;
            }
            .btn-approve:hover { background: #218838; }
            .btn-reject {
                background: #dc3545;
                color: #fff;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
                font-weight: 600;
            }
            .btn-reject:hover { background: #b52a37; }
            .back-link { color: #4285F4; text-decoration: none; }
            .back-link:hover { text-decoration: underline; }
        </style>
    </head>
    <body>
        <div class="review-card">
            <h2><i class="fa-solid fa-file-signature"></i> Chi tiết đơn nghỉ phép #<%= lr.getId() %></h2>
            <c:choose>
                <c:when test="${lr.status eq 'INPROGRESS'}">
                    <span class="badge bg-primary mb-2">Chờ duyệt</span>
                </c:when>
                <c:when test="${lr.status eq 'APPROVED'}">
                    <span class="badge bg-success mb-2">Đã duyệt</span>
                </c:when>
                <c:when test="${lr.status eq 'REJECTED'}">
                    <span class="badge bg-danger mb-2">Bị từ chối</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-secondary mb-2">${lr.status}</span>
                </c:otherwise>
            </c:choose>
            <p><span class="review-label"><i class="fa-solid fa-user"></i> Nhân viên:</span> <%= lr.getEmployeeName() %> (ID: <%= lr.getEmployeeId() %>)</p>
            <p><span class="review-label"><i class="fa-solid fa-calendar-days"></i> Thời gian:</span> <%= lr.getFromDate() %> → <%= lr.getToDate() %> (<b><%= days %></b> ngày)</p>
            <p><span class="review-label"><i class="fa-solid fa-comment-dots"></i> Lý do:</span> <%= lr.getReason() %></p>
            <p><span class="review-label"><i class="fa-solid fa-hourglass-half"></i> Số ngày còn lại:</span> <b><%= remain %></b> / 12</p>
            <form method="post" action="${pageContext.request.contextPath}/app/leave/review">
                <input type="hidden" name="id" value="<%= lr.getId() %>" />
                <div class="mb-3">
                    <label class="form-label">Ghi chú:</label>
                    <textarea name="note" class="form-control" rows="3" maxlength="255"></textarea>
                </div>
                <button type="submit" name="action" value="APPROVE" class="btn btn-approve"><i class="fa-solid fa-check"></i> Duyệt</button>
                <button type="submit" name="action" value="REJECT" class="btn btn-reject"><i class="fa-solid fa-xmark"></i> Từ chối</button>
            </form>
            <br>
            <a href="${pageContext.request.contextPath}/app/leave/reviewlist" class="back-link"><i class="fa-solid fa-arrow-left"></i> Danh sách đơn</a>
        </div>
        <!-- Modal báo lỗi ghi chú -->
        <div id="noteErrorModal" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.25);align-items:center;justify-content:center;">
            <div style="background:#fff;padding:2rem 2.5rem;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,0.12);text-align:center;min-width:320px;">
                <h5 style="margin-bottom:1.5rem;color:#dc3545;"><i class="fa-solid fa-triangle-exclamation"></i> Lỗi ghi chú</h5>
                <div id="noteErrorMsg" style="margin-bottom:1.5rem;"></div>
                <button id="closeNoteError" class="btn btn-danger"><i class="fa-solid fa-xmark"></i> Đóng</button>
            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const reviewForm = document.querySelector('form');
                const noteModal = document.getElementById('noteErrorModal');
                const noteMsgBox = document.getElementById('noteErrorMsg');
                const closeNoteBtn = document.getElementById('closeNoteError');
                const reviewCard = document.querySelector('.review-card');

                function closeNoteModal() {
                    noteModal.style.display = 'none';
                    reviewCard.classList.remove('blur');
                }

                reviewForm.onsubmit = function (e) {
                    const note = document.querySelector('textarea[name="note"]').value;
                    if (note.length > 255) {
                        noteMsgBox.textContent = 'Ghi chú không được vượt quá 255 ký tự!';
                        noteModal.style.display = 'flex';
                        reviewCard.classList.add('blur');
                        e.preventDefault();
                    }
                };

                closeNoteBtn.onclick = closeNoteModal;
                noteModal.onclick = function (e) {
                    if (e.target === this)
                        closeNoteModal();
                };
            });
        </script>
    </body>
</html>
