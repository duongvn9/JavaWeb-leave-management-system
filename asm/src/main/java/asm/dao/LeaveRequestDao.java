package asm.dao;

import asm.model.LeaveRequest;
import asm.util.DBCP;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LeaveRequestDao {
    public int create(int employeeId, LocalDate from, LocalDate to, String reason) {
        String sql = "INSERT INTO leave_requests(employee_id, from_date, to_date, reason, status) VALUES (?,?,?,?, 'INPROGRESS');";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, java.sql.Date.valueOf(from));
            ps.setDate(3, java.sql.Date.valueOf(to));
            ps.setString(4, reason);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (Exception e) {e.printStackTrace();}
        return -1;
    }

    public List<LeaveRequest> listByEmployee(int employeeId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM leave_requests WHERE employee_id=? ORDER BY created_at DESC";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {e.printStackTrace();}
        return list;
    }

    public LeaveRequest findById(int id) {
        String sql = "SELECT * FROM leave_requests WHERE id = ?";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {e.printStackTrace();}
        return null;
    }

    public void update(int id, LocalDate from, LocalDate to, String reason, boolean isEdited) {
        String sql = "UPDATE leave_requests SET from_date=?, to_date=?, reason=?, is_edited=?, updated_at=GETDATE() WHERE id=? AND status='INPROGRESS'";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(from));
            ps.setDate(2, java.sql.Date.valueOf(to));
            ps.setString(3, reason);
            ps.setBoolean(4, isEdited);
            ps.setInt(5, id);
            ps.executeUpdate();
        } catch (Exception e) {e.printStackTrace();}
    }

    public void cancel(int id) {
        String sql = "UPDATE leave_requests SET status='CANCELLED', updated_at=GETDATE() WHERE id=? AND status='INPROGRESS'";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {e.printStackTrace();}
    }

    private LeaveRequest map(ResultSet rs) throws Exception {
        return new LeaveRequest(
                rs.getInt("id"),
                rs.getInt("employee_id"),
                rs.getDate("from_date").toLocalDate(),
                rs.getDate("to_date").toLocalDate(),
                rs.getString("reason"),
                rs.getString("status"),
                rs.getBoolean("is_edited"),
                rs.getTimestamp("created_at").toLocalDateTime()
        );
    }
}
