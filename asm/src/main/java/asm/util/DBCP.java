package asm.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

public final class DBCP {
    private static final HikariDataSource DS;

    static {
        java.util.Properties props = new java.util.Properties();
        try (var in = DBCP.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new ExceptionInInitializerError("Thiếu file db.properties trong classpath");
            }
            props.load(in);
        } catch (Exception e) {
            throw new ExceptionInInitializerError("Không thể nạp db.properties: " + e.getMessage());
        }

        String url  = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String pass = props.getProperty("db.pass");
        int pool    = Integer.parseInt(props.getProperty("db.pool", "10"));

        if (url == null || user == null || pass == null) {
            throw new ExceptionInInitializerError("db.properties phải khai báo db.url, db.user, db.pass");
        }

        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(user);
        cfg.setPassword(pass);
        cfg.setMaximumPoolSize(pool);
        cfg.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        DS = new HikariDataSource(cfg);
    }

    private DBCP() {}

    public static DataSource getDataSource() {
        return DS;
    }
}
