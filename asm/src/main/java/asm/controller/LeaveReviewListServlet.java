package asm.controller;

import asm.dao.UserDao;
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
import java.util.Set;

/**
 * Hiển thị danh sách đơn của phòng ban (Leader) hoặc toàn bộ (Admin).
 * URL: /app/leave/reviewlist
 */
@WebServlet("/app/leave/reviewlist")
public class LeaveReviewListServlet extends HttpServlet {
    private final LeaveRequestService leaveRequestService = new LeaveRequestService();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = (User) req.getSession(false).getAttribute("user");
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        boolean isAdmin = roles != null && roles.contains("ADMIN");
        Integer deptId = null;
        if (!isAdmin) {
            // Tìm phòng ban của leader (giả định chỉ quản lý 1 dept, có thể mở rộng sau)
            deptId = userDao.findDeptIdByUserId(u.getId());
        }
        List<LeaveRequest> list = leaveRequestService.listByDepartment(deptId, isAdmin);
        req.setAttribute("requests", list);
        req.getRequestDispatcher("/WEB-INF/jsp/leave/reviewlist.jsp").forward(req, resp);
    }
}
