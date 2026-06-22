-- Reset and seed fresh dummy data
-- This migration will clear existing data and insert new dummy data

-- =====================
-- ADD MISSING COLUMNS/TABLES FIRST
-- =====================
-- Add reference_number to transactions if not exists
ALTER TABLE transactions ADD COLUMN reference_number VARCHAR(50) NULL;

-- Add whatsapp and other fields to customers if not exists
ALTER TABLE customers ADD COLUMN whatsapp VARCHAR(20) NULL AFTER phone;
ALTER TABLE customers ADD COLUMN credit_limit DECIMAL(15,2) NULL;
ALTER TABLE customers ADD COLUMN payment_terms VARCHAR(20) DEFAULT 'COD';
ALTER TABLE customers ADD COLUMN needs_plan TEXT NULL;
ALTER TABLE customers ADD COLUMN pic_user_id INT NULL;
ALTER TABLE customers ADD COLUMN pic_name VARCHAR(100) NULL;
ALTER TABLE customers ADD COLUMN npwp VARCHAR(30) NULL;
ALTER TABLE customers ADD COLUMN tax_address TEXT NULL;

-- Add bio and other fields to employees if not exists
ALTER TABLE employees ADD COLUMN bio TEXT NULL;
ALTER TABLE employees ADD COLUMN birth_date DATE NULL;

-- Add nickname and employee_id to users if not exists
ALTER TABLE users ADD COLUMN nickname VARCHAR(50) NULL AFTER name;
ALTER TABLE users ADD COLUMN employee_id INT NULL;

-- Create leave_requests table if not exists
CREATE TABLE IF NOT EXISTS leave_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  leave_type ENUM('SICK', 'ANNUAL', 'PERSONAL', 'OTHER') NOT NULL DEFAULT 'PERSONAL',
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  reason TEXT,
  status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
  approved_by INT NULL,
  approved_at DATETIME NULL,
  notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================
-- NOW CLEAR EXISTING DATA
-- =====================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM stock_movements;
DELETE FROM stock_balances;
DELETE FROM product_color_sizes;
DELETE FROM product_colors;
DELETE FROM attendance;
DELETE FROM leave_requests;
DELETE FROM transactions;
DELETE FROM user_sessions;
DELETE FROM users;
DELETE FROM employees;
DELETE FROM customers;
DELETE FROM products;
DELETE FROM colors;
DELETE FROM sizes;
DELETE FROM locations;

-- Reset auto increment
ALTER TABLE stock_movements AUTO_INCREMENT = 1;
ALTER TABLE stock_balances AUTO_INCREMENT = 1;
ALTER TABLE product_color_sizes AUTO_INCREMENT = 1;
ALTER TABLE product_colors AUTO_INCREMENT = 1;
ALTER TABLE attendance AUTO_INCREMENT = 1;
ALTER TABLE leave_requests AUTO_INCREMENT = 1;
ALTER TABLE transactions AUTO_INCREMENT = 1;
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE employees AUTO_INCREMENT = 1;
ALTER TABLE customers AUTO_INCREMENT = 1;
ALTER TABLE products AUTO_INCREMENT = 1;
ALTER TABLE colors AUTO_INCREMENT = 1;
ALTER TABLE sizes AUTO_INCREMENT = 1;
ALTER TABLE locations AUTO_INCREMENT = 1;

-- Drop foreign key constraint on leave_requests.approved_by (references users which is cleared)
ALTER TABLE leave_requests DROP FOREIGN KEY leave_requests_ibfk_2;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================
-- LOCATIONS
-- =====================
INSERT INTO locations (id, name, type, description) VALUES
(1, 'Gudang Utama', 'warehouse', 'Gudang penyimpanan utama'),
(2, 'Display Toko', 'display', 'Area display produk di toko'),
(3, 'Storage Belakang', 'storage', 'Penyimpanan sementara');

-- =====================
-- COLORS
-- =====================
INSERT INTO colors (id, name, hex_code) VALUES
(1, 'Hitam', '#000000'),
(2, 'Putih', '#FFFFFF'),
(3, 'Merah', '#FF0000'),
(4, 'Biru Navy', '#000080'),
(5, 'Abu-abu', '#808080'),
(6, 'Coklat', '#8B4513'),
(7, 'Cream', '#FFFDD0'),
(8, 'Olive', '#808000');

-- =====================
-- SIZES
-- =====================
INSERT INTO sizes (id, name, sort_order) VALUES
(1, 'XS', 1),
(2, 'S', 2),
(3, 'M', 3),
(4, 'L', 4),
(5, 'XL', 5),
(6, 'XXL', 6),
(7, 'XXXL', 7);

-- =====================
-- PRODUCTS
-- =====================
INSERT INTO products (id, name, code, category, description, base_price, retail_price, status) VALUES
(1, 'Kaos Polos Basic', 'KPB001', 'Kaos', 'Kaos polos bahan cotton combed 30s', 50000, 85000, 'active'),
(2, 'Kemeja Formal', 'KMF001', 'Kemeja', 'Kemeja formal bahan katun premium', 120000, 185000, 'active'),
(3, 'Celana Chino', 'CCH001', 'Celana', 'Celana chino slim fit', 150000, 225000, 'active'),
(4, 'Jaket Hoodie', 'JKH001', 'Jaket', 'Jaket hoodie fleece tebal', 180000, 275000, 'active'),
(5, 'Polo Shirt', 'PLS001', 'Kaos', 'Polo shirt lacoste cotton', 85000, 145000, 'active');

-- =====================
-- PRODUCT COLORS
-- =====================
INSERT INTO product_colors (id, product_id, color_id, additional_price) VALUES
-- Kaos Polos Basic (Hitam, Putih, Abu-abu, Navy)
(1, 1, 1, 0), (2, 1, 2, 0), (3, 1, 5, 0), (4, 1, 4, 0),
-- Kemeja Formal (Putih, Biru Navy, Abu-abu)
(5, 2, 2, 0), (6, 2, 4, 0), (7, 2, 5, 0),
-- Celana Chino (Hitam, Cream, Olive, Coklat)
(8, 3, 1, 0), (9, 3, 7, 0), (10, 3, 8, 0), (11, 3, 6, 0),
-- Jaket Hoodie (Hitam, Abu-abu, Navy)
(12, 4, 1, 0), (13, 4, 5, 0), (14, 4, 4, 0),
-- Polo Shirt (Putih, Hitam, Merah, Navy)
(15, 5, 2, 0), (16, 5, 1, 0), (17, 5, 3, 0), (18, 5, 4, 0);

-- =====================
-- PRODUCT COLOR SIZES (SKU level)
-- =====================
INSERT INTO product_color_sizes (id, product_color_id, size_id, sku, additional_price) VALUES
-- Kaos Polos Hitam (S, M, L, XL)
(1, 1, 2, 'KPB001-BLK-S', 0), (2, 1, 3, 'KPB001-BLK-M', 0), (3, 1, 4, 'KPB001-BLK-L', 0), (4, 1, 5, 'KPB001-BLK-XL', 0),
-- Kaos Polos Putih
(5, 2, 2, 'KPB001-WHT-S', 0), (6, 2, 3, 'KPB001-WHT-M', 0), (7, 2, 4, 'KPB001-WHT-L', 0), (8, 2, 5, 'KPB001-WHT-XL', 0),
-- Kaos Polos Abu
(9, 3, 2, 'KPB001-GRY-S', 0), (10, 3, 3, 'KPB001-GRY-M', 0), (11, 3, 4, 'KPB001-GRY-L', 0), (12, 3, 5, 'KPB001-GRY-XL', 0),
-- Kemeja Putih
(13, 5, 3, 'KMF001-WHT-M', 0), (14, 5, 4, 'KMF001-WHT-L', 0), (15, 5, 5, 'KMF001-WHT-XL', 0),
-- Kemeja Navy
(16, 6, 3, 'KMF001-NVY-M', 0), (17, 6, 4, 'KMF001-NVY-L', 0), (18, 6, 5, 'KMF001-NVY-XL', 0),
-- Celana Chino Hitam
(19, 8, 3, 'CCH001-BLK-M', 0), (20, 8, 4, 'CCH001-BLK-L', 0), (21, 8, 5, 'CCH001-BLK-XL', 0),
-- Celana Chino Cream
(22, 9, 3, 'CCH001-CRM-M', 0), (23, 9, 4, 'CCH001-CRM-L', 0), (24, 9, 5, 'CCH001-CRM-XL', 0),
-- Jaket Hoodie Hitam
(25, 12, 3, 'JKH001-BLK-M', 0), (26, 12, 4, 'JKH001-BLK-L', 0), (27, 12, 5, 'JKH001-BLK-XL', 0),
-- Polo Shirt Putih
(28, 15, 3, 'PLS001-WHT-M', 0), (29, 15, 4, 'PLS001-WHT-L', 0), (30, 15, 5, 'PLS001-WHT-XL', 0);

-- =====================
-- STOCK BALANCES
-- =====================
INSERT INTO stock_balances (product_color_size_id, location_id, quantity, moving_avg_cost) VALUES
-- Kaos Polos di Gudang Utama
(1, 1, 50, 50000), (2, 1, 75, 50000), (3, 1, 60, 50000), (4, 1, 40, 50000),
(5, 1, 45, 50000), (6, 1, 80, 50000), (7, 1, 55, 50000), (8, 1, 35, 50000),
(9, 1, 30, 50000), (10, 1, 40, 50000), (11, 1, 25, 50000), (12, 1, 20, 50000),
-- Kemeja di Gudang
(13, 1, 20, 120000), (14, 1, 25, 120000), (15, 1, 15, 120000),
(16, 1, 18, 120000), (17, 1, 22, 120000), (18, 1, 12, 120000),
-- Celana Chino
(19, 1, 15, 150000), (20, 1, 20, 150000), (21, 1, 10, 150000),
(22, 1, 12, 150000), (23, 1, 18, 150000), (24, 1, 8, 150000),
-- Jaket Hoodie
(25, 1, 10, 180000), (26, 1, 15, 180000), (27, 1, 8, 180000),
-- Polo Shirt
(28, 1, 25, 85000), (29, 1, 30, 85000), (30, 1, 20, 85000),
-- Some items in Display
(2, 2, 5, 50000), (6, 2, 5, 50000), (14, 2, 3, 120000), (20, 2, 3, 150000);

-- =====================
-- STOCK MOVEMENTS
-- =====================
INSERT INTO stock_movements (product_color_size_id, location_id, movement_type, quantity, reason_code, reference_type, reference_id, movement_date, created_by) VALUES
-- Initial stock purchases
(1, 1, 'IN', 50, 'PURCHASE', NULL, NULL, '2024-01-01 08:00:00', 'Admin'),
(2, 1, 'IN', 80, 'PURCHASE', NULL, NULL, '2024-01-01 08:00:00', 'Admin'),
(3, 1, 'IN', 60, 'PURCHASE', NULL, NULL, '2024-01-01 08:00:00', 'Admin'),
(5, 1, 'IN', 50, 'PURCHASE', NULL, NULL, '2024-01-01 08:00:00', 'Admin'),
(6, 1, 'IN', 85, 'PURCHASE', NULL, NULL, '2024-01-01 08:00:00', 'Admin'),
-- Sales movements
(2, 1, 'OUT', 5, 'SALES_OUT', 'TRANSACTION', 1, '2024-01-15 10:30:00', 'Rina'),
(6, 1, 'OUT', 5, 'SALES_OUT', 'TRANSACTION', 2, '2024-01-16 14:00:00', 'Dewi'),
-- Transfer to display
(2, 2, 'IN', 5, 'TRANSFER', NULL, NULL, '2024-01-10 09:00:00', 'Admin'),
(6, 2, 'IN', 5, 'TRANSFER', NULL, NULL, '2024-01-10 09:00:00', 'Admin'),
(14, 2, 'IN', 3, 'TRANSFER', NULL, NULL, '2024-01-10 09:00:00', 'Admin'),
(20, 2, 'IN', 3, 'TRANSFER', NULL, NULL, '2024-01-10 09:00:00', 'Admin');

-- =====================
-- EMPLOYEES
-- =====================
INSERT INTO employees (id, employee_code, name, email, phone, position, department, hire_date, status, salary, bio, address, birth_date, emergency_contact, emergency_phone) VALUES
(1, 'EMP001', 'Ahmad Rizki Pratama', 'ahmad.rizki@company.com', '081234567890', 'IT Manager', 'IT', '2022-01-15', 'ACTIVE', 12000000, 'Laki-laki, Jakarta', 'Jl. Sudirman No. 100, Jakarta Selatan', '1990-05-15', 'Siti Nurhaliza', '081234567891'),
(2, 'EMP002', 'Siti Nurhaliza', 'siti.nurhaliza@company.com', '081234567891', 'HR Manager', 'Management', '2021-06-01', 'ACTIVE', 15000000, 'Perempuan, Bandung', 'Jl. Dago No. 50, Bandung', '1988-08-20', 'Ahmad Rizki', '081234567890'),
(3, 'EMP003', 'Budi Santoso', 'budi.santoso@company.com', '081234567892', 'Finance Staff', 'Finance', '2023-03-01', 'ACTIVE', 8000000, 'Laki-laki, Surabaya', 'Jl. Pemuda No. 25, Surabaya', '1995-03-10', 'Dewi Lestari', '081234567893'),
(4, 'EMP004', 'Dewi Lestari', 'dewi.lestari@company.com', '081234567893', 'Customer Service Lead', 'Customer Service', '2022-08-15', 'ACTIVE', 9000000, 'Perempuan, Yogyakarta', 'Jl. Malioboro No. 75, Yogyakarta', '1993-12-25', 'Budi Santoso', '081234567892'),
(5, 'EMP005', 'Rina Wulandari', 'rina.wulandari@company.com', '081234567894', 'Sales Executive', 'Operations', '2023-01-10', 'ACTIVE', 7500000, 'Perempuan, Semarang', 'Jl. Pandanaran No. 30, Semarang', '1996-07-08', 'Agus Hermawan', '081234567895'),
(6, 'EMP006', 'Agus Hermawan', 'agus.hermawan@company.com', '081234567895', 'Warehouse Staff', 'Operations', '2023-05-20', 'ACTIVE', 6000000, 'Laki-laki, Medan', 'Jl. Gatot Subroto No. 45, Medan', '1998-02-14', 'Rina Wulandari', '081234567894'),
(7, 'EMP007', 'Maya Sari', 'maya.sari@company.com', '081234567896', 'Customer Service', 'Customer Service', '2023-07-01', 'ACTIVE', 6500000, 'Perempuan, Makassar', 'Jl. Pettarani No. 60, Makassar', '1997-11-30', 'Lisa Permata', '081234567897'),
(8, 'EMP008', 'Lisa Permata', 'lisa.permata@company.com', '081234567897', 'Sales Executive', 'Operations', '2023-09-15', 'ACTIVE', 7000000, 'Perempuan, Bali', 'Jl. Sunset Road No. 88, Bali', '1999-04-22', 'Maya Sari', '081234567896');

-- =====================
-- USERS - Will be created via /api/auth/setup or seed script
-- Run: curl -X POST http://localhost:3001/api/auth/setup
-- =====================
-- Default users created by /auth/setup:
-- admin/admin123, it_staff/it123, cs_staff/cs123, ops_staff/ops123, finance_staff/finance123

-- =====================
-- CUSTOMERS (with new fields)
-- =====================
INSERT INTO customers (id, customer_code, name, email, phone, whatsapp, city, address, customer_type, status, credit_limit, payment_terms, needs_plan, pic_user_id, pic_name, npwp, tax_address, total_purchases, total_spent) VALUES
(1, 'CUST001', 'PT Maju Jaya', 'contact@majujaya.com', '021-5551234', '08115551234', 'Jakarta', 'Jl. Sudirman No. 100, Jakarta Selatan', 'COMPANY', 'active', 50000000, 'NET30', 'Kebutuhan seragam kantor bulanan, estimasi 100 pcs/bulan', 6, 'Rina', '01.234.567.8-901.000', 'Jl. Sudirman No. 100, Jakarta Selatan', 15, 12750000),
(2, 'CUST002', 'CV Berkah Abadi', 'info@berkahabadi.com', '022-5552345', '08115552345', 'Bandung', 'Jl. Asia Afrika No. 50, Bandung', 'COMPANY', 'active', 30000000, 'NET14', 'Reseller, ambil stok tiap minggu', 9, 'Lisa', '02.345.678.9-012.000', 'Jl. Asia Afrika No. 50, Bandung', 22, 18500000),
(3, 'CUST003', 'Toko Sejahtera', 'toko.sejahtera@gmail.com', '024-5553456', '08115553456', 'Semarang', 'Jl. Pemuda No. 25, Semarang', 'COMPANY', 'active', 20000000, 'NET14', 'Toko retail, fokus kaos polos', 6, 'Rina', NULL, NULL, 8, 4250000),
(4, 'CUST004', 'Budi Santoso', 'budi.customer@gmail.com', '08144444444', '08144444444', 'Surabaya', 'Jl. Basuki Rahmat No. 10, Surabaya', 'INDIVIDUAL', 'active', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, 3, 850000),
(5, 'CUST005', 'Siti Rahayu', 'siti.rahayu@gmail.com', '08155555555', '08155555555', 'Yogyakarta', 'Jl. Malioboro No. 75, Yogyakarta', 'INDIVIDUAL', 'active', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, 5, 1275000),
(6, 'CUST006', 'PT Global Mandiri', 'sales@globalmandiri.co.id', '021-5556789', '08115556789', 'Jakarta', 'Jl. Gatot Subroto No. 200, Jakarta', 'COMPANY', 'active', 100000000, 'NET45', 'Corporate client, seragam untuk 500+ karyawan', 9, 'Lisa', '03.456.789.0-123.000', 'Jl. Gatot Subroto No. 200, Jakarta', 4, 45000000),
(7, 'CUST007', 'Ahmad Hidayat', 'ahmad.h@gmail.com', '08177777777', '08177777777', 'Medan', 'Jl. Diponegoro No. 30, Medan', 'INDIVIDUAL', 'active', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, 2, 425000),
(8, 'CUST008', 'CV Sumber Rezeki', 'cv.sumberrezeki@yahoo.com', '031-5558901', '08115558901', 'Surabaya', 'Jl. Tunjungan No. 45, Surabaya', 'COMPANY', 'active', 25000000, 'NET14', 'Distributor area Jawa Timur', 6, 'Rina', '04.567.890.1-234.000', 'Jl. Tunjungan No. 45, Surabaya', 12, 9800000);

-- =====================
-- TRANSACTIONS
-- =====================
INSERT INTO transactions (id, transaction_type, transaction_date, customer_id, total_amount, payment_method, payment_status, pic, notes, items, reference_number) VALUES
(1, 'SALE', '2024-01-15', 1, 850000, 'BANK_TRANSFER', 'PAID', 'Rina', 'Promo: normal', '[{"name":"Kaos Polos Basic","color":"Hitam","size":"M","quantity":5,"price":85000,"product_color_size_id":2},{"name":"Kaos Polos Basic","color":"Hitam","size":"L","quantity":5,"price":85000,"product_color_size_id":3}]', 'INV-20240115-0001'),
(2, 'SALE', '2024-01-16', 2, 1480000, 'BANK_TRANSFER', 'PAID', 'Lisa', 'Promo: normal', '[{"name":"Kemeja Formal","color":"Putih","size":"L","quantity":4,"price":185000,"product_color_size_id":14},{"name":"Kemeja Formal","color":"Navy","size":"L","quantity":4,"price":185000,"product_color_size_id":17}]', 'INV-20240116-0001'),
(3, 'SALE', '2024-01-17', 4, 255000, 'CASH', 'PAID', 'Rina', NULL, '[{"name":"Kaos Polos Basic","color":"Putih","size":"L","quantity":3,"price":85000,"product_color_size_id":7}]', 'INV-20240117-0001'),
(4, 'SALE', '2024-01-18', 6, 2750000, 'BANK_TRANSFER', 'PAID', 'Lisa', 'Promo: special', '[{"name":"Jaket Hoodie","color":"Hitam","size":"L","quantity":10,"price":275000,"product_color_size_id":26}]', 'INV-20240118-0001'),
(5, 'EXPENSE', '2024-01-19', NULL, 500000, 'CASH', 'PAID', 'Admin', 'Operasional: Listrik dan air bulan Januari', '[]', 'EXP-20240119-0001'),
(6, 'SALE', '2024-01-20', 3, 680000, 'CASH', 'PAID', 'Rina', NULL, '[{"name":"Kaos Polos Basic","color":"Abu-abu","size":"M","quantity":4,"price":85000,"product_color_size_id":10},{"name":"Kaos Polos Basic","color":"Abu-abu","size":"L","quantity":4,"price":85000,"product_color_size_id":11}]', 'INV-20240120-0001');

-- =====================
-- ATTENDANCE (current month data)
-- =====================
INSERT INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours) VALUES
-- This month's attendance
(1, CURDATE() - INTERVAL 5 DAY, '07:55:00', '17:10:00', 'PRESENT', 9.2),
(1, CURDATE() - INTERVAL 4 DAY, '08:05:00', '17:00:00', 'PRESENT', 8.9),
(1, CURDATE() - INTERVAL 3 DAY, '08:00:00', '17:15:00', 'PRESENT', 9.3),
(1, CURDATE() - INTERVAL 2 DAY, '08:15:00', '17:00:00', 'LATE', 8.8),
(1, CURDATE() - INTERVAL 1 DAY, '07:50:00', '17:20:00', 'PRESENT', 9.5),
(2, CURDATE() - INTERVAL 5 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(2, CURDATE() - INTERVAL 4 DAY, '08:10:00', '17:05:00', 'PRESENT', 8.9),
(2, CURDATE() - INTERVAL 3 DAY, NULL, NULL, 'SICK', 0),
(2, CURDATE() - INTERVAL 2 DAY, '08:00:00', '17:30:00', 'PRESENT', 9.5),
(2, CURDATE() - INTERVAL 1 DAY, '08:02:00', '17:00:00', 'PRESENT', 9.0),
(3, CURDATE() - INTERVAL 5 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(3, CURDATE() - INTERVAL 4 DAY, '07:58:00', '17:10:00', 'PRESENT', 9.2),
(3, CURDATE() - INTERVAL 3 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(3, CURDATE() - INTERVAL 2 DAY, '08:05:00', '17:15:00', 'PRESENT', 9.2),
(3, CURDATE() - INTERVAL 1 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(4, CURDATE() - INTERVAL 5 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(4, CURDATE() - INTERVAL 4 DAY, '08:20:00', '17:00:00', 'LATE', 8.7),
(4, CURDATE() - INTERVAL 3 DAY, '08:00:00', '17:20:00', 'PRESENT', 9.3),
(4, CURDATE() - INTERVAL 2 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(4, CURDATE() - INTERVAL 1 DAY, '07:55:00', '17:10:00', 'PRESENT', 9.3),
(5, CURDATE() - INTERVAL 5 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(5, CURDATE() - INTERVAL 4 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(5, CURDATE() - INTERVAL 3 DAY, NULL, NULL, 'LEAVE', 0),
(5, CURDATE() - INTERVAL 2 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(5, CURDATE() - INTERVAL 1 DAY, '08:05:00', '17:15:00', 'PRESENT', 9.2),
(6, CURDATE() - INTERVAL 5 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(6, CURDATE() - INTERVAL 4 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(6, CURDATE() - INTERVAL 3 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(6, CURDATE() - INTERVAL 2 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(6, CURDATE() - INTERVAL 1 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(7, CURDATE() - INTERVAL 5 DAY, '08:30:00', '17:00:00', 'LATE', 8.5),
(7, CURDATE() - INTERVAL 4 DAY, '08:00:00', '17:10:00', 'PRESENT', 9.2),
(7, CURDATE() - INTERVAL 3 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(7, CURDATE() - INTERVAL 2 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(7, CURDATE() - INTERVAL 1 DAY, '08:05:00', '17:05:00', 'PRESENT', 9.0),
(8, CURDATE() - INTERVAL 5 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(8, CURDATE() - INTERVAL 4 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0),
(8, CURDATE() - INTERVAL 3 DAY, '08:00:00', '17:15:00', 'PRESENT', 9.3),
(8, CURDATE() - INTERVAL 2 DAY, '08:10:00', '17:00:00', 'PRESENT', 8.8),
(8, CURDATE() - INTERVAL 1 DAY, '08:00:00', '17:00:00', 'PRESENT', 9.0);

-- =====================
-- LEAVE REQUESTS
-- =====================
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, reason, status, approved_by, approved_at, notes) VALUES
(5, 'ANNUAL', CURDATE() - INTERVAL 3 DAY, CURDATE() - INTERVAL 3 DAY, 'Acara keluarga', 'APPROVED', NULL, CURDATE() - INTERVAL 4 DAY, 'Approved'),
(2, 'SICK', CURDATE() - INTERVAL 3 DAY, CURDATE() - INTERVAL 3 DAY, 'Sakit demam', 'APPROVED', NULL, CURDATE() - INTERVAL 3 DAY, 'Get well soon'),
(7, 'PERSONAL', CURDATE() + INTERVAL 7 DAY, CURDATE() + INTERVAL 8 DAY, 'Urusan pribadi', 'PENDING', NULL, NULL, NULL),
(4, 'ANNUAL', CURDATE() + INTERVAL 14 DAY, CURDATE() + INTERVAL 18 DAY, 'Liburan keluarga', 'PENDING', NULL, NULL, NULL);
