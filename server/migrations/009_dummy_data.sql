-- Dummy data untuk customers
INSERT INTO customers (customer_code, name, email, phone, city, address, customer_type, status) VALUES
('CUST001', 'PT Maju Jaya', 'contact@majujaya.com', '021-5551234', 'Jakarta', 'Jl. Sudirman No. 100', 'COMPANY', 'active'),
('CUST002', 'CV Berkah Abadi', 'info@berkahabadi.com', '022-5552345', 'Bandung', 'Jl. Asia Afrika No. 50', 'COMPANY', 'active'),
('CUST003', 'Toko Sejahtera', 'toko.sejahtera@gmail.com', '024-5553456', 'Semarang', 'Jl. Pemuda No. 25', 'COMPANY', 'active'),
('CUST004', 'Budi Santoso', 'budi.santoso@gmail.com', '08144444444', 'Surabaya', 'Jl. Basuki Rahmat No. 10', 'INDIVIDUAL', 'active'),
('CUST005', 'Siti Rahayu', 'siti.rahayu@gmail.com', '08155555555', 'Yogyakarta', 'Jl. Malioboro No. 75', 'INDIVIDUAL', 'active'),
('CUST006', 'PT Global Mandiri', 'sales@globalmandiri.co.id', '021-5556789', 'Jakarta', 'Jl. Gatot Subroto No. 200', 'COMPANY', 'active'),
('CUST007', 'Ahmad Hidayat', 'ahmad.h@gmail.com', '08177777777', 'Medan', 'Jl. Diponegoro No. 30', 'INDIVIDUAL', 'active'),
('CUST008', 'CV Sumber Rezeki', 'cv.sumberrezeki@yahoo.com', '031-5558901', 'Surabaya', 'Jl. Tunjungan No. 45', 'COMPANY', 'active')
ON DUPLICATE KEY UPDATE name=name;

-- Dummy data untuk attendance
INSERT INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours) VALUES
(1, '2024-01-02', '08:05:00', '17:10:00', 'PRESENT', 9.1),
(1, '2024-01-03', '08:12:00', '17:05:00', 'PRESENT', 8.9),
(1, '2024-01-04', '08:00:00', '17:15:00', 'PRESENT', 9.3),
(1, '2024-01-05', '08:35:00', '17:00:00', 'LATE', 8.4),
(2, '2024-01-02', '08:00:00', '17:20:00', 'PRESENT', 9.3),
(2, '2024-01-03', '08:08:00', '17:00:00', 'PRESENT', 8.9),
(2, '2024-01-04', NULL, NULL, 'SICK', 0),
(2, '2024-01-05', '08:02:00', '17:10:00', 'PRESENT', 9.1),
(3, '2024-01-02', '08:10:00', '17:00:00', 'PRESENT', 8.8),
(3, '2024-01-03', '08:00:00', '17:30:00', 'PRESENT', 9.5),
(3, '2024-01-04', '08:05:00', '17:00:00', 'PRESENT', 8.9),
(3, '2024-01-05', '08:00:00', '17:15:00', 'PRESENT', 9.3),
(4, '2024-01-02', '08:15:00', '17:00:00', 'PRESENT', 8.8),
(4, '2024-01-03', '08:40:00', '17:00:00', 'LATE', 8.3),
(4, '2024-01-04', '08:00:00', '17:20:00', 'PRESENT', 9.3),
(4, '2024-01-05', '08:05:00', '17:00:00', 'PRESENT', 8.9),
(5, '2024-01-02', '08:00:00', '17:10:00', 'PRESENT', 9.2),
(5, '2024-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0),
(5, '2024-01-04', NULL, NULL, 'LEAVE', 0),
(5, '2024-01-05', '08:00:00', '17:25:00', 'PRESENT', 9.4),
(6, '2024-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0),
(6, '2024-01-03', '08:10:00', '17:15:00', 'PRESENT', 9.1),
(6, '2024-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0),
(6, '2024-01-05', '08:05:00', '17:30:00', 'PRESENT', 9.4),
(7, '2024-01-02', '08:45:00', '17:00:00', 'LATE', 8.3),
(7, '2024-01-03', '08:00:00', '17:10:00', 'PRESENT', 9.2),
(7, '2024-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0),
(7, '2024-01-05', '08:00:00', '17:20:00', 'PRESENT', 9.3),
(8, '2024-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0),
(8, '2024-01-03', '08:00:00', '17:15:00', 'PRESENT', 9.3),
(8, '2024-01-04', '08:10:00', '17:00:00', 'PRESENT', 8.8),
(8, '2024-01-05', '08:00:00', '17:00:00', 'PRESENT', 9.0)
ON DUPLICATE KEY UPDATE status=status;
