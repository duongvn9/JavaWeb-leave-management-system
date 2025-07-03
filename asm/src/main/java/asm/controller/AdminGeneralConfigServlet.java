package asm.controller;

import asm.dao.AppConfigDao;
import asm.model.User;
import asm.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

@WebServlet("/admin/general-config")
public class AdminGeneralConfigServlet extends HttpServlet {
    private final AppConfigDao dao = new AppConfigDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền ADMIN
        User user = (User) req.getSession(false).getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }
        
        UserDao userDao = new UserDao();
        Set<String> roles = userDao.getRoles(user.getId());
        
        if (roles == null || !roles.contains("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Lấy các cấu hình hiện tại
        String systemName = dao.get("system_name");
        if (systemName == null) systemName = "Leave Management System";
        
        String companyName = dao.get("company_name");
        if (companyName == null) companyName = "Công ty ABC";
        
        String maxLeaveDays = dao.get("max_leave_days");
        if (maxLeaveDays == null) maxLeaveDays = "30";
        
        String emailNotification = dao.get("email_notification");
        if (emailNotification == null) emailNotification = "true";
        
        req.setAttribute("systemName", systemName);
        req.setAttribute("companyName", companyName);
        req.setAttribute("maxLeaveDays", maxLeaveDays);
        req.setAttribute("emailNotification", "true".equals(emailNotification));
        
        req.getRequestDispatcher("/WEB-INF/jsp/admin/general-config.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền ADMIN
        User user = (User) req.getSession(false).getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }
        
        UserDao userDao = new UserDao();
        Set<String> roles = userDao.getRoles(user.getId());
        
        if (roles == null || !roles.contains("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        try {
            String systemName = req.getParameter("systemName");
            String companyName = req.getParameter("companyName");
            String maxLeaveDays = req.getParameter("maxLeaveDays");
            String emailNotification = req.getParameter("emailNotification");
            
            dao.set("system_name", systemName);
            dao.set("company_name", companyName);
            dao.set("max_leave_days", maxLeaveDays);
            dao.set("email_notification", emailNotification != null ? "true" : "false");
            
            dao.invalidateCache();
            req.getSession().setAttribute("successMessage", "Đã lưu cấu hình chung thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "Lưu cấu hình thất bại: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/general-config");
    }
} 