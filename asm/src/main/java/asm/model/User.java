package asm.model;

import java.io.Serializable;

/**
 * DTO đơn giản đại diện một người dùng.
 */
public class User implements Serializable {
    private int id;
    private String googleId;
    private String email;
    private String fullName;

    public User(int id, String googleId, String email, String fullName) {
        this.id = id;
        this.googleId = googleId;
        this.email = email;
        this.fullName = fullName;
    }

    public int getId() {return id;}
    public String getGoogleId() {return googleId;}
    public String getEmail() {return email;}
    public String getFullName() {return fullName;}
}
