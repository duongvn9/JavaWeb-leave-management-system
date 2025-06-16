package asm.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Tiện ích đọc cấu hình Google OAuth từ file classpath "oauth.properties".
 *
 * File đặt tại: src/main/resources/oauth.properties
 *
 * Nội dung ví dụ:
 * google.clientId=xxxxxxxx.apps.googleusercontent.com
 * google.clientSecret=xxxxxxxx
 * google.redirectUri=http://localhost:9999/asm/login-google
 */
public final class OauthConfig {
    private static final Properties props = new Properties();

    static {
        try (InputStream in = OauthConfig.class.getClassLoader().getResourceAsStream("oauth.properties")) {
            if (in == null) {
                throw new IOException("Không tìm thấy oauth.properties trong classpath");
            }
            props.load(in);
        } catch (IOException e) {
            throw new ExceptionInInitializerError("Lỗi nạp oauth.properties: " + e.getMessage());
        }
    }

    private OauthConfig() {}

    public static String clientId() {
        return props.getProperty("google.clientId");
    }

    public static String clientSecret() {
        return props.getProperty("google.clientSecret");
    }

    public static String redirectUri() {
        return props.getProperty("google.redirectUri");
    }
}
