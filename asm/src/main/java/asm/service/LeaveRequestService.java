package asm.service;

import asm.dao.LeaveRequestDao;
import asm.dao.ApprovalDao;
import asm.dao.QuotaDao;
import asm.model.LeaveRequest;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Service xử lý nghiệp vụ đơn nghỉ phép, có thêm AI Auto-Approve.
 */
public class LeaveRequestService {
    private final LeaveRequestDao dao = new LeaveRequestDao();
    private final ApprovalDao approvalDao = new ApprovalDao();
    private final QuotaDao quotaDao = new QuotaDao();
    private final LeaveAutoService autoService = new LeaveAutoService();

    /**
     * Tạo đơn mới và gọi AI Auto-Approve
     */
    public int create(int employeeId, LocalDate from, LocalDate to, String reason) {
        // Lưu đơn
        int id = dao.create(employeeId, from, to, reason);
        // Lấy lại đối tượng để gửi cho AI
        LeaveRequest lr = dao.findById(id);
        autoService.evaluate(lr);
        return id;
    }

    public List<LeaveRequest> listByEmployee(int id) { return dao.listByEmployee(id); }
    public LeaveRequest findById(int id)      { return dao.findById(id); }

    public void update(int id, LocalDate from, LocalDate to, String reason, boolean edited) {
        dao.update(id, from, to, reason, edited);
    }

    public void cancel(int id) { dao.cancel(id); }

    public int getQuotaRemaining(int userId, int year) {
        return quotaDao.remaining(userId, year);
    }

    public void approveOrReject(int reqId, int approverId, boolean isAdmin, String action, String note) {
        LeaveRequest lr = dao.findById(reqId);
        long days = ChronoUnit.DAYS.between(lr.getFromDate(), lr.getToDate()) + 1;
        if ("APPROVE".equalsIgnoreCase(action)) {
            quotaDao.decreaseUsed(lr.getEmployeeId(), lr.getFromDate().getYear(), (int) days);
            dao.updateStatus(reqId, "APPROVED");
        } else {
            dao.updateStatus(reqId, "REJECTED");
        }
        approvalDao.insert(reqId, approverId, action.toUpperCase(), note, false);
    }

    public List<LeaveRequest> listByDepartment(Integer deptId, boolean isAdmin) {
        return dao.listByDepartment(deptId, isAdmin);
    }

    public List<LeaveRequest> listByEmployeeAndStatus(int empId, String status) {
        return dao.listByEmployeeAndStatus(empId, status);
    }
}