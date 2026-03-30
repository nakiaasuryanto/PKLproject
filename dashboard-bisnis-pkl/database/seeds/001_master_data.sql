-- ============================================================================
-- Seed 001: Master Data
-- Description: Colors, Sizes, Locations
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Seed: Colors (Indonesian context)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO colors (name, hex_code) VALUES
('Merah', '#DC2626'),
('Biru', '#2563EB'),
('Hitam', '#000000'),
('Putih', '#FFFFFF'),
('Kuning', '#FBBF24'),
('Hijau', '#059669'),
('Orange', '#F97316'),
('Ungu', '#9333EA'),
('Pink', '#EC4899'),
('Coklat', '#78350F'),
('Abu-abu', '#6B7280'),
('Navy', '#1E3A8A'),
('Maroon', '#9F1239'),
('Turquoise', '#0D9488'),
('Emas', '#D97706');

-- ----------------------------------------------------------------------------
-- Seed: Sizes
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO sizes (name, sort_order) VALUES
('XS', 1),
('S', 2),
('M', 3),
('L', 4),
('XL', 5),
('XXL', 6),
('XXXL', 7),
('Free Size', 8),
('Custom', 9);

-- ----------------------------------------------------------------------------
-- Seed: Locations
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO locations (name, type, description) VALUES
('DISPLAY', 'display', 'Area display toko utama'),
('GUDANG', 'storage', 'Gudang penyimpanan utama'),
('LEMARI', 'storage', 'Lemari penyimpanan'),
('PRODUKSI', 'warehouse', 'Area produksi'),
('SHOWROOM', 'display', 'Showroom untuk pelanggan');
