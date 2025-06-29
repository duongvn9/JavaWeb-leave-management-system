package asm.controller;

import asm.dao.UserDao;
import asm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet("/admin/users")
public class AdminUserListServlet extends HttpServlet {
    private final UserDao dao = new UserDao();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra thông báo thành công từ session
        HttpSession session = req.getSession();
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            req.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage"); // Xóa thông báo sau khi đã đọc
        }
        
        // Kiểm tra filter hiển thị user deactive
        String showInactive = req.getParameter("showInactive");
        List<User> users;
        
        if ("true".equals(showInactive)) {
            // Hiển thị tất cả user (cả active và inactive)
            users = dao.listAllIncludeInactive();
            req.setAttribute("showInactive", true);
        } else {
            // Chỉ hiển thị user active
            users = dao.listAll();
            req.setAttribute("showInactive", false);
        }
        
        req.setAttribute("users", users);
        req.setAttribute("depts", dao.listDepartments());
        // Map userId -> set role code
        Map<Integer, Set<String>> rolesOfUserMap = new HashMap<>();
        for (User u : users) {
            rolesOfUserMap.put(u.getId(), dao.getRoles(u.getId()));
        }
        req.setAttribute("rolesOfUserMap", rolesOfUserMap);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/userlist.jsp").forward(req, resp);
    }
}