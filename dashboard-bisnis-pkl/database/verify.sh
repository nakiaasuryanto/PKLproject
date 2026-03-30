#!/bin/bash
# ============================================================================
# Verification Script
# Description: Verify database setup and show table counts
# Author: Nakia Suryanto
# Date: 2025-02-01
# ============================================================================

# Database Configuration
DB_HOST="127.0.0.1"
DB_PORT="3306"
DB_USER="u705828172_pklproject"
DB_PASS="PKLproject9"
DB_NAME="u705828172_pklproject"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Database Verification"
echo "=========================================="
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo "=========================================="
echo ""

# Test connection
echo -e "${YELLOW}[TEST]${NC} Testing database connection..."
if MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -e "SELECT '$DB_NAME' AS current_database, NOW() AS timestamp;" 2>/dev/null; then
    echo -e "${GREEN}[SUCCESS]${NC} Database connection successful"
    echo ""
else
    echo -e "${RED}[ERROR]${NC} Database connection failed"
    echo "Please check your credentials and try again."
    exit 1
fi

# Show all tables
echo -e "${YELLOW}[INFO]${NC} Tables in database:"
echo "------------------------------------------"
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "SHOW TABLES;" 2>/dev/null
echo ""

# Show record counts
echo -e "${YELLOW}[INFO]${NC} Record counts:"
echo "------------------------------------------"
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" <<'EOF' 2>/dev/null
SELECT
    'Products' AS item, COUNT(*) AS count FROM products
UNION ALL SELECT 'Colors', COUNT(*) FROM colors
UNION ALL SELECT 'Sizes', COUNT(*) FROM sizes
UNION ALL SELECT 'Locations', COUNT(*) FROM locations
UNION ALL SELECT 'Product Colors', COUNT(*) FROM product_colors
UNION ALL SELECT 'Product Variants (SKUs)', COUNT(*) FROM product_color_sizes
UNION ALL SELECT 'Stock Balances', COUNT(*) FROM stock_balances
UNION ALL SELECT 'Stock Movements', COUNT(*) FROM stock_movements
UNION ALL SELECT 'Customers', COUNT(*) FROM customers
UNION ALL SELECT 'Customer Interactions', COUNT(*) FROM customer_interactions
UNION ALL SELECT 'Transactions', COUNT(*) FROM transactions
UNION ALL SELECT 'Expenses', COUNT(*) FROM expenses
UNION ALL SELECT 'Employees', COUNT(*) FROM employees
UNION ALL SELECT 'Attendance Records', COUNT(*) FROM attendance;
EOF
echo ""

# Show views
echo -e "${YELLOW}[INFO]${NC} Views in database:"
echo "------------------------------------------"
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';" 2>/dev/null
echo ""

echo "=========================================="
echo "  Verification Complete"
echo "=========================================="
