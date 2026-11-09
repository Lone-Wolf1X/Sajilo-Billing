# SAISA Accounting — Production Deployment Guide

## Prerequisites (Linux Server)

- Ubuntu 22.04 / 24.04 or Debian 12
- Java 21 (Temurin)
- PostgreSQL 16
- 2 GB RAM minimum, 4 GB recommended
- 20 GB disk space (backups add up)

## One-Time Setup

### 1. Create service user
```bash
sudo useradd --system --create-home --shell /bin/bash saisa
```

### 2. Install Java 21 (Ubuntu)
```bash
sudo apt install -y temurin-21-jdk
java -version    # verify
```

### 3. Install PostgreSQL 16
```bash
sudo apt install -y postgresql-16 postgresql-client-16
sudo systemctl enable --now postgresql
```

### 4. Create database and user
```bash
sudo -u postgres psql <<EOF
CREATE USER saisa_app WITH PASSWORD 'STRONG_PASSWORD';
CREATE DATABASE saisa_prod OWNER saisa_app;
GRANT ALL PRIVILEGES ON DATABASE saisa_prod TO saisa_app;
EOF
```

### 5. Deploy application files
```bash
sudo mkdir -p /opt/saisa-accounting
sudo chown saisa:saisa /opt/saisa-accounting
sudo -u saisa rsync -a --exclude=backups --exclude=logs --exclude=dist \
    /path/to/saisa-accounting/ /opt/saisa-accounting/
sudo mkdir -p /var/log/saisa /opt/saisa-accounting/{logs,run,backups,dist}
sudo chown -R saisa:saisa /var/log/saisa /opt/saisa-accounting
```

### 6. Configure environment
```bash
cd /opt/saisa-accounting
sudo -u saisa cp .env.example .env
sudo -u saisa openssl rand -base64 64  # generate JWT_SECRET
sudo -u saisa nano .env
sudo chmod 600 .env
```

### 7. Build and start
```bash
cd /opt/saisa-accounting
sudo -u saisa scripts/build.sh
sudo -u saisa scripts/start.sh
sudo -u saisa scripts/check-health.sh
```

### 8. Install systemd service
```bash
sudo cp deploy/saisa.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now saisa
sudo systemctl status saisa
```

### 9. Setup daily backups (cron)
```bash
sudo -u saisa crontab -e
# Add:
0 2 * * * /opt/saisa-accounting/scripts/backup.sh >> /var/log/saisa/backup.log 2>&1
```

### 10. Firewall
```bash
# Only expose via reverse proxy (nginx)
sudo ufw allow 22/tcp       # ssh
sudo ufw deny 8080/tcp      # app not public
sudo ufw enable
```

## Upgrade Procedure

```bash
# 1. Build new JAR on dev machine, copy over
scp dist/saisa-app-NEW.jar saisa@prod:/opt/saisa-accounting/dist/

# 2. On prod:
cd /opt/saisa-accounting
sudo -u saisa scripts/stop.sh
sudo -u saisa ln -sfn saisa-app-NEW.jar dist/saisa-app.jar
sudo -u saisa scripts/start.sh
sudo -u saisa scripts/check-health.sh
```

## Rollback

```bash
sudo -u saisa scripts/stop.sh
sudo -u saisa ln -sfn saisa-app-OLD.jar dist/saisa-app.jar
sudo -u saisa scripts/start.sh
```

## Disaster Recovery

```bash
sudo -u saisa scripts/stop.sh
sudo -u saisa CONFIRM=yes DB_NAME=saisa_prod scripts/restore.sh
```

