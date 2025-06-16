package asm.service;

import asm.dao.LeaveRequestDao;
import asm.model.LeaveRequest;

import java.time.LocalDate;
import java.util.List;

public class LeaveRequestService {
    private final LeaveRequestDao dao = new LeaveRequestDao();

    public int create(int employeeId, LocalDate from, LocalDate to, String reason) {
        return dao.create(employeeId, from, to, reason);
    }

    public List<LeaveRequest> listByEmployee(int employeeId) {
        return dao.listByEmployee(employeeId);
    }

    public LeaveRequest findById(int id) {
        return dao.findById(id);
    }

    public void update(int id, LocalDate from, LocalDate to, String reason, boolean isEdited) {
        dao.update(id, from, to, reason, isEdited);
    }

    public void cancel(int id) {
        dao.cancel(id);
    }
}
