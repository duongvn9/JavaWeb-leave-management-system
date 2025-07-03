<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="asm.model.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    User u = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    java.util.Set<String> roles = (java.util.Set<String>) session.getAttribute("roles");
    String roleName = (String) request.getAttribute("roleName");
    String deptName = (String) request.getAttribute("deptName");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body { background: #f8fafc; }
            .dashboard-container {
                max-width: 950px;
                margin: 60px auto;
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 6px 32px rgba(0,0,0,0.08);
                padding: 2.5rem 2.5rem 2rem 2.5rem;
                position: relative;
            }
            .logout-btn {
                position: absolute;
                top: 24px;
                left: 32px;
                right: unset;
                color: #fff !important;
                background: #dc3545;
                border-radius: 8px;
                padding: 0.5rem 1.2rem;
                font-size: 1rem;
                font-weight: 500;
                border: none;
                transition: background 0.2s;
                z-index: 2;
                text-decoration: none !important;
            }
            .logout-btn:hover {
                background: #b52a37;
            }
            .dashboard-header {
                margin-bottom: 2.2rem;
            }
            .dashboard-header h1 {
                font-size: 2rem;
                font-weight: 700;
                color: #4285F4;
            }
            .dashboard-header p {
                color: #888;
            }
            .dashboard-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 1.5rem;
            }
            .dashboard-card-item {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                border-radius: 14px;
                padding: 1.5rem 1rem;
                font-size: 1.1rem;
                font-weight: 500;
                color: #fff;
                box-shadow: 0 2px 12px rgba(0,0,0,0.06);
                text-decoration: none !important;
                transition: transform 0.15s, box-shadow 0.15s;
                height: 140px;
                min-height: 140px;
            }
            .dashboard-card-item:hover {
                transform: translateY(-4px) scale(1.03);
                box-shadow: 0 6px 24px rgba(66,133,244,0.13);
                text-decoration: none !important;
            }
            .card-blue { background: linear-gradient(120deg, #4285F4 60%, #6dd5ed 100%); }
            .card-green { background: linear-gradient(120deg, #34a853 60%, #b6e6bd 100%); }
            .card-orange { background: linear-gradient(120deg, #fbbc05 60%, #ffe082 100%); color: #333; }
            .card-purple { background: linear-gradient(120deg, #a259d9 60%, #e0c3fc 100%); }
            .card-pink { background: linear-gradient(120deg, #ff6f91 60%, #fbc2eb 100%); }
            .card-grey { background: linear-gradient(120deg, #607d8b 60%, #b0bec5 100%); }
            .dashboard-card-item i { font-size: 1.7rem; margin-bottom: 0.7rem; }
            .dashboard-card-item span { 
                font-size: 1.08rem; 
                font-weight: 500; 
                text-align: center;
                line-height: 1.3;
                word-wrap: break-word;
                max-width: 100%;
            }
            .blur {
                filter: blur(4px);
                pointer-events: none;
                user-select: none;
            }
            
            /* Responsive adjustments */
            @media (max-width: 768px) {
                .dashboard-grid {
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                }
                .dashboard-card-item {
                    height: 120px;
                    min-height: 120px;
                    padding: 1rem 0.8rem;
                }
                .dashboard-card-item i {
                    font-size: 1.5rem;
                    margin-bottom: 0.5rem;
                }
                .dashboard-card-item span {
                    font-size: 1rem;
                }
            }
            
            @media (max-width: 480px) {
                .dashboard-grid {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                }
                .dashboard-card-item {
                    height: 100px;
                    min-height: 100px;
                }
            }
        </style>
    </head>
    <body>
        <a href="#" class="logout-btn" id="logoutBtn">
            <i class="fa-solid fa-sign-out-alt"></i> Đăng xuất
        </a>
        <div class="dashboard-container">
            <div class="dashboard-header text-center">
                <h1><i class="fa-solid fa-gauge-high"></i> Xin chào, <%= u.getFullName() %>
                    <c:if test="${not empty roleName || not empty deptName}"> -
                        <c:if test="${not empty roleName}">${roleName}</c:if>
                        <c:if test="${not empty deptName}"> ${deptName}</c:if>!
                    </c:if>
                </h1>
                <p class="text-muted"><i class="fa-solid fa-envelope"></i> <%= u.getEmail() %></p>
            </div>
            <div class="dashboard-grid">
                <a href="<%= request.getContextPath() %>/app/leave/create" class="dashboard-card-item card-blue">
                    <i class="fa-solid fa-plus-circle"></i>
                    <span>Tạo đơn nghỉ phép</span>
                </a>
                <a href="<%= request.getContextPath() %>/app/leave/list" class="dashboard-card-item card-green">
                    <i class="fa-solid fa-list"></i>
                    <span>Danh sách đơn của tôi</span>
                </a>
                <c:if test="${roles != null && (roles.contains('LEADER') || roles.contains('ADMIN'))}">
                    <a href="<%= request.getContextPath() %>/app/department/users" class="dashboard-card-item card-orange">
                        <i class="fa-solid fa-users"></i>
                        <span>Danh sách nhân viên phòng ban</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/app/leave/reviewlist" class="dashboard-card-item card-purple">
                        <i class="fa-solid fa-clipboard-check"></i>
                        <span>Duyệt đơn nhân viên</span>
                    </a>
                </c:if>
            </div>
            <footer class="footer text-center" style="width:100%; position:fixed; left:0; bottom:0; background:rgba(255,255,255,0.95); padding: 1rem 0; box-shadow: 0 -2px 12px rgba(0,0,0,0.04); z-index:10;">
                <div class="mb-2" style="font-size:1.05rem; color:#666;">About project: JavaWeb Leave Management System &nbsp;|&nbsp; <b>ver 1.4</b></div>
                <a href="https://github.com/duongvn9/JavaWeb-leave-management-system" target="_blank" class="btn btn-dark me-2" style="text-decoration:none;"><i class="fab fa-github"></i> GitHub</a>
                <a href="https://www.facebook.com/ngocduonggvu" target="_blank" class="btn btn-primary" style="text-decoration:none;"><i class="fab fa-facebook"></i> Facebook</a>
            </footer>
        </div>
        <!-- Modal xác nhận đăng xuất -->
        <div id="logoutModal" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.25);align-items:center;justify-content:center;">
            <div id="logoutModalContent" style="background:#fff;padding:2rem 2.5rem;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,0.12);text-align:center;min-width:320px;">
                <h5 style="margin-bottom:1.5rem;"><i class="fa-solid fa-sign-out-alt text-danger"></i> Xác nhận đăng xuất?</h5>
                <button id="confirmLogout" class="btn btn-danger me-2"><i class="fa-solid fa-check"></i> Đăng xuất</button>
                <button id="cancelLogout" class="btn btn-secondary"><i class="fa-solid fa-xmark"></i> Hủy</button>
            </div>
        </div>
        <script>
            document.getElementById('logoutBtn').onclick = function(e) {
                e.preventDefault();
                document.getElementById('logoutModal').style.display = 'flex';
                document.querySelector('.dashboard-container').classList.add('blur');
            };
            document.getElementById('cancelLogout').onclick = function() {
                document.getElementById('logoutModal').style.display = 'none';
                document.querySelector('.dashboard-container').classList.remove('blur');
            };
            document.getElementById('confirmLogout').onclick = function() {
                window.location.href = '<%= request.getContextPath() %>/logout';
            };
            document.getElementById('logoutModal').onclick = function(e) {
                if (e.target === this) {
                    this.style.display = 'none';
                    document.querySelector('.dashboard-container').classList.remove('blur');
                }
            };
        </script>
    </body>
</html>
