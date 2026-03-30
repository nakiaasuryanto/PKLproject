-- ============================================================================
-- Migration 006: Integrations & Additional Features
-- Description: Foreign key constraints and additional indexes
-- Author: Nakia Suryanto
-- Date: 2025-02-01
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Additional indexes for performance optimization
-- ----------------------------------------------------------------------------

-- Transactions: Composite index for date range queries
ALTER TABLE transactions ADD INDEX idx_date_type (transaction_date, transaction_type);

-- Stock movements: Composite index for reporting
ALTER TABLE stock_movements ADD INDEX idx_date_location (movement_date, location_id);

-- Customers: Composite index for spending analytics
ALTER TABLE customers ADD INDEX idx_spending (customer_type, total_spent);

-- Expenses: Composite index for category and date reporting
ALTER TABLE expenses ADD INDEX idx_category_date (category, expense_date);

-- Attendance: Composite index for monthly reports
ALTER TABLE attendance ADD INDEX idx_employee_date_status (employee_id, attendance_date, status);

-- Customer interactions: Composite index for follow-up tracking
ALTER TABLE customer_interactions ADD INDEX idx_followup_tracking (follow_up_required, follow_up_date, status);

-- ----------------------------------------------------------------------------
-- Views for common queries
-- ----------------------------------------------------------------------------

-- View: Product variants with full details
CREATE OR REPLACE VIEW v_product_variants AS
SELECT
    pcs.id AS variant_id,
    pcs.sku,
    p.id AS product_id,
    p.name AS product_name,
    p.code AS product_code,
    p.category,
    c.name AS color,
    c.hex_code AS color_hex,
    s.name AS size,
    p.base_price + pc.additional_price + IFNULL(pcs.additional_price, 0) AS final_price,
    p.status AS product_status
FROM product_color_sizes pcs
JOIN product_colors pc ON pcs.product_color_id = pc.id
JOIN products p ON pc.product_id = p.id
JOIN colors c ON pc.color_id = c.id
JOIN sizes s ON pcs.size_id = s.id;

-- View: Current stock levels with product details
CREATE OR REPLACE VIEW v_stock_levels AS
SELECT
    v.variant_id,
    v.sku,
    v.product_name,
    v.color,
    v.size,
    l.name AS location,
    l.type AS location_type,
    sb.quantity,
    sb.moving_avg_cost,
    v.final_price
FROM stock_balances sb
JOIN v_product_variants v ON sb.product_color_size_id = v.variant_id
JOIN locations l ON sb.location_id = l.id
WHERE sb.quantity > 0;

-- View: Low stock alert
CREATE OR REPLACE VIEW v_low_stock_alert AS
SELECT
    v.product_name,
    v.color,
    v.size,
    l.name AS location,
    sb.quantity
FROM stock_balances sb
JOIN v_product_variants v ON sb.product_color_size_id = v.variant_id
JOIN locations l ON sb.location_id = l.id
WHERE sb.quantity < 10
ORDER BY sb.quantity ASC;

-- View: Sales summary by month
CREATE OR REPLACE VIEW v_sales_summary AS
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS period,
    COUNT(*) AS total_transactions,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS avg_transaction_value
FROM transactions
WHERE transaction_type = 'SALE'
    AND payment_status = 'PAID'
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY period DESC;

-- View: Top customers
CREATE OR REPLACE VIEW v_top_customers AS
SELECT
    c.customer_code,
    c.name,
    c.company_name,
    c.customer_type,
    c.city,
    c.total_purchases,
    c.total_spent,
    c.last_purchase_date
FROM customers c
WHERE c.status = 'active'
    AND c.total_purchases > 0
ORDER BY c.total_spent DESC;

-- View: Employee attendance summary
CREATE OR REPLACE VIEW v_attendance_summary AS
SELECT
    e.employee_code,
    e.name,
    e.department,
    e.position,
    COUNT(*) AS total_days,
    SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN a.status = 'LATE' THEN 1 ELSE 0 END) AS late_days,
    SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN a.status IN ('SICK', 'LEAVE') THEN 1 ELSE 0 END) AS leave_days,
    ROUND(SUM(a.work_hours), 2) AS total_work_hours,
    ROUND(SUM(a.overtime_hours), 2) AS total_overtime_hours
FROM attendance a
JOIN employees e ON a.employee_id = e.id
GROUP BY e.id, e.employee_code, e.name, e.department, e.position
ORDER BY e.employee_code;
