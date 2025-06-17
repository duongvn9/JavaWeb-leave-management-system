package asm.model;

import java.io.Serializable;

/**
 * DTO người dùng, có deptId để kiểm tra quyền leader.
 */
public class User implements Serializable {
    private int id;
    private String googleId;
    private String email;
    private String fullName;
    private Integer deptId; // phòng ban (nullable)

    public User(int id, String googleId, String email, String fullName, Integer deptId) {
        this.id = id;
        this.googleId = googleId;
        this.email = email;
        this.fullName = fullName;
        this.deptId = deptId;
    }

    // Getters
    public int getId() { return id; }
    public String getGoogleId() { return googleId; }
    public String getEmail() { return email; }
    public String getFullName() { return fullName; }
    public Integer getDeptId() { return deptId; }
}
