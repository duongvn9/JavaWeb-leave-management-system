package asm.dao;

import asm.util.DBCP;

import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * DAO ghi bảng approvals khi phê duyệt đơn.
 */
public class ApprovalDao {
    public void insert(int requestId, int approverId, String action, String note, boolean autoByAi) {
        String sql = "INSERT INTO approvals(request_id, approver_id, action, note, auto_by_ai) VALUES(?,?,?,?,?)";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, approverId);
            ps.setString(3, action);
            ps.setString(4, note);
            ps.setBoolean(5, autoByAi);
            ps.executeUpdate();
        } catch (Exception e) {e.printStackTrace();}
    }
}
