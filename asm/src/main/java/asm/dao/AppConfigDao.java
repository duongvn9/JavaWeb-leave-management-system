package asm.dao;

import asm.util.DBCP;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AppConfigDao {
    private static String cachedAutoApprove = null;
    private static long cacheTime = 0;
    private static final long CACHE_TTL = 60_000; // 1 phút

    public String get(String key) {
        String sql = "SELECT [value] FROM app_config WHERE [key]=?";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, key);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString(1);
        } catch (Exception e) {e.printStackTrace();}
        return null;
    }
    public void set(String key, String value) {
        String sql = "MERGE INTO app_config AS t USING (SELECT ? AS k, ? AS v) AS s ON t.[key]=s.k " +
                "WHEN MATCHED THEN UPDATE SET [value]=s.v " +
                "WHEN NOT MATCHED THEN INSERT ([key],[value]) VALUES(s.k,s.v);";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.executeUpdate();
        } catch (Exception e) {e.printStackTrace();}
    }
    public String getCachedAutoApprove() {
        long now = System.currentTimeMillis();
        if (cachedAutoApprove == null || now - cacheTime > CACHE_TTL) {
            String value = get("auto_approve_enabled");
            cachedAutoApprove = value != null ? value : "true"; // Mặc định là true
            cacheTime = now;
        }
        return cachedAutoApprove;
    }
    public void invalidateCache() {
        cachedAutoApprove = null;
    }
} 