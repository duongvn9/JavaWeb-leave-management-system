# JavaWeb Leave Management System

## Tổng quan

Đây là hệ thống quản lý nghỉ phép cho doanh nghiệp, xây dựng bằng Java Servlet/JSP, tuân thủ mô hình MVC, sử dụng Jakarta EE, JSTL, JDBC và Google OAuth. Hệ thống hỗ trợ phân quyền (RBAC) cho các vai trò: Admin, Leader, Employee.

- **Tác giả:** duongvn9
- **Phiên bản:** 1.4
- **Github:** https://github.com/duongvn9/JavaWeb-leave-management-system

## Cấu trúc dự án

```
asm/
├── src/
│   ├── main/
│   │   ├── java/asm/
│   │   │   ├── controller/   # Servlet xử lý request (MVC Controller)
│   │   │   ├── dao/          # Data Access Object (truy vấn DB)
│   │   │   ├── model/        # Entity/model (User, Department, LeaveRequest...)
│   │   │   ├── service/      # Business logic (LeaveRequestService...)
│   │   │   ├── util/         # Tiện ích, cấu hình
│   │   │   ├── filter/       # RBAC Filter
│   │   │   ├── integrations/ # Tích hợp ngoài (Google OAuth, Gemini...)
│   │   ├── resources/        # Cấu hình, script.sql
│   │   ├── webapp/
│   │   │   ├── WEB-INF/jsp/  # Giao diện JSP (dashboard, leave, admin...)
│   │   │   ├── WEB-INF/web.xml # Cấu hình web
│   │   │   └── index.html
│   └── test/                 # Unit test (nếu có)
├── pom.xml                   # Maven build file
```

## Chức năng chính

### 1. Đăng nhập
- Đăng nhập bằng Google OAuth (chỉ user đã đăng ký mới vào được hệ thống).

### 2. Dashboard
- Giao diện tổng quan, hiển thị thông tin cá nhân, vai trò, phòng ban.

### 3. Quản lý đơn nghỉ phép
- Nhân viên tạo, sửa, huỷ đơn nghỉ phép.
- Xem danh sách đơn nghỉ phép của mình, lọc theo trạng thái.

### 4. Duyệt đơn nghỉ phép
- Leader/Admin xem và duyệt/từ chối đơn nghỉ phép của nhân viên phòng ban hoặc toàn công ty.
- Xem lịch sử, trạng thái đơn.

### 5. Quản lý người dùng (Admin)
- Thêm, sửa, xoá user.
- Gán phòng ban, vai trò cho user.
- Xem danh sách user toàn hệ thống.

### 6. Quản lý nhân sự phòng ban (Leader/Admin)
- Xem danh sách nhân viên theo phòng ban.
- Lọc theo phòng ban (Admin).

### 7. Phân quyền (RBAC)
- 3 vai trò: ADMIN, LEADER, EMPLOYEE.
- Chỉ Admin mới truy cập được chức năng quản trị.
- Leader chỉ xem/duyệt đơn của phòng mình.

### 8. Cơ sở dữ liệu
- SQL Server, file `script.sql` cung cấp cấu trúc bảng và dữ liệu mẫu.
- Các bảng chính: users, departments, roles, user_roles, leave_requests, approvals, annual_leave_quota.

## Công nghệ sử dụng
- Java Servlet/JSP (Jakarta EE 10)
- JSTL 3.0
- JDBC, HikariCP
- Google OAuth 2.0
- SQL Server
- Bootstrap 5, FontAwesome (giao diện)

## Hướng dẫn cài đặt
1. Clone project về máy.
2. Import vào IDE (IntelliJ/NetBeans/Eclipse) dạng Maven project.
3. Cấu hình DB SQL Server, import file `script.sql`.
4. Cập nhật thông tin Google OAuth trong file cấu hình.
5. Build và deploy lên server (Tomcat/Payara...)

---

> Mọi thắc mắc vui lòng liên hệ tác giả qua Github hoặc Facebook.
