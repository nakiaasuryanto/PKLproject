# Panduan Deploy - Railway (Backend) + Hostinger (Frontend/Database)

## Architecture

| Component | Platform | URL |
|-----------|----------|-----|
| **Frontend** | Hostinger (Static) | https://pklproject.nakiasuryanto.com |
| **Backend** | Railway (Node.js) | https://pklproject-backend.railway.app |
| **Database** | Hostinger MySQL | localhost (diakses dari Railway) |

---

## 1️⃣ Setup Database (Hostinger)

1. Login ke [Hostinger hPanel](https://hpanel.hostinger.com)
2. Masuk ke **Databases** → **MySQL Databases**
3. Database sudah ada:
   - **Database:** `u705828172_pklproject`
   - **Username:** `u705828172_pklproject`
   - **Password:** `PKLproject27`

4. Import struktur database:
   - Buka **phpMyAdmin**
   - Pilih database `u705828172_pklproject`
   - Klik **Import**
   - Upload file SQL secara berurutan:
     - `001_core_tables.sql`
     - `002_inventory_tables.sql`
     - `003_transactions_tables.sql`
     - `004_crm_tables.sql`
     - `005_hr_tables.sql`
     - `006_integrations.sql`

5. **PENTING:** Allow remote connection
   - Di hPanel, cari **Remote MySQL**
   - Add host: `%` (atau IP Railway jika ada)
   - Ini agar Railway bisa connect ke database Hostinger

---

## 2️⃣ Deploy Backend ke Railway

### Opsi A: Via GitHub (Recommended)

1. **Push code ke GitHub** (kalau belum):
   ```bash
   git add .
   git commit -m "Ready for Railway deployment"
   git push origin main
   ```

2. **Login ke Railway:**
   - Buka https://railway.app
   - Login dengan GitHub

3. **Create New Project:**
   - Klik **New Project**
   - Pilih **Deploy from GitHub repo**
   - Pilih repo `PKLproject` kamu
   - Set **Root directory** ke `server`
   - Klik **Deploy Now**

4. **Setup Environment Variables:**
   - Di dashboard Railway, buka project kamu
   - Klik **Variables** tab
   - Add variables:
     ```
     DB_HOST=u705828172.hostinger.io
     DB_PORT=3306
     DB_NAME=u705828172_pklproject
     DB_USER=u705828172_pklproject
     DB_PASSWORD=PKLproject27
     NODE_ENV=production
     ALLOWED_ORIGINS=https://pklproject.nakiasuryanto.com
     ```

5. **Cek Deployment:**
   - Railway akan otomatis detect package.json dan install dependencies
   - Tunggu sampai status jadi **Active**
   - Copy URL backend, misal: `https://pklproject-backend.railway.app`

### Opsi B: Via Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Init project
cd server
railway init

# Set environment variables
railway variables set DB_HOST=u705828172.hostinger.io
railway variables set DB_PORT=3306
railway variables set DB_NAME=u705828172_pklproject
railway variables set DB_USER=u705828172_pklproject
railway variables set DB_PASSWORD=PKLproject27
railway variables set NODE_ENV=production
railway variables set ALLOWED_ORIGINS=https://pklproject.nakiasuryanto.com

# Deploy
railway up
```

---

## 3️⃣ Setup Subdomain di Hostinger

1. Di hPanel, masuk ke **Domains**
2. Cari domain `nakiasuryanto.com`
3. Klik **Manage** → **Subdomains**
4. Create subdomain:
   - **Subdomain:** `pklproject`
   - **Document root:** `public_html/pklproject`

---

## 4️⃣ Build Frontend (Local)

```bash
cd dashboard-bisnis-pkl/frontend

# Install dependencies
npm install

# Build untuk production dengan API URL Railway
PUBLIC_API_URL=https://pklproject-backend.railway.app/api npm run build
```

Hasil build ada di folder `dist/`

---

## 5️⃣ Deploy Frontend ke Hostinger

### Via File Manager

1. Di hPanel, buka **File Manager**
2. Navigate ke `public_html/pklproject/`
3. Upload semua file dari `dashboard-bisnis-pkl/frontend/dist/`
4. Extract jika upload dalam format zip

### Via Script

```bash
# Run deploy script
./deploy.sh

# Upload file yang dihasilkan:
# - frontend-pklproject.tar.gz → public_html/pklproject/
```

---

## 6️⃣ Testing

1. **Frontend:** https://pklproject.nakiasuryanto.com
2. **Backend Health:** https://pklproject-backend.railway.app/health
3. **Cek console browser** (F12) untuk error

---

## 🔧 Troubleshooting

### Backend Railway Error

**Database connection failed:**
- Pastikan Remote MySQL sudah di-enable di Hostinger
- Cek apakah host sudah benar (biasanya `u705828172.hostinger.io`)
- Cek password database

**Build failed:**
- Cek Railway logs untuk detail error
- Pastikan package.json ada di folder server

**CORS error:**
- Pastikan `ALLOWED_ORIGINS` sesuai dengan domain frontend
- Pastikan frontend URL menggunakan https

### Frontend Error

**Blank page:**
- Cek console browser (F12)
- Pastikan API URL benar
- Cek apakah backend sudah jalan

**API not reachable:**
- Cek apakah Railway backend sudah Active
- Cek URL backend benar
- Cek CORS configuration

### Database Issue

**Can't connect from Railway:**
- Pastikan Remote MySQL sudah di-enable
- Cek firewall Hostinger
- Coba test connection dari Railway console

---

## 📝 Environment Variables Reference

### Railway (Backend)

| Variable | Value |
|----------|-------|
| `DB_HOST` | `u705828172.hostinger.io` |
| `DB_PORT` | `3306` |
| `DB_NAME` | `u705828172_pklproject` |
| `DB_USER` | `u705828172_pklproject` |
| `DB_PASSWORD` | `PKLproject27` |
| `NODE_ENV` | `production` |
| `ALLOWED_ORIGINS` | `https://pklproject.nakiasuryanto.com` |

### Frontend (Build time)

| Variable | Value |
|----------|-------|
| `PUBLIC_API_URL` | `https://pklproject-backend.railway.app/api` |

---

## 💡 Tips

1. **Auto-deploy:** Railway akan auto-deploy setiap kali kamu push ke GitHub
2. **Logs:** Cek Railway logs untuk debugging
3. **Domain:** Railway bisa custom domain (opsional)
4. **Free tier:** Railway free tier cukup untuk development

---

## 🎯 Summary

| Step | Action | Platform |
|------|--------|----------|
| 1 | Import database | Hostinger phpMyAdmin |
| 2 | Enable Remote MySQL | Hostinger hPanel |
| 3 | Deploy backend | Railway (from GitHub) |
| 4 | Set environment variables | Railway dashboard |
| 5 | Create subdomain | Hostinger hPanel |
| 6 | Build frontend | Local |
| 7 | Upload frontend | Hostinger File Manager |

**Done! 🎉**
