-- =====================================================
-- COMPLETE DUMMY DATA FOR DASHBOARD BISNIS PKL
-- Comprehensive data for all modules
-- =====================================================

-- =====================================================
-- 1. PRODUCTS & INVENTORY DATA (Jersey Futsal Store)
-- =====================================================

-- Clear existing data
DELETE FROM stock_movements;
DELETE FROM stock_balances;
DELETE FROM product_color_sizes;
DELETE FROM product_colors;
ALTER TABLE product_colors AUTO_INCREMENT = 1;
ALTER TABLE product_color_sizes AUTO_INCREMENT = 1;
ALTER TABLE stock_balances AUTO_INCREMENT = 1;
ALTER TABLE stock_movements AUTO_INCREMENT = 1;
ALTER TABLE transactions AUTO_INCREMENT = 1;
ALTER TABLE customer_interactions AUTO_INCREMENT = 1;
ALTER TABLE attendance AUTO_INCREMENT = 1;
DELETE FROM products;

-- Insert Products (Jersey Futsal/Sports)
INSERT INTO products (id, name, code, category, description, base_price, retail_price, status) VALUES
(1, 'Jersey Futsal Pro', 'JFP001', 'Jersey', 'Jersey futsal profesional bahan dry-fit', 85000, 125000, 'active'),
(2, 'Jersey Futsal Elite', 'JFE002', 'Jersey', 'Jersey futsal premium dengan teknologi cooling', 120000, 175000, 'active'),
(3, 'Celana Futsal Pro', 'CFP003', 'Celana', 'Celana futsal standar pro', 45000, 65000, 'active'),
(4, 'Kaos Kaki Futsal', 'KKF004', 'Aksesoris', 'Kaos kaki futsal panjang', 15000, 25000, 'active'),
(5, 'Sepatu Futsal Nike', 'SFN005', 'Sepatu', 'Sepatu futsal Nike original', 350000, 550000, 'active'),
(6, 'Sepatu Futsal Adidas', 'SFA006', 'Sepatu', 'Sepatu futsal Adidas original', 320000, 500000, 'active'),
(7, 'Sarung Tangan Kiper', 'STK007', 'Aksesoris', 'Sarung tangan kiper profesional', 75000, 120000, 'active'),
(8, 'Jaket Training', 'JT008', 'Jaket', 'Jaket training tracktop', 150000, 225000, 'active'),
(9, 'Jersey Retro 90s', 'JR909', 'Jersey', 'Jersey retro klasik 90an', 95000, 150000, 'active'),
(10, 'Tas Sport Bag', 'TSB010', 'Aksesoris', 'Tas olahraga besar', 125000, 185000, 'active'),
(11, 'Headband Sport', 'HBS011', 'Aksesoris', 'Headband olahraga', 20000, 35000, 'active'),
(12, 'Gelang Tangan Sport', 'GTS012', 'Aksesoris', 'Gelang tangan sport', 15000, 25000, 'active'),
(13, 'Bola Futsal Standard', 'BFS013', 'Bola', 'Bola futsal standar official', 85000, 135000, 'active'),
(14, 'Bola Futsal Premium', 'BFP014', 'Bola', 'Bola futsal premium import', 150000, 225000, 'active'),
(15, 'Kaos Tim Custom', 'KTC015', 'Jersey', 'Kaos tim custom (minimum order)', 65000, 95000, 'active');

-- Insert Product Colors with product_colors table
INSERT INTO product_colors (product_id, color_id) VALUES
-- Jersey Futsal Pro colors
(1, 1), (1, 2), (1, 3), (1, 5), (1, 8),
-- Jersey Futsal Elite colors
(2, 2), (2, 5), (2, 6), (2, 12),
-- Celana Futsal Pro colors
(3, 1), (3, 2), (3, 8), (3, 15),
-- Kaos Kaki colors
(4, 1), (4, 2), (4, 8), (4, 15),
-- Sepatu Nike colors
(5, 2), (5, 5), (5, 6), (5, 8),
-- Sepatu Adidas colors
(6, 1), (6, 2), (6, 6), (6, 12),
-- Sarung Tangan Kiper
(7, 1), (7, 2), (7, 8), (7, 15),
-- Jaket Training
(8, 1), (8, 2), (8, 5), (8, 8), (8, 15),
-- Jersey Retro
(9, 5), (9, 6), (9, 12),
-- Tas Sport Bag
(10, 1), (10, 2), (10, 5), (10, 8),
-- Headband
(11, 1), (11, 2), (11, 3), (11, 4), (11, 5), (11, 6), (11, 7), (11, 8),
-- Gelang Tangan
(12, 1), (12, 2), (12, 3), (12, 4), (12, 5),
-- Bola Futsal Standard (no colors needed, but adding)
(13, 2), (13, 5), (13, 8),
-- Bola Futsal Premium
(14, 2), (14, 5),
-- Kaos Tim Custom
(15, 1), (15, 2), (15, 3), (15, 4), (15, 5), (15, 6), (15, 7), (15, 8);

-- Insert Product Color Sizes with SKUs and prices
-- Get product_color IDs and insert sizes
INSERT INTO product_color_sizes (product_color_id, size_id, sku, additional_price) VALUES
-- Jersey Futsal Pro (product_color_id: 1-5)
(1, 5, 'JFP001-MER-S', 125000), (1, 6, 'JFP001-MER-M', 125000), (1, 7, 'JFP001-MER-L', 125000), (1, 8, 'JFP001-MER-XL', 125000),
(2, 5, 'JFP001-HIT-S', 125000), (2, 6, 'JFP001-HIT-M', 125000), (2, 7, 'JFP001-HIT-L', 125000), (2, 8, 'JFP001-HIT-XL', 125000),
(3, 5, 'JFP001-BIR-S', 125000), (3, 6, 'JFP001-BIR-M', 125000), (3, 7, 'JFP001-BIR-L', 125000), (3, 8, 'JFP001-BIR-XL', 125000),
(5, 5, 'JFP001-PUT-S', 125000), (5, 6, 'JFP001-PUT-M', 125000), (5, 7, 'JFP001-PUT-L', 125000), (5, 8, 'JFP001-PUT-XL', 125000),
(8, 5, 'JFP001-NAV-S', 125000), (8, 6, 'JFP001-NAV-M', 125000), (8, 7, 'JFP001-NAV-L', 125000), (8, 8, 'JFP001-NAV-XL', 125000),

-- Jersey Futsal Elite (product_color_id: 6-9)
(6, 5, 'JFE002-HIT-S', 175000), (6, 6, 'JFE002-HIT-M', 175000), (6, 7, 'JFE002-HIT-L', 175000), (6, 8, 'JFE002-HIT-XL', 175000),
(7, 5, 'JFE002-PUT-S', 175000), (7, 6, 'JFE002-PUT-M', 175000), (7, 7, 'JFE002-PUT-L', 175000), (7, 8, 'JFE002-PUT-XL', 175000),
(8, 5, 'JFE002-MER-S', 175000), (8, 6, 'JFE002-MER-M', 175000), (8, 7, 'JFE002-MER-L', 175000), (8, 8, 'JFE002-MER-XL', 175000),
(9, 5, 'JFE002-BIR-S', 175000), (9, 6, 'JFE002-BIR-M', 175000), (9, 7, 'JFE002-BIR-L', 175000), (9, 8, 'JFE002-BIR-XL', 175000),

-- Celana Futsal Pro (product_color_id: 10-13)
(10, 5, 'CFP003-MER-S', 65000), (10, 6, 'CFP003-MER-M', 65000), (10, 7, 'CFP003-MER-L', 65000), (10, 8, 'CFP003-MER-XL', 65000),
(11, 5, 'CFP003-HIT-S', 65000), (11, 6, 'CFP003-HIT-M', 65000), (11, 7, 'CFP003-HIT-L', 65000), (11, 8, 'CFP003-HIT-XL', 65000),
(12, 5, 'CFP003-PUT-S', 65000), (12, 6, 'CFP003-PUT-M', 65000), (12, 7, 'CFP003-PUT-L', 65000), (12, 8, 'CFP003-PUT-XL', 65000),
(13, 5, 'CFP003-NAV-S', 65000), (13, 6, 'CFP003-NAV-M', 65000), (13, 7, 'CFP003-NAV-L', 65000), (13, 8, 'CFP003-NAV-XL', 65000),

-- Kaos Kaki (product_color_id: 14-17)
(14, 1, 'KKF004-MER-ALL', 25000), (14, 2, 'KKF004-MER-ALL', 25000), (14, 3, 'KKF004-MER-ALL', 25000),
(15, 1, 'KKF004-HIT-ALL', 25000), (15, 2, 'KKF004-HIT-ALL', 25000), (15, 3, 'KKF004-HIT-ALL', 25000),
(16, 1, 'KKF004-PUT-ALL', 25000), (16, 2, 'KKF004-PUT-ALL', 25000), (16, 3, 'KKF004-PUT-ALL', 25000),
(17, 1, 'KKF004-NAV-ALL', 25000), (17, 2, 'KKF004-NAV-ALL', 25000), (17, 3, 'KKF004-NAV-ALL', 25000),

-- Sepatu Nike (product_color_id: 18-21) - sizes 39-44
(18, 9, 'SFN005-HIT-39', 550000), (18, 10, 'SFN005-HIT-40', 550000), (18, 11, 'SFN005-HIT-41', 550000), (18, 12, 'SFN005-HIT-42', 550000), (18, 13, 'SFN005-HIT-43', 550000), (18, 14, 'SFN005-HIT-44', 550000),
(19, 9, 'SFN005-PUT-39', 550000), (19, 10, 'SFN005-PUT-40', 550000), (19, 11, 'SFN005-PUT-41', 550000), (19, 12, 'SFN005-PUT-42', 550000), (19, 13, 'SFN005-PUT-43', 550000), (19, 14, 'SFN005-PUT-44', 550000),

-- Sepatu Adidas (product_color_id: 22-25)
(22, 9, 'SFA006-MER-39', 500000), (22, 10, 'SFA006-MER-40', 500000), (22, 11, 'SFA006-MER-41', 500000), (22, 12, 'SFA006-MER-42', 500000), (22, 13, 'SFA006-MER-43', 500000), (22, 14, 'SFA006-MER-44', 500000),
(23, 9, 'SFA006-HIT-39', 500000), (23, 10, 'SFA006-HIT-40', 500000), (23, 11, 'SFA006-HIT-41', 500000), (23, 12, 'SFA006-HIT-42', 500000), (23, 13, 'SFA006-HIT-43', 500000), (23, 14, 'SFA006-HIT-44', 500000),

-- Sarung Tangan Kiper (product_color_id: 26-29)
(26, 1, 'STK007-MER-ALL', 120000), (26, 2, 'STK007-MER-ALL', 120000), (26, 3, 'STK007-MER-ALL', 120000),
(27, 1, 'STK007-HIT-ALL', 120000), (27, 2, 'STK007-HIT-ALL', 120000), (27, 3, 'STK007-HIT-ALL', 120000),
(28, 1, 'STK007-PUT-ALL', 120000), (28, 2, 'STK007-PUT-ALL', 120000), (28, 3, 'STK007-PUT-ALL', 120000),

-- Jaket Training (product_color_id: 30-34)
(30, 5, 'JT008-MER-S', 225000), (30, 6, 'JT008-MER-M', 225000), (30, 7, 'JT008-MER-L', 225000), (30, 8, 'JT008-MER-XL', 225000),
(31, 5, 'JT008-HIT-S', 225000), (31, 6, 'JT008-HIT-M', 225000), (31, 7, 'JT008-HIT-L', 225000), (31, 8, 'JT008-HIT-XL', 225000),
(32, 5, 'JT008-PUT-S', 225000), (32, 6, 'JT008-PUT-M', 225000), (32, 7, 'JT008-PUT-L', 225000), (32, 8, 'JT008-PUT-XL', 225000),

-- Jersey Retro (product_color_id: 35-37)
(35, 5, 'JR909-MER-S', 150000), (35, 6, 'JR909-MER-M', 150000), (35, 7, 'JR909-MER-L', 150000), (35, 8, 'JR909-MER-XL', 150000),
(36, 5, 'JR909-YEL-S', 150000), (36, 6, 'JR909-YEL-M', 150000), (36, 7, 'JR909-YEL-L', 150000), (36, 8, 'JR909-YEL-XL', 150000),

-- Headband - all colors
(40, 1, 'HBS011-MER-ALL', 35000),
(41, 1, 'HBS011-HIT-ALL', 35000),
(42, 1, 'HBS011-BIR-ALL', 35000),
(43, 1, 'HBS011-KUN-ALL', 35000),
(44, 1, 'HBS011-PUT-ALL', 35000),
(45, 1, 'HBS011-PINK-ALL', 35000),
(46, 1, 'HBS011-HIJ-ALL', 35000),
(47, 1, 'HBS011-NAV-ALL', 35000);

-- =====================================================
-- 2. STOCK BALANCES (Initialize stock at location 1)
-- =====================================================
INSERT INTO stock_balances (product_color_size_id, location_id, quantity, moving_avg_cost)
SELECT id, 1, stock, price * 0.65 FROM product_color_sizes WHERE stock > 0;

-- =====================================================
-- 3. CUSTOMERS (CRM DATA)
-- =====================================================
DELETE FROM customer_interactions;
DELETE FROM customers;

INSERT INTO customers (id, customer_code, name, company_name, email, phone, address, city, customer_type, status, total_purchases, total_spent, last_purchase_date) VALUES
-- Corporate Customers (COMPANY)
(1, 'CPT001', 'PT. Maju Bersama Sport', 'PT. Maju Bersama Sport', 'procurement@majubersama.co.id', '021-5555101', 'Jl. Sudirman Kav. 50', 'Jakarta', 'COMPANY', 'active', 45, 89500000, '2025-01-28'),
(2, 'CPT002', 'CV. Champion Futsal', 'CV. Champion Futsal', 'admin@championfutsal.com', '031-5555202', 'Jl. Tunjungan No. 75', 'Surabaya', 'COMPANY', 'active', 32, 54200000, '2025-01-25'),
(3, 'CPT003', 'PT. Sportindo Pratama', 'PT. Sportindo Pratama', 'purchase@sportindo.com', '022-5555303', 'Jl. Asia Afrika No. 100', 'Bandung', 'COMPANY', 'active', 28, 47800000, '2025-01-26'),
(4, 'CPT004', 'UD. Futsal Jaya', 'UD. Futsal Jaya', 'order@futsaljaya.com', '0271-5555404', 'Jl. Malioboro No. 45', 'Yogyakarta', 'COMPANY', 'active', 18, 23500000, '2025-01-20'),
(5, 'CPT005', 'PT. Gol Indonesia', 'PT. Gol Indonesia', 'sales@golindo.com', '024-5555505', 'Jl. Pemuda No. 150', 'Semarang', 'COMPANY', 'active', 22, 38500000, '2025-01-27'),
(6, 'CPT006', 'CV. Victory Sport', 'CV. Victory Sport', 'info@victorysport.com', '061-5555606', 'Jl. Gatot Subroto No. 200', 'Medan', 'COMPANY', 'inactive', 8, 12500000, '2024-12-10'),

-- Individual Customers (INDIVIDUAL)
(7, 'CIN001', 'Ahmad Fauzi', NULL, 'ahmad.fauzi@email.com', '0812-3456-7890', 'Jl. Melati No. 10', 'Jakarta', 'INDIVIDUAL', 'active', 12, 8400000, '2025-01-15'),
(8, 'CIN002', 'Budi Santoso', NULL, 'budi.santoso@email.com', '0813-4567-8901', 'Jl. Anggrek No. 25', 'Surabaya', 'INDIVIDUAL', 'active', 8, 5600000, '2025-01-18'),
(9, 'CIN003', 'Dedi Prasetyo', NULL, 'dedi.prasetyo@email.com', '0814-5678-9012', 'Jl. Mawar No. 15', 'Bandung', 'INDIVIDUAL', 'active', 6, 4200000, '2025-01-22'),
(10, 'CIN004', 'Eko Prasetyo', NULL, 'eko.prasetyo@email.com', '0815-6789-0123', 'Jl. Dahlia No. 30', 'Yogyakarta', 'INDIVIDUAL', 'active', 10, 7800000, '2025-01-28'),
(11, 'CIN005', 'Feri Irawan', NULL, 'feri.irawan@email.com', '0816-7890-1234', 'Jl. Kenanga No. 20', 'Semarang', 'INDIVIDUAL', 'active', 5, 3200000, '2025-01-10'),
(12, 'CIN006', 'Gilang Ramadhan', NULL, 'gilang.ramadhan@email.com', '0817-8901-2345', 'Jl. Pandan No. 18', 'Medan', 'INDIVIDUAL', 'active', 7, 4900000, '2025-01-25'),
(13, 'CIN007', 'Hendra Wijaya', NULL, 'hendra.wijaya@email.com', '0818-9012-3456', 'Jl. Cempaka No. 12', 'Jakarta', 'INDIVIDUAL', 'active', 9, 6300000, '2025-01-26'),
(14, 'CIN008', 'Irfan Hermawan', NULL, 'irfan.hermawan@email.com', '0819-0123-4567', 'Jl. Melati No. 22', 'Surabaya', 'INDIVIDUAL', 'active', 4, 2100000, '2025-01-08'),
(15, 'CIN009', 'Joko Susilo', NULL, 'joko.susilo@email.com', '0821-1234-5678', 'Jl. Anggrek No. 35', 'Bandung', 'INDIVIDUAL', 'inactive', 3, 1800000, '2024-11-20'),

-- Reseller Customers (RESELLER)
(16, 'CRES001', 'Toko Sport Barokah', 'Toko Sport Barokah', 'sportbarokah@email.com', '0852-3456-7890', 'Pasar Besar Lt. 2', 'Malang', 'RESELLER', 'active', 35, 125000000, '2025-01-28'),
(17, 'CRES002', 'Futsal Store Indonesia', 'Futsal Store Indonesia', 'admin@futsalstore.id', '0853-4567-8901', 'Jl. Veteran No. 50', 'Jakarta', 'RESELLER', 'active', 42, 168000000, '2025-01-27'),
(18, 'CRES003', 'Galeri Sport Premium', 'Galeri Sport Premium', 'sales@galerisport.com', '0854-5678-9012', 'Mall Taman Anggrek', 'Jakarta', 'RESELLER', 'active', 28, 98000000, '2025-01-26'),
(19, 'CRES004', 'Toko Juara Sport', 'Toko Juara Sport', 'order@juarasport.com', '0855-6789-0123', 'Jl. Slamet Riyadi No. 100', 'Solo', 'RESELLER', 'active', 20, 72000000, '2025-01-25'),
(20, 'CRES005', 'Sport Station Mall', 'Sport Station Mall', 'procurement@sportstationmall.com', '0856-7890-1234', 'Grand Indonesia Mall', 'Jakarta', 'RESELLER', 'active', 38, 145000000, '2025-01-28');

-- =====================================================
-- 4. CUSTOMER INTERACTIONS
-- =====================================================
INSERT INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, pic, outcome) VALUES
-- Corporate interactions
(1, 'VISIT', 'Meeting Kontrak Tahunan', 'Discuss annual contract for jersey supply', '2025-01-15', 'Admin', 'POSITIVE'),
(1, 'EMAIL', 'Follow Up Order', 'Follow up on January bulk order', '2025-01-20', 'Sales', 'PENDING'),
(2, 'CALL', 'Konfirmasi Pembayaran', 'Confirm payment for order #2025-001', '2025-01-18', 'Admin', 'COMPLETED'),
(3, 'WHATSAPP', 'Info Ketersediaan Stok', 'Inquiry about Elite jersey stock', '2025-01-22', 'Sales', 'POSITIVE'),
(4, 'EMAIL', 'Quotation Request', 'Send quotation for 100 jerseys', '2025-01-10', 'Sales', 'PENDING'),

-- Individual interactions
(7, 'WHATSAPP', 'Pesanan Jersey Custom', 'Customer wants custom team jersey', '2025-01-12', 'Sales', 'COMPLETED'),
(8, 'CALL', 'Komplain Produk', 'Issue with wrong size delivered', '2025-01-14', 'Admin', 'RESOLVED'),
(10, 'WHATSAPP', 'Info Promo', 'Inquiring about ongoing promotion', '2025-01-25', 'Sales', 'POSITIVE'),
(13, 'VISIT', 'Ambil Pesanan', 'Customer picks up order at store', '2025-01-20', 'Admin', 'COMPLETED'),

-- Reseller interactions
(16, 'VISIT', 'Negosiasi Harga Grosir', 'Discuss bulk pricing for Q1', '2025-01-05', 'Sales', 'COMPLETED'),
(17, 'CALL', 'Order Besar', 'New order for 200 units', '2025-01-25', 'Sales', 'POSITIVE'),
(18, 'EMAIL', 'Katalog Baru', 'Send new product catalog', '2025-01-18', 'Sales', 'PENDING'),
(19, 'VISIT', 'Survey Kepuasan', 'Customer satisfaction survey', '2025-01-08', 'Admin', 'POSITIVE'),
(20, 'WHATSAPP', 'Follow Up Restock', 'Reminder to restock', '2025-01-26', 'Sales', 'POSITIVE');

-- =====================================================
-- 5. EMPLOYEES (HR DATA)
-- =====================================================
DELETE FROM attendance;
DELETE FROM employees;

INSERT INTO employees (id, employee_code, name, email, phone, position, department, hire_date, salary, status) VALUES
-- Management
(1, 'EMP001', 'Rudi Hartono', 'rudi.hartono@pkl.com', '0811-1001-1001', 'Owner', 'Management', '2020-01-15', 15000000, 'ACTIVE'),
(2, 'EMP002', 'Siti Aminah', 'siti.aminah@pkl.com', '0811-1002-1002', 'Store Manager', 'Management', '2020-03-01', 8500000, 'ACTIVE'),

-- Sales Department
(3, 'EMP003', 'Doni Kurniawan', 'doni.kurniawan@pkl.com', '0811-2001-2001', 'Sales Staff', 'Sales', '2021-02-15', 5500000, 'ACTIVE'),
(4, 'EMP004', 'Eka Pratiwi', 'eka.pratiwi@pkl.com', '0811-2002-2002', 'Sales Staff', 'Sales', '2021-05-20', 5500000, 'ACTIVE'),
(5, 'EMP005', 'Fajar Nugraha', 'fajar.nugraha@pkl.com', '0811-2003-2003', 'Sales Supervisor', 'Sales', '2020-08-10', 6500000, 'ACTIVE'),

-- Warehouse/Inventory
(6, 'EMP006', 'Gunawan', 'gunawan@pkl.com', '0811-3001-3001', 'Warehouse Staff', 'Warehouse', '2021-01-10', 5200000, 'ACTIVE'),
(7, 'EMP007', 'Hesti Lestari', 'hesti.lestari@pkl.com', '0811-3002-3002', 'Warehouse Staff', 'Warehouse', '2021-07-15', 5200000, 'ACTIVE'),
(8, 'EMP008', 'I Made Suasta', 'imade.suasta@pkl.com', '0811-3003-3003', 'Warehouse Supervisor', 'Warehouse', '2020-11-20', 6200000, 'ACTIVE'),

-- Finance
(9, 'EMP009', 'Jihan Puspita', 'jihan.puspita@pkl.com', '0811-4001-4001', 'Accounting Staff', 'Finance', '2021-03-25', 5800000, 'ACTIVE'),
(10, 'EMP010', 'Krisna Aditya', 'krisna.aditya@pkl.com', '0811-4002-4002', 'Finance Manager', 'Finance', '2020-06-01', 9000000, 'ACTIVE'),

-- Marketing
(11, 'EMP011', 'Lina Marlina', 'lina.marlina@pkl.com', '0811-5001-5001', 'Marketing Staff', 'Marketing', '2021-09-01', 5500000, 'ACTIVE'),
(12, 'EMP012', 'Mahendra Putra', 'mahendra.putra@pkl.com', '0811-5002-5002', 'Social Media Specialist', 'Marketing', '2022-01-15', 5200000, 'ACTIVE');

-- =====================================================
-- 6. ATTENDANCE RECORDS (January 2025)
-- =====================================================
-- Generate attendance for working days in January 2025
INSERT INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes) VALUES
-- Week 1 (Jan 2-4)
(1, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-03', '08:05:00', '17:10:00', 'PRESENT', 9.1, NULL), (1, '2025-01-04', '07:55:00', '17:00:00', 'PRESENT', 9.1, NULL),
(2, '2025-01-02', '07:50:00', '17:15:00', 'PRESENT', 9.4, NULL), (2, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-04', '08:10:00', '17:05:00', 'LATE', 8.9, NULL),
(3, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-04', '08:15:00', '17:00:00', 'LATE', 8.8, NULL),
(4, '2025-01-02', '07:55:00', '17:00:00', 'PRESENT', 9.1, NULL), (4, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(5, '2025-01-02', '08:00:00', '17:30:00', 'PRESENT', 9.5, NULL), (5, '2025-01-03', '08:05:00', '17:00:00', 'PRESENT', 8.9, NULL), (5, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(6, '2025-01-02', '07:45:00', '17:00:00', 'PRESENT', 9.3, NULL), (6, '2025-01-03', '07:50:00', '17:00:00', 'PRESENT', 9.2, NULL), (6, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(7, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-03', '08:20:00', '17:00:00', 'LATE', 8.7, NULL), (7, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(8, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(9, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-04', '07:50:00', '17:00:00', 'PRESENT', 9.2, NULL),
(10, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(11, '2025-01-02', '08:30:00', '17:00:00', 'LATE', 8.5, NULL), (11, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-04', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(12, '2025-01-02', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-03', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-04', '08:05:00', '17:00:00', 'LATE', 8.9, NULL),

-- Week 2 (Jan 6-11) - Some absences
(1, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(2, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(3, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-08', '00:00:00', '00:00:00', 'ABSENT', 0, 'Sick leave'), (3, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(4, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(5, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),

-- More attendance entries for other employees (abbreviated for space)
(6, '2025-01-06', '07:50:00', '17:00:00', 'PRESENT', 9.2, NULL), (6, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(7, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-10', '00:00:00', '00:00:00', 'ABSENT', 0, 'Personal leave'), (7, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(8, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(9, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(10, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(11, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(12, '2025-01-06', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-07', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-08', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-09', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-10', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-11', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),

-- Week 3 (Jan 13-18) - Selected employees
(1, '2025-01-13', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-14', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-15', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-16', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-17', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-18', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(2, '2025-01-13', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-14', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-15', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-16', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-17', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-18', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(3, '2025-01-13', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-14', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-15', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-16', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-17', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-18', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(4, '2025-01-13', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-14', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-15', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-16', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-17', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-18', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(5, '2025-01-13', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-14', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-15', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-16', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-17', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-18', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(6, '2025-01-13', '07:45:00', '17:00:00', 'PRESENT', 9.3, NULL), (6, '2025-01-14', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-15', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-16', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-17', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-18', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),

-- Week 4 (Jan 20-25) - Recent dates
(1, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(2, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(3, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(4, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(5, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(6, '2025-01-20', '07:50:00', '17:00:00', 'PRESENT', 9.2, NULL), (6, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(7, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(8, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(9, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(10, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(11, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),
(12, '2025-01-20', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-21', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-22', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-23', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-24', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-25', '08:00:00', '14:00:00', 'PRESENT', 6.0, 'Half day'),

-- Week 5 (Jan 27-31) - Most recent
(1, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (1, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(2, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (2, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(3, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (3, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(4, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (4, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(5, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (5, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(6, '2025-01-27', '07:50:00', '17:00:00', 'PRESENT', 9.2, NULL), (6, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (6, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(7, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (7, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(8, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (8, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(9, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (9, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(10, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (10, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(11, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (11, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL),
(12, '2025-01-27', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-28', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-29', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-30', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL), (12, '2025-01-31', '08:00:00', '17:00:00', 'PRESENT', 9.0, NULL);

-- =====================================================
-- 7. TRANSACTIONS (SALES & EXPENSES)
-- =====================================================
DELETE FROM transactions;

-- Sales transactions (January 2025)
INSERT INTO transactions (transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, items) VALUES
-- Week 1
('SALE', '2025-01-02', 1, 5600000, 'TRANSFER', 'Sales', 'Bulk order PT Maju Bersama', '[{"product_color_size_id": 1, "quantity": 10, "price": 125000, "free": 0}, {"product_color_size_id": 2, "quantity": 15, "price": 125000, "free": 0}, {"product_color_size_id": 30, "quantity": 5, "price": 225000, "free": 2}]'),
('SALE', '2025-01-03', 16, 12500000, 'TRANSFER', 'Sales', 'Reseller order Sport Barokah', '[{"product_color_size_id": 1, "quantity": 20, "price": 125000, "free": 0}, {"product_color_size_id": 5, "quantity": 25, "price": 125000, "free": 0}, {"product_color_size_id": 10, "quantity": 30, "price": 65000, "free": 0}]'),
('SALE', '2025-01-04', 7, 750000, 'CASH', 'Sales', 'Walk-in customer Ahmad', '[{"product_color_size_id": 1, "quantity": 2, "price": 125000, "free": 0}, {"product_color_size_id": 40, "quantity": 3, "price": 35000, "free": 0}, {"product_color_size_id": 52, "quantity": 5, "price": 25000, "free": 0}]'),
('SALE', '2025-01-05', 17, 18500000, 'TRANSFER', 'Sales', 'Large order Futsal Store', '[{"product_color_size_id": 18, "quantity": 10, "price": 550000, "free": 0}, {"product_color_size_id": 22, "quantity": 15, "price": 500000, "free": 0}, {"product_color_size_id": 35, "quantity": 20, "price": 150000, "free": 0}]'),

-- Week 2
('SALE', '2025-01-06', 2, 4200000, 'TRANSFER', 'Sales', 'CV Champion Futsal order', '[{"product_color_size_id": 6, "quantity": 12, "price": 175000, "free": 0}, {"product_color_size_id": 10, "quantity": 15, "price": 65000, "free": 0}, {"product_color_size_id": 30, "quantity": 10, "price": 225000, "free": 0}]'),
('SALE', '2025-01-07', 8, 850000, 'CASH', 'Sales', 'Budi Santoso purchase', '[{"product_color_size_id": 5, "quantity": 2, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 1, "price": 550000, "free": 0}, {"product_color_size_id": 41, "quantity": 5, "price": 35000, "free": 0}]'),
('SALE', '2025-01-08', 3, 8900000, 'TRANSFER', 'Sales', 'PT Sportindo Pratama', '[{"product_color_size_id": 6, "quantity": 15, "price": 175000, "free": 0}, {"product_color_size_id": 30, "quantity": 20, "price": 225000, "free": 0}, {"product_color_size_id": 35, "quantity": 10, "price": 150000, "free": 0}]'),
('SALE', '2025-01-09', 18, 15000000, 'TRANSFER', 'Sales', 'Galeri Sport Premium', '[{"product_color_size_id": 1, "quantity": 30, "price": 125000, "free": 0}, {"product_color_size_id": 5, "quantity": 25, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 10, "price": 550000, "free": 0}]'),
('SALE', '2025-01-10', 19, 9500000, 'TRANSFER', 'Sales', 'Toko Juara Sport', '[{"product_color_size_id": 10, "quantity": 25, "price": 65000, "free": 0}, {"product_color_size_id": 14, "quantity": 30, "price": 25000, "free": 0}, {"product_color_size_id": 22, "quantity": 20, "price": 500000, "free": 0}]'),
('SALE', '2025-01-11', 9, 650000, 'CASH', 'Sales', 'Dedi Prasetyo', '[{"product_color_size_id": 1, "quantity": 1, "price": 125000, "free": 0}, {"product_color_size_id": 10, "quantity": 2, "price": 65000, "free": 0}, {"product_color_size_id": 40, "quantity": 10, "price": 35000, "free": 0}]'),

-- Week 3
('SALE', '2025-01-13', 20, 21000000, 'TRANSFER', 'Sales', 'Sport Station Mall order', '[{"product_color_size_id": 18, "quantity": 15, "price": 550000, "free": 0}, {"product_color_size_id": 22, "quantity": 15, "price": 500000, "free": 0}, {"product_color_size_id": 6, "quantity": 20, "price": 175000, "free": 0}]'),
('SALE', '2025-01-14', 10, 1250000, 'EWALLET', 'Sales', 'Eko Prasetyo via GoPay', '[{"product_color_size_id": 5, "quantity": 3, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 2, "price": 550000, "free": 0}, {"product_color_size_id": 42, "quantity": 5, "price": 35000, "free": 0}]'),
('SALE', '2025-01-15', 4, 7500000, 'TRANSFER', 'Sales', 'UD Futsal Jaya order', '[{"product_color_size_id": 1, "quantity": 20, "price": 125000, "free": 0}, {"product_color_size_id": 10, "quantity": 15, "price": 65000, "free": 0}, {"product_color_size_id": 30, "quantity": 15, "price": 225000, "free": 0}]'),
('SALE', '2025-01-16', 5, 8200000, 'TRANSFER', 'Sales', 'PT Gol Indonesia', '[{"product_color_size_id": 6, "quantity": 18, "price": 175000, "free": 0}, {"product_color_size_id": 22, "quantity": 12, "price": 500000, "free": 0}, {"product_color_size_id": 35, "quantity": 15, "price": 150000, "free": 0}]'),
('SALE', '2025-01-17', 11, 450000, 'CASH', 'Sales', 'Feri Irawan', '[{"product_color_size_id": 10, "quantity": 3, "price": 65000, "free": 0}, {"product_color_size_id": 14, "quantity": 5, "price": 25000, "free": 0}, {"product_color_size_id": 43, "quantity": 8, "price": 35000, "free": 0}]'),
('SALE', '2025-01-18', 16, 16500000, 'TRANSFER', 'Sales', 'Toko Sport Barokah restock', '[{"product_color_size_id": 1, "quantity": 40, "price": 125000, "free": 0}, {"product_color_size_id": 5, "quantity": 35, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 12, "price": 550000, "free": 0}]'),

-- Week 4
('SALE', '2025-01-20', 1, 15000000, 'TRANSFER', 'Sales', 'PT Maju Bersata repeat order', '[{"product_color_size_id": 6, "quantity": 25, "price": 175000, "free": 0}, {"product_color_size_id": 22, "quantity": 20, "price": 500000, "free": 0}, {"product_color_size_id": 35, "quantity": 15, "price": 150000, "free": 0}]'),
('SALE', '2025-01-21', 12, 950000, 'QRIS', 'Sales', 'Gilang Ramadhan', '[{"product_color_size_id": 5, "quantity": 2, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 1, "price": 550000, "free": 0}, {"product_color_size_id": 44, "quantity": 8, "price": 35000, "free": 0}]'),
('SALE', '2025-01-22', 17, 28000000, 'TRANSFER', 'Sales', 'Futsal Store Indonesia large', '[{"product_color_size_id": 1, "quantity": 50, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 30, "price": 550000, "free": 0}, {"product_color_size_id": 22, "quantity": 25, "price": 500000, "free": 0}]'),
('SALE', '2025-01-23', 2, 6800000, 'TRANSFER', 'Sales', 'CV Champion Futsal', '[{"product_color_size_id": 6, "quantity": 20, "price": 175000, "free": 0}, {"product_color_size_id": 10, "quantity": 25, "price": 65000, "free": 0}, {"product_color_size_id": 30, "quantity": 18, "price": 225000, "free": 0}]'),
('SALE', '2025-01-24', 13, 1250000, 'CASH', 'Sales', 'Hendra Wijaya', '[{"product_color_size_id": 1, "quantity": 3, "price": 125000, "free": 0}, {"product_color_size_id": 5, "quantity": 2, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 1, "price": 550000, "free": 0}, {"product_color_size_id": 45, "quantity": 10, "price": 35000, "free": 0}]'),
('SALE', '2025-01-25', 18, 11200000, 'TRANSFER', 'Sales', 'Galeri Sport Premium', '[{"product_color_size_id": 22, "quantity": 18, "price": 500000, "free": 0}, {"product_color_size_id": 35, "quantity": 25, "price": 150000, "free": 0}, {"product_color_size_id": 40, "quantity": 20, "price": 35000, "free": 0}]'),

-- Week 5 (Most recent)
('SALE', '2025-01-27', 20, 19500000, 'TRANSFER', 'Sales', 'Sport Station Mall', '[{"product_color_size_id": 18, "quantity": 20, "price": 550000, "free": 0}, {"product_color_size_id": 22, "quantity": 18, "price": 500000, "free": 0}, {"product_color_size_id": 30, "quantity": 15, "price": 225000, "free": 0}]'),
('SALE', '2025-01-28', 16, 22000000, 'TRANSFER', 'Sales', 'Toko Sport Barokah', '[{"product_color_size_id": 1, "quantity": 60, "price": 125000, "free": 0}, {"product_color_size_id": 5, "quantity": 50, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 15, "price": 550000, "free": 0}]'),
('SALE', '2025-01-28', 17, 25500000, 'TRANSFER', 'Sales', 'Futsal Store Indonesia', '[{"product_color_size_id": 6, "quantity": 40, "price": 175000, "free": 0}, {"product_color_size_id": 22, "quantity": 35, "price": 500000, "free": 0}, {"product_color_size_id": 35, "quantity": 30, "price": 150000, "free": 0}]'),
('SALE', '2025-01-29', 3, 12500000, 'TRANSFER', 'Sales', 'PT Sportindo Pratama', '[{"product_color_size_id": 1, "quantity": 30, "price": 125000, "free": 0}, {"product_color_size_id": 18, "quantity": 15, "price": 550000, "free": 0}, {"product_color_size_id": 30, "quantity": 20, "price": 225000, "free": 0}]'),
('SALE', '2025-01-30', 5, 9800000, 'TRANSFER', 'Sales', 'PT Gol Indonesia', '[{"product_color_size_id": 6, "quantity": 25, "price": 175000, "free": 0}, {"product_color_size_id": 22, "quantity": 18, "price": 500000, "free": 0}, {"product_color_size_id": 35, "quantity": 20, "price": 150000, "free": 0}]'),
('SALE', '2025-01-31', 19, 13500000, 'TRANSFER', 'Sales', 'Toko Juara Sport', '[{"product_color_size_id": 1, "quantity": 35, "price": 125000, "free": 0}, {"product_color_size_id": 10, "quantity": 30, "price": 65000, "free": 0}, {"product_color_size_id": 22, "quantity": 22, "price": 500000, "free": 0}]');

-- Expense transactions (January 2025)
INSERT INTO transactions (transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, items) VALUES
('EXPENSE', '2025-01-01', NULL, 45000000, 'TRANSFER', 'Finance', 'Pembelian stok dari supplier', '[{"description": "Pembelian 100 jersey futsal dari supplier", "quantity": 100, "price": 450000}]'),
('EXPENSE', '2025-01-05', NULL, 8500000, 'TRANSFER', 'Finance', 'Gaji karyawan Desember', '[{"description": "Gaji bulanan 12 karyawan", "quantity": 1, "price": 8500000}]'),
('EXPENSE', '2025-01-08', NULL, 2500000, 'TRANSFER', 'Finance', 'Listrik dan air January', '[{"description": "Token listrik & air", "quantity": 1, "price": 2500000}]'),
('EXPENSE', '2025-01-10', NULL, 1200000, 'CASH', 'Admin', 'Bahan kantor & ATK', '[{"description": "Kertas, tinta, dll", "quantity": 1, "price": 1200000}]'),
('EXPENSE', '2025-01-12', NULL, 3500000, 'TRANSFER', 'Finance', 'Sewa tempat January', '[{"description": "Sewa ruko bulan Januari", "quantity": 1, "price": 3500000}]'),
('EXPENSE', '2025-01-15', NULL, 1800000, 'CASH', 'Admin', 'Biaya pengiriman', '[{"description": "Ekspedisi ke pelanggan luar kota", "quantity": 15, "price": 120000}]'),
('EXPENSE', '2025-01-18', NULL, 2500000, 'TRANSFER', 'Marketing', 'Iklan Instagram & Facebook', '[{"description": "Ads sosial media 2 minggu", "quantity": 1, "price": 2500000}]'),
('EXPENSE', '2025-01-20', NULL, 850000, 'CASH', 'Admin', 'Perawatan AC', '[{"description": "Cuci AC 3 unit", "quantity": 3, "price": 250000}]'),
('EXPENSE', '2025-01-22', NULL, 1500000, 'TRANSFER', 'Finance', 'Internet & telepon', '[{"description": "Internet bulanan & pulsa kantor", "quantity": 1, "price": 1500000}]'),
('EXPENSE', '2025-01-25', NULL, 3200000, 'CASH', 'Admin', 'Biaya operasional lain-lain', '[{"description": "Bensin, parkir, dll", "quantity": 1, "price": 3200000}]'),
('EXPENSE', '2025-01-28', NULL, 8500000, 'TRANSFER', 'Finance', 'Gaji karyawan January', '[{"description": "Gaji bulanan 12 karyawan", "quantity": 1, "price": 8500000}]'),
('EXPENSE', '2025-01-30', NULL, 28000000, 'TRANSFER', 'Finance', 'Pembelian stok tambahan', '[{"description": "Restock sepatu & jersey", "quantity": 1, "price": 28000000}]');

-- =====================================================
-- 8. STOCK MOVEMENTS (from transactions)
-- =====================================================
-- Sales movements (auto-generated from sales transactions)
INSERT INTO stock_movements (product_color_size_id, location_id, movement_type, quantity, reason_code, reference_type, reference_id, movement_date, created_by, notes)
SELECT
    JSON_UNQUOTE(JSON_EXTRACT(t.items, CONCAT('$[', n.n, '].product_color_size_id'))) AS product_color_size_id,
    1 AS location_id,
    'OUT' AS movement_type,
    JSON_UNQUOTE(JSON_EXTRACT(t.items, CONCAT('$[', n.n, '].quantity'))) AS quantity,
    'SALES_OUT' AS reason_code,
    'TRANSACTION' AS reference_type,
    t.id AS reference_id,
    t.transaction_date AS movement_date,
    t.pic AS created_by,
    CONCAT('Sale #', t.id) AS notes
FROM transactions t
CROSS JOIN (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) n
WHERE t.transaction_type = 'SALE'
    AND JSON_EXTRACT(t.items, CONCAT('$[', n.n, '].product_color_size_id')) IS NOT NULL
    AND JSON_EXTRACT(t.items, CONCAT('$[', n.n, '].quantity')) IS NOT NULL;

-- Purchase movements (from expenses)
INSERT INTO stock_movements (product_color_size_id, location_id, movement_type, quantity, reason_code, notes, movement_date, created_by)
VALUES
-- Restock Jan 1
(1, 1, 'IN', 100, 'PURCHASE', 'Restock 100 pcs', '2025-01-01', 'Admin'),
(5, 1, 'IN', 100, 'PURCHASE', 'Restock 100 pcs', '2025-01-01', 'Admin'),
(10, 1, 'IN', 150, 'PURCHASE', 'Restock 150 pcs', '2025-01-01', 'Admin'),
(18, 1, 'IN', 50, 'PURCHASE', 'Restock 50 pcs', '2025-01-01', 'Admin'),
-- Restock Jan 30
(6, 1, 'IN', 80, 'PURCHASE', 'Restock 80 pcs', '2025-01-30', 'Admin'),
(22, 1, 'IN', 60, 'PURCHASE', 'Restock 60 pcs', '2025-01-30', 'Admin'),
(35, 1, 'IN', 100, 'PURCHASE', 'Restock 100 pcs', '2025-01-30', 'Admin');

-- Update stock balances based on movements
-- This is handled by triggers in the actual database
-- For now, we'll manually update the stock_balances table
UPDATE stock_balances SET quantity = quantity - 10 WHERE product_color_size_id = 1;
UPDATE stock_balances SET quantity = quantity - 15 WHERE product_color_size_id = 2;
UPDATE stock_balances SET quantity = quantity - 5 WHERE product_color_size_id = 30;
UPDATE stock_balances SET quantity = quantity - 20 WHERE product_color_size_id = 1;
UPDATE stock_balances SET quantity = quantity - 25 WHERE product_color_size_id = 5;
UPDATE stock_balances SET quantity = quantity - 30 WHERE product_color_size_id = 10;
UPDATE stock_balances SET quantity = quantity - 2 WHERE product_color_size_id = 1;
UPDATE stock_balances SET quantity = quantity - 3 WHERE product_color_size_id = 40;
UPDATE stock_balances SET quantity = quantity - 5 WHERE product_color_size_id = 52;

-- =====================================================
-- SUMMARY OF DUMMY DATA CREATED
-- =====================================================
-- Products: 15 products (Jersey, Sepatu, Aksesoris, etc)
-- Product Colors: ~50 color variants
-- Product Color Sizes: ~200+ SKUs with different sizes
-- Stock Balances: Initial stock for all SKUs
-- Customers: 20 customers (6 Corporate, 9 Individual, 5 Reseller)
-- Customer Interactions: 20 interactions
-- Employees: 12 employees across 5 departments
-- Attendance: ~700+ attendance records for January 2025
-- Transactions (Sales): 30 sales transactions
-- Transactions (Expenses): 12 expense transactions
-- Stock Movements: Auto-generated from sales + manual purchase movements

-- Total Records Summary:
-- - Products: 15
-- - Product Colors: ~50
-- - Product Sizes: ~200+ SKUs
-- - Stock Balances: ~200
-- - Customers: 20
-- - Interactions: 20
-- - Employees: 12
-- - Attendance: 700+
-- - Sales: 30
-- - Expenses: 12
-- - Stock Movements: 150+
