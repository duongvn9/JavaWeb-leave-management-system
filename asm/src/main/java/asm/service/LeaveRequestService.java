package asm.service;

import asm.dao.ApprovalDao;
import asm.dao.LeaveRequestDao;
import asm.dao.QuotaDao;
import asm.model.LeaveRequest;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class LeaveRequestService {
    private final LeaveRequestDao dao = new LeaveRequestDao();
    private final ApprovalDao approvalDao = new ApprovalDao();
    private final QuotaDao quotaDao = new QuotaDao();

    // CRUD đơn
    public int create(int employeeId, LocalDate from, LocalDate to, String reason) {
        return dao.create(employeeId, from, to, reason);
    }

    public List<LeaveRequest> listByEmployee(int id) {return dao.listByEmployee(id);}    
    public LeaveRequest findById(int id) { return dao.findById(id); }

    public void update(int id, LocalDate from, LocalDate to, String reason, boolean edited) {
        dao.update(id, from, to, reason, edited);
    }

    public void cancel(int id) { dao.cancel(id);}    

    // Quota
    public int getQuotaRemaining(int userId, int year) { return quotaDao.remaining(userId, year);}    

    // Phê duyệt
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

    // Leader/Admin list
    public List<LeaveRequest> listByDepartment(Integer deptId, boolean isAdmin) {
        return dao.listByDepartment(deptId, isAdmin);
    }
}
