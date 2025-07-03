package asm.dao;

import asm.model.LeaveRequest;
import asm.util.DBCP;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LeaveRequestDao {

    /* ------------------- CRUD ------------------- */
    public int create(int employeeId, LocalDate from, LocalDate to, String reason) {
        String sql = "INSERT INTO leave_requests(employee_id, from_date, to_date, reason, status) VALUES (?,?,?,?, 'INPROGRESS');";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(from));
            ps.setDate(3, Date.valueOf(to));
            ps.setString(4, reason);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public LeaveRequest findById(int id) {
        String sql = "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id WHERE lr.id=?";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<LeaveRequest> listByEmployee(int empId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id WHERE lr.employee_id=? ORDER BY lr.created_at DESC";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<LeaveRequest> listByDepartment(Integer deptId, boolean isAdmin) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = isAdmin
                ? "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id ORDER BY lr.created_at DESC"
                : "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id WHERE u.dept_id=? ORDER BY lr.created_at DESC";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (!isAdmin) {
                ps.setInt(1, deptId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE leave_requests SET status=?, updated_at=GETDATE() WHERE id=?";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(int id, LocalDate from, LocalDate to, String reason, boolean edited) {
        String sql = "UPDATE leave_requests SET from_date=?, to_date=?, reason=?, is_edited=?, updated_at=GETDATE() WHERE id=? AND status='INPROGRESS'";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(from));
            ps.setDate(2, Date.valueOf(to));
            ps.setString(3, reason);
            ps.setBoolean(4, edited);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cancel(int id) {
        String sql = "UPDATE leave_requests SET status='CANCELLED', updated_at=GETDATE() WHERE id=? AND status='INPROGRESS'";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* ------------------- Helper ------------------- */
    private LeaveRequest map(ResultSet rs) throws Exception {
        return new LeaveRequest(
                rs.getInt("id"),
                rs.getInt("employee_id"),
                rs.getString("emp_name"),
                rs.getObject("dept_id", Integer.class),
                rs.getDate("from_date").toLocalDate(),
                rs.getDate("to_date").toLocalDate(),
                rs.getString("reason"),
                rs.getString("status"),
                rs.getBoolean("is_edited"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getString("ai_decision"),
                rs.getString("approved_by"),
                rs.getString("approver_type"),
                rs.getString("approver_note")
        );
    }

    public void approveByAI(int id, String note) {
        updateStatus(id, "APPROVED"); // note bỏ qua
    }

    public void rejectByAI(int id, String note) {
        updateStatus(id, "REJECTED");
    }
    /**
     * Cập nhật cột ai_decision trong leave_requests
     */
    public void updateAiDecision(int requestId, String decision) {
        String sql = "UPDATE leave_requests SET ai_decision=? WHERE id=?";
        try (Connection c = DBCP.getDataSource().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, decision);
            ps.setInt(2, requestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<LeaveRequest> listByEmployeeAndStatus(int empId, String status) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id WHERE lr.employee_id=? AND lr.status=? ORDER BY lr.created_at DESC";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<LeaveRequest> listByDepartmentAndStatus(Integer deptId, boolean isAdmin, String status) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = isAdmin
                ? "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id WHERE lr.status=? ORDER BY lr.created_at DESC"
                : "SELECT lr.*, u.full_name emp_name, u.dept_id, lr.ai_decision, lr.approver_note FROM leave_requests lr JOIN users u ON lr.employee_id=u.id WHERE u.dept_id=? AND lr.status=? ORDER BY lr.created_at DESC";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (isAdmin) {
                ps.setString(1, status);
            } else {
                ps.setInt(1, deptId);
                ps.setString(2, status);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateStatusAndApprover(int id, String status, String approvedBy, String approverType, String approverNote) {
        String sql = "UPDATE leave_requests SET status=?, approved_by=?, approver_type=?, approver_note=?, updated_at=GETDATE() WHERE id=?";
        try (Connection con = DBCP.getDataSource().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, approvedBy);
            ps.setString(3, approverType);
            ps.setString(4, approverNote);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
