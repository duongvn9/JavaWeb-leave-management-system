package asm.service;

import asm.dao.LeaveRequestDao;
import asm.dao.ApprovalDao;
import asm.dao.QuotaDao;
import asm.dao.UserDao;
import asm.dao.AppConfigDao;
import asm.model.LeaveRequest;
import asm.util.LeaveRuleLoader;

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
    private final AppConfigDao configDao = new AppConfigDao();

    /**
     * Tạo đơn mới và gọi AI Auto-Approve
     */
    public int create(int employeeId, LocalDate from, LocalDate to, String reason) {
        // Lưu đơn
        int id = dao.create(employeeId, from, to, reason);
        // Lấy lại đối tượng để gửi cho AI
        LeaveRequest lr = dao.findById(id);
        int remain = getQuotaRemaining(lr.getEmployeeId(), lr.getFromDate().getYear());
        
        // Đọc cấu hình từ database thay vì YAML
        String autoApproveConfig = configDao.getCachedAutoApprove();
        boolean autoApprove = autoApproveConfig == null ? true : "true".equals(autoApproveConfig);
        
        if (autoApprove) {
            String aiDecision = autoService.evaluate(lr, remain);
            dao.updateAiDecision(id, aiDecision);
            if ("APPROVED".equals(aiDecision)) {
                long days = ChronoUnit.DAYS.between(lr.getFromDate(), lr.getToDate()) + 1;
                quotaDao.decreaseUsed(lr.getEmployeeId(), lr.getFromDate().getYear(), (int) days);
                dao.updateStatusAndApprover(id, "APPROVED", null, "AI");
                // Ghi log vào bảng approvals
                approvalDao.insert(id, null, "APPROVED", "Tự động duyệt bởi AI", true);
            } else if ("REJECTED".equals(aiDecision)) {
                dao.updateStatusAndApprover(id, "REJECTED", null, "AI");
                // Ghi log vào bảng approvals
                approvalDao.insert(id, null, "REJECTED", "Tự động từ chối bởi AI", true);
            }
            // Nếu là CONSIDER thì giữ nguyên trạng thái INPROGRESS
        }
        // Nếu autoApprove=false thì luôn giữ trạng thái INPROGRESS
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
        UserDao userDao = new UserDao();
        String approverName = null;
        asm.model.User user = userDao.findById(approverId);
        if (user != null) {
            approverName = user.getFullName() + " (ID: " + user.getId() + ")";
        } else {
            approverName = String.valueOf(approverId);
        }
        if ("APPROVE".equalsIgnoreCase(action)) {
            quotaDao.decreaseUsed(lr.getEmployeeId(), lr.getFromDate().getYear(), (int) days);
            dao.updateStatusAndApprover(reqId, "APPROVED", approverName, "USER");
        } else {
            dao.updateStatusAndApprover(reqId, "REJECTED", approverName, "USER");
        }
        approvalDao.insert(reqId, approverId, action.toUpperCase(), note, false);
    }

    public List<LeaveRequest> listByDepartment(Integer deptId, boolean isAdmin) {
        return dao.listByDepartment(deptId, isAdmin);
    }

    public List<LeaveRequest> listByEmployeeAndStatus(int empId, String status) {
        return dao.listByEmployeeAndStatus(empId, status);
    }

    public List<LeaveRequest> listByDepartmentAndStatus(Integer deptId, boolean isAdmin, String status) {
        return dao.listByDepartmentAndStatus(deptId, isAdmin, status);
    }
}