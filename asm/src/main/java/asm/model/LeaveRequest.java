package asm.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * DTO đơn nghỉ phép (phiên bản mới, thêm deptId & employeeName).
 */
public class LeaveRequest implements Serializable {
    private int id;
    private int employeeId;
    private String employeeName;
    private Integer deptId;
    private LocalDate fromDate;
    private LocalDate toDate;
    private String reason;
    private String status; // INPROGRESS / APPROVED / REJECTED / CANCELLED
    private boolean edited;
    private LocalDateTime createdAt;

    public LeaveRequest(int id, int employeeId, String employeeName, Integer deptId,
                        LocalDate fromDate, LocalDate toDate, String reason,
                        String status, boolean edited, LocalDateTime createdAt) {
        this.id = id;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
        this.deptId = deptId;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.reason = reason;
        this.status = status;
        this.edited = edited;
        this.createdAt = createdAt;
    }

    // Getters
    public int getId() { return id; }
    public int getEmployeeId() { return employeeId; }
    public String getEmployeeName() { return employeeName; }
    public Integer getDeptId() { return deptId; }
    public LocalDate getFromDate() { return fromDate; }
    public LocalDate getToDate() { return toDate; }
    public String getReason() { return reason; }
    public String getStatus() { return status; }
    public boolean isEdited() { return edited; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
