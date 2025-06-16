package asm.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class LeaveRequest implements Serializable {
    private int id;
    private int employeeId;
    private LocalDate fromDate;
    private LocalDate toDate;
    private String reason;
    private String status; // INPROGRESS / APPROVED / REJECTED
    private boolean edited;
    private LocalDateTime createdAt;

    public LeaveRequest(int id, int employeeId, LocalDate fromDate, LocalDate toDate, String reason, String status, boolean edited, LocalDateTime createdAt) {
        this.id = id;
        this.employeeId = employeeId;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.reason = reason;
        this.status = status;
        this.edited = edited;
        this.createdAt = createdAt;
    }

    public int getId() {return id;}
    public int getEmployeeId() {return employeeId;}
    public LocalDate getFromDate() {return fromDate;}
    public LocalDate getToDate() {return toDate;}
    public String getReason() {return reason;}
    public String getStatus() {return status;}
    public boolean isEdited() {return edited;}
    public LocalDateTime getCreatedAt() {return createdAt;}
}
