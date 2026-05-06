-- ============================================================================
-- Migration 003: Transactions & Finance Tables
-- Description: Sales transactions and expense tracking
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: customers (CRM core - created here for FK reference)
-- Description: Customer master data
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_code VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  company_name VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20),
  address TEXT,
  city VARCHAR(50),
  province VARCHAR(50),
  postal_code VARCHAR(10),
  customer_type ENUM('INDIVIDUAL', 'COMPANY', 'RESELLER') DEFAULT 'INDIVIDUAL',
  status ENUM('active', 'inactive') DEFAULT 'active',
  first_purchase_date DATE,
  last_purchase_date DATE,
  total_purchases INT DEFAULT 0,
  total_spent DECIMAL(15,2) DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_code (customer_code),
  INDEX idx_email (email),
  INDEX idx_phone (phone),
  INDEX idx_city (city),
  INDEX idx_type (customer_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Customer master data';

-- ----------------------------------------------------------------------------
-- Table: transactions
-- Description: Sales, gifts, and other transactions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  transaction_type ENUM('SALE', 'EXPENSE', 'GIFT') NOT NULL,
  transaction_date DATE NOT NULL,
  transaction_time TIME,
  customer_id INT,
  total_amount DECIMAL(15,2) DEFAULT 0,
  payment_method ENUM('CASH', 'BANK_TRANSFER', 'OTHER') DEFAULT 'CASH',
  payment_status ENUM('PENDING', 'PAID', 'CANCELLED') DEFAULT 'PAID',
  pic VARCHAR(100) COMMENT 'Person in charge',
  notes TEXT,
  items JSON COMMENT 'Store multiple items: [{product_id, color_id, size_id, qty, price, free}, ...]',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  INDEX idx_type (transaction_type),
  INDEX idx_date (transaction_date),
  INDEX idx_customer (customer_id),
  INDEX idx_pic (pic),
  INDEX idx_payment_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Sales and gift transactions';

-- ----------------------------------------------------------------------------
-- Table: expenses
-- Description: Detailed expense tracking
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS expenses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category VARCHAR(50) NOT NULL COMMENT 'MATERIALS, UTILITIES, SALARY, MARKETING, TRANSPORTATION, OTHER',
  description TEXT,
  amount DECIMAL(15,2) NOT NULL,
  expense_date DATE NOT NULL,
  payment_method ENUM('CASH', 'BANK_TRANSFER', 'OTHER') DEFAULT 'CASH',
  pic VARCHAR(100) COMMENT 'Person in charge',
  receipt_number VARCHAR(50),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_category (category),
  INDEX idx_date (expense_date),
  INDEX idx_pic (pic)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Business expense records';
