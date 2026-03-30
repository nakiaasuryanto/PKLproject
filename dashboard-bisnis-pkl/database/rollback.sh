#!/bin/bash
# ============================================================================
# Rollback Script
# Description: Drop all tables (use with caution!)
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
NC='\033[0m' # No Color

echo "=========================================="
echo "  DATABASE ROLLBACK - WARNING!"
echo "=========================================="
echo "This will DROP ALL TABLES in the database."
echo "Database: $DB_NAME"
echo "=========================================="
echo ""

# Prompt for confirmation
read -p "Are you sure you want to proceed? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo "Rollback cancelled."
    exit 0
fi

# Disable foreign key checks
echo -e "${YELLOW}[INFO]${NC} Disabling foreign key checks..."
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS=0;" 2>&1

# Drop views first
echo -e "${YELLOW}[INFO]${NC} Dropping views..."
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "
DROP VIEW IF EXISTS v_attendance_summary;
DROP VIEW IF EXISTS v_top_customers;
DROP VIEW IF EXISTS v_sales_summary;
DROP VIEW IF EXISTS v_low_stock_alert;
DROP VIEW IF EXISTS v_stock_levels;
DROP VIEW IF EXISTS v_product_variants;
" 2>&1

# Drop tables
echo -e "${YELLOW}[INFO]${NC} Dropping tables..."
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customer_interactions;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS stock_movements;
DROP TABLE IF EXISTS stock_balances;
DROP TABLE IF EXISTS product_color_sizes;
DROP TABLE IF EXISTS product_colors;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS sizes;
DROP TABLE IF EXISTS colors;
DROP TABLE IF EXISTS products;
" 2>&1

# Re-enable foreign key checks
echo -e "${YELLOW}[INFO]${NC} Re-enabling foreign key checks..."
MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS=1;" 2>&1

echo ""
echo -e "${GREEN}[SUCCESS]${NC} All tables and views have been dropped."
