package asm.controller;

import asm.model.LeaveRequest;
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
 * Cho phép sửa đơn nghỉ phép khi còn INPROGRESS và là chủ sở hữu.
 * GET  /app/leave/edit?id=xxx   -> show form
 * POST /app/leave/edit?id=xxx   -> update
 */
@WebServlet("/app/leave/edit")
public class LeaveRequestEditServlet extends HttpServlet {
    private final LeaveRequestService service = new LeaveRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        int id = Integer.parseInt(req.getParameter("id"));
        LeaveRequest lr = service.findById(id);
        if (u == null || lr == null || lr.getEmployeeId() != u.getId()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        req.setAttribute("leaveRequest", lr);
        req.getRequestDispatcher("/WEB-INF/jsp/leave/edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        int id = Integer.parseInt(req.getParameter("id"));
        LeaveRequest lr = service.findById(id);
        if (u == null || lr == null || lr.getEmployeeId() != u.getId()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (!"INPROGRESS".equals(lr.getStatus())) {
            req.getSession(false).setAttribute("errorMessage", "Thao tác thất bại: Đơn #" + id + " đã được xử lý hoặc đã bị huỷ.");
            resp.sendRedirect(req.getContextPath() + "/app/leave/list");
            return;
        }
        LocalDate from = LocalDate.parse(req.getParameter("from_date"));
        LocalDate to   = LocalDate.parse(req.getParameter("to_date"));
        String reason  = req.getParameter("reason");
        service.update(id, from, to, reason, true);
        req.getSession(false).setAttribute("successMessage", "Đã cập nhật đơn nghỉ phép #" + id + " thành công!");
        resp.sendRedirect(req.getContextPath() + "/app/leave/list");
    }
}
