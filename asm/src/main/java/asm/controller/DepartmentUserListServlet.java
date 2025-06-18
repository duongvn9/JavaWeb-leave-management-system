package asm.controller;

import asm.dao.UserDao;
import asm.model.Department;
import asm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;

/**
 * Danh sách nhân viên – Leader xem phòng mình, Admin xem tất cả hoặc lọc phòng.
 * URL: /app/department/users  (?deptId=)
 */
@WebServlet("/app/department/users")
public class DepartmentUserListServlet extends HttpServlet {
    private final UserDao dao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User current = (User) req.getSession(false).getAttribute("user");
        @SuppressWarnings("unchecked")
        Set<String> roles = (Set<String>) req.getSession().getAttribute("roles");
        if (current == null || roles == null || !(roles.contains("LEADER") || roles.contains("ADMIN"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN); return;
        }

        Integer deptId;
        if (roles.contains("ADMIN")) {
            // nạp list phòng ban cho dropdown
            List<Department> depts = dao.listDepartments();
            req.setAttribute("depts", depts);
            String p = req.getParameter("deptId");
            deptId = (p == null || p.isBlank()) ? null : Integer.valueOf(p);
        } else {
            deptId = current.getDeptId();
        }

        req.setAttribute("users", dao.listByDepartment(deptId));
        req.setAttribute("selectedDept", deptId);
        req.getRequestDispatcher("/WEB-INF/jsp/department/userlist.jsp").forward(req, resp);
    }
}
