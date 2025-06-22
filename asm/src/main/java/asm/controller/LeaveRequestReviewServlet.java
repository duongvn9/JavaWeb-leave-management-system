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
import java.time.temporal.ChronoUnit;
import java.util.Set;

/**
 * Chi tiết & phê duyệt đơn nghỉ phép.
 * URL:
 *   GET  /app/leave/review?id=123  -> xem chi tiết
 *   POST /app/leave/review         -> approve / reject
 */
@WebServlet("/app/leave/review")
public class LeaveRequestReviewServlet extends HttpServlet {
    private final LeaveRequestService service = new LeaveRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User approver = (User) req.getSession(false).getAttribute("user");
        int id = Integer.parseInt(req.getParameter("id"));
        LeaveRequest lr = service.findById(id);
        if (!isAllowed(req, approver, lr)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        long days = ChronoUnit.DAYS.between(lr.getFromDate(), lr.getToDate()) + 1;
        int remain = service.getQuotaRemaining(lr.getEmployeeId(), lr.getFromDate().getYear());
        req.setAttribute("leave", lr);
        req.setAttribute("days", days);
        req.setAttribute("remain", remain);
        req.getRequestDispatcher("/WEB-INF/jsp/leave/review.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User approver = (User) req.getSession(false).getAttribute("user");
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        int id = Integer.parseInt(req.getParameter("id"));
        String action = req.getParameter("action"); // APPROVE or REJECT
        String note = req.getParameter("note");
        LeaveRequest lr = service.findById(id);

        if (!isAllowed(req, approver, lr)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Race condition: nhân viên đã huỷ đơn trong lúc sếp đang review
        if (!"INPROGRESS".equals(lr.getStatus())) {
            req.setAttribute("errorMessage", "Thao tác thất bại do nhân viên đã thay đổi hoặc huỷ đơn này.");
            req.getRequestDispatcher("/WEB-INF/jsp/error/action-failed.jsp").forward(req, resp);
            return;
        }

        service.approveOrReject(id, approver.getId(), roles.contains("ADMIN"), action, note);
        // TODO: success message
        resp.sendRedirect(req.getContextPath() + "/app/leave/reviewlist");
    }

    private boolean isAllowed(HttpServletRequest req, User approver, LeaveRequest lr) {
        if (approver == null || lr == null) return false;
        @SuppressWarnings("unchecked")
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        if (roles.contains("ADMIN")) return true;
        // leader: phải cùng phòng ban
        return roles.contains("LEADER") && approver.getDeptId() != null && approver.getDeptId().equals(lr.getDeptId());
    }
}
