package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;
import asm.model.User;
import asm.model.LeaveRequest;
import asm.service.LeaveRequestService;
import java.util.*;

@WebServlet("/employee/agenda-report")
public class EmployeeAgendaReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/signin.jsp");
            return;
        }
        String fromParam = request.getParameter("from");
        String toParam = request.getParameter("to");
        LocalDate today = LocalDate.now();
        LocalDate fromDate, toDate;
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter fmtDMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        if (fromParam != null && !fromParam.isEmpty() && toParam != null && !toParam.isEmpty()) {
            try {
                fromDate = LocalDate.parse(fromParam, fmt);
                toDate = LocalDate.parse(toParam, fmt);
            } catch (Exception e1) {
                try {
                    fromDate = LocalDate.parse(fromParam, fmtDMY);
                    toDate = LocalDate.parse(toParam, fmtDMY);
                } catch (Exception e2) {
                    fromDate = today.with(DayOfWeek.MONDAY);
                    toDate = today.with(DayOfWeek.SUNDAY);
                }
            }
        } else {
            fromDate = today.with(DayOfWeek.MONDAY);
            toDate = today.with(DayOfWeek.SUNDAY);
        }
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        // Chỉ lấy user hiện tại
        List<User> users = new ArrayList<>();
        users.add(user);
        request.setAttribute("users", users);

        // Lấy danh sách ngày
        List<LocalDate> days = new ArrayList<>();
        List<String> daysStr = new ArrayList<>();
        DateTimeFormatter dmyFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        for (LocalDate d = fromDate; !d.isAfter(toDate); d = d.plusDays(1)) {
            days.add(d);
            daysStr.add(d.format(dmyFmt));
        }
        request.setAttribute("days", days);
        request.setAttribute("daysStr", daysStr);

        // Lấy danh sách đơn nghỉ phép đã duyệt của user trong khoảng
        LeaveRequestService leaveService = new LeaveRequestService();
        List<LeaveRequest> leaves = leaveService.listByEmployeeAndStatus(user.getId(), "APPROVED");

        // Tổng hợp dữ liệu agenda: userId -> (date -> status)
        Map<Integer, Map<LocalDate, String>> agendaMap = new HashMap<>();
        Map<LocalDate, String> dayMap = new HashMap<>();
        for (LocalDate d : days) {
            dayMap.put(d, "WORKING");
        }
        for (LeaveRequest lr : leaves) {
            for (LocalDate d = lr.getFromDate(); !d.isAfter(lr.getToDate()); d = d.plusDays(1)) {
                if (d.isBefore(fromDate) || d.isAfter(toDate)) continue;
                dayMap.put(d, "ON_LEAVE");
            }
        }
        agendaMap.put(user.getId(), dayMap);
        request.setAttribute("agendaMap", agendaMap);

        request.getRequestDispatcher("/WEB-INF/jsp/employee/agenda-report.jsp").forward(request, response);
    }
} 