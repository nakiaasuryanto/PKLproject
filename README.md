# 📊 Dashboard Bisnis PKL

Sistem dashboard bisnis terintegrasi untuk mengelola operasional bisnis kecil (PKL). Menggabungkan Sales, Inventory, Finance, CRM, dan HR dalam satu platform.

---

## 🚀 Cara Jalanin

```bash
# 1. Install dulu backend-nya
cd server
npm install

# 2. Copy file env
cp .env.example .env
# Edit .env pake database kamu

# 3. Setup database (pake MySQL)
mysql -u root -p < database/migrations/001_core_tables.sql
mysql -u root -p < database/migrations/002_inventory_tables.sql
mysql -u root -p < database/migrations/003_transactions_tables.sql
mysql -u root -p < database/migrations/004_crm_tables.sql
mysql -u root -p < database/migrations/005_hr_tables.sql
mysql -u root -p < database/migrations/006_integrations.sql

# 4. Jalanin backend (terminal 1)
cd server
node server.js
# Backend jalan di http://localhost:3001

# 5. Install frontend
cd frontend
npm install

# 6. Jalanin frontend (terminal 2)
npm run dev
# Frontend jalan di http://localhost:4321
```

---

## 📁 Struktur Folder

```
PKLproject/
│
├── server/                 ⚙️  Backend API
│   ├── routes/            - API endpoints (products, inventory, transactions, dll)
│   ├── db.js              - Koneksi database
│   ├── server.js          - Express app
│   └── package.json
│
├── frontend/              🎨  Frontend (Astro)
│   ├── src/
│   │   ├── pages/        - Halaman-halaman (index, sales, inventory, dll)
│   │   ├── components/   - Komponen reusable (Card, Button, Modal)
│   │   ├── layouts/      - Layout templates
│   │   └── lib/          - Utilities & API helper
│   └── package.json
│
├── database/              🗄️  Database SQL files
│   ├── migrations/       - Schema pembuatan tabel
│   └── seeds/            - Data dummy buat testing
│
├── docs/                 📚  Documentation
│   ├── API_ENDPOINTS.md
│   ├── DATABASE_SCHEMA.md
│   └── ...
│
└── dashboard-bisnis-pkl/  📦 Project files lama (README, logo, dll)
```

---

## 🎨 Modul & Warna

| Modul | Warna | Hex |
|-------|-------|-----|
| **Penjualan** | Merah | `#EF4444` |
| **Inventory** | Biru | `#3B82F6` |
| **Keuangan** | Hijau | `#10B981` |
| **CRM** | Ungu | `#8B5CF6` |
| **HR** | Orange | `#F97316` |

---

## 📡 API Endpoints

```
Backend: http://localhost:3001

GET  /api/health              - Cek server
GET  /api/dashboard/overview  - Stats dashboard
GET  /api/products            - List produk
POST /api/products            - Tambah produk
GET  /api/inventory/stock     - Cek stok
GET  /api/transactions        - List transaksi
POST /api/transactions        - Buat transaksi
GET  /api/customers           - List customer
GET  /api/employees           - List karyawan
```

---

## 🗄️ Database

14 Tabel + 6 Views:

**Tabel Utama:**
- `products` - Data produk
- `product_colors` - Warna varian
- `product_color_sizes` - Ukuran varian (SKU)
- `stock_balances` - Stok saat ini
- `stock_movements` - Riwayat stok
- `transactions` - Transaksi (jual/beli)
- `customers` - Data pelanggan
- `employees` - Data karyawan
- `attendance` - Absensi

**Views:**
- `v_product_variants` - Produk + harga
- `v_stock_levels` - Stok per lokasi
- `v_low_stock_alert` - Barang stok rendah
- `v_sales_summary` - Summary penjualan bulanan

---

## 📱 Halaman-halaman

| Halaman | Route | Deskripsi |
|---------|-------|-----------|
| Dashboard | `/` | Home + stats + activity feed |
| Penjualan | `/sales` | Transaksi + trend penjualan |
| Inventory | `/inventory` | Stok + input/import |
| Keuangan | `/finance` | Pendapatan + pengeluaran |
| CRM | `/crm` | Customer management |
| HR | `/hr` | Karyawan + absensi |

---

## 🔧 Tech Stack

### Backend
- **Node.js** - Runtime
- **Express** - Web framework
- **MySQL** - Database
- **mysql2** - Database driver

### Frontend
- **Astro** - Framework
- **TailwindCSS** - Styling
- **Chart.js** - Grafik
- **TypeScript** - Type safety

---

## 🛠️ Troubleshooting

**Backend gagal start?**
```bash
# Cek port 3001
lsof -i:3001
# Kill process yang pake port 3001
kill -9 <PID>
```

**Database error?**
```bash
# Cek koneksi
mysql -u root -p
# SHOW DATABASES;
# USE nama_database;
# SHOW TABLES;
```

**Frontend error?**
```bash
cd frontend
rm -rf node_modules
npm install
npm run dev
```

---

## 🚀 Deploy ke Production

**Architecture:** Railway (Backend) + Hostinger (Frontend + Database)

Panduan lengkap ada di file [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

### Quick Summary:

| Component | Platform | URL |
|-----------|----------|-----|
| Frontend | Hostinger (Static) | https://pklproject.nakiasuryanto.com |
| Backend | Railway (Node.js) | https://pklproject-backend.railway.app |
| Database | Hostinger MySQL | u705828172.hostinger.io |

### Quick Start Deploy:

1. **Backend (Railway):**
   ```bash
   # Push ke GitHub
   git push origin main

   # Deploy via Railway dashboard
   # - Connect GitHub repo
   # - Set root directory: server
   # - Set environment variables
   ```

2. **Frontend (Hostinger):**
   ```bash
   cd dashboard-bisnis-pkl/frontend
   PUBLIC_API_URL=https://pklproject-backend.railway.app/api npm run build
   # Upload folder dist/ ke public_html/pklproject/
   ```

3. **Database (Hostinger):**
   - Import SQL files via phpMyAdmin
   - Enable Remote MySQL untuk Railway access

---

## 📝 Update Terakhir

- ✅ Growth percentage dynamic (bukan hardcoded)
- ✅ Activity log real-time dari database
- ✅ Empty states untuk semua halaman
- ✅ Clean up file-file gak kepake
- ✅ Reorganize struktur folder
- ✅ Railway deployment configuration siap
- ✅ Deployment guide untuk Railway + Hostinger
- ✅ Project siap deploy!

---

## 👤 Author

**Nakia Suryanto**
PKL Project 2025

---

**Happy Coding!** 🎉
