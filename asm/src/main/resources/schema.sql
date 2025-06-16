/*============================================================
   Leave‑Management v1 – Schema + Seed Data
   DB: PRJdatabase  (SQL Server)
============================================================*/

/* 0. Tạo mới DB nếu chưa có (tuỳ chọn) */
IF DB_ID('PRJdatabase') IS NOT NULL
    DROP DATABASE PRJdatabase;
GO
CREATE DATABASE PRJdatabase;
GO
USE PRJdatabase;
GO

/*------------------------------------------------------------
 1. Core reference tables
------------------------------------------------------------*/

/* 1.1 Departments */
CREATE TABLE departments (
    id           INT IDENTITY PRIMARY KEY,
    code         VARCHAR(50)  UNIQUE NOT NULL,
    name         NVARCHAR(100) NOT NULL
);

/* 1.2 Roles */
CREATE TABLE roles (
    id           INT IDENTITY PRIMARY KEY,
    code         VARCHAR(50) UNIQUE NOT NULL,
    name         NVARCHAR(100) NOT NULL
);

/*------------------------------------------------------------
 2. User & RBAC
------------------------------------------------------------*/

CREATE TABLE users (
    id           INT IDENTITY PRIMARY KEY,
    google_id    VARCHAR(50) NULL,
    email        NVARCHAR(150) UNIQUE NOT NULL,
    full_name    NVARCHAR(100) NOT NULL,
    dept_id      INT           NULL,
    active       BIT           DEFAULT 1,
    CONSTRAINT fk_users_dept FOREIGN KEY (dept_id)
        REFERENCES departments(id)
);

-- Đảm bảo google_id duy nhất khi KHÔNG NULL
CREATE UNIQUE INDEX ux_users_google_id ON users(google_id)
WHERE google_id IS NOT NULL;

CREATE TABLE user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_ur_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_ur_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

/*------------------------------------------------------------
 3. Quota & Leave Request
------------------------------------------------------------*/

CREATE TABLE annual_leave_quota (
    user_id  INT,
    [year]   INT,
    quota    INT DEFAULT 12,
    used     INT DEFAULT 0,
    PRIMARY KEY (user_id, [year]),
    CONSTRAINT fk_quota_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE leave_requests (
    id           INT IDENTITY PRIMARY KEY,
    employee_id  INT NOT NULL,
    from_date    DATE NOT NULL,
    to_date      DATE NOT NULL,
    reason       NVARCHAR(255),
    status       VARCHAR(20) NOT NULL, -- INPROGRESS / APPROVED / REJECTED
    is_edited    BIT DEFAULT 0,
    created_at   DATETIME DEFAULT GETDATE(),
    updated_at   DATETIME,
    CONSTRAINT fk_lr_emp FOREIGN KEY (employee_id) REFERENCES users(id)
);

CREATE TABLE approvals (
    id           INT IDENTITY PRIMARY KEY,
    request_id   INT NOT NULL,
    approver_id  INT NOT NULL,
    action       VARCHAR(20) NOT NULL, -- APPROVED / REJECTED
    note         NVARCHAR(255),
    action_time  DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_appr_req FOREIGN KEY (request_id) REFERENCES leave_requests(id),
    CONSTRAINT fk_appr_user FOREIGN KEY (approver_id) REFERENCES users(id)
);

/*------------------------------------------------------------
 4. Audit Log
------------------------------------------------------------*/

CREATE TABLE audit_logs (
    id          INT IDENTITY PRIMARY KEY,
    entity      VARCHAR(50) NOT NULL,
    entity_id   INT         NOT NULL,
    field       VARCHAR(100),
    old_value   NVARCHAR(255),
    new_value   NVARCHAR(255),
    action      VARCHAR(50) NOT NULL,
    actor_id    INT NOT NULL,
    log_time    DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_audit_actor FOREIGN KEY (actor_id) REFERENCES users(id)
);

/*------------------------------------------------------------
 5. Seed Data
------------------------------------------------------------*/

-- 5.1 Seed departments
INSERT INTO departments(code, name) VALUES
 ('ADMIN', N'Admin'),
 ('IT',    N'IT'),
 ('SALE',  N'Sale');

-- 5.2 Seed roles (theo yêu cầu cũ)
INSERT INTO roles(code, name) VALUES
 ('ADMIN',  N'Quản trị hệ thống'),
 ('LEADER', N'Trưởng phòng'),
 ('EMPLOYEE', N'Nhân viên');

-- 5.3 Seed users  (sử dụng dept_code để tra id)
DECLARE @deptAdmin INT, @deptIT INT, @deptSale INT;
SELECT @deptAdmin = id FROM departments WHERE code='ADMIN';
SELECT @deptIT    = id FROM departments WHERE code='IT';
SELECT @deptSale  = id FROM departments WHERE code='SALE';

INSERT INTO users(email, full_name, dept_id)
VALUES
 ('vduong2709@gmail.com',          N'Dương Admin',     @deptAdmin),
 ('ngocduongvu9999@gmail.com',     N'Dương Lead IT',   @deptIT),
 ('vndshopee1@gmail.com',          N'Nhân viên IT 1',  @deptIT),
 ('vndshopee2@gmail.com',          N'Nhân viên IT 2',  @deptIT),
 ('canvaprofds@gmail.com',         N'Nhân viên Sale 1',@deptSale),
 ('ngocduongvu.working@gmail.com', N'Dương Lead Sale', @deptSale),
 ('stepup.6m1t@gmail.com',         N'Nhân viên Sale 2',@deptSale);

-- 5.4 Gán vai trò (ADMIN cho user[1], LEADER cho user[2] & [6], EMPLOYEE cho còn lại)
DECLARE @roleAdmin INT, @roleLeader INT, @roleEmp INT;
SELECT @roleAdmin  = id FROM roles WHERE code='ADMIN';
SELECT @roleLeader = id FROM roles WHERE code='LEADER';
SELECT @roleEmp    = id FROM roles WHERE code='EMPLOYEE';

-- user_ids khớp theo insert thứ tự (IDENTITY)
INSERT INTO user_roles(user_id, role_id) VALUES
 (1, @roleAdmin), -- Dương Admin
 (2, @roleLeader), -- Dương Lead IT
 (3, @roleEmp), (4, @roleEmp), -- Nhân viên IT
 (5, @roleEmp), -- Nhân viên Sale 1
 (6, @roleLeader), -- Dương Lead Sale
 (7, @roleEmp); -- Nhân viên Sale 2

/*------------------------------------------------------------
Hoàn tất Schema + Seed
------------------------------------------------------------*/
