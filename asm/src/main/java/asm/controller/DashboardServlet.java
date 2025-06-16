package asm.controller;

import asm.model.User;

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
        request.setAttribute("user", u);
        request.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp").forward(request, response);
    }
}
