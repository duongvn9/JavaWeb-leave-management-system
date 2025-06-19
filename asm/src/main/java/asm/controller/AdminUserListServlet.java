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
        List<User> users = dao.listAll();
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