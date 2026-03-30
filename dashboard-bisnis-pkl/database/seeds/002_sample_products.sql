-- ============================================================================
-- Seed 002: Sample Products
-- Description: Products with variants for Indonesian context
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Seed: Products
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO products (name, code, category, description, base_price, retail_price) VALUES
('Jersey Futsal Custom', 'JFC-001', 'JERSEY', 'Jersey futsal printing sublimasi kualitas premium', 75000, 125000),
('Jersey Sepeda Premium', 'JSP-001', 'JERSEY', 'Jersey sepeda full printing bahan dry-fit', 95000, 150000),
('Kaos Polo Event', 'KPE-001', 'KAOS', 'Kaos polo untuk event/perusahaan bordir komputer', 45000, 75000),
('Jaket Varsity', 'JKV-001', 'JAKET', 'Jaket varsity custom bordir patch premium', 150000, 250000),
('Topi Baseball Custom', 'TBC-001', 'TOPI', 'Topi baseball bordir/printing custom', 35000, 60000),
('Kaos Raglan Custom', 'KRC-001', 'KAOS', 'Kaos raglan 3/4 printing sublimasi', 40000, 70000),
('Jaket Hoodie', 'JKH-001', 'JAKET', 'Jaket hoodie custom sablon/bordir', 95000, 150000),
('Kemeja PDH/PDL', 'KPD-001', 'KEMEJA', 'Kemeja PDH/PDL komunitas/instansi', 85000, 140000),
('Training Pack', 'TRP-001', 'TRAINING', 'Paket training jersey + celana', 120000, 200000),
('Rompi Safety', 'RMS-001', 'ROMPI', 'Rompi safety/organisasi custom', 50000, 85000);

-- ----------------------------------------------------------------------------
-- Seed: Product Colors
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO product_colors (product_id, color_id, additional_price)
SELECT p.id, c.id, 0
FROM products p
CROSS JOIN colors c
WHERE p.code IN ('JFC-001', 'JSP-001', 'KPE-001', 'JKV-001', 'TBC-001')
AND c.name IN ('Merah', 'Biru', 'Hitam', 'Putih', 'Kuning');

-- ----------------------------------------------------------------------------
-- Seed: Product Color Sizes (SKU variants)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO product_color_sizes (product_color_id, size_id, sku, additional_price)
SELECT pc.id, s.id, CONCAT(p.code, '-', SUBSTRING(c.name, 1, 3), '-', UPPER(s.name)), 0
FROM product_colors pc
JOIN products p ON pc.product_id = p.id
JOIN colors c ON pc.color_id = c.id
CROSS JOIN sizes s
WHERE s.name IN ('S', 'M', 'L', 'XL', 'XXL')
AND pc.product_id IN (SELECT id FROM products WHERE code IN ('JFC-001', 'JSP-001', 'KPE-001', 'JKV-001', 'TBC-001'));

-- ----------------------------------------------------------------------------
-- Seed: Initial Stock Balances
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO stock_balances (product_color_size_id, location_id, quantity, moving_avg_cost)
SELECT pcs.id, l.id, FLOOR(50 + RAND() * 100), p.base_price
FROM product_color_sizes pcs
JOIN product_colors pc ON pcs.product_color_id = pc.id
JOIN products p ON pc.product_id = p.id
CROSS JOIN locations l
WHERE pc.product_id IN (SELECT id FROM products WHERE code IN ('JFC-001', 'JSP-001', 'KPE-001'))
AND l.name = 'GUDANG'
LIMIT 50;
