-- ============================================================================
-- Migration 005: HR Tables
-- Description: Employee and attendance management
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: employees
-- Description: Employee master data
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS employees (
  id INT PRIMARY KEY AUTO_INCREMENT,
  employee_code VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100),
  phone VARCHAR(20),
  position VARCHAR(50),
  department VARCHAR(50) COMMENT 'SALES, PRODUCTION, DESIGN, ADMIN, MANAGEMENT',
  hire_date DATE NOT NULL,
  resignation_date DATE,
  status ENUM('ACTIVE', 'INACTIVE', 'RESIGNED') DEFAULT 'ACTIVE',
  salary DECIMAL(15,2),
  address TEXT,
  city VARCHAR(50),
  emergency_contact VARCHAR(100),
  emergency_phone VARCHAR(20),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_code (employee_code),
  INDEX idx_department (department),
  INDEX idx_position (position)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Employee master data';

-- ----------------------------------------------------------------------------
-- Table: attendance
-- Description: Employee attendance records
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS attendance (
  id INT PRIMARY KEY AUTO_INCREMENT,
  employee_id INT NOT NULL,
  attendance_date DATE NOT NULL,
  check_in TIME,
  check_out TIME,
  status ENUM('PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'SICK', 'LEAVE', 'HOLIDAY') NOT NULL,
  work_hours DECIMAL(4,2) COMMENT 'Total work hours',
  overtime_hours DECIMAL(4,2) DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  UNIQUE KEY unique_employee_date (employee_id, attendance_date),
  INDEX idx_employee (employee_id),
  INDEX idx_date (attendance_date),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Employee attendance records';
