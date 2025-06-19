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
        String id = req.getParameter("id");
        boolean edit = id != null && !id.isBlank();
        req.setAttribute("edit", edit);

        if (edit) {
            User u = dao.findById(Integer.parseInt(id));
            if (u == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "User không tồn tại hoặc đã bị xóa.");
                return;
            }
            req.setAttribute("user", u);
            Set<String> rolesOfUser = dao.getRoles(u.getId());
            req.setAttribute("rolesOfUser", rolesOfUser);
        }

        // Luôn nạp dropdown
        List<Department> depts = dao.listDepartments();
        List<RoleOption> roles = dao.listRoles();
        req.setAttribute("depts", depts);
        req.setAttribute("roles", roles);

        req.getRequestDispatcher("/WEB-INF/jsp/admin/userform.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String id       = req.getParameter("id");
        String email    = req.getParameter("email");
        String fullName = req.getParameter("full_name");
        Integer deptId  = req.getParameter("deptId").isBlank() ? null : Integer.valueOf(req.getParameter("deptId"));
        int roleId      = Integer.parseInt(req.getParameter("roleId"));

        // Kiểm tra trùng email
        User existing = dao.findByEmail(email);
        if (existing != null) {
            // trường hợp new hoặc sửa sang email của user khác
            if (id == null || id.isBlank() || existing.getId() != Integer.parseInt(id)) {
                req.setAttribute("error", "Email đã tồn tại, vui lòng chọn email khác!");
                doGet(req, resp);
                return;
            }
        }

        // Thực hiện lưu
        if (id == null || id.isBlank()) {
            // Thêm mới
            dao.insert(new User(0, null, email, fullName, deptId), roleId, deptId);
        } else {
            // Cập nhật (không cập nhật email)
            int uid = Integer.parseInt(id);
            dao.updateUser(uid, fullName, deptId, true);
            dao.setSingleRole(uid, roleId);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
