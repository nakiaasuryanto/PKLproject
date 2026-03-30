#!/bin/bash
# ============================================================================
# Migration Script
# Description: Run all database migrations in order
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

# Base directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATIONS_DIR="$SCRIPT_DIR/migrations"

echo "=========================================="
echo "  Database Migration Script"
echo "=========================================="
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo "=========================================="
echo ""

# Function to run a single migration file
run_migration() {
    local file=$1
    local filename=$(basename "$file")

    echo -e "${YELLOW}[RUNNING]${NC} $filename"

    if MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" < "$file" 2>&1; then
        echo -e "${GREEN}[SUCCESS]${NC} $filename"
        echo ""
        return 0
    else
        echo -e "${RED}[ERROR]${NC} $filename"
        echo ""
        return 1
    fi
}

# Check if migrations directory exists
if [ ! -d "$MIGRATIONS_DIR" ]; then
    echo -e "${RED}[ERROR]${NC} Migrations directory not found: $MIGRATIONS_DIR"
    exit 1
fi

# Run migrations in order
MIGRATION_FILES=(
    "$MIGRATIONS_DIR/001_core_tables.sql"
    "$MIGRATIONS_DIR/002_inventory_tables.sql"
    "$MIGRATIONS_DIR/003_transactions_tables.sql"
    "$MIGRATIONS_DIR/004_crm_tables.sql"
    "$MIGRATIONS_DIR/005_hr_tables.sql"
    "$MIGRATIONS_DIR/006_integrations.sql"
)

SUCCESS_COUNT=0
FAILED_COUNT=0

for migration in "${MIGRATION_FILES[@]}"; do
    if [ -f "$migration" ]; then
        if run_migration "$migration"; then
            ((SUCCESS_COUNT++))
        else
            ((FAILED_COUNT++))
        fi
    else
        echo -e "${RED}[ERROR]${NC} Migration file not found: $migration"
        echo ""
        ((FAILED_COUNT++))
    fi
done

echo "=========================================="
echo "  Migration Summary"
echo "=========================================="
echo -e "Success: ${GREEN}$SUCCESS_COUNT${NC}"
echo -e "Failed: ${RED}$FAILED_COUNT${NC}"
echo "=========================================="

if [ $FAILED_COUNT -eq 0 ]; then
    echo -e "${GREEN}All migrations completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Some migrations failed. Please check the errors above.${NC}"
    exit 1
fi
