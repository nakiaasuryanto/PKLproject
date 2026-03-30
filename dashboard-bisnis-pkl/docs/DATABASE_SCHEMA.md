# Database Schema Documentation

**Project:** Dashboard Bisnis Terintegrasi PKL
**Version:** 1.0
**Date:** 2025-02-01
**Author:** Nakia Suryanto

---

## Table of Contents

1. [Overview](#overview)
2. [Schema Diagram](#schema-diagram)
3. [Module 1: Inventory](#module-1-inventory)
4. [Module 2: Sales & Finance](#module-2-sales--finance)
5. [Module 3: CRM](#module-3-crm)
6. [Module 4: HR](#module-4-hr)
7. [Views](#views)
8. [Indexes](#indexes)
9. [Business Rules](#business-rules)

---

## Overview

The database uses a modular architecture supporting:
- **Inventory Management** (Products, Variants, Stock)
- **Sales & Finance** (Transactions, Expenses)
- **CRM** (Customers, Interactions)
- **HR** (Employees, Attendance)

**Database Charset:** `utf8mb4` with `utf8mb4_unicode_ci` collation
**Engine:** `InnoDB` for ACID compliance

---

## Schema Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          INVENTORY MODULE                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────┐     ┌──────────┐     ┌──────────────────┐     ┌──────────┐  │
│  │ colors   │────▶│ product_ │────▶│ product_color_   │────▶│   stock_ │  │
│  └──────────┘     │  colors  │     │     sizes        │     │ balances │  │
│                   └─────┬────┘     └──────────────────┘     └─────┬────┘  │
│                         │                                        │        │
│                   ┌─────▼────┐                                  │        │
│                   │ products │                                  │        │
│                   └──────────┘                                  │        │
│                   ┌──────────┐     ┌──────────────┐            │        │
│                   │  sizes   │────▶│ stock_       │◀───────────┘        │
│                   └──────────┘     │ movements    │                         │
│                   ┌──────────┐     └──────────────┘                         │
│                   │locations │────────────────────────────────────────┐    │
│                   └──────────┘                                         │    │
└────────────────────────────────────────────────────────────────────────┼────┘
                                                                         │
┌────────────────────────────────────────────────────────────────────────┼────┐
│                        SALES & FINANCE MODULE                          │    │
├────────────────────────────────────────────────────────────────────────┼────┤
│                                                                         │    │
│  ┌────────────────┐         ┌────────────────┐                         │    │
│  │ transactions   │────────▶│   customers    │◄────────────────────────┘    │
│  └────────────────┘         └────────────────┘                              │
│  ┌────────────────┐                                                       │
│  │   expenses     │                                                       │
│  └────────────────┘                                                       │
└────────────────────────────────────────────────────────────────────────────┘
                                         │
┌────────────────────────────────────────────────────────────────────────────┐
│                             CRM MODULE                                     │
├────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────┐                                                 │
│  │ customer_            │                                                 │
│  │ interactions   │─────────────────────────────────────────────────────  │
│  └──────────────────────┘                                                 │
└────────────────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────────────────┐
│                              HR MODULE                                     │
├────────────────────────────────────────────────────────────────────────────┤
│  ┌──────────┐         ┌────────────┐                                     │
│  │employees │────────▶│ attendance │                                     │
│  └──────────┘         └────────────┘                                     │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Module 1: Inventory

### Core Tables

#### `products`
Master product catalog.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| name | VARCHAR(100) | NOT NULL | Product name |
| code | VARCHAR(50) | UNIQUE | Product code |
| category | VARCHAR(50) | | Product category |
| description | TEXT | | Product description |
| base_price | DECIMAL(15,2) | NOT NULL DEFAULT 0 | Base production cost |
| retail_price | DECIMAL(15,2) | | Selling price |
| status | ENUM | DEFAULT 'active' | active, inactive |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Indexes:** `code`, `category`, `status`

#### `colors`
Available colors for variants.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| name | VARCHAR(50) | UNIQUE, NOT NULL | Color name |
| hex_code | VARCHAR(7) | | Hex color code |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

#### `sizes`
Available sizes for variants.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| name | VARCHAR(20) | UNIQUE, NOT NULL | Size name |
| sort_order | INT | DEFAULT 0 | Display order |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Indexes:** `sort_order`

#### `locations`
Storage and display locations.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| name | VARCHAR(50) | UNIQUE, NOT NULL | Location name |
| type | ENUM | DEFAULT 'storage' | display, storage, warehouse |
| description | TEXT | | Location description |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

### Variant Hierarchy

#### `product_colors`
Product-color combinations.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| product_id | INT | FK → products(id) | Product reference |
| color_id | INT | FK → colors(id) | Color reference |
| additional_price | DECIMAL(15,2) | DEFAULT 0 | Extra cost for this color |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Foreign Keys:**
- `product_id`: CASCADE delete
- `color_id`: RESTRICT delete

**Unique:** `(product_id, color_id)`

#### `product_color_sizes`
SKU-level variants (product-color-size).

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| product_color_id | INT | FK → product_colors(id) | Product-color reference |
| size_id | INT | FK → sizes(id) | Size reference |
| sku | VARCHAR(100) | UNIQUE | Stock Keeping Unit |
| additional_price | DECIMAL(15,2) | DEFAULT 0 | Extra cost for this size |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Foreign Keys:**
- `product_color_id`: CASCADE delete
- `size_id`: RESTRICT delete

**Unique:** `(product_color_id, size_id)`

### Stock Management

#### `stock_balances`
Current stock levels per variant per location.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| product_color_size_id | INT | FK → product_color_sizes(id) | Variant reference |
| location_id | INT | FK → locations(id) | Location reference |
| quantity | INT | DEFAULT 0 | Current stock quantity |
| moving_avg_cost | DECIMAL(15,2) | DEFAULT 0 | Moving average cost |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Unique:** `(product_color_size_id, location_id)`

#### `stock_movements`
Historical stock movements.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| product_color_size_id | INT | FK → product_color_sizes(id) | Variant reference |
| location_id | INT | FK → locations(id) | Location reference |
| movement_type | ENUM | NOT NULL | IN, OUT |
| quantity | INT | NOT NULL | Quantity moved |
| reason_code | VARCHAR(50) | NOT NULL | Movement reason |
| reference_type | VARCHAR(50) | | Reference type |
| reference_id | INT | | Reference ID |
| notes | TEXT | | Additional notes |
| movement_date | DATETIME | NOT NULL | Movement date |
| created_by | VARCHAR(100) | | Creator |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Reason Codes:** `SALES_OUT`, `GIFT_OUT`, `ADJUSTMENT_IN`, `ADJUSTMENT_OUT`, `TRANSFER_IN`, `TRANSFER_OUT`, `PRODUCTION_IN`, `RETURN_IN`

---

## Module 2: Sales & Finance

#### `customers`
Customer master data (also used by CRM module).

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| customer_code | VARCHAR(20) | UNIQUE, NOT NULL | Customer code |
| name | VARCHAR(100) | NOT NULL | Customer name |
| company_name | VARCHAR(100) | | Company name |
| email | VARCHAR(100) | | Email address |
| phone | VARCHAR(20) | | Phone number |
| address | TEXT | | Address |
| city | VARCHAR(50) | | City |
| province | VARCHAR(50) | | Province |
| postal_code | VARCHAR(10) | | Postal code |
| customer_type | ENUM | DEFAULT 'INDIVIDUAL' | INDIVIDUAL, COMPANY, RESELLER |
| status | ENUM | DEFAULT 'active' | active, inactive |
| first_purchase_date | DATE | | First purchase date |
| last_purchase_date | DATE | | Last purchase date |
| total_purchases | INT | DEFAULT 0 | Total purchase count |
| total_spent | DECIMAL(15,2) | DEFAULT 0 | Total amount spent |
| notes | TEXT | | Additional notes |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Indexes:** `status`, `customer_code`, `email`, `phone`, `city`, `customer_type`

#### `transactions`
Sales and gift transactions.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| transaction_type | ENUM | NOT NULL | SALE, EXPENSE, GIFT |
| transaction_date | DATE | NOT NULL | Transaction date |
| transaction_time | TIME | | Transaction time |
| customer_id | INT | FK → customers(id) | Customer reference |
| total_amount | DECIMAL(15,2) | DEFAULT 0 | Total amount |
| payment_method | ENUM | DEFAULT 'CASH' | CASH, BANK_TRANSFER, OTHER |
| payment_status | ENUM | DEFAULT 'PAID' | PENDING, PAID, CANCELLED |
| pic | VARCHAR(100) | | Person in charge |
| notes | TEXT | | Additional notes |
| items | JSON | | Transaction items |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**JSON Structure for items:**
```json
[
  {
    "product_id": 1,
    "color_id": 2,
    "size_id": 3,
    "quantity": 5,
    "price": 125000,
    "free": 0
  }
]
```

**Indexes:** `transaction_type`, `transaction_date`, `customer_id`, `pic`, `payment_status`, `(transaction_date, transaction_type)`

#### `expenses`
Business expense records.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| category | VARCHAR(50) | NOT NULL | Expense category |
| description | TEXT | | Description |
| amount | DECIMAL(15,2) | NOT NULL | Expense amount |
| expense_date | DATE | NOT NULL | Expense date |
| payment_method | ENUM | DEFAULT 'CASH' | CASH, BANK_TRANSFER, OTHER |
| pic | VARCHAR(100) | | Person in charge |
| receipt_number | VARCHAR(50) | | Receipt number |
| notes | TEXT | | Additional notes |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Categories:** `MATERIALS`, `UTILITIES`, `SALARY`, `MARKETING`, `TRANSPORTATION`, `OTHER`

**Indexes:** `category`, `expense_date`, `pic`, `(category, expense_date)`

---

## Module 3: CRM

#### `customer_interactions`
Customer communication and interaction history.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| customer_id | INT | FK → customers(id) | Customer reference |
| interaction_type | ENUM | NOT NULL | Interaction type |
| subject | VARCHAR(200) | | Subject |
| description | TEXT | | Description |
| interaction_date | DATETIME | NOT NULL | Interaction date |
| pic | VARCHAR(100) | | Person in charge |
| follow_up_required | BOOLEAN | DEFAULT FALSE | Follow-up needed |
| follow_up_date | DATE | | Follow-up date |
| status | ENUM | DEFAULT 'PENDING' | PENDING, COMPLETED, CANCELLED |
| outcome | VARCHAR(50) | | Outcome |
| notes | TEXT | | Additional notes |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Interaction Types:** `CALL`, `EMAIL`, `MEETING`, `WHATSAPP`, `VISIT`, `COMPLAINT`, `INQUIRY`, `ORDER`, `FOLLOW_UP`, `OTHER`

**Indexes:** `customer_id`, `interaction_date`, `interaction_type`, `status`, `(follow_up_required, follow_up_date)`

---

## Module 4: HR

#### `employees`
Employee master data.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| employee_code | VARCHAR(20) | UNIQUE, NOT NULL | Employee code |
| name | VARCHAR(100) | NOT NULL | Employee name |
| email | VARCHAR(100) | | Email address |
| phone | VARCHAR(20) | | Phone number |
| position | VARCHAR(50) | | Position |
| department | VARCHAR(50) | | Department |
| hire_date | DATE | NOT NULL | Hire date |
| resignation_date | DATE | | Resignation date |
| status | ENUM | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, RESIGNED |
| salary | DECIMAL(15,2) | | Monthly salary |
| address | TEXT | | Address |
| city | VARCHAR(50) | | City |
| emergency_contact | VARCHAR(100) | | Emergency contact |
| emergency_phone | VARCHAR(20) | | Emergency phone |
| notes | TEXT | | Additional notes |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Departments:** `SALES`, `PRODUCTION`, `DESIGN`, `ADMIN`, `MANAGEMENT`

**Indexes:** `status`, `employee_code`, `department`, `position`

#### `attendance`
Employee attendance records.

| Column | Type | Attributes | Description |
|--------|------|------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| employee_id | INT | FK → employees(id) | Employee reference |
| attendance_date | DATE | NOT NULL | Attendance date |
| check_in | TIME | | Check-in time |
| check_out | TIME | | Check-out time |
| status | ENUM | NOT NULL | Attendance status |
| work_hours | DECIMAL(4,2) | | Total work hours |
| overtime_hours | DECIMAL(4,2) | DEFAULT 0 | Overtime hours |
| notes | TEXT | | Additional notes |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE | Last update |

**Status Values:** `PRESENT`, `ABSENT`, `LATE`, `HALF_DAY`, `SICK`, `LEAVE`, `HOLIDAY`

**Unique:** `(employee_id, attendance_date)`

**Indexes:** `employee_id`, `attendance_date`, `status`, `(employee_id, attendance_date, status)`

---

## Views

### `v_product_variants`
Product variants with full details including prices.

**Columns:** variant_id, sku, product_id, product_name, product_code, category, color, color_hex, size, final_price, product_status

### `v_stock_levels`
Current stock levels with product details (only items with quantity > 0).

**Columns:** variant_id, sku, product_name, color, size, location, location_type, quantity, moving_avg_cost, final_price

### `v_low_stock_alert`
Products with stock below 10 units.

**Columns:** product_name, color, size, location, quantity

### `v_sales_summary`
Monthly sales summary.

**Columns:** period (YYYY-MM), total_transactions, revenue, avg_transaction_value

### `v_top_customers`
Customers sorted by total spending.

**Columns:** customer_code, name, company_name, customer_type, city, total_purchases, total_spent, last_purchase_date

### `v_attendance_summary`
Employee attendance summary.

**Columns:** employee_code, name, department, position, total_days, present_days, late_days, absent_days, leave_days, total_work_hours, total_overtime_hours

---

## Indexes

### Single Column Indexes
- Products: code, category, status
- Colors: name
- Sizes: sort_order
- Customers: status, customer_code, email, phone, city, customer_type
- Employees: status, employee_code, department, position
- Attendance: employee_id, attendance_date, status

### Composite Indexes
- Transactions: (transaction_date, transaction_type)
- Stock Movements: (movement_date, location_id)
- Customers: (customer_type, total_spent)
- Expenses: (category, expense_date)
- Attendance: (employee_id, attendance_date, status)
- Customer Interactions: (follow_up_required, follow_up_date, status)

---

## Business Rules

### Inventory
1. SKU must be unique across all variants
2. Stock cannot go negative (application level)
3. Moving average cost updates on each stock IN

### Sales
1. Total amount = sum(items.price × items.quantity)
2. Customer stats update on SALE transactions

### CRM
1. Customer interactions cascade delete with customer
2. Follow-up required = TRUE needs follow_up_date

### HR
1. One attendance record per employee per day
2. Overtime hours = work_hours - 8 (when work_hours > 8)

---

## Schema Status

```
Database Schema Status:

Tables Created: 14
- products: ✅ Complete
- colors: ✅ Complete
- sizes: ✅ Complete
- locations: ✅ Complete
- product_colors: ✅ Complete
- product_color_sizes: ✅ Complete
- stock_balances: ✅ Complete
- stock_movements: ✅ Complete
- customers: ✅ Complete
- transactions: ✅ Complete
- expenses: ✅ Complete
- customer_interactions: ✅ Complete
- employees: ✅ Complete
- attendance: ✅ Complete

Views Created: 6
- v_product_variants: ✅ Complete
- v_stock_levels: ✅ Complete
- v_low_stock_alert: ✅ Complete
- v_sales_summary: ✅ Complete
- v_top_customers: ✅ Complete
- v_attendance_summary: ✅ Complete

Migrations: ✅ Complete (6 files)
Seeds: ✅ Complete (4 files)
```
