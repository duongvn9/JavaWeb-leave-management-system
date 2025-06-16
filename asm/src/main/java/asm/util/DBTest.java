package asm.util;

import java.sql.Connection;

/**
 * Chạy main() để kiểm tra kết nối SQL Server.
 * Output "Connection successful: PRJdatabase" nếu OK.
 */
public class DBTest {
    public static void main(String[] args) {
        try (Connection con = DBCP.getDataSource().getConnection()) {
            System.out.println("Connection successful: " + con.getCatalog());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
