package asm.controller;

import asm.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Xóa mềm nhân viên (active = 0) và kích hoạt lại nhân viên. Chỉ dành cho ADMIN.
 * URL: GET /admin/users/delete?id=123 (xóa mềm)
 * URL: POST /admin/users/delete (kích hoạt lại)
 */
@WebServlet("/admin/users/delete")
public class AdminUserDeleteServlet extends HttpServlet {
    private final UserDao dao = new UserDao();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            int userId = Integer.parseInt(id);
            dao.softDelete(userId);
            
            // Thêm thông báo thành công vào session
            HttpSession session = req.getSession();
            session.setAttribute("successMessage", "Đã xóa mềm nhân viên thành công!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            int userId = Integer.parseInt(id);
            // Kích hoạt lại user (chỉ thay đổi active=1, giữ nguyên thông tin khác)
            dao.activateUser(userId);
            
            // Thêm thông báo thành công vào session
            HttpSession session = req.getSession();
            session.setAttribute("successMessage", "Đã kích hoạt lại nhân viên thành công!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
