-- ============================================================================
-- Migration 004: CRM Tables
-- Description: Customer interactions and relationship management
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: customer_interactions
-- Description: Customer communication and interaction history
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customer_interactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  interaction_type ENUM('CALL', 'EMAIL', 'MEETING', 'WHATSAPP', 'VISIT', 'COMPLAINT', 'INQUIRY', 'ORDER', 'FOLLOW_UP', 'OTHER') NOT NULL,
  subject VARCHAR(200),
  description TEXT,
  interaction_date DATETIME NOT NULL,
  pic VARCHAR(100) COMMENT 'Person in charge',
  follow_up_required BOOLEAN DEFAULT FALSE,
  follow_up_date DATE,
  status ENUM('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
  outcome VARCHAR(50),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  INDEX idx_customer (customer_id),
  INDEX idx_date (interaction_date),
  INDEX idx_type (interaction_type),
  INDEX idx_status (status),
  INDEX idx_follow_up (follow_up_required, follow_up_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Customer interaction history';
