package asm.controller;

import asm.model.User;
import asm.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

@WebServlet("/admin/system")
public class AdminSystemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession(false).getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }
        
        // Kiểm tra role ADMIN
        UserDao dao = new UserDao();
        Set<String> roles = dao.getRoles(user.getId());
        
        if (roles != null && roles.contains("ADMIN")) {
            req.getRequestDispatcher("/WEB-INF/jsp/admin/system.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/app/dashboard");
        }
    }
} 