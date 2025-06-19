package asm.controller;

import asm.model.User;
import asm.dao.UserDao;
import asm.model.Department;
import asm.model.RoleOption;
import java.util.List;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Hiển thị dashboard sau khi đăng nhập.
 * URL: /app/dashboard  (không lộ .jsp)
 */
@WebServlet("/app/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User u = (User) request.getSession(false).getAttribute("user");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }
        UserDao dao = new UserDao();
        // Lấy tên phòng ban
        String deptName = null;
        if (u.getDeptId() != null) {
            List<Department> depts = dao.listDepartments();
            for (Department d : depts) {
                if (d.getId() == u.getDeptId()) {
                    deptName = d.getName();
                    break;
                }
            }
        }
        // Lấy tên chức vụ (ưu tiên ADMIN > LEADER > EMPLOYEE)
        Set<String> roleCodes = dao.getRoles(u.getId());
        List<RoleOption> roles = dao.listRoles();
        String roleName = null;
        if (roleCodes != null && !roleCodes.isEmpty()) {
            String[] priority = {"ADMIN", "LEADER", "EMPLOYEE", "HR"};
            for (String code : priority) {
                if (roleCodes.contains(code)) {
                    for (RoleOption r : roles) {
                        if (r.getCode().equals(code)) {
                            roleName = r.getName();
                            break;
                        }
                    }
                    if (roleName != null) break;
                }
            }
        }
        request.setAttribute("user", u);
        request.setAttribute("deptName", deptName);
        request.setAttribute("roleName", roleName);
        request.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp").forward(request, response);
    }
}
