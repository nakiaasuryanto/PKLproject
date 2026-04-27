#!/bin/bash

# ============================================================================
# Build & Package untuk Deploy
# Backend: Railway | Frontend: Hostinger
# ============================================================================

echo "=========================================="
echo "  Build & Package untuk Production"
echo "  Backend → Railway"
echo "  Frontend → Hostinger"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# API URL untuk Railway backend (ubah setelah deploy)
API_URL="https://pklproject-backend.railway.app/api"

# Step 1: Build Frontend
echo -e "${YELLOW}[1/2] Building Frontend...${NC}"
cd dashboard-bisnis-pkl/frontend
PUBLIC_API_URL=$API_URL npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build frontend gagal!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Frontend build selesai!${NC}"
echo ""

# Step 2: Package Frontend
echo -e "${YELLOW}[2/2] Packaging Frontend...${NC}"
cd dist
tar -czf ../../frontend-pklproject.tar.gz .
cd ../..
echo -e "${GREEN}✅ Frontend package: frontend-pklproject.tar.gz${NC}"
echo ""

echo "=========================================="
echo "  Package siap untuk di-upload!"
echo "=========================================="
echo ""
echo "📦 Deployment Steps:"
echo ""
echo -e "${BLUE}1. Backend (Railway):${NC}"
echo "   → Push code ke GitHub"
echo "   → Deploy via railway.app"
echo "   → Set environment variables"
echo "   → Copy backend URL, misal: $API_URL"
echo ""
echo -e "${BLUE}2. Frontend (Hostinger):${NC}"
echo "   → Upload: frontend-pklproject.tar.gz"
echo "   → Ke: public_html/pklproject/"
echo "   → Extract di situ"
echo ""
echo -e "${BLUE}3. Database (Hostinger):${NC}"
echo "   → Import SQL via phpMyAdmin:"
echo "      • 001_core_tables.sql"
echo "      • 002_inventory_tables.sql"
echo "      • 003_transactions_tables.sql"
echo "      • 004_crm_tables.sql"
echo "      • 005_hr_tables.sql"
echo "      • 006_integrations.sql"
echo "   → Enable Remote MySQL untuk Railway"
echo ""
echo -e "${BLUE}4. Rebuild Frontend (kalau API URL berubah):${NC}"
echo "   PUBLIC_API_URL=<BACKEND_URL> npm run build"
echo ""
echo -e "${GREEN}Done! Cek DEPLOYMENT_GUIDE.md untuk detail 🎉${NC}"
