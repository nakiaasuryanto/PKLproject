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

INSERT INTO colors (name, hex_code) VALUES
('Hitam', '#000000'),
('Putih', '#FFFFFF'),
('Navy', '#001F3F'),
('Abu-abu', '#808080'),
('Merah', '#FF0000'),
('Maroon', '#800000'),
('Olive', '#556B2F'),
('Cream', '#FFFDD0')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO sizes (name, sort_order) VALUES
('S', 1),
('M', 2),
('L', 3),
('XL', 4),
('XXL', 5)
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO locations (name, type, description) VALUES
('Gudang Utama', 'warehouse', 'Gudang penyimpanan utama'),
('Display Toko', 'display', 'Area display toko'),
('Rak Storage', 'storage', 'Rak penyimpanan tambahan')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO products (code, name, category, description, base_price, retail_price, status) VALUES
('KLP001', 'Kaos Polos Lengan Panjang', 'Kaos', 'Kaos polos lengan panjang bahan cotton combed 30s', 75000, 95000, 'active'),
('KLP002', 'Kaos Polos Lengan Pendek', 'Kaos', 'Kaos polos lengan pendek bahan cotton combed 30s', 55000, 75000, 'active'),
('JKT001', 'Jaket Hoodie Polos', 'Jaket', 'Jaket hoodie bahan fleece tebal', 150000, 195000, 'active'),
('JKT002', 'Jaket Bomber', 'Jaket', 'Jaket bomber dengan resleting', 175000, 225000, 'active'),
('SWT001', 'Sweater Crewneck', 'Sweater', 'Sweater crewneck bahan fleece', 125000, 165000, 'active'),
('PLO001', 'Polo Shirt', 'Polo', 'Kaos polo bahan lacoste cotton', 85000, 115000, 'active')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO product_colors (product_id, color_id)
SELECT p.id, c.id FROM products p, colors c
WHERE p.code IN ('KLP001', 'KLP002') AND c.name IN ('Hitam', 'Putih', 'Navy', 'Abu-abu', 'Maroon')
ON DUPLICATE KEY UPDATE product_id=product_id;

INSERT INTO product_colors (product_id, color_id)
SELECT p.id, c.id FROM products p, colors c
WHERE p.code IN ('JKT001', 'JKT002') AND c.name IN ('Hitam', 'Navy', 'Abu-abu', 'Olive', 'Maroon')
ON DUPLICATE KEY UPDATE product_id=product_id;

INSERT INTO product_colors (product_id, color_id)
SELECT p.id, c.id FROM products p, colors c
WHERE p.code IN ('SWT001') AND c.name IN ('Hitam', 'Abu-abu', 'Navy', 'Cream')
ON DUPLICATE KEY UPDATE product_id=product_id;

INSERT INTO product_colors (product_id, color_id)
SELECT p.id, c.id FROM products p, colors c
WHERE p.code IN ('PLO001') AND c.name IN ('Hitam', 'Putih', 'Navy', 'Merah')
ON DUPLICATE KEY UPDATE product_id=product_id;

INSERT INTO product_color_sizes (product_color_id, size_id, sku)
SELECT pc.id, s.id, CONCAT(p.code, '-', LEFT(c.name, 3), '-', s.name)
FROM product_colors pc
JOIN products p ON pc.product_id = p.id
JOIN colors c ON pc.color_id = c.id
JOIN sizes s ON 1=1
ON DUPLICATE KEY UPDATE sku=sku;

INSERT INTO stock_balances (product_color_size_id, location_id, quantity, moving_avg_cost)
SELECT pcs.id, l.id, FLOOR(RAND() * 50) + 10, p.base_price
FROM product_color_sizes pcs
JOIN product_colors pc ON pcs.product_color_id = pc.id
JOIN products p ON pc.product_id = p.id
JOIN locations l ON l.name = 'Gudang Utama'
ON DUPLICATE KEY UPDATE quantity=quantity;

INSERT INTO employees (employee_code, name, email, phone, position, department, hire_date, status) VALUES
('EMP001', 'Andi Wijaya', 'andi.wijaya@company.com', '08111112222', 'Manager', 'Management', '2020-01-15', 'ACTIVE'),
('EMP002', 'Dewi Lestari', 'dewi.lestari@company.com', '08122223333', 'Staff', 'Finance', '2021-03-01', 'ACTIVE'),
('EMP003', 'Rudi Hartono', 'rudi.hartono@company.com', '08133334444', 'Staff', 'Operations', '2021-06-15', 'ACTIVE'),
('EMP004', 'Maya Sari', 'maya.sari@company.com', '08144445555', 'Staff', 'Customer Service', '2022-01-10', 'ACTIVE'),
('EMP005', 'Bram Prakoso', 'bram.prakoso@company.com', '08155556666', 'Staff', 'IT', '2022-04-01', 'ACTIVE'),
('EMP006', 'Linda Kusuma', 'linda.kusuma@company.com', '08166667777', 'Supervisor', 'Operations', '2020-08-20', 'ACTIVE'),
('EMP007', 'Fajar Nugroho', 'fajar.nugroho@company.com', '08177778888', 'Staff', 'Finance', '2023-02-15', 'ACTIVE'),
('EMP008', 'Rina Marlina', 'rina.marlina@company.com', '08188889999', 'Staff', 'Customer Service', '2023-05-01', 'ACTIVE')
ON DUPLICATE KEY UPDATE name=name;

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
ON DUPLICATE KEY UPDATE status=status

INSERT INTO transactions (transaction_type, transaction_date, total_amount, payment_method, notes, payment_status) VALUES
('SALE', '2024-01-05', 950000, 'BANK_TRANSFER', 'Penjualan 10 Kaos Polos ke PT Maju Jaya', 'PAID'),
('SALE', '2024-01-08', 780000, 'CASH', 'Penjualan 4 Jaket Hoodie', 'PAID'),
('EXPENSE', '2024-01-10', 500000, 'CASH', 'Pembelian bahan baku kain', 'PAID'),
('SALE', '2024-01-12', 1170000, 'BANK_TRANSFER', 'Penjualan 6 Jaket Bomber', 'PAID'),
('EXPENSE', '2024-01-15', 1500000, 'BANK_TRANSFER', 'Pembayaran Listrik', 'PAID'),
('SALE', '2024-01-18', 495000, 'CASH', 'Penjualan 3 Sweater Crewneck', 'PAID'),
('EXPENSE', '2024-01-20', 2000000, 'BANK_TRANSFER', 'Pembelian stok kain cotton', 'PAID'),
('SALE', '2024-01-22', 575000, 'OTHER', 'Penjualan 5 Polo Shirt', 'PAID'),
('SALE', '2024-01-25', 375000, 'CASH', 'Penjualan 5 Kaos Lengan Pendek', 'PAID'),
('EXPENSE', '2024-01-28', 800000, 'BANK_TRANSFER', 'Biaya Internet dan Telepon', 'PAID'),
('SALE', '2024-02-01', 1900000, 'BANK_TRANSFER', 'Penjualan 20 Kaos Polos ke CV Berkah Abadi', 'PAID'),
('SALE', '2024-02-05', 1125000, 'BANK_TRANSFER', 'Penjualan 5 Jaket Bomber', 'PAID'),
('EXPENSE', '2024-02-08', 350000, 'CASH', 'Biaya Pengiriman', 'PAID'),
('SALE', '2024-02-10', 585000, 'OTHER', 'Penjualan 3 Jaket Hoodie', 'PAID'),
('EXPENSE', '2024-02-15', 1500000, 'BANK_TRANSFER', 'Pembayaran Listrik', 'PAID'),
('SALE', '2024-02-20', 2850000, 'BANK_TRANSFER', 'Penjualan 30 Kaos ke Toko Sejahtera', 'PAID'),
('SALE', '2024-03-01', 1950000, 'BANK_TRANSFER', 'Penjualan 10 Jaket Hoodie', 'PAID'),
('EXPENSE', '2024-03-05', 3000000, 'BANK_TRANSFER', 'Pembelian mesin jahit baru', 'PAID'),
('SALE', '2024-03-10', 690000, 'CASH', 'Penjualan 6 Polo Shirt', 'PAID'),
('SALE', '2024-03-15', 1425000, 'BANK_TRANSFER', 'Penjualan 15 Kaos Lengan Panjang', 'PAID'),
('EXPENSE', '2024-03-20', 1500000, 'BANK_TRANSFER', 'Pembayaran Listrik', 'PAID'),
('SALE', '2024-04-01', 2250000, 'BANK_TRANSFER', 'Penjualan 10 Jaket Bomber ke PT Global Mandiri', 'PAID'),
('SALE', '2024-04-10', 825000, 'OTHER', 'Penjualan 5 Sweater Crewneck', 'PAID'),
('EXPENSE', '2024-04-15', 1500000, 'BANK_TRANSFER', 'Pembayaran Listrik', 'PAID'),
('SALE', '2024-04-20', 1500000, 'CASH', 'Penjualan 20 Kaos Lengan Pendek', 'PAID'),
('SALE', '2024-05-01', 3900000, 'BANK_TRANSFER', 'Penjualan 20 Jaket Hoodie ke CV Sumber Rezeki', 'PAID'),
('EXPENSE', '2024-05-05', 2500000, 'BANK_TRANSFER', 'Pembelian bahan fleece', 'PAID'),
('SALE', '2024-05-10', 1140000, 'BANK_TRANSFER', 'Penjualan 12 Kaos Lengan Panjang', 'PAID'),
('EXPENSE', '2024-05-15', 1500000, 'BANK_TRANSFER', 'Pembayaran Listrik', 'PAID'),
('SALE', '2024-05-20', 920000, 'CASH', 'Penjualan 8 Polo Shirt', 'PAID'),
('SALE', '2024-06-01', 2850000, 'BANK_TRANSFER', 'Penjualan 15 Jaket ke PT Maju Jaya', 'PAID'),
('SALE', '2024-06-05', 1650000, 'OTHER', 'Penjualan 10 Sweater Crewneck', 'PAID')
ON DUPLICATE KEY UPDATE total_amount=total_amount;
