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

@WebServlet("/app/leave/cancel")
public class LeaveRequestCancelServlet extends HttpServlet {
    private final LeaveRequestService service = new LeaveRequestService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        int id = Integer.parseInt(req.getParameter("id"));
        LeaveRequest lr = service.findById(id);
        if (u == null || lr == null || lr.getEmployeeId() != u.getId() || !"INPROGRESS".equals(lr.getStatus())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        service.cancel(id);
        resp.sendRedirect(req.getContextPath() + "/app/leave/list");
    }
}
