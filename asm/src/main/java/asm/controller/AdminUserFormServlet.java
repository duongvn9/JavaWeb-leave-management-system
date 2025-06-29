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
import jakarta.servlet.http.HttpSession;
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
        } else {
            // Đảm bảo user attribute là null khi thêm mới
            req.setAttribute("user", null);
            // Set role mặc định là "Nhân viên" khi thêm mới
            int defaultRoleId = dao.findRoleIdByCode("EMPLOYEE");
            req.setAttribute("defaultRoleId", defaultRoleId);
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
        String reactivate = req.getParameter("reactivate"); // Tham số để kích hoạt lại user

        boolean isEdit = id != null && !id.isBlank();

        // Nếu có yêu cầu kích hoạt lại user đã bị deactive
        if (reactivate != null && reactivate.equals("true")) {
            User existing = dao.findByEmailIncludeInactive(email);
            if (existing != null && !existing.isActive()) {
                // Kích hoạt lại user cũ (giữ nguyên thông tin cũ)
                dao.activateUser(existing.getId());
                
                // Thêm thông báo thành công vào session
                HttpSession session = req.getSession();
                session.setAttribute("successMessage", "Đã kích hoạt lại user thành công!");
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }
        }

        // Kiểm tra trùng email (bao gồm cả user đã bị deactive)
        User existing = dao.findByEmailIncludeInactive(email);
        if (existing != null) {
            // trường hợp new hoặc sửa sang email của user khác
            if (!isEdit || existing.getId() != Integer.parseInt(id)) {
                // Nếu user đã bị deactive, hỏi admin có muốn kích hoạt lại không
                if (!existing.isActive()) {
                    req.setAttribute("deactivatedUser", existing);
                    req.setAttribute("reactivate", true);
                    req.setAttribute("edit", isEdit);
                    
                    // Tạo tempUser để giữ lại dữ liệu đã nhập
                    User tempUser = new User(isEdit ? Integer.parseInt(id) : 0, null, email, fullName, deptId);
                    req.setAttribute("user", tempUser);
                    req.setAttribute("selectedRoleId", roleId);
                    
                    // Nếu đang edit, cần rolesOfUser
                    if (isEdit) {
                        Set<String> rolesOfUser = dao.getRoles(Integer.parseInt(id));
                        req.setAttribute("rolesOfUser", rolesOfUser);
                    }
                    
                    // Luôn nạp dropdown
                    List<Department> depts = dao.listDepartments();
                    List<RoleOption> roles = dao.listRoles();
                    req.setAttribute("depts", depts);
                    req.setAttribute("roles", roles);
                    
                    req.getRequestDispatcher("/WEB-INF/jsp/admin/userform.jsp").forward(req, resp);
                    return;
                } else {
                    req.setAttribute("error", "Email đã tồn tại, vui lòng chọn email khác!");
                    // Set lại các attribute cần thiết cho form và giữ lại dữ liệu đã nhập
                    req.setAttribute("edit", isEdit);
                    
                    // Tạo tempUser để giữ lại dữ liệu đã nhập
                    User tempUser = new User(isEdit ? Integer.parseInt(id) : 0, null, email, fullName, deptId);
                    req.setAttribute("user", tempUser);
                    req.setAttribute("selectedRoleId", roleId);
                    
                    // Nếu đang edit, cần rolesOfUser
                    if (isEdit) {
                        Set<String> rolesOfUser = dao.getRoles(Integer.parseInt(id));
                        req.setAttribute("rolesOfUser", rolesOfUser);
                    }
                    
                    // Luôn nạp dropdown
                    List<Department> depts = dao.listDepartments();
                    List<RoleOption> roles = dao.listRoles();
                    req.setAttribute("depts", depts);
                    req.setAttribute("roles", roles);
                    
                    req.getRequestDispatcher("/WEB-INF/jsp/admin/userform.jsp").forward(req, resp);
                    return;
                }
            }
        }

        // Thực hiện lưu
        if (!isEdit) {
            // Thêm mới
            dao.insert(new User(0, null, email, fullName, deptId), roleId);
        } else {
            // Cập nhật (không cập nhật email)
            int uid = Integer.parseInt(id);
            dao.updateUser(uid, fullName, deptId, true);
            dao.setSingleRole(uid, roleId);
        }
        
        // Thêm thông báo thành công vào session
        HttpSession session = req.getSession();
        if (!isEdit) {
            session.setAttribute("successMessage", "Đã thêm user thành công!");
        } else {
            session.setAttribute("successMessage", "Đã cập nhật user thành công!");
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
