-- ============================================================================
-- Seed 003: Sample Customers
-- Description: Indonesian customers with realistic data
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Seed: Customers (Indonesian context)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO customers (customer_code, name, company_name, email, phone, city, customer_type, status, total_purchases, total_spent, first_purchase_date, last_purchase_date) VALUES
('CUST001', 'Budi Santoso', 'PT Maju Jaya Abadi', 'budi@majujaya.com', '081234567890', 'Surabaya', 'COMPANY', 'active', 15, 67500000, '2024-01-10', '2025-01-28'),
('CUST002', 'Siti Aminah', 'CV Sukses Bersama', 'siti@suksesbersama.co.id', '081234567891', 'Jakarta', 'COMPANY', 'active', 8, 32000000, '2024-03-15', '2025-01-25'),
('CUST003', 'Ahmad Rizki', NULL, 'ahmad.rizki@email.com', '081234567892', 'Bandung', 'INDIVIDUAL', 'active', 3, 4500000, '2024-06-20', '2025-01-20'),
('CUST004', 'Universitas Airlangga', 'UNAIR', 'procurement@unair.ac.id', '0315914042', 'Surabaya', 'COMPANY', 'active', 20, 125000000, '2023-11-05', '2025-01-30'),
('CUST005', 'Komunitas Futsal SBY', 'Futsal Community', 'admin@futsalsby.com', '081234567893', 'Surabaya', 'RESELLER', 'active', 12, 45000000, '2024-02-28', '2025-01-27'),
('CUST006', 'Dewi Kartika', 'PT Berkah Selalu', 'dewi@berkahselalu.com', '081234567894', 'Malang', 'COMPANY', 'active', 6, 28000000, '2024-04-10', '2025-01-15'),
('CUST007', 'Rudi Hermawan', NULL, 'rudi.h@email.com', '081234567895', 'Sidoarjo', 'INDIVIDUAL', 'active', 2, 1500000, '2024-08-05', '2025-01-10'),
('CUST008', 'PT Telkom Indonesia', 'TELKOM', 'procurement@telkom.co.id', '021-5551234', 'Jakarta', 'COMPANY', 'active', 25, 187500000, '2023-09-01', '2025-01-29'),
('CUST009', 'Komunitas Sepeda Gowes', 'Gowes Community', 'info@gowescity.id', '081234567896', 'Surabaya', 'RESELLER', 'active', 18, 68000000, '2024-01-20', '2025-01-26'),
('CUST010', 'Eko Prasetyo', 'CV Kreatif Digital', 'eko@kreatifdigital.com', '081234567897', 'Yogyakarta', 'COMPANY', 'active', 10, 42000000, '2024-05-15', '2025-01-22');

-- ----------------------------------------------------------------------------
-- Seed: Customer Interactions
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO customer_interactions (customer_id, interaction_type, subject, description, interaction_date, pic, follow_up_required, status) VALUES
-- Customer 1: Budi Santoso
(1, 'MEETING', 'Diskusi Order Q1 2025', 'Meeting untuk pembahasan order jersey futsal untuk Q1 2025. Quantity sekitar 100 pcs.', '2025-01-15 10:00:00', 'Andi Pratama', TRUE, 'COMPLETED'),
(1, 'WHATSAPP', 'Follow-up desain', 'Konfirmasi desain revisi 2 sudah disetujui', '2025-01-18 14:30:00', 'Andi Pratama', FALSE, 'COMPLETED'),
(1, 'ORDER', 'Order #2025-001', 'Order 50 jersey futsal custom PT Maju Jaya', '2025-01-20 09:15:00', 'Andi Pratama', FALSE, 'COMPLETED'),

-- Customer 2: Siti Aminah
(2, 'EMAIL', 'Penawaran Harga', 'Kirim penawaran harga untuk 100 kaos polo event', '2025-01-10 08:00:00', 'Andi Pratama', TRUE, 'COMPLETED'),
(2, 'CALL', 'Follow-up Penawaran', 'Follow-up apakah penawaran sudah diterima dan direview', '2025-01-14 11:00:00', 'Andi Pratama', TRUE, 'PENDING'),
(2, 'WHATSAPP', 'Kirim desain sample', 'Kirim beberapa desain sample untuk referensi', '2025-01-16 15:45:00', 'Andi Pratama', FALSE, 'COMPLETED'),

-- Customer 3: Universitas Airlangga
(4, 'MEETING', 'Presentasi Produk', 'Presentasi produk untuk kebutuhan jersey mahasiswa baru', '2025-01-05 13:00:00', 'Kia Ramadhani', TRUE, 'COMPLETED'),
(4, 'EMAIL', 'Kirim Quotation', 'Kirim quotation untuk 200 jersey', '2025-01-06 09:30:00', 'Kia Ramadhani', TRUE, 'PENDING'),
(4, 'VISIT', 'Site Visit', 'Kunjungan ke kampus untuk diskusi teknis', '2025-01-08 10:00:00', 'Kia Ramadhani', FALSE, 'COMPLETED'),
(4, 'ORDER', 'Order #2025-002', 'Order 200 jersey mahasiswa baru UNAIR', '2025-01-25 14:00:00', 'Kia Ramadhani', FALSE, 'COMPLETED'),

-- Customer 5: Komunitas Futsal SBY
(5, 'WHATSAPP', 'Inquiry Produk', 'Tanya harga jersey futsal untuk 5 tim', '2025-01-12 09:00:00', 'Andi Pratama', TRUE, 'COMPLETED'),
(5, 'MEETING', 'Diskusi Reseller', 'Meeting diskusi kerjasama reseller', '2025-01-15 14:00:00', 'Kia Ramadhani', FALSE, 'COMPLETED'),
(5, 'CALL', 'Follow-up MOU', 'Follow-up penandatanganan MOU reseller', '2025-01-20 10:30:00', 'Kia Ramadhani', TRUE, 'PENDING'),

-- Customer 8: PT Telkom
(8, 'EMAIL', 'Corporate Order', 'Inquiry untuk 500 jaket hoodie training', '2025-01-08 08:00:00', 'Kia Ramadhani', TRUE, 'COMPLETED'),
(8, 'MEETING', 'Presentasi ke Telkom', 'Presentasi produk dan diskusi spesifikasi', '2025-01-11 13:30:00', 'Kia Ramadhani', FALSE, 'COMPLETED'),
(8, 'WHATSAPP', 'Negosiasi Harga', 'Negosiasi harga untuk quantity 500 pcs', '2025-01-14 11:00:00', 'Kia Ramadhani', FALSE, 'COMPLETED'),
(8, 'ORDER', 'Order #2025-003', 'PO 500 jaket hoodie PT Telkom', '2025-01-22 16:00:00', 'Kia Ramadhani', FALSE, 'COMPLETED');
