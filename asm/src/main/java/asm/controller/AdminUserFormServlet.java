package asm.controller;

import asm.dao.UserDao;
import asm.model.Department;
import asm.model.RoleOption;
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
 * Thêm / Sửa User cho ADMIN
 *   GET  /admin/users/form            (thêm mới)
 *   GET  /admin/users/form?id=123     (sửa)
 *   POST /admin/users/form            (lưu)
 */
@WebServlet("/admin/users/form")
public class AdminUserFormServlet extends HttpServlet {
    private final UserDao dao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        preloadDropdown(req);
        String id = req.getParameter("id");
        if (id != null) {
            User u = dao.findById(Integer.parseInt(id));
            req.setAttribute("user", u);
            Set<String> r = dao.getRoles(u.getId());
            req.setAttribute("rolesOfUser", r);
        }
        req.getRequestDispatcher("/WEB-INF/jsp/admin/userform.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id       = req.getParameter("id");
        String email    = req.getParameter("email");
        String name     = req.getParameter("full_name");
        Integer deptId  = req.getParameter("deptId").isBlank()?null:Integer.valueOf(req.getParameter("deptId"));
        int roleId      = Integer.parseInt(req.getParameter("roleId"));

        // ----- Check duplicate email when create -----
        if (id == null || id.isBlank()) {
            if (dao.findByEmail(email) != null) {
                req.setAttribute("error", "Email đã tồn tại, vui lòng chọn email khác!");
                preloadDropdown(req);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/userform.jsp").forward(req, resp);
                return;
            }
            dao.insert(new User(0, null, email, name, deptId), roleId, deptId);
        } else {
            int uid = Integer.parseInt(id);
            dao.updateUser(uid, name, deptId, true);
            dao.setSingleRole(uid, roleId);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void preloadDropdown(HttpServletRequest req) {
        List<Department> depts = dao.listDepartments();
        List<RoleOption> roles = dao.listRoles();
        req.setAttribute("depts", depts);
        req.setAttribute("roles", roles);
    }
}
