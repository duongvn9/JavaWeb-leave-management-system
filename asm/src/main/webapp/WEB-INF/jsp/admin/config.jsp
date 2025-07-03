<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cấu hình hệ thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .config-card {
            max-width: 600px;
            margin: 60px auto;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(0,0,0,0.08);
            background: #fff;
            padding: 2.5rem;
        }
        .custom-switch {
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }
        .custom-switch input[type="checkbox"] {
            width: 56px;
            height: 32px;
            appearance: none;
            background: #e0e0e0;
            outline: none;
            border-radius: 32px;
            position: relative;
            transition: background 0.2s;
            cursor: pointer;
            border: 2px solid #bdbdbd;
        }
        .custom-switch input[type="checkbox"]:checked {
            background: #28a745;
            border-color: #28a745;
        }
        .custom-switch input[type="checkbox"]::before {
            content: '';
            position: absolute;
            left: 4px;
            top: 4px;
            width: 24px;
            height: 24px;
            background: #fff;
            border-radius: 50%;
            transition: transform 0.2s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.10);
        }
        .custom-switch input[type="checkbox"]:checked::before {
            transform: translateX(24px);
        }
        .custom-switch label {
            font-size: 1.25rem;
            font-weight: 600;
            color: #222;
            display: flex;
            align-items: center;
            gap: 0.7rem;
            cursor: pointer;
            user-select: none;
        }
        .note-box {
            background: #f1f8e9;
            border-left: 5px solid #43a047;
            padding: 1rem 1.2rem;
            border-radius: 10px;
            margin-top: 1.2rem;
            color: #333;
            font-size: 1.08rem;
            display: flex;
            align-items: flex-start;
            gap: 0.7rem;
        }
        .note-box i {
            color: #43a047;
            font-size: 1.3rem;
            margin-top: 2px;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
        }
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@500&display=swap');
        :root {
          --sz: 44px;
          --on: #2eddf3;
          --of: #68838d;
          --tr: all 0.25s cubic-bezier(.4,2,.6,1);
        }
        .toggle-wrapper {
          display: flex;
          align-items: center;
          justify-content: center;
          margin-bottom: 1.2rem;
          gap: 1rem;
        }
        .toggle.ai-switch {
          position: relative;
          display: inline-block;
          width: calc(var(--sz) * 3.2);
          height: var(--sz);
        }
        .toggle.ai-switch input[type="checkbox"] {
          display: none;
        }
        .toggle.ai-switch label.toggle-item {
          display: block;
          width: 100%;
          height: 100%;
          background: #2e394d;
          border-radius: var(--sz);
          position: relative;
          cursor: pointer;
          transition: background 0.3s;
          box-shadow: 0 2px 8px #0002;
        }
        .toggle.ai-switch input[type="checkbox"]:checked + label.toggle-item {
          background: #43e97b;
        }
        .toggle.ai-switch .ai-face {
          position: absolute;
          top: 3px;
          left: 3px;
          width: calc(var(--sz) - 6px);
          height: calc(var(--sz) - 6px);
          background: #fff;
          border-radius: 50%;
          box-shadow: 0 2px 8px #0002;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1.7rem;
          color: #2e394d;
          transition: left 0.3s var(--tr), background 0.3s;
          z-index: 2;
        }
        .toggle.ai-switch input[type="checkbox"]:checked + label.toggle-item .ai-face {
          left: calc(100% - var(--sz) + 3px);
          background: #2eddf3;
          color: #fff;
        }
        .toggle.ai-switch .ai-track {
          position: absolute;
          top: 0; left: 0; right: 0; bottom: 0;
          border-radius: var(--sz);
          background: linear-gradient(90deg, #af4c4c 0%, #43e97b 100%);
          opacity: 0.13;
          z-index: 1;
        }
        .toggle.ai-switch .ai-label-text {
          margin-left: 1.5rem;
          font-size: 1.18rem;
          font-weight: 600;
          color: #222;
          letter-spacing: 0.5px;
          user-select: none;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }
        .toggle-label {
          font-size: 1.1rem;
          font-weight: 600;
          color: #666;
          user-select: none;
        }
        .toggle-label.on {
          color: #28a745;
        }
        .toggle-label.off {
          color: #dc3545;
        }
    </style>
</head>
<body>
    <!-- Toast Container -->
    <div class="toast-container">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-success text-white">
                    <i class="fa-solid fa-check-circle me-2"></i>
                    <strong class="me-auto">Thành công</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body">
                    ${sessionScope.successMessage}
                </div>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-danger text-white">
                    <i class="fa-solid fa-exclamation-triangle me-2"></i>
                    <strong class="me-auto">Lỗi</strong>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body">
                    ${sessionScope.errorMessage}
                </div>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
    </div>

    <div class="config-card">
        <form method="post" action="${pageContext.request.contextPath}/admin/config">
            <div class="mb-4">
                <div class="toggle-wrapper">
                    <span class="toggle-label off">TẮT</span>
                    <div class="toggle ai-switch">
                        <input type="checkbox" id="autoApprove" name="autoApprove" <c:if test="${autoApprove}">checked</c:if>>
                        <label class="toggle-item" for="autoApprove">
                            <span class="ai-track"></span>
                            <span class="ai-face"><i class="fa-solid fa-robot"></i></span>
                        </label>
                    </div>
                    <span class="toggle-label on">BẬT</span>
                </div>
                <div class="note-box">
                    <i class="fa-solid fa-info-circle"></i>
                    <div>
                        <b>Khi <span style='color:#28a745'>BẬT</span>:</b> Hệ thống sẽ <b>tự động duyệt/từ chối</b> đơn dựa trên đánh giá của AI theo chính sách của công ty.<br>
                        <b>Khi <span style='color:#dc3545'>TẮT</span>:</b> Tất cả đơn sẽ <b>chờ người duyệt xử lý thủ công</b>.
                    </div>
                </div>
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-save"></i> Lưu cấu hình
                </button>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-hide toasts after 5 seconds
        setTimeout(function() {
            const toasts = document.querySelectorAll('.toast');
            toasts.forEach(toast => {
                const bsToast = new bootstrap.Toast(toast);
                bsToast.hide();
            });
        }, 5000);
    </script>
</body>
</html> 