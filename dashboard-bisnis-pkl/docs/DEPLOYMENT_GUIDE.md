# Deployment Guide - Dashboard Bisnis PKL

Complete guide for deploying the Dashboard Bisnis PKL application.

---

## Prerequisites

### Server Requirements

- **Operating System:** Linux (Ubuntu 20.04+ recommended) or Windows Server
- **Node.js:** 18.x or higher
- **MySQL:** 8.0 or higher
- **RAM:** Minimum 2GB (4GB recommended)
- **Storage:** Minimum 20GB
- **Domain:** Optional (for production)

### Software Requirements

```bash
# Check versions
node --version  # Should be 18.x+
npm --version   # Should be 9.x+
mysql --version # Should be 8.0+
```

---

## Environment Configuration

### Production .env File

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=u705828172_pklproject
DB_USER=production_db_user
DB_PASSWORD=secure_production_password

# Server Configuration
PORT=3001
NODE_ENV=production

# Frontend Configuration
FRONTEND_URL=https://your-domain.com

# Optional: Authentication
JWT_SECRET=your_jwt_secret_minimum_32_characters
SESSION_SECRET=your_session_secret_minimum_32_characters
```

---

## Database Setup

### 1. Create Database User

```sql
-- Create production database user
CREATE USER 'dashboard_user'@'localhost' IDENTIFIED BY 'secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON u705828172_pklproject.* TO 'dashboard_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;
```

### 2. Run Migrations

```bash
cd server

# Run all migrations
npm run migrate

# Verify tables created
mysql -u dashboard_user -p u705828172_pklproject -e "SHOW TABLES;"
```

### 3. Seed Production Data (Optional)

```bash
cd server

# Seed reference data only
npm run seed:production
```

---

## Backend Deployment

### Option 1: Direct Node.js

```bash
# Install dependencies
cd server
npm install --production

# Build/transpile if needed
npm run build

# Start with PM2 (recommended)
npm install -g pm2
pm2 start server.js --name dashboard-pkl

# Configure PM2 to start on boot
pm2 startup
pm2 save
```

### Option 2: Docker

```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --production

COPY . .

EXPOSE 3001

CMD ["node", "server.js"]
```

```bash
# Build and run
docker build -t dashboard-pkl .
docker run -d -p 3001:3001 --name dashboard-api \
  --env-file .env dashboard-pkl
```

### Option 3: Systemd Service

```ini
# /etc/systemd/system/dashboard-pkl.service
[Unit]
Description=Dashboard Bisnis PKL API
After=network.target mysql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/dashboard-bisnis-pkl/server
ExecStart=/usr/bin/node server.js
Restart=on-failure
Environment=NODE_ENV=production
EnvironmentFile=/var/www/dashboard-bisnis-pkl/.env

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl enable dashboard-pkl
sudo systemctl start dashboard-pkl
sudo systemctl status dashboard-pkl
```

---

## Frontend Deployment

### Build for Production

```bash
# From root directory
npm run build

# Output will be in dist/ directory
```

### Option 1: Static Hosting (Vercel, Netlify)

```bash
# Deploy to Vercel
npm install -g vercel
vercel --prod

# Deploy to Netlify
npm install -g netlify-cli
netlify deploy --prod --dir=dist
```

### Option 2: Nginx (VPS)

```nginx
# /etc/nginx/sites-available/dashboard-pkl
server {
    listen 80;
    server_name your-domain.com;

    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    # SSL certificates
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    # Frontend static files
    root /var/www/dashboard-bisnis-pkl/dist;
    index index.html;

    # Frontend routes
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API to backend
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/dashboard-pkl /etc/nginx/sites-enabled/

# Test and restart
sudo nginx -t
sudo systemctl restart nginx
```

---

## SSL Certificate (Let's Encrypt)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal (already configured)
sudo certbot renew --dry-run
```

---

## Security Checklist

### Database Security

- [ ] Strong database password (16+ characters)
- [ ] Restricted database user (no root access)
- [ ] Disabled remote MySQL root access
- [ ] Regular database backups

### Application Security

- [ ] Environment variables not in git
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] Input validation on all endpoints
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Helmet.js headers configured

### Server Security

- [ ] Firewall configured (UFW)
- [ ] SSH key authentication only
- [ ] Auto security updates
- [ ] Fail2ban installed
- [ ] Log monitoring configured

---

## Backup Strategy

### Database Backups

```bash
# Create backup script
cat > /usr/local/bin/backup-dashboard.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/var/backups/dashboard-pkl"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u dashboard_user -p'password' u705828172_pklproject | gzip > $BACKUP_DIR/db_$DATE.sql.gz

# Keep last 30 days
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +30 -delete
EOF

chmod +x /usr/local/bin/backup-dashboard.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /usr/local/bin/backup-dashboard.sh
```

### Application Backups

```bash
# Backup application files
rsync -avz /var/www/dashboard-bisnis-pkl/ /var/backups/dashboard-pkl/app/
```

---

## Monitoring

### Health Checks

```bash
# Simple health check
curl https://your-domain.com/api/health

# Expected response
{"status":"ok","timestamp":"2025-01-15T10:30:00Z"}
```

### Log Files

```bash
# Application logs
tail -f /var/www/dashboard-bisnis-pkl/server/logs/app.log

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# PM2 logs (if using PM2)
pm2 logs dashboard-pkl
```

### Monitoring Tools

Consider setting up:
- **Uptime monitoring:** UptimeRobot, Pingdom
- **Error tracking:** Sentry
- **Analytics:** Google Analytics, Plausible
- **Performance:** Lighthouse CI

---

## Performance Optimization

### Backend

- Enable gzip compression
- Implement response caching
- Use connection pooling
- Add database indexes
- Enable CDN for static assets

### Frontend

- Minimize JavaScript bundles
- Optimize images
- Lazy load components
- Use code splitting
- Enable browser caching

---

## Troubleshooting

### Common Issues

**Issue:** Port 3001 already in use
```bash
# Find and kill process
lsof -ti:3001 | xargs kill -9
```

**Issue:** Database connection failed
```bash
# Check MySQL status
sudo systemctl status mysql

# Test connection
mysql -u dashboard_user -p -h localhost u705828172_pklproject
```

**Issue:** Nginx 502 Bad Gateway
```bash
# Check if backend is running
pm2 status

# Check backend logs
pm2 logs dashboard-pkl
```

---

## Rollback Procedure

### Database Rollback

```bash
# Stop application
pm2 stop dashboard-pkl

# Restore from backup
gunzip < /var/backups/dashboard-pkl/db_20250115_020000.sql.gz | mysql -u dashboard_user -p u705828172_pklproject

# Restart application
pm2 start dashboard-pkl
```

### Application Rollback

```bash
# Revert to previous commit
cd /var/www/dashboard-bisnis-pkl
git log --oneline
git checkout <previous-commit-hash>

# Rebuild and restart
npm run build
pm2 restart dashboard-pkl
```

---

## Deployment Status

```
Deployment Checklist:

Development Environment:
- [ ] Local database configured
- [ ] Backend server running locally
- [ ] Frontend dev server working
- [ ] All modules accessible

Production Environment:
- [ ] Server provisioned
- [ ] Database configured
- [ ] Backend deployed
- [ ] Frontend built and deployed
- [ ] SSL certificate installed
- [ ] Monitoring configured
- [ ] Backups automated
```
