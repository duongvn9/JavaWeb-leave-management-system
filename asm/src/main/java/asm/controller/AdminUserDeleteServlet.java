package asm.controller;

import asm.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
            dao.softDelete(Integer.parseInt(id));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
