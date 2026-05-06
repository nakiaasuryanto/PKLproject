-- ============================================================================
-- Migration 002: Inventory Tables
-- Description: Product variants and stock management
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: product_colors
-- Description: Product-color combinations (2nd level variant)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_colors (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  color_id INT NOT NULL,
  additional_price DECIMAL(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (color_id) REFERENCES colors(id) ON DELETE RESTRICT,
  UNIQUE KEY unique_product_color (product_id, color_id),
  INDEX idx_product (product_id),
  INDEX idx_color (color_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Product-color variant combinations';

-- ----------------------------------------------------------------------------
-- Table: product_color_sizes
-- Description: SKU level variants (product-color-size)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_color_sizes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_color_id INT NOT NULL,
  size_id INT NOT NULL,
  sku VARCHAR(100) UNIQUE,
  additional_price DECIMAL(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_color_id) REFERENCES product_colors(id) ON DELETE CASCADE,
  FOREIGN KEY (size_id) REFERENCES sizes(id) ON DELETE RESTRICT,
  UNIQUE KEY unique_variant (product_color_id, size_id),
  INDEX idx_product_color (product_color_id),
  INDEX idx_size (size_id),
  INDEX idx_sku (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='SKU level product variants';

-- ----------------------------------------------------------------------------
-- Table: stock_balances
-- Description: Current stock levels per variant per location
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stock_balances (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_color_size_id INT NOT NULL,
  location_id INT NOT NULL,
  quantity INT DEFAULT 0,
  moving_avg_cost DECIMAL(15,2) DEFAULT 0,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_color_size_id) REFERENCES product_color_sizes(id) ON DELETE CASCADE,
  FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE RESTRICT,
  UNIQUE KEY unique_variant_location (product_color_size_id, location_id),
  INDEX idx_variant (product_color_size_id),
  INDEX idx_location (location_id),
  INDEX idx_quantity (quantity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Current stock balances by variant and location';

-- ----------------------------------------------------------------------------
-- Table: stock_movements
-- Description: Historical stock movements (IN/OUT)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stock_movements (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_color_size_id INT NOT NULL,
  location_id INT NOT NULL,
  movement_type ENUM('IN', 'OUT') NOT NULL,
  quantity INT NOT NULL,
  reason_code VARCHAR(50) NOT NULL COMMENT 'SALES_OUT, GIFT_OUT, ADJUSTMENT_IN, ADJUSTMENT_OUT, TRANSFER_IN, TRANSFER_OUT, PRODUCTION_IN, RETURN_IN',
  reference_type VARCHAR(50) COMMENT 'Transaction, Manual, etc.',
  reference_id INT,
  notes TEXT,
  movement_date DATETIME NOT NULL,
  created_by VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_color_size_id) REFERENCES product_color_sizes(id) ON DELETE RESTRICT,
  FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE RESTRICT,
  INDEX idx_variant (product_color_size_id),
  INDEX idx_location (location_id),
  INDEX idx_date (movement_date),
  INDEX idx_reference (reference_type, reference_id),
  INDEX idx_reason (reason_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Historical stock movement records';
