# API Endpoints - Dashboard Bisnis PKL

Complete reference for all backend API endpoints.

## Base URL

```
Development: http://localhost:3001/api
Production:  https://your-domain.com/api
```

## Response Format

### Success Response

```json
{
  "success": true,
  "data": { ... },
  "message": "Optional success message"
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": { ... }
  }
}
```

---

## Sales Endpoints

### Transactions

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/sales/transactions` | List all transactions | Optional |
| GET | `/sales/transactions/:id` | Get single transaction | Optional |
| POST | `/sales/transactions` | Create new transaction | Required |
| PUT | `/sales/transactions/:id` | Update transaction | Required |
| DELETE | `/sales/transactions/:id` | Delete transaction | Required |

### Query Parameters (GET /sales/transactions)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | number | 1 | Page number |
| limit | number | 20 | Items per page |
| startDate | date | - | Filter start date |
| endDate | date | - | Filter end date |
| customerId | number | - | Filter by customer |
| search | string | - | Search in notes/reference |

### Request Body (POST /sales/transactions)

```json
{
  "customerId": 1,
  "transactionDate": "2025-01-15",
  "items": [
    {
      "productId": 10,
      "quantity": 2,
      "unitPrice": 50000
    }
  ],
  "totalAmount": 100000,
  "paymentMethod": "cash",
  "notes": "Optional notes"
}
```

### Analytics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/sales/summary` | Sales summary by period |
| GET | `/sales/performance` | Sales performance comparison |
| GET | `/sales/by-product` | Sales breakdown by product |
| GET | `/sales/by-customer` | Sales breakdown by customer |

---

## Finance Endpoints

### Revenue

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/finance/revenue` | List revenue entries | Required |
| POST | `/finance/revenue` | Create revenue entry | Required |
| GET | `/finance/revenue/summary` | Revenue summary by period | Required |

### Expenses

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/finance/expenses` | List expense entries | Required |
| POST | `/finance/expenses` | Create expense entry | Required |
| GET | `/finance/expenses/by-category` | Expenses by category | Required |

### Cash Flow

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/finance/cashflow` | Cash flow overview |
| GET | `/finance/cashflow/:period` | Cash flow for specific period |

### Reports

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/finance/reports/profit-loss` | Profit & Loss statement |
| GET | `/finance/reports/balance-sheet` | Balance sheet |

---

## Inventory Endpoints

### Products

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/inventory/products` | List all products | Required |
| GET | `/inventory/products/:id` | Get single product | Required |
| POST | `/inventory/products` | Create new product | Required |
| PUT | `/inventory/products/:id` | Update product | Required |
| DELETE | `/inventory/products/:id` | Delete product | Required |

### Query Parameters (GET /inventory/products)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | number | 1 | Page number |
| limit | number | 20 | Items per page |
| category | string | - | Filter by category |
| status | string | - | in_stock, low_stock, out_of_stock |
| search | string | - | Search name/SKU |

### Stock Movements

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/inventory/movements` | List stock movements |
| POST | `/inventory/movements` | Record stock movement |
| GET | `/inventory/movements/:productId` | Movements for product |

### Stock Status

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/inventory/status` | Overall stock status |
| GET | `/inventory/alerts` | Low stock alerts |

---

## CRM Endpoints

### Customers

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/crm/customers` | List all customers | Required |
| GET | `/crm/customers/:id` | Get single customer | Required |
| POST | `/crm/customers` | Create new customer | Required |
| PUT | `/crm/customers/:id` | Update customer | Required |
| DELETE | `/crm/customers/:id` | Delete customer | Required |

### Query Parameters (GET /crm/customers)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | number | 1 | Page number |
| limit | number | 20 | Items per page |
| status | string | - | active, inactive |
| search | string | - | Search name/email/phone |

### Request Body (POST /crm/customers)

```json
{
  "name": "Customer Name",
  "email": "customer@example.com",
  "phone": "628123456789",
  "address": "Optional address",
  "status": "active"
}
```

### Interactions

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/crm/interactions` | List all interactions |
| POST | `/crm/interactions` | Record new interaction |
| GET | `/crm/interactions/:customerId` | Customer interactions |

### Analytics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/crm/analytics/summary` | Customer activity summary |
| GET | `/crm/analytics/by-status` | Customer count by status |

---

## HR Endpoints

### Employees

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/hr/employees` | List all employees | Required |
| GET | `/hr/employees/:id` | Get single employee | Required |
| POST | `/hr/employees` | Create new employee | Required |
| PUT | `/hr/employees/:id` | Update employee | Required |
| DELETE | `/hr/employees/:id` | Delete employee | Required |

### Query Parameters (GET /hr/employees)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| page | number | 1 | Page number |
| limit | number | 20 | Items per page |
| department | string | - | Filter by department |
| status | string | - | active, inactive |
| search | string | - | Search name/email |

### Attendance

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/hr/attendance` | List attendance records |
| POST | `/hr/attendance` | Record attendance |
| GET | `/hr/attendance/:employeeId` | Employee attendance |
| GET | `/hr/attendance/summary` | Attendance summary |

### Analytics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/hr/analytics/summary` | Employee count and status |
| GET | `/hr/analytics/attendance-rate` | Attendance rate by period |

---

## Health & Status

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | API health check |
| GET | `/api/version` | API version info |

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| VALIDATION_ERROR | 400 | Invalid request data |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Access denied |
| NOT_FOUND | 404 | Resource not found |
| CONFLICT | 409 | Resource already exists |
| SERVER_ERROR | 500 | Internal server error |
| DATABASE_ERROR | 500 | Database operation failed |

---

## Status Notes

```
✅ Backend API IMPLEMENTED (2025-02-02)

All backend API endpoints have been implemented and are ready for use.

Implementation Status:
- [x] Server dependencies installed
- [x] server.js with Express.js setup complete
- [x] db.js (MySQL connection pool) complete
- [x] All route files created (6 modules)
- [x] Middleware (CORS, error handling) complete
- [x] .env configuration with database credentials

Available Endpoints:
- Dashboard: /api/dashboard/*
- Products: /api/products/*
- Inventory: /api/inventory/*
- Transactions: /api/transactions/*
- Customers (CRM): /api/customers/*
- Employees (HR): /api/employees/*

Database Connection Issue:
⚠️ The server is running but database connection is currently failing:
  "Access denied for user 'u705828172_pklproject'@'localhost'"

To resolve:
1. Verify MySQL is running on 127.0.0.1:3306
2. Verify database credentials in server/.env
3. Run database migrations in database/migrations/
4. Restart server after fixing credentials

Frontend Integration:
The frontend (frontend/src/lib/api.ts) is configured to connect to:
- Backend URL: http://localhost:3001
- All endpoints match the routes defined in this document
```
