package asm.dao;

import asm.util.DBCP;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class QuotaDao {
    public int remaining(int userId, int year) {
        String sql = "SELECT quota - used AS remaining FROM annual_leave_quota WHERE user_id=? AND [year]=?";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("remaining");
        } catch (Exception e) {e.printStackTrace();}
        return 12; // default if none
    }

    public void decreaseUsed(int userId, int year, int days) {
        String sql = "UPDATE annual_leave_quota SET used = used + ? WHERE user_id=? AND [year]=?";
        try (Connection con = DBCP.getDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, days);
            ps.setInt(2, userId);
            ps.setInt(3, year);
            int affected = ps.executeUpdate();
            if (affected == 0) {
                // row not exist, create default 12
                try (PreparedStatement ins = con.prepareStatement("INSERT INTO annual_leave_quota(user_id,[year],quota,used) VALUES(?,?,12,?)")) {
                    ins.setInt(1, userId);
                    ins.setInt(2, year);
                    ins.setInt(3, days);
                    ins.executeUpdate();
                }
            }
        } catch (Exception e) {e.printStackTrace();}
    }
}
