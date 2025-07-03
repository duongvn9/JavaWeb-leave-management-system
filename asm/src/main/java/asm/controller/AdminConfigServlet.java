package asm.controller;

import asm.dao.AppConfigDao;
import asm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

@WebServlet("/admin/config")
public class AdminConfigServlet extends HttpServlet {
    private final AppConfigDao dao = new AppConfigDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền ADMIN
        User user = (User) req.getSession(false).getAttribute("user");
        @SuppressWarnings("unchecked")
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        
        if (user == null || roles == null || !roles.contains("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String autoApprove = dao.getCachedAutoApprove();
        req.setAttribute("autoApprove", "true".equals(autoApprove));
        req.getRequestDispatcher("/WEB-INF/jsp/admin/config.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền ADMIN
        User user = (User) req.getSession(false).getAttribute("user");
        @SuppressWarnings("unchecked")
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        
        if (user == null || roles == null || !roles.contains("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String autoApprove = req.getParameter("autoApprove");
        try {
            dao.set("auto_approve_enabled", autoApprove != null ? "true" : "false");
            dao.invalidateCache();
            req.getSession().setAttribute("successMessage", "Đã lưu cấu hình thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "Lưu cấu hình thất bại!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/config");
    }
} 