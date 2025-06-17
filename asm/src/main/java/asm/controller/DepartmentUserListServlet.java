package asm.controller;

import asm.dao.UserDao;
import asm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Set;

/**
 * Hiển thị danh sách nhân viên trong cùng phòng ban (Leader) hoặc phòng ban lựa chọn (Admin).
 * URL: /app/department/users  [GET]
 *   - Leader: tự động lấy dept_id của mình
 *   - Admin : có thể truyền param ?deptId=1 để xem phòng khác; nếu không sẽ liệt kê tất cả
 */
@WebServlet("/app/department/users")
public class DepartmentUserListServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User current = (User) req.getSession(false).getAttribute("user");
        @SuppressWarnings("unchecked")
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        if (current == null || roles == null || !(roles.contains("LEADER") || roles.contains("ADMIN"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        Integer deptId;
        if (roles.contains("ADMIN")) {
            // Admin có thể xem tất cả hoặc theo phòng ban query string
            String p = req.getParameter("deptId");
            deptId = (p == null || p.isBlank()) ? null : Integer.valueOf(p);
        } else {
            // Leader chỉ phòng ban của mình
            deptId = current.getDeptId();
        }

        List<User> users = userDao.listByDepartment(deptId);
        req.setAttribute("users", users);
        req.setAttribute("deptId", deptId);
        req.getRequestDispatcher("/WEB-INF/jsp/department/userlist.jsp").forward(req, resp);
    }
}
