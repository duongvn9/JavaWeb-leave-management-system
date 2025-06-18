package asm.controller;

import asm.dao.UserDao;          // ⬅ dùng DAO trực tiếp
import asm.model.User;
import asm.util.OauthConfig;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.GeneralSecurityException;

@WebServlet("/login-google")
public class GoogleOAuthCallbackServlet extends HttpServlet {
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private final UserDao userDao = new UserDao();         // ⬅ DAO
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        if (code == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã OAuth");
            return;
        }
        try {
            var http = GoogleNetHttpTransport.newTrustedTransport();
            var token = new GoogleAuthorizationCodeTokenRequest(
                    http, JSON_FACTORY,
                    OauthConfig.clientId(), OauthConfig.clientSecret(),
                    code, OauthConfig.redirectUri()).execute();

            GoogleIdToken idToken = GoogleIdToken.parse(JSON_FACTORY, token.getIdToken());
            if (idToken == null) {
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Không nhận được id_token");
                return;
            }
            var p      = idToken.getPayload();
            String email    = p.getEmail();
            String name     = (String) p.get("name");
            String googleId = p.getSubject();

            /* --------- CHẶN USER CHƯA ĐĂNG KÝ --------- */
            User user = userDao.findByEmail(email);     // chỉ tìm, KHÔNG tạo
            if (user == null) {
                req.setAttribute("loginError",
                        "Tài khoản \"" + email + "\" chưa được cấp quyền truy cập. "
                      + "Vui lòng liên hệ Admin để thêm vào hệ thống.");
                req.getRequestDispatcher("/WEB-INF/jsp/error/notRegistered.jsp")
                   .forward(req, resp);
                return;
            }

            // user hợp lệ → cho vào hệ thống
            req.getSession(true).setAttribute("user",  user);
            req.getSession().setAttribute("roles", userDao.getRoles(user.getId()));
            resp.sendRedirect(req.getContextPath() + "/app/dashboard");
        } catch (GeneralSecurityException e) {
            throw new ServletException(e);
        }
    }
}
