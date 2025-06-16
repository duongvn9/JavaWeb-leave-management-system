package asm.filter;

import asm.dao.UserDao;
import asm.model.Role;
import asm.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.EnumSet;
import java.util.Set;

/**
 * RBAC Filter kiểm tra quyền truy cập URL.
 * Mapping đã đăng ký toàn bộ under /app/* và /admin/* trong web.xml (hoặc annotation).
 */
@WebFilter(urlPatterns = {"/app/*", "/admin/*"})
public class RbacFilter implements Filter {
    private final UserDao userDao = new UserDao();

    @Override public void init(FilterConfig filterConfig) {}
    @Override public void destroy() {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        User user  = (User) request.getSession(false).getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin");
            return;
        }
        // Lấy roles (cache vào session lần đầu)
        @SuppressWarnings("unchecked")
        Set<String> roles = (Set<String>) request.getSession().getAttribute("roles");
        if (roles == null) {
            roles = userDao.getRoles(user.getId());
            request.getSession().setAttribute("roles", roles);
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (isAllowed(path, roles)) {
            chain.doFilter(req, res);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
        }
    }

    private boolean isAllowed(String path, Set<String> roles) {
        if (path.startsWith("/admin")) {
            return roles.contains(Role.ADMIN.name());
        }
        if (path.startsWith("/app/leave/review")) {
            return roles.contains(Role.LEADER.name()) || roles.contains(Role.ADMIN.name());
        }
        if (path.startsWith("/app/agenda")) {
            return roles.contains(Role.LEADER.name()) || roles.contains(Role.ADMIN.name()) || roles.contains(Role.HR.name());
        }
        // Các URL còn lại dưới /app đều cho phép user đã login
        return true;
    }
}
