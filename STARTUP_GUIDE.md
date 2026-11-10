# 🚀 SAISA PRO — How to Run Backend & Frontend (Startup Guide)

This guide contains the exact terminal commands to start the **Spring Boot Backend**, **React Web App**, and **Flutter Desktop App** on your macOS machine.

---

## 📋 Quick Overview of Ports & URLs

| Component        | Technology                | Default URL / Port         | Terminal Folder   |
| :--------------- | :------------------------ | :------------------------- | :---------------- |
| **Backend API**  | Spring Boot (Java 21)     | `http://localhost:8080`    | `backend/`        |
| **Web Frontend** | React + Vite + TypeScript | `http://localhost:5173`    | `saisa-frontend/` |
| **Desktop App**  | Flutter (macOS / Windows) | Native Window              | `flutter app/`    |
| **Database**     | PostgreSQL                | `localhost:5432/saisa_dev` | —                 |

---

## 🛠️ Step 1: Start PostgreSQL (If not running)

Make sure PostgreSQL is running on port 5432:

```bash
# Check if PostgreSQL is running
pg_isready -h localhost -p 5432

# Or start it via Homebrew / Service (if stopped)
brew services start postgresql@17
```

---

## ⚙️ Step 2: Start the Backend (Spring Boot API)

Open a **new terminal tab** and run:

```bash
cd ~/Downloads/Sajilo_Billing/backend

# Set Java 21 and Maven paths
export JAVA_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null || echo "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home")
export PATH="/opt/maven/bin:/opt/homebrew/opt/openjdk@17/bin:$PATH"

# Run Spring Boot backend
mvn spring-boot:run -pl saisa-app
```

> **Verify it is running:**
> When you see:
> `Application availability state ReadinessState changed to ACCEPTING_TRAFFIC`
> Backend is live on **`http://localhost:8080`**!

---

## 🌐 Step 3: Start the Web Frontend (React Vite)

Open a **second terminal tab** and run:

```bash
cd ~/Downloads/Sajilo_Billing/saisa-frontend

# Load Node.js (via NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Start Vite dev server
npm run dev
```

> **Open in Browser:**
> Go to **[http://localhost:5173](http://localhost:5173)** in Chrome or Brave!

---

## 💻 Step 4: Start the Desktop App (Flutter macOS / Windows)

Open a **third terminal tab** and run:

```bash
cd ~/Downloads/Sajilo_Billing/"flutter app"

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"

# Run native desktop app (macOS)
flutter run -d macos
```

_(On Windows, run `flutter run -d windows`)_

---

## 🔑 Login Credentials

### 1. Platform Superadmin (Real User — NextGen Innovations)

- **Company Code:** `_platform`
- **Username:** `superadmin`
- **Email:** `nextgeninnovationsprivatelimit@gmail.com`
- **Initial Password:** `ChangeMe#2026` *(You can also reset via real Email OTP)*
- **What to do:** Go to **Admin Panel** → **Tenants** to onboard new customers.

### 2. Tenant / Customer (Once Onboarded)

- **Company Code:** _(The code you assigned, e.g. `PRM01`)_
- **Username:** _(The admin username assigned, e.g. `owner`)_
- **Password:** _(The password assigned or generated)_
- **What they can do:** Complete Sajilo Billing POS, Sales Invoices, Inventory, Khata, Ledger, and IRD Reports.

---

## 🛑 How to Stop or Free Busy Ports

If a port says `Address already in use`:

```bash
# To kill port 8080 (Backend)
lsof -ti :8080 | xargs kill -9

# To kill port 5173 (Frontend)
lsof -ti :5173 | xargs kill -9
```

---

## ⚡ 1-Click Startup Script (All-in-One)

You can also run both Backend and Frontend in one go:

```bash
# Run from project root:
cd ~/Downloads/Sajilo_Billing

# Terminal 1: Backend
(export PATH="/opt/maven/bin:$PATH" && cd backend && mvn spring-boot:run -pl saisa-app) &

# Terminal 2: Web Frontend
(source ~/.nvm/nvm.sh && cd saisa-frontend && npm run dev)
```
