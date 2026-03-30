# Dummy Data Guide - Dashboard Bisnis PKL

## Overview

This guide explains the comprehensive dummy data created for all modules of the Dashboard Bisnis PKL system.

## How to Load Dummy Data

### Option 1: Quick Load (Recommended)
```bash
cd database
./seed-dummy.sh
```

### Option 2: Manual Load
```bash
cd database/seeds
mysql -h 127.0.0.1 -u u705828172_pklproject -p u705828172_pklproject < 001_master_data.sql
mysql -h 127.0.0.1 -u u705828172_pklproject -p u705828172_pklproject < 005_dummy_data_complete.sql
```

---

## Data Summary by Module

### 📦 Inventory Module

#### Products (15 items)
| Product | Code | Category | Price Range |
|---------|------|----------|-------------|
| Jersey Futsal Pro | JFP001 | Jersey | Rp 125.000 |
| Jersey Futsal Elite | JFE002 | Jersey | Rp 175.000 |
| Celana Futsal Pro | CFP003 | Celana | Rp 65.000 |
| Kaos Kaki Futsal | KKF004 | Aksesoris | Rp 25.000 |
| Sepatu Futsal Nike | SFN005 | Sepatu | Rp 550.000 |
| Sepatu Futsal Adidas | SFA006 | Sepatu | Rp 500.000 |
| Sarung Tangan Kiper | STK007 | Aksesoris | Rp 120.000 |
| Jaket Training | JT008 | Jaket | Rp 225.000 |
| Jersey Retro 90s | JR909 | Jersey | Rp 150.000 |
| Tas Sport Bag | TSB010 | Aksesoris | Rp 185.000 |
| Headband Sport | HBS011 | Aksesoris | Rp 35.000 |
| Gelang Tangan Sport | GTS012 | Aksesoris | Rp 25.000 |
| Bola Futsal Standard | BFS013 | Bola | Rp 135.000 |
| Bola Futsal Premium | BFP014 | Bola | Rp 225.000 |
| Kaos Tim Custom | KTC015 | Jersey | Rp 95.000 |

#### Product Variants
- **Colors**: 15 colors available (Merah, Hitam, Biru, Kuning, Putih, Pink, Hijau, Navy, Orange, Ungu, Abu, Coklat, Maroon, Tosca, Turquoise)
- **Sizes**:
  - Jerseys/Jackets: S, M, L, XL
  - Shoes: 39, 40, 41, 42, 43, 44
  - Accessories: One Size / All

#### Stock Status
- **Total SKUs**: ~200+ variants
- **Low Stock Items**: Some variants have stock below 10 units (trigger low stock alerts)
- **Total Stock**: ~4,000+ units across all locations

---

### 👥 CRM Module

#### Customer Types

**Corporate Customers (6)**
| Code | Company | City | Total Spent |
|------|---------|------|-------------|
| CPT001 | PT. Maju Bersama Sport | Jakarta | Rp 89.5M |
| CPT002 | CV. Champion Futsal | Surabaya | Rp 54.2M |
| CPT003 | PT. Sportindo Pratama | Bandung | Rp 47.8M |
| CPT004 | UD. Futsal Jaya | Yogyakarta | Rp 23.5M |
| CPT005 | PT. Gol Indonesia | Semarang | Rp 38.5M |
| CPT006 | CV. Victory Sport (inactive) | Medan | Rp 12.5M |

**Individual Customers (9)**
| Code | Name | City | Total Spent |
|------|------|------|-------------|
| CIN001 | Ahmad Fauzi | Jakarta | Rp 8.4M |
| CIN002 | Budi Santoso | Surabaya | Rp 5.6M |
| CIN003 | Dedi Prasetyo | Bandung | Rp 4.2M |
| CIN004 | Eko Prasetyo | Yogyakarta | Rp 7.8M |
| CIN005 | Feri Irawan | Semarang | Rp 3.2M |
| CIN006 | Gilang Ramadhan | Medan | Rp 4.9M |
| CIN007 | Hendra Wijaya | Jakarta | Rp 6.3M |
| CIN008 | Irfan Hermawan | Surabaya | Rp 2.1M |
| CIN009 | Joko Susilo (inactive) | Bandung | Rp 1.8M |

**Reseller Customers (5)**
| Code | Company | City | Total Spent |
|------|---------|------|-------------|
| CRES001 | Toko Sport Barokah | Malang | Rp 125M |
| CRES002 | Futsal Store Indonesia | Jakarta | Rp 168M |
| CRES003 | Galeri Sport Premium | Jakarta | Rp 98M |
| CRES004 | Toko Juara Sport | Solo | Rp 72M |
| CRES005 | Sport Station Mall | Jakarta | Rp 145M |

#### Customer Interactions (20 records)
- Types: VISIT, CALL, EMAIL, WHATSAPP
- Outcomes: POSITIVE, PENDING, COMPLETED, RESOLVED

---

### 💼 HR Module

#### Employees (12 across 5 departments)

**Management (2)**
- Rudi Hartono - Owner
- Siti Aminah - Store Manager

**Sales (3)**
- Fajar Nugraha - Sales Supervisor
- Doni Kurniawan - Sales Staff
- Eka Pratiwi - Sales Staff

**Warehouse (3)**
- I Made Suasta - Warehouse Supervisor
- Gunawan - Warehouse Staff
- Hesti Lestari - Warehouse Staff

**Finance (2)**
- Krisna Aditya - Finance Manager
- Jihan Puspita - Accounting Staff

**Marketing (2)**
- Lina Marlina - Marketing Staff
- Mahendra Putra - Social Media Specialist

#### Attendance Records (January 2025)
- **Total Records**: 700+ entries
- **Working Days**: Monday-Saturday (24 days in January)
- **Status Types**:
  - PRESENT: Normal attendance
  - LATE: Clock in after 8:00 AM
  - ABSENT: Excused absences (sick leave, personal leave)
- **Daily Hours**: 9 hours (8:00 AM - 5:00 PM)

---

### 💰 Sales Module

#### Sales Transactions (30 records - January 2025)

**Weekly Sales Summary**
| Week | Transactions | Total Revenue |
|------|--------------|---------------|
| Week 1 (Jan 2-4) | 4 | Rp 37.2M |
| Week 2 (Jan 6-11) | 6 | Rp 53.5M |
| Week 3 (Jan 13-18) | 6 | Rp 67.8M |
| Week 4 (Jan 20-25) | 6 | Rp 72.7M |
| Week 5 (Jan 27-31) | 6 | Rp 92.3M |

**Payment Methods**
- CASH: ~25%
- TRANSFER: ~60%
- EWALLET: ~10%
- QRIS: ~5%

**Top Selling Products**
1. Sepatu Futsal Nike - 50+ units
2. Jersey Futsal Pro - 150+ units
3. Sepatu Futsal Adidas - 45+ units

---

### 💵 Finance Module

#### Expense Transactions (12 records - January 2025)

| Date | Description | Amount |
|------|-------------|--------|
| Jan 1 | Pembelian stok dari supplier | Rp 45.0M |
| Jan 5 | Gaji karyawan Desember | Rp 8.5M |
| Jan 8 | Listrik dan air | Rp 2.5M |
| Jan 10 | Bahan kantor & ATK | Rp 1.2M |
| Jan 12 | Sewa tempat | Rp 3.5M |
| Jan 15 | Biaya pengiriman | Rp 1.8M |
| Jan 18 | Iklan Instagram & Facebook | Rp 2.5M |
| Jan 20 | Perawatan AC | Rp 0.85M |
| Jan 22 | Internet & telepon | Rp 1.5M |
| Jan 25 | Biaya operasional lain-lain | Rp 3.2M |
| Jan 28 | Gaji karyawan January | Rp 8.5M |
| Jan 30 | Pembelian stok tambahan | Rp 28.0M |

**Total Expenses January 2025**: Rp 106.05M
**Total Revenue January 2025**: Rp 323.5M
**Net Profit**: Rp 217.45M

---

## API Endpoints to Test

After loading the dummy data, test these endpoints:

```bash
# Health check
curl http://localhost:3001/health

# Dashboard overview
curl http://localhost:3001/api/dashboard/overview

# Products
curl http://localhost:3001/api/products
curl http://localhost:3001/api/products/1

# Inventory
curl http://localhost:3001/api/inventory/stock
curl http://localhost:3001/api/inventory/stock?low_stock=true
curl http://localhost:3001/api/inventory/movements?limit=20

# Sales
curl http://localhost:3001/api/transactions?limit=10
curl http://localhost:3001/api/transactions/stats/summary?start_date=2025-01-01

# CRM
curl http://localhost:3001/api/customers
curl http://localhost:3001/api/customers/stats/summary

# HR
curl http://localhost:3001/api/employees
curl http://localhost:3001/api/employees/attendance/summary?month=2025-01

# Dashboard
curl http://localhost:3001/api/dashboard/sales-trend?period=daily&limit=30
curl http://localhost:3001/api/dashboard/top-products?limit=10
curl http://localhost:3001/api/dashboard/recent-activities?limit=20
```

---

## Pages That Will Display Data

### Home Dashboard (`/`)
- Quick stats from all modules
- Recent activities feed

### Inventory (`/inventory`)
- Stock levels by location
- Low stock alerts
- Recent stock movements

### Sales (`/sales`)
- Sales trend chart
- Payment method breakdown
- Recent transactions

### CRM (`/crm`)
- Customer statistics
- Customer list with search/filter
- Top customers by spending

### HR (`/hr`)
- Attendance summary by month
- Employee directory
- Department breakdown

### Finance (`/finance`)
- Revenue vs Expenses chart
- Profit & Loss summary
- Recent expenses

---

## Resetting Data

To reset all data and start fresh:

```bash
cd database
./rollback.sh
./migrate.sh
./seed-dummy.sh
```

---

## Troubleshooting

### Issue: Database connection failed
**Solution**: Check your database credentials in the `.env` file or connection settings.

### Issue: Foreign key errors
**Solution**: Make sure to run migrations first before seeding data.

### Issue: Data not showing in frontend
**Solution**:
1. Ensure backend server is running: `cd server && npm start`
2. Check API endpoint is accessible
3. Check browser console for errors

---

## Notes

- All dates are in January 2025 for consistency
- Currency is in Indonesian Rupiah (IDR)
- Locations are in major Indonesian cities
- Employee attendance follows Indonesian work week (Mon-Sat)
- Customer types reflect different business segments
