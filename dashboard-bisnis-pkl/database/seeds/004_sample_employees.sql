-- ============================================================================
-- Seed 004: Sample Employees
-- Description: Employees with attendance data
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Seed: Employees
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO employees (employee_code, name, email, phone, position, department, hire_date, status, salary, address, city, emergency_contact, emergency_phone) VALUES
('EMP001', 'Kia Ramadhani', 'kia@digital360.id', '081234560001', 'Owner & Manager', 'MANAGEMENT', '2023-01-01', 'ACTIVE', 0, 'Jl. Raya Utama No. 123', 'Surabaya', 'Ibu Kia', '081234560099'),
('EMP002', 'Andi Pratama', 'andi@digital360.id', '081234560002', 'Sales Executive', 'SALES', '2023-06-15', 'ACTIVE', 4500000, 'Jl. Merdeka No. 45', 'Surabaya', 'Sri Pratama', '081234560098'),
('EMP003', 'Dewi Lestari', 'dewi@digital360.id', '081234560003', 'Graphic Designer', 'DESIGN', '2023-08-01', 'ACTIVE', 4000000, 'Jl. Melati No. 12', 'Sidoarjo', 'Bapak Lestari', '081234560097'),
('EMP004', 'Rizal Hidayat', 'rizal@digital360.id', '081234560004', 'Production Staff', 'PRODUCTION', '2024-01-10', 'ACTIVE', 3500000, 'Jl. Kenanga No. 78', 'Gresik', 'Ibu Hidayat', '081234560096'),
('EMP005', 'Sari Wulandari', 'sari@digital360.id', '081234560005', 'Admin & Finance', 'ADMIN', '2023-09-20', 'ACTIVE', 3800000, 'Jl. Anggrek No. 33', 'Surabaya', 'Suwandi', '081234560095');

-- ----------------------------------------------------------------------------
-- Seed: Attendance (February 2025)
-- ----------------------------------------------------------------------------

-- EMP002: Andi (Sales) - First 10 days of Feb 2025
INSERT IGNORE INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes) VALUES
(2, '2025-02-01', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(2, '2025-02-02', NULL, NULL, 'ABSENT', 0.00, 'Weekend - Libur Nasional'),
(2, '2025-02-03', '08:15:00', '17:05:00', 'LATE', 7.83, 'Telat 15 menit - macet'),
(2, '2025-02-04', '08:00:00', '17:30:00', 'PRESENT', 8.50, 'Lembur 30 menit'),
(2, '2025-02-05', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(2, '2025-02-06', '08:00:00', '19:00:00', 'PRESENT', 10.00, 'Lembur 2 jam - deadline order'),
(2, '2025-02-07', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(2, '2025-02-08', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(2, '2025-02-09', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(2, '2025-02-10', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL);

-- EMP003: Dewi (Designer) - First 10 days of Feb 2025
INSERT IGNORE INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes) VALUES
(3, '2025-02-01', '08:00:00', '17:30:00', 'PRESENT', 8.50, 'Lembur finishing desain'),
(3, '2025-02-02', NULL, NULL, 'ABSENT', 0.00, 'Weekend - Libur Nasional'),
(3, '2025-02-03', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(3, '2025-02-04', '09:00:00', '17:00:00', 'LATE', 7.00, 'Telat 1 jam - dokter'),
(3, '2025-02-05', '08:00:00', '18:00:00', 'PRESENT', 9.00, 'Lembur 1 jam'),
(3, '2025-02-06', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(3, '2025-02-07', NULL, NULL, 'SICK', 0.00, 'Sakit - demam'),
(3, '2025-02-08', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(3, '2025-02-09', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(3, '2025-02-10', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL);

-- EMP004: Rizal (Production) - First 10 days of Feb 2025
INSERT IGNORE INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes) VALUES
(4, '2025-02-01', '07:30:00', '17:00:00', 'PRESENT', 8.50, 'Masuk lebih awal'),
(4, '2025-02-02', NULL, NULL, 'ABSENT', 0.00, 'Weekend - Libur Nasional'),
(4, '2025-02-03', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(4, '2025-02-04', '08:00:00', '20:00:00', 'PRESENT', 11.00, 'Lembur 3 jam - produksi marathon'),
(4, '2025-02-05', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(4, '2025-02-06', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(4, '2025-02-07', '08:00:00', '19:30:00', 'PRESENT', 10.50, 'Lembur 2.5 jam'),
(4, '2025-02-08', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(4, '2025-02-09', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(4, '2025-02-10', '07:45:00', '17:00:00', 'PRESENT', 8.25, 'Masuk lebih awal');

-- EMP005: Sari (Admin) - First 10 days of Feb 2025
INSERT IGNORE INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes) VALUES
(5, '2025-02-01', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(5, '2025-02-02', NULL, NULL, 'ABSENT', 0.00, 'Weekend - Libur Nasional'),
(5, '2025-02-03', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(5, '2025-02-04', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(5, '2025-02-05', '08:30:00', '17:00:00', 'LATE', 7.50, 'Telat 30 menit'),
(5, '2025-02-06', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(5, '2025-02-07', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL),
(5, '2025-02-08', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(5, '2025-02-09', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(5, '2025-02-10', '08:00:00', '17:00:00', 'PRESENT', 8.00, NULL);

-- EMP001: Kia (Owner) - First 10 days of Feb 2025
INSERT IGNORE INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes) VALUES
(1, '2025-02-01', '09:00:00', '18:00:00', 'PRESENT', 8.00, 'Meeting dengan klien'),
(1, '2025-02-02', NULL, NULL, 'ABSENT', 0.00, 'Weekend - Libur Nasional'),
(1, '2025-02-03', '09:30:00', '19:00:00', 'PRESENT', 8.50, 'Monitoring produksi'),
(1, '2025-02-04', '09:00:00', '20:00:00', 'PRESENT', 10.00, 'Meeting supplier'),
(1, '2025-02-05', '09:00:00', '18:00:00', 'PRESENT', 8.00, NULL),
(1, '2025-02-06', '09:00:00', '18:30:00', 'PRESENT', 8.50, 'Review keuangan'),
(1, '2025-02-07', '09:00:00', '18:00:00', 'PRESENT', 8.00, NULL),
(1, '2025-02-08', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(1, '2025-02-09', NULL, NULL, 'ABSENT', 0.00, 'Weekend'),
(1, '2025-02-10', '09:00:00', '18:00:00', 'PRESENT', 8.00, NULL);
