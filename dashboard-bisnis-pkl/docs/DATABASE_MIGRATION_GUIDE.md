# Database Migration Guide

**Project:** Dashboard Bisnis Terintegrasi PKL
**Version:** 1.0
**Date:** 2025-02-01
**Author:** Nakia Suryanto

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Manual Migration](#manual-migration)
4. [Seeding Data](#seeding-data)
5. [Verification](#verification)
6. [Rollback](#rollback)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Requirements
- MySQL 5.7+ or MariaDB 10.3+
- Database user with CREATE, ALTER, INDEX, INSERT privileges
- bash shell for executing scripts

### Database Connection

Update the connection details in each script if different from:
```bash
DB_HOST="127.0.0.1"
DB_PORT="3306"
DB_USER="u705828172_pklproject"
DB_PASS="PKLproject9"
DB_NAME="u705828172_pklproject"
```

---

## Quick Start

### 1. Make Scripts Executable
```bash
chmod +x database/*.sh
```

### 2. Run Migrations
```bash
cd database
./migrate.sh
```

### 3. Run Seeds
```bash
./seed.sh
```

### 4. Verify Installation
```bash
./verify.sh
```

---

## Manual Migration

### Step 1: Create Backup (if existing data)
```bash
mkdir -p backups
mysqldump -h 127.0.0.1 -P 3306 -u u705828172_pklproject -p u705828172_pklproject > backups/backup_$(date +%Y%m%d_%H%M%S).sql
```

### Step 2: Run Migration Files in Order

Using mysql command line:
```bash
# Core tables
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/migrations/001_core_tables.sql

# Inventory tables
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/migrations/002_inventory_tables.sql

# Transactions tables
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/migrations/003_transactions_tables.sql

# CRM tables
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/migrations/004_crm_tables.sql

# HR tables
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/migrations/005_hr_tables.sql

# Integrations
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/migrations/006_integrations.sql
```

### Step 3: Verify Tables Created
```sql
SHOW TABLES;
```

Expected output:
```
+------------------------------+
| Tables_in_u705828172_pklproject |
+------------------------------+
| attendance                   |
| colors                       |
| customer_interactions        |
| customers                    |
| employees                    |
| expenses                     |
| locations                    |
| product_color_sizes          |
| product_colors               |
| products                     |
| sizes                        |
| stock_balances               |
| stock_movements              |
| transactions                 |
+------------------------------+
```

---

## Seeding Data

### Using Seed Script
```bash
cd database
./seed.sh
```

### Manual Seeding
```bash
# Master data (colors, sizes, locations)
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/seeds/001_master_data.sql

# Sample products
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/seeds/002_sample_products.sql

# Sample customers
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/seeds/003_sample_customers.sql

# Sample employees
MYSQL_PWD='PKLproject9' mysql -h 127.0.0.1 -P 3306 -u u705828172_pklproject u705828172_pklproject < database/seeds/004_sample_employees.sql
```

### Seed Data Summary

| Table | Records |
|-------|---------|
| colors | 15 |
| sizes | 9 |
| locations | 5 |
| products | 10 |
| product_colors | ~50 |
| product_color_sizes | ~250 |
| stock_balances | ~50 |
| customers | 10 |
| customer_interactions | ~20 |
| employees | 5 |
| attendance | ~50 |

---

## Verification

### Run Verification Script
```bash
cd database
./verify.sh
```

### Manual Verification Queries

#### Check Table Counts
```sql
SELECT
    TABLE_NAME,
    TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'u705828172_pklproject'
ORDER BY TABLE_NAME;
```

#### Check Views
```sql
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';
```

#### Check Foreign Keys
```sql
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'u705828172_pklproject'
    AND REFERENCED_TABLE_NAME IS NOT NULL;
```

---

## Rollback

### Using Rollback Script
```bash
cd database
./rollback.sh
```

**WARNING:** This will drop ALL tables and views. Only use this in development or after creating a backup.

### Manual Rollback
```sql
SET FOREIGN_KEY_CHECKS=0;

DROP VIEW IF EXISTS v_attendance_summary;
DROP VIEW IF EXISTS v_top_customers;
DROP VIEW IF EXISTS v_sales_summary;
DROP VIEW IF EXISTS v_low_stock_alert;
DROP VIEW IF EXISTS v_stock_levels;
DROP VIEW IF EXISTS v_product_variants;

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

SET FOREIGN_KEY_CHECKS=1;
```

---

## Troubleshooting

### Connection Issues

**Error:** `Access denied for user 'u705828172_pklproject'@'localhost'`

**Solutions:**
1. Verify credentials are correct
2. Check if database is on remote host (not localhost)
3. Grant privileges if needed:
```sql
GRANT ALL PRIVILEGES ON u705828172_pklproject.* TO 'u705828172_pklproject'@'%';
FLUSH PRIVILEGES;
```

### Foreign Key Errors

**Error:** `Cannot add foreign key constraint`

**Solutions:**
1. Ensure parent tables exist before child tables
2. Run migrations in order (001-006)
3. Check data types match between FK and referenced column

### Permission Issues

**Error:** `Permission denied` when running scripts

**Solution:**
```bash
chmod +x database/*.sh
```

### Script Not Found

**Error:** `bash: ./migrate.sh: No such file or directory`

**Solution:**
```bash
# Use absolute path or navigate to database directory first
cd /path/to/dashboard-bisnis-pkl/database
./migrate.sh
```

---

## Migration Checklist

- [ ] Database credentials verified
- [ ] Backup created (if existing data)
- [ ] All migration files present (001-006)
- [ ] All seed files present (001-004)
- [ ] Scripts are executable
- [ ] Migrations executed successfully
- [ ] Seeds executed successfully
- [ ] Views created
- [ ] Verification queries return expected results
- [ ] Application can connect to database

---

## Next Steps

After successful migration:

1. **Configure Application**: Update `.env` with database credentials
2. **Test API Endpoints**: Verify CRUD operations work
3. **Load Production Data**: If migrating from legacy system
4. **Set Up Backups**: Configure automated database backups
5. **Monitor Performance**: Review slow query log after initial usage
