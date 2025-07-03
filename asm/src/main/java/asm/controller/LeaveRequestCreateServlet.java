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
        User u = (User) req.getSession(false).getAttribute("user");
        int remain = 0;
        if (u != null) {
            remain = service.getQuotaRemaining(u.getId(), java.time.LocalDate.now().getYear());
        }
        req.setAttribute("remain", remain);
        req.getRequestDispatcher("/WEB-INF/jsp/leave/create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }
        try {
            LocalDate from = LocalDate.parse(req.getParameter("from_date"));
            LocalDate to   = LocalDate.parse(req.getParameter("to_date"));
            String reason  = req.getParameter("reason");

            int result = service.create(u.getId(), from, to, reason);
            if (result == -1) {
                req.getSession().setAttribute("errorMessage", "Tạo đơn nghỉ phép thất bại. Vui lòng thử lại!");
            } else {
                req.getSession().setAttribute("successMessage", "Tạo đơn nghỉ phép thành công!");
            }
            resp.sendRedirect(req.getContextPath() + "/app/leave/list");
        } catch (Exception ex) {
            req.setAttribute("errorMessage", "Dữ liệu không hợp lệ hoặc lỗi hệ thống. Vui lòng kiểm tra lại!");
            int remain = 0;
            if (u != null) {
                remain = service.getQuotaRemaining(u.getId(), java.time.LocalDate.now().getYear());
            }
            req.setAttribute("remain", remain);
            req.getRequestDispatcher("/WEB-INF/jsp/leave/create.jsp").forward(req, resp);
        }
    }
}
