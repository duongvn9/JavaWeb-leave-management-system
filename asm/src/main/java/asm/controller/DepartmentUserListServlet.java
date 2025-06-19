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
import java.util.HashMap;
import java.util.Map;

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

        List<User> userList = dao.listByDepartment(deptId);
        req.setAttribute("users", userList);
        // Map userId -> set role code
        Map<Integer, Set<String>> rolesOfUserMap = new HashMap<>();
        for (User u : userList) {
            rolesOfUserMap.put(u.getId(), dao.getRoles(u.getId()));
        }
        req.setAttribute("rolesOfUserMap", rolesOfUserMap);
        req.setAttribute("selectedDept", deptId);
        req.getRequestDispatcher("/WEB-INF/jsp/department/userlist.jsp").forward(req, resp);
    }
}
