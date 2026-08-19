# Dashboard Bisnis PKL

Sistem dashboard bisnis terintegrasi untuk mengelola operasional bisnis. Menggabungkan Sales, Inventory, Finance, Prospecting (CRM), dan HR dalam satu platform.

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
| Customer Service | Dashboard, Prospecting, Sales, Inventory |
| Operations | Dashboard, Inventory, Sales |
| Finance | Dashboard, Finance, Sales |

### Prospecting (CRM) - VG Style
Sistem prospecting terintegrasi dengan struktur:
- **Instansi** → Perusahaan/organisasi customer
- **Kontak** → PIC dari instansi
- **Prospecting** → Data deal/project

**Flow Prospecting → Invoice → Pembayaran:**
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Prospecting │───▶│   Invoice   │───▶│  VA Active  │───▶│    PAID     │
│    (New)    │    │  (PENDING)  │    │  (Closing)  │    │  (Closed)   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                         │                                      │
                         ▼                                      ▼
                   Auto-generate                          Auto-create
                   VA Number                              Journal Entry
```

**Fitur:**
- Daftar prospecting baru → otomatis buat customer
- Klik "Buat Invoice" → pre-fill data customer
- VA auto-generate saat invoice dibuat
- Status tracking: New → Follow Up → Closing → Closed
- Link ke halaman Sales untuk toggle pembayaran

### Penjualan & Invoice
- Buat invoice dengan pilih customer dari Prospecting
- **Auto-generate Virtual Account (VA)** saat invoice dibuat
- **Integrasi otomatis dengan inventory** - stok berkurang saat transaksi
- Metode pembayaran: Cash, Bank Transfer, VA, Lainnya
- Status pembayaran: Pending, Paid, Cancelled
- **Toggle Paid** - tandai invoice sebagai lunas
- Tracking transaksi real-time

### Keuangan (Finance)
- Dashboard pendapatan vs pengeluaran
- **Auto Journal Entry** - jurnal otomatis saat invoice dibayar:
  - Debit: Kas (uang masuk)
  - Credit: Pendapatan Penjualan
- Laporan laba rugi
- Breakdown pembayaran per metode
- Chart trend bulanan
- Format mata uang Indonesia (Rp 1.000.000)

### Inventory Management
- Tracking stok per lokasi gudang
- Alert stok rendah (< 10 unit)
- Pergerakan stok (IN/OUT) dengan reason code
- Import data via CSV
- Integrasi dengan penjualan (auto reduce)

### HR & Kehadiran
- Database karyawan dengan department
- **Sistem Check-in/Check-out** real-time
- Tracking jam kerja & kehadiran
- Ringkasan kehadiran bulanan

---

## Flow Integrasi

```
PROSPECTING                    SALES                      FINANCE
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ 1. Daftar        │     │ 3. Buat Invoice  │     │ 5. Journal Entry │
│    Customer      │────▶│    + Auto VA     │────▶│    Auto Created  │
│                  │     │                  │     │                  │
│ 2. Klik "Buat    │     │ 4. Toggle Paid   │     │ Debit: Kas       │
│    Invoice"      │     │    di Sales      │     │ Credit: Penjualan│
└──────────────────┘     └──────────────────┘     └──────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
   Status: New            Status: Closing           Laporan Keuangan
   → Closing              → Closed (Paid)           Terupdate
```

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
│   │   ├── transactions.js          # Invoice + VA generation
│   │   ├── prospectings.js          # Prospecting CRUD
│   │   ├── customers.js             # Customer management
│   │   └── ...
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
│   │   │   ├── pages/               # Halaman
│   │   │   │   ├── crm.astro        # Prospecting management
│   │   │   │   ├── sales.astro      # Sales + Toggle Paid
│   │   │   │   ├── sales/invoice/new.astro  # Buat invoice
│   │   │   │   └── ...
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

Transactions:
GET  /api/transactions        - List transaksi
POST /api/transactions/create - Buat transaksi + auto VA
PATCH /api/transactions/:id/toggle-paid - Toggle status pembayaran

Prospecting:
GET  /prospectings            - List prospecting + VA info
POST /prospectings            - Buat prospecting + auto customer
PATCH /prospectings/:id/status - Update status
GET  /prospectings/stats      - Statistik prospecting

Inventory:
GET  /api/inventory/stock     - Cek stok
POST /api/inventory/movements - Pergerakan stok

Products:
GET  /api/products            - List produk
POST /api/products            - Tambah produk

Customers:
GET  /api/customers           - List customer
POST /api/customers           - Tambah customer

Employees:
GET  /api/employees           - List karyawan
POST /api/employees/attendance/check-in  - Check-in
POST /api/employees/attendance/check-out - Check-out
```

---

## Database

**Tabel Utama:**

| Tabel | Deskripsi |
|-------|-----------|
| `instansis` | Data perusahaan/organisasi |
| `kontaks` | Data kontak PIC |
| `prospectings` | Data prospecting/deal |
| `customers` | Data customer (auto dari prospecting) |
| `transactions` | Transaksi penjualan & pengeluaran |
| `virtual_accounts` | Data VA untuk pembayaran |
| `journal_entries` | Jurnal akuntansi (auto dari paid) |
| `products` | Data produk |
| `stock_balances`, `stock_movements` | Stok & riwayat |
| `employees`, `attendance` | Data karyawan & absensi |

---

## Halaman

| Halaman | Route | Deskripsi |
|---------|-------|-----------|
| Dashboard | `/` | Overview + stats |
| Penjualan | `/sales` | Transaksi + Toggle Paid |
| Buat Invoice | `/sales/invoice/new` | Form invoice baru |
| Inventory | `/inventory` | Manajemen stok |
| Keuangan | `/finance` | Pendapatan, pengeluaran, jurnal |
| Prospecting | `/crm` | Prospecting management |
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
| Prospecting | Hijau | `#10B981` |
| HR | Biru | `#3B82F6` |

---

## Default Login

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | Administrator |

---

## Author

**Nakia Suryanto** - PKL Project 2026
