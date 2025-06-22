package asm.dao;

import asm.model.Department;
import asm.model.RoleOption;
import asm.model.User;
import asm.util.DBCP;

import java.sql.*;
import java.util.*;

/**
 * UserDao phiên bản đầy đủ – bao gồm: • CRUD user • listByDepartment / listAll
 * • listDepartments() / listRoles() • setSingleRole() – gán một vai trò duy
 * nhất • findDeptIdByUserId() – phục vụ LeaveReviewList
 */
public class UserDao {

    private static final String ROLE_EMPLOYEE_CODE = "EMPLOYEE";

    /* ========== helpers ========= */
    private Connection open() throws SQLException {
        return DBCP.getDataSource().getConnection();
    }

    private User map(ResultSet rs) throws Exception {
        return new User(
                rs.getInt("id"),
                rs.getString("google_id"),
                rs.getString("email"),
                rs.getString("full_name"),
                rs.getObject("dept_id", Integer.class),
                rs.getBoolean("active")
        );
    }

    private User single(String sql, Object p) {
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (p instanceof String) {
                ps.setString(1, (String) p);
            } else {
                ps.setInt(1, (Integer) p);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ========== find ========= */
    public User findById(int id) {
        return single("SELECT * FROM users WHERE id=? AND active=1", id);
    }

    public User findByEmail(String email) {
        return single("SELECT * FROM users WHERE email=? AND active=1", email);
    }

    public User findByGoogleId(String g) {
        return single("SELECT * FROM users WHERE google_id=? AND active=1", g);
    }

    /* ========== list ========= */
    public List<User> listByDepartment(Integer deptId) {
        List<User> out = new ArrayList<>();
        String sql = (deptId == null)
                ? "SELECT * FROM users WHERE active=1 ORDER BY id ASC"
                : "SELECT * FROM users WHERE active=1 AND dept_id=? ORDER BY id ASC";
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (deptId != null) {
                ps.setInt(1, deptId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    public List<User> listAll() {
        return listByDepartment(null);
    }

    public List<Department> listDepartments() {
        List<Department> d = new ArrayList<>();
        try (Connection c = open(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery("SELECT id,code,name FROM departments ORDER BY name")) {
            while (rs.next()) {
                d.add(new Department(rs.getInt(1), rs.getString(2), rs.getString(3)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return d;
    }

    public List<RoleOption> listRoles() {
        List<RoleOption> r = new ArrayList<>();
        try (Connection c = open(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery("SELECT id,code,name FROM roles ORDER BY id")) {
            while (rs.next()) {
                r.add(new RoleOption(rs.getInt(1), rs.getString(2), rs.getString(3)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return r;
    }

    /* ========== insert & update ========= */
    public void insert(User u, int roleId) {
        String sql = "INSERT INTO users(email,full_name,dept_id,active) VALUES(?,?,?,1)";
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getFullName());
            if (u.getDeptId() == null) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, u.getDeptId());
            }
            ps.executeUpdate();
            ResultSet k = ps.getGeneratedKeys();
            if (k.next()) {
                setSingleRole(k.getInt(1), roleId, c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateUser(int id, String name, Integer deptId, boolean active) {
        String sql = "UPDATE users SET full_name=?, dept_id=?, active=? WHERE id=?";
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            if (deptId == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, deptId);
            }
            ps.setBoolean(3, active);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void softDelete(int id) {
        updateUser(id, "", null, false);
    }

    /* ========== role util ========= */
    public void setSingleRole(int userId, int roleId) {
        try (Connection c = open()) {
            setSingleRole(userId, roleId, c);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void setSingleRole(int userId, int roleId, Connection c) throws Exception {
        try (PreparedStatement d = c.prepareStatement("DELETE FROM user_roles WHERE user_id=?")) {
            d.setInt(1, userId);
            d.executeUpdate();
        }
        try (PreparedStatement i = c.prepareStatement("INSERT INTO user_roles(user_id,role_id) VALUES(?,?)")) {
            i.setInt(1, userId);
            i.setInt(2, roleId);
            i.executeUpdate();
        }
    }

    public int findRoleIdByCode(String code) {
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement("SELECT id FROM roles WHERE code=?")) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Set<String> getRoles(int uid) {
        Set<String> s = new HashSet<>();
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement("SELECT r.code FROM roles r JOIN user_roles ur ON r.id=ur.role_id WHERE ur.user_id=?")) {
            ps.setInt(1, uid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                s.add(rs.getString(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    public Integer findDeptIdByUserId(int uid) {
        User u = findById(uid);
        return u == null ? null : u.getDeptId();
    }

    /* ========== create wrapper for SSO ========= */
    public User create(String gid, String email, String fullName) {
        int roleEmp = findRoleIdByCode(ROLE_EMPLOYEE_CODE);
        User tmp = new User(0, gid, email, fullName, null);
        insert(tmp, roleEmp);
        return findByEmail(email);
    }

    public String findLeaderEmail(Integer deptId) {
        if (deptId == null) {
            return null;
        }
        String sql = "SELECT u.email FROM users u JOIN user_roles ur ON u.id=ur.user_id "
                + "JOIN roles r ON ur.role_id=r.id WHERE r.code='LEADER' AND u.dept_id=? AND u.active=1";
        try (Connection c = open(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // XÓA CỨNG USER
    public void hardDelete(int id) {
        try (Connection c = open()) {
            // Xóa các role liên quan trước
            try (PreparedStatement d = c.prepareStatement("DELETE FROM user_roles WHERE user_id=?")) {
                d.setInt(1, id);
                d.executeUpdate();
            }
            // Xóa user
            try (PreparedStatement d = c.prepareStatement("DELETE FROM users WHERE id=?")) {
                d.setInt(1, id);
                d.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
