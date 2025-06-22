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
 * Xóa mềm user (active = 0). Chỉ dành cho ADMIN.
 * URL: GET /admin/users/delete?id=123
 */
@WebServlet("/admin/users/delete")
public class AdminUserDeleteServlet extends HttpServlet {
    private final UserDao dao = new UserDao();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            int userId = Integer.parseInt(id);
            dao.hardDelete(userId);
            
            // Thêm thông báo thành công vào session
            HttpSession session = req.getSession();
            session.setAttribute("successMessage", "Đã xóa user thành công!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
