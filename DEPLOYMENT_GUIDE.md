# Panduan Deploy ke Railway

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Railway Project                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   │
│   │   Frontend   │   │   Backend    │   │    MySQL     │   │
│   │    (Astro)   │──▶│  (Express)   │──▶│   Database   │   │
│   │              │   │              │   │              │   │
│   └──────────────┘   └──────────────┘   └──────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

| Component | Technology | Railway Service |
|-----------|------------|-----------------|
| **Frontend** | Astro + TailwindCSS | Web Service |
| **Backend** | Express + Node.js | Web Service |
| **Database** | MySQL 8.0 | MySQL Plugin |

---

## Prerequisites

1. Akun [Railway](https://railway.app) (free tier available)
2. Repository GitHub sudah di-push
3. Node.js >= 18.x (untuk local development)

---

## Step 1: Buat Project Railway

1. Login ke https://railway.app
2. Klik **New Project**
3. Pilih **Deploy from GitHub repo**
4. Authorize Railway untuk akses GitHub kamu
5. Pilih repository `PKLproject`

---

## Step 2: Setup MySQL Database

1. Di Railway dashboard, klik **+ New**
2. Pilih **Database** → **MySQL**
3. Railway akan otomatis membuat database dengan kredensial
4. Catat environment variables yang disediakan:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`
   - `MYSQLDATABASE`

### Database Schema (Auto-Migration)

Database schema akan **otomatis dijalankan** saat backend pertama kali start jika `RUN_MIGRATIONS=true`.

**Opsi 1: Auto-Migration (Recommended)**
- Set `RUN_MIGRATIONS=true` di environment variables backend
- Backend akan otomatis menjalankan semua migration saat startup
- Migration yang sudah dijalankan tidak akan diulang

**Opsi 2: Manual Import**
1. Di MySQL service, klik tab **Data**
2. Import file SQL secara berurutan dari folder `server/migrations/`

---

## Step 3: Deploy Backend

1. Di Railway dashboard, klik **+ New** → **GitHub Repo**
2. Pilih repo yang sama (`PKLproject`)
3. **PENTING:** Set **Root Directory** ke `server`
4. Railway akan auto-detect Node.js dan deploy

### Environment Variables Backend

Di tab **Variables**, tambahkan:

```
NODE_ENV=production
RUN_MIGRATIONS=true
ALLOWED_ORIGINS=https://<frontend-url>.up.railway.app
```

Untuk koneksi database, reference variabel dari MySQL service:
- Klik **Add Variable Reference**
- Pilih MySQL service
- Railway akan auto-connect dengan variabel `MYSQL*`

> **Note:** Set `RUN_MIGRATIONS=true` untuk pertama kali deploy. Setelah database ter-setup, bisa diubah ke `false`.

### Verifikasi Backend

Setelah deploy selesai:
- Klik URL backend yang diberikan Railway
- Test endpoint: `https://<backend-url>.up.railway.app/health`

---

## Step 4: Deploy Frontend

1. Di Railway dashboard, klik **+ New** → **GitHub Repo**
2. Pilih repo yang sama (`PKLproject`)
3. **PENTING:** Set **Root Directory** ke `dashboard-bisnis-pkl/frontend`
4. Railway akan auto-detect dan deploy

### Environment Variables Frontend

Di tab **Variables**, tambahkan:

```
PUBLIC_API_URL=https://<backend-url>.up.railway.app/api
PORT=4321
```

Ganti `<backend-url>` dengan URL backend dari Step 3.

---

## Step 5: Update CORS Backend

Setelah frontend deployed, update CORS di backend:

1. Buka backend service di Railway
2. Di **Variables**, update `ALLOWED_ORIGINS`:
   ```
   ALLOWED_ORIGINS=https://<frontend-url>.up.railway.app
   ```

---

## Final URLs

Setelah semua selesai, kamu akan punya:

| Service | URL |
|---------|-----|
| Frontend | `https://xxx-frontend.up.railway.app` |
| Backend | `https://xxx-backend.up.railway.app` |
| Health Check | `https://xxx-backend.up.railway.app/health` |

---

## Environment Variables Reference

### Backend (`server/`)

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `PORT` | Server port (auto by Railway) | `3001` |
| `RUN_MIGRATIONS` | Auto-run migrations on startup | `true` |
| `ALLOWED_ORIGINS` | CORS allowed origins | `https://xxx.up.railway.app` |
| `MYSQLHOST` | MySQL host (from Railway) | auto |
| `MYSQLPORT` | MySQL port (from Railway) | auto |
| `MYSQLUSER` | MySQL user (from Railway) | auto |
| `MYSQLPASSWORD` | MySQL password (from Railway) | auto |
| `MYSQLDATABASE` | MySQL database (from Railway) | auto |

### Frontend (`dashboard-bisnis-pkl/frontend/`)

| Variable | Description | Example |
|----------|-------------|---------|
| `PUBLIC_API_URL` | Backend API URL | `https://xxx-backend.up.railway.app/api` |
| `PORT` | Server port | `4321` |

---

## Troubleshooting

### Backend tidak bisa connect ke database

1. Pastikan MySQL service sudah running
2. Cek apakah variable reference sudah benar
3. Lihat logs di Railway untuk error detail

### Frontend menampilkan error API

1. Cek `PUBLIC_API_URL` sudah benar
2. Pastikan backend sudah running dan healthy
3. Cek CORS di backend sudah include frontend URL

### Build failed

1. Cek logs di Railway
2. Pastikan `Root Directory` sudah benar:
   - Backend: `server`
   - Frontend: `dashboard-bisnis-pkl/frontend`

---

## Local Development

```bash
# Install dependencies
cd server && npm install
cd ../dashboard-bisnis-pkl/frontend && npm install

# Copy environment files
cp server/.env.example server/.env
cp dashboard-bisnis-pkl/frontend/.env.example dashboard-bisnis-pkl/frontend/.env

# Edit .env files with your local settings

# Run backend (terminal 1)
cd server && npm run dev

# Run frontend (terminal 2)
cd dashboard-bisnis-pkl/frontend && npm run dev
```

Frontend: http://localhost:4321
Backend: http://localhost:3001

---

## Project Structure

```
PKLproject/
├── server/                          # Backend (Express)
│   ├── routes/                      # API routes
│   ├── db.js                        # Database connection
│   ├── server.js                    # Entry point
│   ├── package.json
│   ├── railway.json                 # Railway config
│   └── .env.example
│
├── dashboard-bisnis-pkl/
│   ├── frontend/                    # Frontend (Astro)
│   │   ├── src/
│   │   │   ├── pages/               # Page routes
│   │   │   ├── components/          # UI components
│   │   │   ├── layouts/             # Layout templates
│   │   │   └── lib/                 # Utilities
│   │   ├── package.json
│   │   ├── railway.json             # Railway config
│   │   └── .env.example
│   │
│   └── database/                    # SQL migrations
│       ├── migrations/
│       └── seeds/
│
├── package.json                     # Root package
└── DEPLOYMENT_GUIDE.md              # This file
```
