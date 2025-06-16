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
import java.util.List;

/**
 * Danh sách đơn nghỉ phép của nhân viên hiện tại.
 * URL: /app/leave/list
 */
@WebServlet("/app/leave/list")
public class LeaveRequestListServlet extends HttpServlet {
    private final LeaveRequestService service = new LeaveRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/signin");
            return;
        }
        List<LeaveRequest> list = service.listByEmployee(u.getId());
        req.setAttribute("requests", list);
        req.getRequestDispatcher("/WEB-INF/jsp/leave/list.jsp").forward(req, resp);
    }
}
