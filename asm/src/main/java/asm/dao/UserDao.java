package asm.dao;

import asm.model.User;
import asm.util.DBCP;

import java.sql.*;
import java.util.HashSet;
import java.util.Set;

/**
 * DAO thao tác bảng users & user_roles & roles.
 */
public class UserDao {
    private static final String ROLE_EMPLOYEE_CODE = "EMPLOYEE";

    /* ==== Tìm User ==== */
    public User findByEmail(String email) {
        return querySingle("SELECT id, google_id, email, full_name FROM users WHERE email=? AND active=1", email);
    }

    public User findByGoogleId(String googleId) {
        return querySingle("SELECT id, google_id, email, full_name FROM users WHERE google_id=? AND active=1", googleId);
    }

    private User querySingle(String sql, String param) {
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, param);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("google_id"),
                        rs.getString("email"),
                        rs.getString("full_name")
                );
            }
        } catch (Exception e) {e.printStackTrace();}
        return null;
    }

    /* ==== Create User + role employee ==== */
    public User create(String googleId, String email, String fullName) {
        String insertUser = "INSERT INTO users(google_id,email,full_name) VALUES(?,?,?)";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, googleId);
            ps.setString(2, email);
            ps.setString(3, fullName);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                int userId = keys.getInt(1);
                int roleId = getRoleId(con, ROLE_EMPLOYEE_CODE);
                if (roleId > 0) {
                    try (PreparedStatement ps2 = con.prepareStatement("INSERT INTO user_roles(user_id,role_id) VALUES(?,?)")) {
                        ps2.setInt(1, userId);
                        ps2.setInt(2, roleId);
                        ps2.executeUpdate();
                    }
                }
                return new User(userId, googleId, email, fullName);
            }
        } catch (Exception e) {e.printStackTrace();}
        return null;
    }

    /* ==== Roles ==== */
    public Set<String> getRoles(int userId) {
        Set<String> roles = new HashSet<>();
        String sql = "SELECT r.code FROM roles r JOIN user_roles ur ON r.id=ur.role_id WHERE ur.user_id=?";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(rs.getString("code"));
            }
        } catch (Exception e) {e.printStackTrace();}
        return roles;
    }
    public Integer findDeptIdByUserId(int userId) {
        String sql = "SELECT dept_id FROM users WHERE id = ?";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("dept_id");
        } catch (Exception e) {e.printStackTrace();}
        return null;
    }

    private int getRoleId(Connection con, String code) {
        try (PreparedStatement ps = con.prepareStatement("SELECT id FROM roles WHERE code=?")) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception ignored) {}
        return -1;
    }
}
