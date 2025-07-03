<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cấu hình chung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .config-container {
            max-width: 800px;
            margin: 2rem auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 2rem;
        }
        .config-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e9ecef;
        }
        .config-header h2 {
            color: #232946;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .config-header p {
            color: #666;
            margin: 0;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-label {
            font-weight: 600;
            color: #232946;
            margin-bottom: 0.5rem;
        }
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem;
            transition: border-color 0.2s;
        }
        .form-control:focus {
            border-color: #4285F4;
            box-shadow: 0 0 0 0.2rem rgba(66,133,244,0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #4285F4 0%, #34a853 100%);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(66,133,244,0.3);
        }
        .alert {
            border-radius: 8px;
            border: none;
        }
        .form-check-input:checked {
            background-color: #4285F4;
            border-color: #4285F4;
        }
    </style>
</head>
<body>
    <div class="config-container">
        <div class="config-header">
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-check-circle"></i> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-exclamation-triangle"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <form method="POST" action="${pageContext.request.contextPath}/admin/general-config">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="systemName" class="form-label">
                            <i class="fa-solid fa-tag"></i> Tên hệ thống
                        </label>
                        <input type="text" class="form-control" id="systemName" name="systemName" 
                               value="${systemName}" required>
                        <div class="form-text">Tên hiển thị của hệ thống</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="companyName" class="form-label">
                            <i class="fa-solid fa-building"></i> Tên công ty
                        </label>
                        <input type="text" class="form-control" id="companyName" name="companyName" 
                               value="${companyName}" required>
                        <div class="form-text">Tên công ty sử dụng hệ thống</div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="maxLeaveDays" class="form-label">
                            <i class="fa-solid fa-calendar-days"></i> Số ngày nghỉ tối đa/năm
                        </label>
                        <input type="number" class="form-control" id="maxLeaveDays" name="maxLeaveDays" 
                               value="${maxLeaveDays}" min="1" max="365" required>
                        <div class="form-text">Số ngày nghỉ phép tối đa cho mỗi nhân viên</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fa-solid fa-envelope"></i> Thông báo email
                        </label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="emailNotification" 
                                   name="emailNotification" ${emailNotification ? 'checked' : ''}>
                            <label class="form-check-label" for="emailNotification">
                                Bật thông báo email khi có đơn nghỉ phép mới
                            </label>
                        </div>
                        <div class="form-text">Gửi email thông báo cho quản lý khi có đơn mới</div>
                    </div>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-save"></i> Lưu cấu hình
                </button>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 