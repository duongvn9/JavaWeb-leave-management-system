package asm.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Đọc cấu hình từ application.properties nằm trong classpath.
 */
public class AppConfig {
    private static final Properties properties = new Properties();
    static {
        try (InputStream input = AppConfig.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException ex) {
            throw new RuntimeException("Không thể load application.properties", ex);
        }
    }

    public static String geminiEndpoint() {
        return properties.getProperty("gemini.endpoint");
    }

    public static String geminiApiKey() {
        return properties.getProperty("gemini.apiKey");
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }

    // Nếu cần thêm config khác, bổ sung getter tại đây
}
