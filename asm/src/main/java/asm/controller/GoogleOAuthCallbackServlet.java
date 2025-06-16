package asm.controller;

import asm.service.UserService;
import asm.model.User;
import asm.util.OauthConfig;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.GeneralSecurityException;

/**
 * Servlet callback nhận mã code từ Google và tạo/lấy user.
 * URL khớp với redirectUri trong oauth.properties: /login-google
 */
@WebServlet("/login-google")
public class GoogleOAuthCallbackServlet extends HttpServlet {
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        if (code == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu code OAuth");
            return;
        }
        try {
            var httpTransport = GoogleNetHttpTransport.newTrustedTransport();
            var tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    httpTransport,
                    JSON_FACTORY,
                    OauthConfig.clientId(),
                    OauthConfig.clientSecret(),
                    code,
                    OauthConfig.redirectUri())
                    .execute();

            GoogleIdToken idToken = GoogleIdToken.parse(JSON_FACTORY, tokenResponse.getIdToken());
            if (idToken == null) {
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Không nhận được id_token");
                return;
            }
            var payload = idToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String googleId = payload.getSubject();

            // Tạo hoặc lấy user trong DB
            User user = userService.findOrCreate(googleId, email, name);
            if (user == null) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo user");
                return;
            }

            req.getSession(true).setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/app/dashboard");
        } catch (GeneralSecurityException e) {
            throw new ServletException(e);
        }
    }
}
