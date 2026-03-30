#!/bin/bash
# ============================================================================
# Dummy Data Seed Script
# Description: Load comprehensive dummy data for all modules
# Author: Nakia Suryanto
# Date: 2025-02-02
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
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Base directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEEDS_DIR="$SCRIPT_DIR/seeds"

echo -e "${CYAN}=========================================="
echo "  Dummy Data Seeder"
echo "  Dashboard Bisnis PKL"
echo -e "==========================================${NC}"
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo -e "${YELLOW}⚠️  WARNING: This will REPLACE existing data!${NC}"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Starting dummy data import...${NC}"
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

# Check if master data file exists
if [ ! -f "$SEEDS_DIR/001_master_data.sql" ]; then
    echo -e "${RED}[ERROR]${NC} Master data file not found. Please run migrate.sh first."
    exit 1
fi

# Run seeds in order
echo -e "${BLUE}Step 1/2: Loading master data (colors, sizes, locations)...${NC}"
run_seed "$SEEDS_DIR/001_master_data.sql"

echo -e "${BLUE}Step 2/2: Loading comprehensive dummy data...${NC}"
run_seed "$SEEDS_DIR/005_dummy_data_complete.sql"

echo -e "${CYAN}=========================================="
echo "  Dummy Data Summary"
echo -e "==========================================${NC}"
echo -e "${GREEN}✓${NC} Products: 15 (Jersey, Sepatu, Aksesoris)"
echo -e "${GREEN}✓${NC} Product Colors: ~50 variants"
echo -e "${GREEN}✓${NC} Product Sizes: ~200+ SKUs"
echo -e "${GREEN}✓${NC} Stock Balances: Initial stock set"
echo -e "${GREEN}✓${NC} Customers: 20 (Corporate, Individual, Reseller)"
echo -e "${GREEN}✓${NC} Interactions: 20 customer interactions"
echo -e "${GREEN}✓${NC} Employees: 12 across 5 departments"
echo -e "${GREEN}✓${NC} Attendance: 700+ records (January 2025)"
echo -e "${GREEN}✓${NC} Sales: 30 transactions"
echo -e "${GREEN}✓${NC} Expenses: 12 transactions"
echo -e "${GREEN}✓${NC} Stock Movements: Auto-generated"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo -e "${GREEN}✅ Dummy data loaded successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Start the backend server: cd server && npm start"
echo "2. Start the frontend: cd frontend && npm run dev"
echo "3. Open http://localhost:4321"
echo ""
