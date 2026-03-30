#!/bin/bash
# ============================================================================
# Seed Script
# Description: Run all database seed files
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
SEEDS_DIR="$SCRIPT_DIR/seeds"

echo "=========================================="
echo "  Database Seed Script"
echo "=========================================="
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo "=========================================="
echo ""

# Function to run a single seed file
run_seed() {
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

# Check if seeds directory exists
if [ ! -d "$SEEDS_DIR" ]; then
    echo -e "${RED}[ERROR]${NC} Seeds directory not found: $SEEDS_DIR"
    exit 1
fi

# Run seeds in order
SEED_FILES=(
    "$SEEDS_DIR/001_master_data.sql"
    "$SEEDS_DIR/002_sample_products.sql"
    "$SEEDS_DIR/003_sample_customers.sql"
    "$SEEDS_DIR/004_sample_employees.sql"
)

SUCCESS_COUNT=0
FAILED_COUNT=0

for seed in "${SEED_FILES[@]}"; do
    if [ -f "$seed" ]; then
        if run_seed "$seed"; then
            ((SUCCESS_COUNT++))
        else
            ((FAILED_COUNT++))
        fi
    else
        echo -e "${RED}[ERROR]${NC} Seed file not found: $seed"
        echo ""
        ((FAILED_COUNT++))
    fi
done

echo "=========================================="
echo "  Seed Summary"
echo "=========================================="
echo -e "Success: ${GREEN}$SUCCESS_COUNT${NC}"
echo -e "Failed: ${RED}$FAILED_COUNT${NC}"
echo "=========================================="

if [ $FAILED_COUNT -eq 0 ]; then
    echo -e "${GREEN}All seeds completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Some seeds failed. Please check the errors above.${NC}"
    exit 1
fi
