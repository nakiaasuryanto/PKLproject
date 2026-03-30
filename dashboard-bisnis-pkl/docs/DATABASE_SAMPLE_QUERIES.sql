-- ============================================================================
-- Database Sample Queries
-- Project: Dashboard Bisnis Terintegrasi PKL
-- Author: Nakia Suryanto
-- Date: 2025-02-01
--
-- Purpose: Common queries for dashboard development
-- ============================================================================

-- ============================================================================
-- SALES QUERIES
-- ============================================================================

-- Sales: Revenue by period (monthly)
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

-- Sales: Revenue by day (last 30 days)
SELECT
    transaction_date AS date,
    COUNT(*) AS total_transactions,
    SUM(total_amount) AS revenue
FROM transactions
WHERE transaction_type = 'SALE'
    AND payment_status = 'PAID'
    AND transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY transaction_date
ORDER BY date DESC;

-- Sales: Top selling products
SELECT
    p.name AS product_name,
    p.code AS product_code,
    c.name AS color,
    s.name AS size,
    SUM(JSON_EXTRACT(t.items, '$*.quantity')) AS total_quantity_sold
FROM transactions t
JOIN customers cu ON t.customer_id = cu.id
, JSON_TABLE(t.items, '$[*]' COLUMNS(
    product_id INT PATH '$.product_id',
    color_id INT PATH '$.color_id',
    size_id INT PATH '$.size_id',
    quantity INT PATH '$.quantity'
)) AS jt
JOIN products p ON jt.product_id = p.id
LEFT JOIN colors c ON jt.color_id = c.id
LEFT JOIN sizes s ON jt.size_id = s.id
WHERE t.transaction_type = 'SALE'
GROUP BY p.id, c.id, s.id
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Sales: Revenue by customer type
SELECT
    c.customer_type,
    COUNT(*) AS total_orders,
    SUM(t.total_amount) AS revenue
FROM transactions t
JOIN customers c ON t.customer_id = c.id
WHERE t.transaction_type = 'SALE'
    AND t.payment_status = 'PAID'
GROUP BY c.customer_type
ORDER BY revenue DESC;

-- Sales: Payment method distribution
SELECT
    payment_method,
    COUNT(*) AS count,
    SUM(total_amount) AS total_amount
FROM transactions
WHERE transaction_type = 'SALE'
    AND payment_status = 'PAID'
GROUP BY payment_method;

-- ============================================================================
-- CRM QUERIES
-- ============================================================================

-- CRM: Top customers by spending
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
ORDER BY c.total_spent DESC
LIMIT 20;

-- CRM: Customers with no purchases in last 90 days (inactive)
SELECT
    c.customer_code,
    c.name,
    c.company_name,
    c.city,
    c.phone,
    c.last_purchase_date,
    DATEDIFF(CURDATE(), c.last_purchase_date) AS days_since_last_purchase
FROM customers c
WHERE c.status = 'active'
    AND (c.last_purchase_date IS NULL
         OR c.last_purchase_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY))
ORDER BY days_since_last_purchase DESC;

-- CRM: Follow-up required (pending interactions)
SELECT
    c.customer_code,
    c.name AS customer_name,
    ci.subject,
    ci.interaction_type,
    ci.interaction_date,
    ci.follow_up_date,
    ci.pic,
    ci.status
FROM customer_interactions ci
JOIN customers c ON ci.customer_id = c.id
WHERE ci.follow_up_required = TRUE
    AND ci.status = 'PENDING'
    AND ci.follow_up_date >= CURDATE()
ORDER BY ci.follow_up_date ASC;

-- CRM: Interaction summary by type
SELECT
    interaction_type,
    COUNT(*) AS total_interactions,
    COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) AS completed,
    COUNT(CASE WHEN status = 'PENDING' THEN 1 END) AS pending
FROM customer_interactions
WHERE interaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY interaction_type
ORDER BY total_interactions DESC;

-- CRM: New customers this month
SELECT
    COUNT(*) AS new_customers
FROM customers
WHERE DATE_FORMAT(created_at, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m');

-- ============================================================================
-- INVENTORY QUERIES
-- ============================================================================

-- Inventory: Low stock alert (below 10 units)
SELECT
    p.name AS product_name,
    p.code AS product_code,
    c.name AS color,
    s.name AS size,
    l.name AS location,
    sb.quantity
FROM stock_balances sb
JOIN product_color_sizes pcs ON sb.product_color_size_id = pcs.id
JOIN product_colors pc ON pcs.product_color_id = pc.id
JOIN products p ON pc.product_id = p.id
JOIN colors c ON pc.color_id = c.id
JOIN sizes s ON pcs.size_id = s.id
JOIN locations l ON sb.location_id = l.id
WHERE sb.quantity < 10
ORDER BY sb.quantity ASC;

-- Inventory: Total stock by product
SELECT
    p.name AS product_name,
    p.code AS product_code,
    p.category,
    SUM(sb.quantity) AS total_quantity,
    SUM(sb.quantity * sb.moving_avg_cost) AS total_value
FROM stock_balances sb
JOIN product_color_sizes pcs ON sb.product_color_size_id = pcs.id
JOIN product_colors pc ON pcs.product_color_id = pc.id
JOIN products p ON pc.product_id = p.id
GROUP BY p.id, p.name, p.code, p.category
HAVING total_quantity > 0
ORDER BY total_quantity DESC;

-- Inventory: Stock movements summary (last 7 days)
SELECT
    movement_type,
    reason_code,
    COUNT(*) AS total_movements,
    SUM(quantity) AS total_quantity
FROM stock_movements
WHERE movement_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY movement_type, reason_code
ORDER BY movement_type, total_quantity DESC;

-- Inventory: Product variants with no stock
SELECT
    p.name AS product_name,
    c.name AS color,
    s.name AS size,
    pcs.sku
FROM product_color_sizes pcs
JOIN product_colors pc ON pcs.product_color_id = pc.id
JOIN products p ON pc.product_id = p.id
JOIN colors c ON pc.color_id = c.id
JOIN sizes s ON pcs.size_id = s.id
LEFT JOIN stock_balances sb ON pcs.id = sb.product_color_size_id
WHERE (sb.quantity IS NULL OR sb.quantity = 0)
    AND p.status = 'active'
ORDER BY p.name, c.name, s.name;

-- ============================================================================
-- HR QUERIES
-- ============================================================================

-- HR: Attendance rate this month
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
    ROUND(SUM(CASE WHEN a.status IN ('PRESENT', 'LATE') THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS attendance_rate,
    ROUND(SUM(a.work_hours), 2) AS total_work_hours,
    ROUND(SUM(a.overtime_hours), 2) AS total_overtime_hours
FROM attendance a
JOIN employees e ON a.employee_id = e.id
WHERE a.attendance_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY e.id, e.employee_code, e.name, e.department, e.position
ORDER BY attendance_rate DESC;

-- HR: Employee list by department
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active_employees,
    SUM(CASE WHEN status = 'INACTIVE' THEN 1 ELSE 0 END) AS inactive_employees,
    SUM(CASE WHEN status = 'RESIGNED' THEN 1 ELSE 0 END) AS resigned_employees
FROM employees
GROUP BY department
ORDER BY total_employees DESC;

-- HR: Today's attendance
SELECT
    e.employee_code,
    e.name,
    e.department,
    a.status,
    a.check_in,
    a.check_out,
    a.work_hours
FROM attendance a
JOIN employees e ON a.employee_id = e.id
WHERE a.attendance_date = CURDATE()
    AND e.status = 'ACTIVE'
ORDER BY a.check_in;

-- HR: Overtime summary this month
SELECT
    e.name,
    e.position,
    SUM(a.overtime_hours) AS total_overtime,
    SUM(a.overtime_hours * e.salary / 173) AS estimated_overtime_pay
FROM attendance a
JOIN employees e ON a.employee_id = e.id
WHERE a.attendance_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
    AND a.overtime_hours > 0
GROUP BY e.id, e.name, e.position
ORDER BY total_overtime DESC;

-- ============================================================================
-- FINANCE QUERIES
-- ============================================================================

-- Finance: Expense summary by category (this month)
SELECT
    category,
    COUNT(*) AS total_expenses,
    SUM(amount) AS total_amount
FROM expenses
WHERE DATE_FORMAT(expense_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')
GROUP BY category
ORDER BY total_amount DESC;

-- Finance: Profit/Loss statement (this month)
SELECT
    'Revenue' AS type,
    SUM(total_amount) AS amount
FROM transactions
WHERE transaction_type = 'SALE'
    AND payment_status = 'PAID'
    AND DATE_FORMAT(transaction_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')

UNION ALL

SELECT
    'Expenses' AS type,
    SUM(amount) AS amount
FROM expenses
WHERE DATE_FORMAT(expense_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')

UNION ALL

SELECT
    'Profit' AS type,
    (SELECT SUM(total_amount) FROM transactions WHERE transaction_type = 'SALE' AND payment_status = 'PAID' AND DATE_FORMAT(transaction_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')) -
    (SELECT SUM(amount) FROM expenses WHERE DATE_FORMAT(expense_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')) AS amount;

-- ============================================================================
-- DASHBOARD WIDGETS
-- ============================================================================

-- Widget: Total revenue this month
SELECT
    COALESCE(SUM(total_amount), 0) AS revenue_this_month
FROM transactions
WHERE transaction_type = 'SALE'
    AND payment_status = 'PAID'
    AND DATE_FORMAT(transaction_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m');

-- Widget: Total expenses this month
SELECT
    COALESCE(SUM(amount), 0) AS expenses_this_month
FROM expenses
WHERE DATE_FORMAT(expense_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m');

-- Widget: Total customers
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS active_customers
FROM customers;

-- Widget: Low stock count
SELECT
    COUNT(*) AS low_stock_items
FROM stock_balances
WHERE quantity < 10;

-- Widget: Today's attendance
SELECT
    COUNT(*) AS total_present,
    SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) AS present,
    SUM(CASE WHEN status = 'LATE' THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN status = 'ABSENT' THEN 1 ELSE 0 END) AS absent
FROM attendance a
JOIN employees e ON a.employee_id = e.id
WHERE a.attendance_date = CURDATE()
    AND e.status = 'ACTIVE';

-- Widget: Pending follow-ups
SELECT
    COUNT(*) AS pending_followups
FROM customer_interactions
WHERE follow_up_required = TRUE
    AND status = 'PENDING'
    AND follow_up_date >= CURDATE();

-- ============================================================================
-- REPORTING QUERIES
-- ============================================================================

-- Report: Sales vs Expenses (last 6 months)
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS period,
    SUM(CASE WHEN transaction_type = 'SALE' AND payment_status = 'PAID' THEN total_amount ELSE 0 END) AS revenue,
    0 AS expenses
FROM transactions
WHERE transaction_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')

UNION ALL

SELECT
    DATE_FORMAT(expense_date, '%Y-%m') AS period,
    0 AS revenue,
    SUM(amount) AS expenses
FROM expenses
WHERE expense_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(expense_date, '%Y-%m')
ORDER BY period;

-- Report: Customer acquisition by month
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS period,
    COUNT(*) AS new_customers,
    SUM(CASE WHEN customer_type = 'COMPANY' THEN 1 ELSE 0 END) AS companies,
    SUM(CASE WHEN customer_type = 'RESELLER' THEN 1 ELSE 0 END) AS resellers,
    SUM(CASE WHEN customer_type = 'INDIVIDUAL' THEN 1 ELSE 0 END) AS individuals
FROM customers
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY period DESC
LIMIT 12;

-- Report: Employee work hours summary (monthly)
SELECT
    DATE_FORMAT(attendance_date, '%Y-%m') AS period,
    e.name,
    e.department,
    SUM(a.work_hours) AS total_hours,
    SUM(a.overtime_hours) AS overtime_hours,
    ROUND(SUM(a.work_hours) / COUNT(DISTINCT a.attendance_date), 2) AS avg_hours_per_day
FROM attendance a
JOIN employees e ON a.employee_id = e.id
WHERE a.attendance_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY DATE_FORMAT(a.attendance_date, '%Y-%m'), e.id, e.name, e.department
ORDER BY period DESC, total_hours DESC;
