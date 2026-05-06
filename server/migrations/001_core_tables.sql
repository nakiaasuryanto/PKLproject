-- ============================================================================
-- Migration 001: Core Tables
-- Description: Products, Colors, Sizes, Locations
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: products
-- Description: Master product catalog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  code VARCHAR(50) UNIQUE,
  category VARCHAR(50),
  description TEXT,
  base_price DECIMAL(15,2) NOT NULL DEFAULT 0,
  retail_price DECIMAL(15,2),
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (code),
  INDEX idx_category (category),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Master product catalog';

-- ----------------------------------------------------------------------------
-- Table: colors
-- Description: Available colors for products
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS colors (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  hex_code VARCHAR(7),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Available colors for product variants';

-- ----------------------------------------------------------------------------
-- Table: sizes
-- Description: Available sizes for products
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sizes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL UNIQUE,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_sort (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Available sizes for product variants';

-- ----------------------------------------------------------------------------
-- Table: locations
-- Description: Storage/Display locations for inventory
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS locations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  type ENUM('display', 'storage', 'warehouse') DEFAULT 'storage',
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Storage and display locations';
