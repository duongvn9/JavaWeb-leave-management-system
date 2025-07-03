package asm.controller;

import asm.model.User;
import asm.dao.UserDao;
import asm.model.Department;
import asm.model.RoleOption;
import java.util.List;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Hiển thị dashboard sau khi đăng nhập.
 * URL: /app/dashboard  (không lộ .jsp)
 */
@WebServlet("/app/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User u = (User) request.getSession(false).getAttribute("user");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }
        
        UserDao dao = new UserDao();
        Set<String> roleCodes = dao.getRoles(u.getId());
        
        // Nếu là ADMIN, redirect đến system page
        if (roleCodes != null && roleCodes.contains("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/system");
            return;
        }
        // Nếu là LEADER, forward đến leader.jsp
        if (roleCodes != null && roleCodes.contains("LEADER")) {
            request.getRequestDispatcher("/WEB-INF/jsp/leader.jsp").forward(request, response);
            return;
        }
        // Mặc định là nhân viên, forward đến employee.jsp
        request.getRequestDispatcher("/WEB-INF/jsp/employee.jsp").forward(request, response);
    }
}
