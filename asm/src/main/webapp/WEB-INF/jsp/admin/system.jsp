<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản trị hệ thống</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                body {
                    background: #f8fafc;
                }

                .admin-system-wrapper {
                    display: flex;
                    min-height: 100vh;
                }

                .sidebar {
                    width: 280px;
                    background: linear-gradient(135deg, #232946 0%, #1a1f35 100%);
                    color: #fff;
                    padding: 2rem 1rem 1rem 1rem;
                    display: flex;
                    flex-direction: column;
                    align-items: flex-start;
                    min-height: 100vh;
                    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
                    transition: transform 0.3s ease, width 0.3s ease;
                    position: relative;
                }

                .sidebar-toggle {
                    position: fixed;
                    top: 2rem;
                    left: 0.5rem;
                    background: linear-gradient(135deg, #4285F4 0%, #34a853 100%);
                    color: #fff;
                    border: none;
                    width: 36px;
                    height: 36px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                    transition: all 0.3s ease;
                    z-index: 3000;
                }

                .sidebar-toggle:hover {
                    transform: scale(1.1);
                    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                }

                .sidebar-toggle i {
                    transition: transform 0.3s ease;
                }

                .sidebar.collapsed {
                    width: 0 !important;
                    min-width: 0 !important;
                    padding: 0 !important;
                    overflow: visible !important;
                }

                .sidebar.collapsed > * {
                    display: none !important;
                }

                .sidebar.collapsed ~ .sidebar-toggle i {
                    transform: rotate(180deg);
                }

                @media (max-width: 600px) {
                    .sidebar-toggle { top: 1rem; left: 0.2rem; width: 32px; height: 32px; }
                }

                .sidebar .nav-link {
                    color: #fff;
                    font-size: 1rem;
                    margin-bottom: 0.5rem;
                    border-radius: 8px;
                    padding: 0.8rem 1.2rem;
                    width: 100%;
                    text-align: left;
                    transition: all 0.3s ease;
                    border: 1px solid transparent;
                    display: flex;
                    align-items: center;
                    gap: 0.8rem;
                }

                .sidebar .nav-link.active,
                .sidebar .nav-link:hover {
                    background: linear-gradient(135deg, #4285F4 0%, #34a853 100%);
                    color: #fff;
                    transform: translateX(5px);
                    box-shadow: 0 4px 12px rgba(66,133,244,0.3);
                }

                .sidebar .nav-link.back {
                    background: #fff;
                    color: #232946;
                    font-weight: 600;
                    border: 2px solid #4285F4;
                    margin-top: auto;
                    margin-bottom: 0;
                    text-align: center;
                    justify-content: center;
                }

                .sidebar .nav-link.back:hover {
                    background: #4285F4;
                    color: #fff;
                }

                .sidebar .sidebar-title {
                    font-size: 1.4rem;
                    font-weight: 700;
                    margin-bottom: 2rem;
                    color: #fff;
                    letter-spacing: 1px;
                    text-align: center;
                    width: 100%;
                    padding-bottom: 1rem;
                    border-bottom: 2px solid #4285F4;
                }

                .sidebar .nav-section {
                    width: 100%;
                    margin-bottom: 1.5rem;
                }

                .sidebar .nav-section-title {
                    font-size: 0.9rem;
                    font-weight: 600;
                    color: #a0a0a0;
                    margin-bottom: 0.8rem;
                    padding-left: 0.5rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .system-content {
                    flex: 1;
                    padding: 0;
                    background: #f8fafc;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    transition: margin-left 0.3s ease;
                }

                .system-content.sidebar-collapsed {
                    margin-left: 0;
                }

                .tab-pane {
                    display: none;
                    flex: 1;
                    height: 100%;
                }

                .tab-pane.active {
                    display: flex;
                    flex-direction: column;
                    flex: 1;
                    height: 100%;
                }

                .tab-pane iframe {
                    flex: 1;
                    width: 100%;
                    height: 100%;
                    min-height: 0;
                    border: none;
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 12px rgba(0,0,0,0.04);
                }

                .header-bar {
                    background: #fff;
                    padding: 1rem 2rem;
                    border-bottom: 1px solid #e9ecef;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                }

                .header-title {
                    font-size: 1.5rem;
                    font-weight: 600;
                    color: #232946;
                    margin: 0;
                    transition: margin-left 0.3s;
                }

                .sidebar.collapsed ~ .system-content .header-title {
                    margin-left: 56px;
                }

                @media (max-width: 600px) {
                    .sidebar.collapsed ~ .system-content .header-title {
                        margin-left: 40px;
                    }
                }

                .user-info {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .logout-btn {
                    background: #dc3545;
                    color: #fff;
                    border: none;
                    padding: 0.5rem 1rem;
                    border-radius: 6px;
                    text-decoration: none;
                    transition: background 0.2s;
                }

                .logout-btn:hover {
                    background: #b52a37;
                    color: #fff;
                }
                
                .home-btn {
                    background: linear-gradient(135deg, #4285F4 0%, #34a853 100%);
                    color: #fff;
                    padding: 0.5rem 1rem;
                    border-radius: 6px;
                    text-decoration: none;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    border: none;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }
                .home-btn:hover {
                    color: #fff;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(66,133,244,0.3);
                }
                .header-left {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }
                .blur {
                    filter: blur(4px);
                    pointer-events: none;
                    user-select: none;
                }
            </style>
        </head>

        <body>
            <div class="admin-system-wrapper">
                <button class="sidebar-toggle" id="sidebarToggle" title="Ẩn/Hiện menu">
                    <i class="fa-solid fa-chevron-left"></i>
                </button>
                <nav class="sidebar" id="sidebar">
                    <div class="sidebar-title">
                        <a href="#" id="sidebar-home-btn" style="color:inherit;text-decoration:none;display:flex;align-items:center;gap:0.7rem;font-weight:700;font-size:1.3rem;">
                            <i class="fa-solid fa-shield-halved"></i> Quản trị hệ thống
                        </a>
                    </div>
                    <div class="nav-section">
                        <div class="nav-section-title">Đơn nghỉ phép</div>
                        <a href="#" class="nav-link" id="menu-leave-review">
                            <i class="fa-solid fa-clipboard-check"></i> Duyệt đơn
                        </a>
                        <a href="#" class="nav-link" id="menu-leave-list">
                            <i class="fa-solid fa-list"></i> Danh sách đơn của tôi
                        </a>
                        <a href="#" class="nav-link" id="menu-leave-create">
                            <i class="fa-solid fa-plus-circle"></i> Tạo đơn nghỉ phép
                        </a>
                    </div>
                    <div class="nav-section">
                        <div class="nav-section-title">Quản lý nhân viên</div>
                        
                        <a href="#" class="nav-link" id="menu-user">
                            <i class="fa-solid fa-users"></i> Sửa thông tin
                        </a>
                        
                        <a href="#" class="nav-link" id="menu-userform">
                            <i class="fa-solid fa-user-plus"></i> Thêm nhân viên
                        </a>
                        <a href="#" class="nav-link" id="menu-dept-userlist">
                            <i class="fa-solid fa-address-book"></i> Danh sách nhân viên
                        </a>
                    </div>
                    <div class="nav-section">
                        <div class="nav-section-title">Cấu hình hệ thống</div>
                        <a href="#" class="nav-link" id="menu-auto">
                            <i class="fa-solid fa-robot"></i> Tự động duyệt
                        </a>
                        <a href="#" class="nav-link" id="menu-config">
                            <i class="fa-solid fa-cogs"></i> Cấu hình chung
                        </a>
                    </div>
                    <div class="nav-section">
                        <div class="nav-section-title">Báo cáo & Thống kê</div>
                        <a href="#" class="nav-link" id="menu-reports">
                            <i class="fa-solid fa-chart-bar"></i> Báo cáo tổng quan
                        </a>
                        <a href="#" class="nav-link" id="menu-analytics">
                            <i class="fa-solid fa-chart-line"></i> Thống kê chi tiết
                        </a>
                    </div>
                    <div class="nav-section">
                        <div class="nav-section-title">Khác</div>
                        <a href="#" class="nav-link" id="menu-about">
                            <i class="fa-solid fa-circle-info"></i> Giới thiệu
                        </a>
                    </div>
                </nav>
                
                <div class="system-content" id="systemContent">
                    <div class="header-bar">
                        <div class="header-left">
                            <h1 class="header-title" id="page-title">Quản lý hệ thống</h1>
                        </div>
                        <div class="user-info">
                            <span>${sessionScope.user.fullName}</span>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" id="logoutBtn">
                                <i class="fa-solid fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                    
                    <div id="tab-home" class="tab-pane active">
                        <div style="flex:1;display:flex;align-items:center;justify-content:center;min-height:60vh;padding:2rem;">
                            <div style="text-align:center;max-width:600px;margin:0 auto;">
                                <div style="background: linear-gradient(135deg, #4285F4 0%, #34a853 100%); width: 90px; height: 90px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto; box-shadow: 0 8px 32px rgba(66,133,244,0.15);">
                                    <i class="fa-solid fa-shield-halved" style="font-size:2rem;color:#fff;"></i>
                                </div>
                                <h2 style="font-size:2rem;font-weight:800;margin-bottom:1rem;color:#232946; white-space:nowrap;">Chào mừng đến trang quản trị hệ thống</h2>
                                <div style="font-size:1.1rem;color:#555;line-height:1.7;">Chọn chức năng từ menu bên trái để bắt đầu quản lý.</div>
                            </div>
                        </div>
                    </div>
                    
                    <div id="tab-user" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/admin/users"></iframe>
                    </div>
                    <div id="tab-dept-userlist" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/app/department/users"></iframe>
                    </div>
                    
                    <div id="tab-userform" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/admin/users/form"></iframe>
                    </div>
                    
                    <div id="tab-auto" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/admin/config"></iframe>
                    </div>
                    
                    <div id="tab-config" class="tab-pane">
                        <div style="flex:1;display:flex;align-items:center;justify-content:center;min-height:60vh;">
                            <div style="text-align:center;">
                                <i class="fa-solid fa-cogs" style="font-size:4rem;color:#a259d9;margin-bottom:1.5rem;"></i>
                                <h2 style="font-size:2rem;font-weight:700;margin:1rem 0;color:#232946;">Cấu hình chung</h2>
                                <p style="font-size:1.1rem;color:#666;">Tính năng đang được phát triển...</p>
                            </div>
                        </div>
                    </div>
                    
                    <div id="tab-reports" class="tab-pane">
                        <div style="flex:1;display:flex;align-items:center;justify-content:center;min-height:60vh;">
                            <div style="text-align:center;">
                                <i class="fa-solid fa-chart-bar" style="font-size:4rem;color:#34a853;margin-bottom:1.5rem;"></i>
                                <h2 style="font-size:2rem;font-weight:700;margin:1rem 0;color:#232946;">Báo cáo tổng quan</h2>
                                <p style="font-size:1.1rem;color:#666;">Tính năng đang được phát triển...</p>
                            </div>
                        </div>
                    </div>
                    
                    <div id="tab-analytics" class="tab-pane">
                        <div style="flex:1;display:flex;align-items:center;justify-content:center;min-height:60vh;">
                            <div style="text-align:center;">
                                <i class="fa-solid fa-chart-line" style="font-size:4rem;color:#fbbc05;margin-bottom:1.5rem;"></i>
                                <h2 style="font-size:2rem;font-weight:700;margin:1rem 0;color:#232946;">Thống kê chi tiết</h2>
                                <p style="font-size:1.1rem;color:#666;">Tính năng đang được phát triển...</p>
                            </div>
                        </div>
                    </div>
                    
                    <div id="tab-leave-list" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/app/leave/list"></iframe>
                    </div>
                    <div id="tab-leave-review" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/app/leave/reviewlist"></iframe>
                    </div>
                    <div id="tab-leave-create" class="tab-pane">
                        <iframe src="${pageContext.request.contextPath}/app/leave/create"></iframe>
                    </div>
                    <div id="tab-about" class="tab-pane">
                        <div style="flex:1;display:flex;align-items:center;justify-content:center;min-height:60vh;">
                            <div style="text-align:center;max-width:500px;margin:0 auto;">
                                <h2 style="font-size:2rem;font-weight:800;margin-bottom:1.2rem;color:#232946;"><i class="fa-solid fa-circle-info"></i> Giới thiệu hệ thống</h2>
                                <div style="font-size:1.1rem;color:#666;margin-bottom:2rem;">About project: JavaWeb Leave Management System &nbsp;|&nbsp; <b>ver 1.5</b></div>
                                <a href="https://github.com/duongvn9/JavaWeb-leave-management-system" target="_blank" class="btn btn-dark me-2" style="text-decoration:none; font-size:1.25rem; padding:0.9rem 2.2rem; border-radius:10px; display:inline-flex; align-items:center; gap:0.7rem;">
                                    <i class="fab fa-github" style="font-size:1.6rem;"></i> GitHub
                                </a>
                                <a href="https://www.facebook.com/ngocduonggvu" target="_blank" class="btn btn-primary" style="text-decoration:none; font-size:1.25rem; padding:0.9rem 2.2rem; border-radius:10px; display:inline-flex; align-items:center; gap:0.7rem;">
                                    <i class="fab fa-facebook" style="font-size:1.6rem;"></i> Facebook
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal xác nhận đăng xuất -->
            <div id="logoutModal" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100vw;height:100vh;background:rgba(0,0,0,0.25);align-items:center;justify-content:center;">
                <div id="logoutModalContent" style="background:#fff;padding:2rem 2.5rem;border-radius:14px;box-shadow:0 4px 24px rgba(0,0,0,0.12);text-align:center;min-width:320px;">
                    <h5 style="margin-bottom:1.5rem;"><i class="fa-solid fa-sign-out-alt text-danger"></i> Xác nhận đăng xuất?</h5>
                    <button id="confirmLogout" class="btn btn-danger me-2"><i class="fa-solid fa-check"></i> Đăng xuất</button>
                    <button id="cancelLogout" class="btn btn-secondary"><i class="fa-solid fa-xmark"></i> Hủy</button>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Lưu trữ trạng thái sidebar
                let sidebarCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
                
                // Khởi tạo trạng thái sidebar
                function initSidebar() {
                    const sidebar = document.getElementById('sidebar');
                    const systemContent = document.getElementById('systemContent');
                    
                    if (sidebarCollapsed) {
                        sidebar.classList.add('collapsed');
                        systemContent.classList.add('sidebar-collapsed');
                    }
                }
                
                // Toggle sidebar
                function toggleSidebar() {
                    const sidebar = document.getElementById('sidebar');
                    const systemContent = document.getElementById('systemContent');
                    
                    sidebarCollapsed = !sidebarCollapsed;
                    localStorage.setItem('sidebarCollapsed', sidebarCollapsed);
                    
                    if (sidebarCollapsed) {
                        sidebar.classList.add('collapsed');
                        systemContent.classList.add('sidebar-collapsed');
                    } else {
                        sidebar.classList.remove('collapsed');
                        systemContent.classList.remove('sidebar-collapsed');
                    }
                }
                
                // Xử lý chuyển tab sidebar
                const menuItems = {
                    'menu-user': { tab: 'user', title: 'Sửa thông tin nhân viên' },
                    'menu-userform': { tab: 'userform', title: 'Thêm nhân viên' },
                    'menu-auto': { tab: 'auto', title: 'Tự động duyệt' },
                    'menu-config': { tab: 'config', title: 'Cấu hình chung' },
                    'menu-reports': { tab: 'reports', title: 'Báo cáo tổng quan' },
                    'menu-analytics': { tab: 'analytics', title: 'Thống kê chi tiết' },
                    'menu-leave-list': { tab: 'leave-list', title: 'Danh sách đơn của tôi' },
                    'menu-leave-review': { tab: 'leave-review', title: 'Duyệt đơn' },
                    'menu-leave-create': { tab: 'leave-create', title: 'Tạo đơn nghỉ phép' },
                    'menu-about': { tab: 'about', title: 'Giới thiệu' },
                    'menu-dept-userlist': { tab: 'dept-userlist', title: 'Danh sách nhân viên' }
                };
                
                // Xử lý sidebar home (nút trên cùng bên trái)
                document.getElementById('sidebar-home-btn').onclick = function(e) {
                    e.preventDefault();
                    setActiveTab('home');
                    document.getElementById('page-title').textContent = 'Quản lý hệ thống';
                    localStorage.removeItem('adminSystemTab');
                };
                
                Object.keys(menuItems).forEach(menuId => {
                    document.getElementById(menuId).onclick = function(e) {
                        e.preventDefault();
                        const item = menuItems[menuId];
                        setActiveTab(item.tab);
                        document.getElementById('page-title').textContent = item.title;
                        localStorage.setItem('adminSystemTab', item.tab);
                    };
                });
                
                function setActiveTab(tab) {
                    // Remove active class from all menu items
                    Object.keys(menuItems).forEach(menuId => {
                        document.getElementById(menuId).classList.remove('active');
                    });
                    
                    // Remove active class from all tab panes
                    Object.values(menuItems).forEach(item => {
                        document.getElementById('tab-' + item.tab).classList.remove('active');
                    });
                    document.getElementById('tab-home').classList.remove('active');
                    
                    // Add active class to selected menu and tab
                    if (tab !== 'home') {
                        const menuId = Object.keys(menuItems).find(key => menuItems[key].tab === tab);
                        if (menuId) {
                            document.getElementById(menuId).classList.add('active');
                        }
                        document.getElementById('tab-' + tab).classList.add('active');
                    } else {
                        document.getElementById('tab-home').classList.add('active');
                    }
                }
                
                // Khôi phục trạng thái tab khi load trang
                function restoreTabState() {
                    const lastTab = localStorage.getItem('adminSystemTab');
                    if (lastTab && lastTab !== 'home') {
                        setActiveTab(lastTab);
                        const item = Object.values(menuItems).find(item => item.tab === lastTab);
                        if (item) {
                            document.getElementById('page-title').textContent = item.title;
                        }
                    } else {
                        setActiveTab('home');
                        document.getElementById('page-title').textContent = 'Quản lý hệ thống';
                    }
                }
                
                // Khi load lại trang, khởi tạo sidebar và khôi phục tab state
                window.addEventListener('DOMContentLoaded', function() {
                    // Khởi tạo sidebar
                    initSidebar();
                    
                    // Khôi phục tab state
                    restoreTabState();
                    
                    // Xử lý sự kiện toggle sidebar
                    document.getElementById('sidebarToggle').addEventListener('click', toggleSidebar);
                });
                
                // Xử lý modal đăng xuất
                document.getElementById('logoutBtn').onclick = function(e) {
                    e.preventDefault();
                    document.getElementById('logoutModal').style.display = 'flex';
                    document.querySelector('.admin-system-wrapper').classList.add('blur');
                };
                document.getElementById('cancelLogout').onclick = function() {
                    document.getElementById('logoutModal').style.display = 'none';
                    document.querySelector('.admin-system-wrapper').classList.remove('blur');
                };
                document.getElementById('confirmLogout').onclick = function() {
                    window.location.href = document.getElementById('logoutBtn').href;
                };
                // Đóng modal khi click ra ngoài
                document.getElementById('logoutModal').onclick = function(e) {
                    if (e.target === this) {
                        this.style.display = 'none';
                        document.querySelector('.admin-system-wrapper').classList.remove('blur');
                    }
                };
            </script>
        </body>

        </html>