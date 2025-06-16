package asm.controller;

import asm.model.User;
import asm.service.LeaveRequestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

/**
 * Tạo đơn nghỉ phép.
 * GET  /app/leave/create   -> form tạo
 * POST /app/leave/create   -> xử lý lưu và redirect danh sách
 */
@WebServlet("/app/leave/create")
public class LeaveRequestCreateServlet extends HttpServlet {
    private final LeaveRequestService service = new LeaveRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/leave/create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }
        LocalDate from = LocalDate.parse(req.getParameter("from_date"));
        LocalDate to   = LocalDate.parse(req.getParameter("to_date"));
        String reason  = req.getParameter("reason");

        service.create(u.getId(), from, to, reason);
        resp.sendRedirect(req.getContextPath() + "/app/leave/list");
    }
}
