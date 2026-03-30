# Database Migrations - Dashboard Bisnis PKL

This directory contains all database schema migrations and seed data.

## Structure

```
database/
├── migrations/          # Schema changes (chronological)
│   ├── 001_create_customers_table.sql
│   ├── 002_create_products_table.sql
│   ├── 003_create_sales_table.sql
│   ├── 004_create_sale_items_table.sql
│   ├── 005_create_revenue_table.sql
│   ├── 006_create_expenses_table.sql
│   ├── 007_create_stock_movements_table.sql
│   ├── 008_create_interactions_table.sql
│   ├── 009_create_employees_table.sql
│   └── 010_create_attendance_table.sql
│
└── seeds/               # Sample data for development
    ├── seed_customers.sql
    ├── seed_products.sql
    ├── seed_sales.sql
    ├── seed_revenue.sql
    ├── seed_expenses.sql
    ├── seed_stock_movements.sql
    ├── seed_interactions.sql
    ├── seed_employees.sql
    └── seed_attendance.sql
```

## Migrations

Migrations define the database schema changes. They should be run in chronological order.

### Running Migrations

```bash
# From server directory
npm run migrate
```

### Migration Naming Convention

```
###_description.sql

Example:
001_create_customers_table.sql
002_add_index_to_customers_email.sql
003_add_phone_to_customers.sql
```

## Seed Data

Seeds populate the database with sample/development data.

### Running Seeds

```bash
# From server directory
npm run seed
```

### Production Seeds

For production, only seed reference data (categories, statuses, etc.):

```bash
npm run seed:production
```

## Database Connection

```
Host: 127.0.0.1
Port: 3306
Database: u705828172_pklproject
Username: u705828172_pklproject
```

## Tables

See `../docs/DATABASE_SCHEMA.md` for complete table definitions.

### Module Mapping

| Module | Tables |
|--------|--------|
| CRM | customers, interactions |
| Inventory | products, stock_movements |
| Sales | sales, sale_items |
| Finance | revenue, expenses |
| HR | employees, attendance |

## Database Tasks

- [ ] Create all 10 migration files
- [ ] Create seed files for development
- [ ] Document foreign key relationships
- [ ] Add necessary indexes
- [ ] Test migrations on clean database
- [ ] Update DATABASE_SCHEMA.md with final schema

## Backup

Before running migrations on production:

```bash
# Backup database
mysqldump -u username -p database_name > backup_$(date +%Y%m%d).sql
```
