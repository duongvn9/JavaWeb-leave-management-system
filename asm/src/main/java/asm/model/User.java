package asm.model;

import java.io.Serializable;

public class User implements Serializable {

    private int id;
    private String googleId;
    private String email;
    private String fullName;
    private Integer deptId;
    private boolean active;

    public User(int id, String googleId, String email, String fullName, Integer deptId, boolean active) {
        this.id = id;
        this.googleId = googleId;
        this.email = email;
        this.fullName = fullName;
        this.deptId = deptId;
        this.active = active;
    }

    public User(int id, String googleId, String email, String fullName, Integer deptId) {
        this(id, googleId, email, fullName, deptId, true);
    }

    public int getId() {
        return id;
    }

    public String getGoogleId() {
        return googleId;
    }

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public Integer getDeptId() {
        return deptId;
    }

    public boolean isActive() {
        return active;
    }

    public boolean getActive() {
        return active;
    }

}
