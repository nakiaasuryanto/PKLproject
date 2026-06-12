# Dashboard Bisnis PKL

Sistem dashboard bisnis terintegrasi untuk mengelola operasional bisnis. Menggabungkan Sales, Inventory, Finance, CRM, dan HR dalam satu platform.

---

## Fitur Utama

### Sistem Login & Role-Based Access
- **5 Role:** Admin, IT, Customer Service, Operations, Finance
- Setiap role punya akses modul berbeda
- Admin & IT bisa lihat semua data summary
- Role lain hanya akses modul yang relevan

| Role | Akses Modul |
|------|-------------|
| Admin | Semua modul + summary |
| IT | Semua modul + summary |
| Customer Service | Dashboard, CRM, Sales, Inventory |
| Operations | Dashboard, Inventory, Sales |
| Finance | Dashboard, Finance, Sales |

### Penjualan & Invoice
- Buat invoice dengan pilih customer dan produk
- **Integrasi otomatis dengan inventory** - stok berkurang saat transaksi
- Metode pembayaran: Cash, Bank Transfer, Lainnya (E-Wallet/QRIS)
- Status pembayaran: Pending, Paid, Cancelled
- Tracking transaksi real-time

### Inventory Management
- Tracking stok per lokasi gudang
- Alert stok rendah (< 10 unit)
- Pergerakan stok (IN/OUT) dengan reason code
- Import data via CSV
- Integrasi dengan penjualan (auto reduce)

### Keuangan
- Dashboard pendapatan vs pengeluaran
- Laporan laba rugi
- Breakdown pembayaran per metode
- Chart trend bulanan
- Format mata uang Indonesia (Rp 1.000.000)

### CRM (Customer Relationship Management)
- Database customer (Perusahaan, Individual, Reseller)
- Tracking total pembelian per customer
- Riwayat interaksi customer
- Status aktif/tidak aktif

### HR & Kehadiran
- Database karyawan dengan department
- **Sistem Check-in/Check-out** real-time
- Tracking jam kerja & kehadiran
- Ringkasan kehadiran bulanan

---

## Cara Jalanin (Local Development)

```bash
# 1. Clone repo
git clone https://github.com/nakiaasuryanto/PKLproject.git
cd PKLproject

# 2. Install backend
cd server
npm install
cp .env.example .env
# Edit .env sesuai database lokal kamu

# 3. Setup database (auto-migration)
npm run migrate

# 4. Jalanin backend (terminal 1)
npm run dev
# Backend jalan di http://localhost:3001

# 5. Install & jalanin frontend (terminal 2)
cd ../dashboard-bisnis-pkl/frontend
npm install
npm run dev
# Frontend jalan di http://localhost:4321
```

---

## Struktur Folder

```
PKLproject/
├── server/                          # Backend API (Express + Node.js)
│   ├── routes/                      # API endpoints
│   ├── migrations/                  # SQL migration files
│   ├── db.js                        # Database connection
│   ├── migrate.js                   # Auto-migration script
│   ├── server.js                    # Express app
│   ├── railway.json                 # Railway deploy config
│   └── package.json
│
├── dashboard-bisnis-pkl/
│   ├── frontend/                    # Frontend (Astro + TailwindCSS)
│   │   ├── src/
│   │   │   ├── pages/               # Halaman (index, sales, inventory, dll)
│   │   │   ├── components/          # Komponen UI
│   │   │   ├── layouts/             # Layout templates
│   │   │   └── lib/                 # API client & utilities
│   │   ├── railway.json             # Railway deploy config
│   │   └── package.json
│   │
│   └── database/                    # SQL files (backup)
│       ├── migrations/
│       └── seeds/
│
├── DEPLOYMENT_GUIDE.md              # Panduan deploy ke Railway
└── README.md
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Astro, TailwindCSS, Chart.js, TypeScript |
| **Backend** | Node.js, Express |
| **Database** | MySQL |
| **Deployment** | Railway |

---

## API Endpoints

```
Base URL: http://localhost:3001 (dev) atau https://xxx.railway.app (prod)

Auth:
POST /api/auth/login          - Login user
POST /api/auth/logout         - Logout user

Dashboard:
GET  /api/dashboard/overview  - Stats semua modul
GET  /api/dashboard/sales-trend - Trend penjualan
GET  /api/dashboard/payment-methods - Breakdown metode pembayaran

Transactions:
GET  /api/transactions        - List transaksi
POST /api/transactions/create - Buat transaksi (dengan integrasi stok)
GET  /api/transactions/stats/summary - Statistik transaksi

Inventory:
GET  /api/inventory/stock     - Cek stok
POST /api/inventory/movements - Pergerakan stok
GET  /api/inventory/locations - List lokasi gudang

Products:
GET  /api/products            - List produk
POST /api/products            - Tambah produk

Customers:
GET  /api/customers           - List customer
POST /api/customers           - Tambah customer
GET  /api/customers/stats/summary - Statistik CRM

Employees:
GET  /api/employees           - List karyawan
POST /api/employees/attendance/check-in  - Check-in
POST /api/employees/attendance/check-out - Check-out
GET  /api/employees/attendance/today     - Status kehadiran hari ini
```

---

## Database

**14 Tabel + 6 Views:**

| Tabel | Deskripsi |
|-------|-----------|
| `products` | Data produk |
| `colors`, `sizes` | Varian warna & ukuran |
| `product_colors`, `product_color_sizes` | Kombinasi varian (SKU) |
| `stock_balances`, `stock_movements` | Stok & riwayat |
| `transactions`, `expenses` | Transaksi & pengeluaran |
| `customers`, `customer_interactions` | Data pelanggan & interaksi |
| `employees`, `attendance` | Data karyawan & absensi |

**Views:** `v_product_variants`, `v_stock_levels`, `v_low_stock_alert`, `v_sales_summary`, `v_top_customers`, `v_attendance_summary`

---

## Halaman

| Halaman | Route | Deskripsi |
|---------|-------|-----------|
| Dashboard | `/` | Overview + stats |
| Penjualan | `/sales` | Transaksi penjualan |
| Inventory | `/inventory` | Manajemen stok |
| Keuangan | `/finance` | Pendapatan & pengeluaran |
| CRM | `/crm` | Customer management |
| HR | `/hr` | Karyawan & absensi |

---

## Deploy ke Railway

Semua service (Frontend, Backend, Database) di-deploy ke Railway.

```
┌─────────────────────────────────────────────────────────────┐
│                      Railway Project                         │
├─────────────────────────────────────────────────────────────┤
│   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   │
│   │   Frontend   │──▶│   Backend    │──▶│    MySQL     │   │
│   │    (Astro)   │   │  (Express)   │   │   Database   │   │
│   └──────────────┘   └──────────────┘   └──────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Quick Deploy:**

1. Push ke GitHub
2. Buka Railway → New Project → Deploy from GitHub
3. Tambah MySQL service
4. Deploy Backend (Root: `server`)
5. Deploy Frontend (Root: `dashboard-bisnis-pkl/frontend`)
6. Set environment variables

Panduan lengkap: [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

---

## Environment Variables

**Backend:**
```env
NODE_ENV=production
MYSQLHOST=xxx (auto dari Railway)
MYSQLPORT=xxx (auto dari Railway)
MYSQLUSER=xxx (auto dari Railway)
MYSQLPASSWORD=xxx (auto dari Railway)
MYSQLDATABASE=xxx (auto dari Railway)
```

**Frontend:**
```env
PUBLIC_API_URL=https://your-backend.railway.app/api
```

---

## Modul & Warna

| Modul | Warna | Hex |
|-------|-------|-----|
| Penjualan (Sales) | Merah | `#EF4444` |
| Inventory | Kuning | `#F59E0B` |
| Keuangan (Finance) | Abu-abu | `#6B7280` |
| CRM | Hijau | `#10B981` |
| HR | Biru | `#3B82F6` |

---

## Default Login

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | Administrator |

---

## Author

**Nakia Suryanto** - PKL Project 2026
