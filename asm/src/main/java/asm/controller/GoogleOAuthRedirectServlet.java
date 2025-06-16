package asm.controller;

import asm.util.OauthConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Khởi động luồng OAuth 2.0 của Google.
 * Người dùng truy cập URL /oauth2/google để chuyển hướng tới trang consent.
 */
@WebServlet("/oauth2/google")
public class GoogleOAuthRedirectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String clientId = OauthConfig.clientId();
        String redirectUri = OauthConfig.redirectUri();

        if (clientId == null || redirectUri == null) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Thiếu google.clientId hoặc google.redirectUri trong oauth.properties");
            return;
        }

        String authUrl = "https://accounts.google.com/o/oauth2/v2/auth?" +
                "client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8) +
                "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8) +
                "&response_type=code" +
                "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8) +
                "&access_type=offline" +
                "&prompt=consent";

        resp.sendRedirect(authUrl);
    }
}
