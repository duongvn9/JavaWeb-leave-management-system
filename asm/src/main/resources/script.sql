CREATE DATABASE [PRJdatabase]
USE [PRJdatabase]
GO
/****** Object:  Table [dbo].[annual_leave_quota]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[annual_leave_quota](
	[user_id] [int] NOT NULL,
	[year] [int] NOT NULL,
	[quota] [int] NULL,
	[used] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[approvals]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[approvals](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[request_id] [int] NOT NULL,
	[approver_id] [int] NOT NULL,
	[action] [varchar](20) NOT NULL,
	[note] [nvarchar](255) NULL,
	[action_time] [datetime] NULL,
	[auto_by_ai] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[audit_logs]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[audit_logs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[entity] [varchar](50) NOT NULL,
	[entity_id] [int] NOT NULL,
	[field] [varchar](100) NULL,
	[old_value] [nvarchar](255) NULL,
	[new_value] [nvarchar](255) NULL,
	[action] [varchar](50) NOT NULL,
	[actor_id] [int] NOT NULL,
	[log_time] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[departments]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[departments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](50) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[leave_requests]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[leave_requests](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[employee_id] [int] NOT NULL,
	[from_date] [date] NOT NULL,
	[to_date] [date] NOT NULL,
	[reason] [nvarchar](255) NULL,
	[status] [varchar](20) NOT NULL,
	[is_edited] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[ai_decision] [varchar](10) NULL,
	[approved_by] [nvarchar](255) NULL,
	[approver_type] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roles]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](50) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_roles]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_roles](
	[user_id] [int] NOT NULL,
	[role_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[google_id] [varchar](50) NULL,
	[email] [nvarchar](150) NOT NULL,
	[full_name] [nvarchar](100) NOT NULL,
	[dept_id] [int] NULL,
	[active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[annual_leave_quota] ADD  DEFAULT ((12)) FOR [quota]
GO
ALTER TABLE [dbo].[annual_leave_quota] ADD  DEFAULT ((0)) FOR [used]
GO
ALTER TABLE [dbo].[approvals] ADD  DEFAULT (getdate()) FOR [action_time]
GO
ALTER TABLE [dbo].[approvals] ADD  DEFAULT ((0)) FOR [auto_by_ai]
GO
ALTER TABLE [dbo].[audit_logs] ADD  DEFAULT (getdate()) FOR [log_time]
GO
ALTER TABLE [dbo].[leave_requests] ADD  DEFAULT ((0)) FOR [is_edited]
GO
ALTER TABLE [dbo].[leave_requests] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [active]
GO
ALTER TABLE [dbo].[annual_leave_quota]  WITH CHECK ADD  CONSTRAINT [fk_quota_user] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[annual_leave_quota] CHECK CONSTRAINT [fk_quota_user]
GO
ALTER TABLE [dbo].[approvals]  WITH CHECK ADD  CONSTRAINT [fk_appr_req] FOREIGN KEY([request_id])
REFERENCES [dbo].[leave_requests] ([id])
GO
ALTER TABLE [dbo].[approvals] CHECK CONSTRAINT [fk_appr_req]
GO
ALTER TABLE [dbo].[approvals]  WITH CHECK ADD  CONSTRAINT [fk_appr_user] FOREIGN KEY([approver_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[approvals] CHECK CONSTRAINT [fk_appr_user]
GO
ALTER TABLE [dbo].[audit_logs]  WITH CHECK ADD  CONSTRAINT [fk_audit_actor] FOREIGN KEY([actor_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[audit_logs] CHECK CONSTRAINT [fk_audit_actor]
GO
ALTER TABLE [dbo].[leave_requests]  WITH CHECK ADD  CONSTRAINT [fk_lr_emp] FOREIGN KEY([employee_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[leave_requests] CHECK CONSTRAINT [fk_lr_emp]
GO
ALTER TABLE [dbo].[user_roles]  WITH CHECK ADD  CONSTRAINT [fk_ur_role] FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([id])
GO
ALTER TABLE [dbo].[user_roles] CHECK CONSTRAINT [fk_ur_role]
GO
ALTER TABLE [dbo].[user_roles]  WITH CHECK ADD  CONSTRAINT [fk_ur_user] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[user_roles] CHECK CONSTRAINT [fk_ur_user]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [fk_users_dept] FOREIGN KEY([dept_id])
REFERENCES [dbo].[departments] ([id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [fk_users_dept]
GO

/****** Object:  Table [dbo].[app_config]    Script Date: 6/23/2025 3:05:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[app_config](
	[key] [varchar](100) NOT NULL,
	[value] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Đảm bảo có cấu hình auto_approve_enabled
IF NOT EXISTS (SELECT 1 FROM app_config WHERE [key] = 'auto_approve_enabled')
BEGIN
    INSERT INTO app_config([key], [value]) VALUES ('auto_approve_enabled', 'true');
END

-- Thêm các cột còn thiếu vào bảng leave_requests nếu chưa có
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'leave_requests' AND COLUMN_NAME = 'approved_by')
BEGIN
    ALTER TABLE leave_requests ADD approved_by NVARCHAR(255) NULL;
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'leave_requests' AND COLUMN_NAME = 'approver_type')
BEGIN
    ALTER TABLE leave_requests ADD approver_type VARCHAR(20) NULL;
END

-- Thêm các cột còn thiếu vào bảng approvals nếu chưa có
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'approvals' AND COLUMN_NAME = 'auto_by_ai')
BEGIN
    ALTER TABLE approvals ADD auto_by_ai BIT DEFAULT 0;
END

-- Cập nhật constraint cho approvals để cho phép approver_id NULL
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_appr_user')
BEGIN
    ALTER TABLE approvals DROP CONSTRAINT fk_appr_user;
    ALTER TABLE approvals ADD CONSTRAINT fk_appr_user FOREIGN KEY (approver_id) REFERENCES users(id) ON DELETE SET NULL;
END
