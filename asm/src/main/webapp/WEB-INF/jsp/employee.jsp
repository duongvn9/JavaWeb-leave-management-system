<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f8fafc; }
        .employee-wrapper { display: flex; min-height: 100vh; }
        .sidebar {
            width: 250px;
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
        .sidebar .sidebar-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 2rem;
            color: #fff;
            letter-spacing: 1px;
            width: 100%;
            display: flex;
            align-items: center;
            gap: 0.7rem;
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
        .sidebar .nav-link.active, .sidebar .nav-link:hover {
            background: linear-gradient(135deg, #4285F4 0%, #34a853 100%);
            color: #fff;
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(66,133,244,0.3);
        }
        .system-content {
            flex: 1;
            padding: 0;
            background: #f8fafc;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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
        .tab-pane { display: none; flex: 1; height: 100%; }
        .tab-pane.active { display: flex; flex-direction: column; flex: 1; height: 100%; }
        .tab-pane iframe { flex: 1; width: 100%; height: 100%; min-height: 0; border: none; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); }
        .blur { filter: blur(4px); pointer-events: none; user-select: none; }
        .sidebar.collapsed ~ .system-content .header-title {
            margin-left: 56px;
        }
        @media (max-width: 600px) {
            .sidebar.collapsed ~ .system-content .header-title {
                margin-left: 40px;
            }
        }
    </style>
</head>
<body>
<div class="employee-wrapper">
    <button class="sidebar-toggle" id="sidebarToggle" title="Ẩn/Hiện menu">
        <i class="fa-solid fa-chevron-left"></i>
    </button>
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-title">
            <a href="#" id="sidebar-home-btn" style="color:inherit;text-decoration:none;display:flex;align-items:center;gap:0.7rem;font-weight:700;font-size:1.3rem;">
                <i class="fa-solid fa-user"></i> Nhân viên
            </a>
        </div>
        <a href="#" class="nav-link" id="menu-leave-create">
            <i class="fa-solid fa-plus-circle"></i> Tạo đơn nghỉ phép
        </a>
        <a href="#" class="nav-link" id="menu-leave-list">
            <i class="fa-solid fa-list"></i> Danh sách đơn của tôi
        </a>
    </nav>
    <div class="system-content" id="systemContent">
        <div class="header-bar">
            <h1 class="header-title" id="page-title">Trang nhân viên</h1>
            <div class="user-info">
                <span><i class="fa-solid fa-user"></i> ${sessionScope.user.fullName}</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn" id="logoutBtn">
                    <i class="fa-solid fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
        <div id="tab-home" class="tab-pane active">
            <div style="flex:1;display:flex;align-items:center;justify-content:center;min-height:60vh;padding:2rem;">
                <div style="text-align:center;max-width:600px;margin:0 auto;">
                    <div style="background: linear-gradient(135deg, #4285F4 0%, #34a853 100%); width: 90px; height: 90px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem auto; box-shadow: 0 8px 32px rgba(66,133,244,0.15);">
                        <i class="fa-solid fa-user" style="font-size:2rem;color:#fff;"></i>
                    </div>
                    <h2 style="font-size:2rem;font-weight:800;margin-bottom:1rem;color:#232946;">Chào mừng, ${sessionScope.user.fullName}!</h2>
                    <div style="font-size:1.1rem;color:#555;line-height:1.7;">Bạn có thể tạo đơn nghỉ phép hoặc xem lại các đơn đã gửi ở menu bên trái.</div>
                </div>
            </div>
        </div>
        <div id="tab-leave-create" class="tab-pane">
            <iframe src="${pageContext.request.contextPath}/app/leave/create"></iframe>
        </div>
        <div id="tab-leave-list" class="tab-pane">
            <iframe src="${pageContext.request.contextPath}/app/leave/list"></iframe>
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
    let sidebarCollapsed = localStorage.getItem('employeeSidebarCollapsed') === 'true';
    
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
        localStorage.setItem('employeeSidebarCollapsed', sidebarCollapsed);
        
        if (sidebarCollapsed) {
            sidebar.classList.add('collapsed');
            systemContent.classList.add('sidebar-collapsed');
        } else {
            sidebar.classList.remove('collapsed');
            systemContent.classList.remove('sidebar-collapsed');
        }
    }
    // Sidebar home
    document.getElementById('sidebar-home-btn').onclick = function(e) {
        e.preventDefault();
        setActiveTab('home');
        document.getElementById('page-title').textContent = 'Trang nhân viên';
        localStorage.removeItem('employeeTab');
    };
    // Tab menu
    const menuItems = {
        'menu-leave-create': { tab: 'leave-create', title: 'Tạo đơn nghỉ phép' },
        'menu-leave-list': { tab: 'leave-list', title: 'Danh sách đơn của tôi' }
    };
    Object.keys(menuItems).forEach(menuId => {
        document.getElementById(menuId).onclick = function(e) {
            e.preventDefault();
            const item = menuItems[menuId];
            setActiveTab(item.tab);
            document.getElementById('page-title').textContent = item.title;
            localStorage.setItem('employeeTab', item.tab);
        };
    });
    function setActiveTab(tab) {
        Object.keys(menuItems).forEach(menuId => {
            document.getElementById(menuId).classList.remove('active');
        });
        Object.values(menuItems).forEach(item => {
            document.getElementById('tab-' + item.tab).classList.remove('active');
        });
        document.getElementById('tab-home').classList.remove('active');
        if (tab !== 'home') {
            const menuId = Object.keys(menuItems).find(key => menuItems[key].tab === tab);
            if (menuId) document.getElementById(menuId).classList.add('active');
            document.getElementById('tab-' + tab).classList.add('active');
        } else {
            document.getElementById('tab-home').classList.add('active');
        }
    }
    // Khôi phục trạng thái tab khi load trang
    function restoreTabState() {
        const lastTab = localStorage.getItem('employeeTab');
        if (lastTab && lastTab !== 'home') {
            setActiveTab(lastTab);
            const item = Object.values(menuItems).find(item => item.tab === lastTab);
            if (item) {
                document.getElementById('page-title').textContent = item.title;
            }
        } else {
            setActiveTab('home');
            document.getElementById('page-title').textContent = 'Trang nhân viên';
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
    // Modal đăng xuất
    document.getElementById('logoutBtn').onclick = function(e) {
        e.preventDefault();
        document.getElementById('logoutModal').style.display = 'flex';
        document.querySelector('.employee-wrapper').classList.add('blur');
    };
    document.getElementById('cancelLogout').onclick = function() {
        document.getElementById('logoutModal').style.display = 'none';
        document.querySelector('.employee-wrapper').classList.remove('blur');
    };
    document.getElementById('confirmLogout').onclick = function() {
        window.location.href = document.getElementById('logoutBtn').href;
    };
    // Đóng modal khi click ra ngoài
    document.getElementById('logoutModal').onclick = function(e) {
        if (e.target === this) {
            this.style.display = 'none';
            document.querySelector('.employee-wrapper').classList.remove('blur');
        }
    };
</script>
</body>
</html> 