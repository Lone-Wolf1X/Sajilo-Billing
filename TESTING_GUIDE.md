# 🚀 SAISA PRO — Web Testing & Tenant Onboarding Guide

## 🌐 URLs & Ports

| Service | Local URL | Description | Status |
| :--- | :--- | :--- | :---: |
| **Web Application (React)** | **[http://localhost:5173](http://localhost:5173)** | Complete SAISA Pro Web Portal | 🟢 READY TO START |
| **Backend API (Spring Boot)** | **[http://localhost:8080](http://localhost:8080)** | REST API & Security Engine | 🟢 READY TO START |
| **Database (PostgreSQL)** | `localhost:5432/saisa_dev` | Cleaned (All dummy data removed) | 🟢 SPOTLESS (Only `_platform`) |

---

## 🔑 1. Superadmin (Real User — NextGen Innovations)

Use these credentials to log in as the **SISA Pro Super Admin**:

- **Company / Tenant Code:** `_platform`
- **Username:** `superadmin`
- **Official Registered Email:** `nextgeninnovationsprivatelimit@gmail.com`
- **Full Name:** `NextGen Administrator`
- **Initial Password:** `ChangeMe#2026` *(You can also reset this password anytime via real Email OTP)*
- **Role:** `PLATFORM_ADMIN` (Universal multi-tenant, licensing & operations authority)

---

## 🔒 2. How to Test Real Email OTP Password Reset (New Feature)

1. Open **[http://localhost:5173/login](http://localhost:5173/login)**.
2. Above the Password input field, click **"पासवर्ड बिर्सनुभयो? (Forgot?)"**.
3. In the popup modal:
   - Email is pre-filled: `nextgeninnovationsprivatelimit@gmail.com`
   - Company Code: `_platform`
   - Click **"इमेलमा OTP पठाउनुहोस्"**.
4. Check your Gmail inbox (`nextgeninnovationsprivatelimit@gmail.com`):
   - You will receive a branded email: **"🔒 SAISA Pro पासवर्ड रिसेट OTP: [XXXXXX]"**.
5. Enter the **6-digit numeric OTP** in the modal.
6. Enter your desired **नयाँ पासवर्ड (New Password)** and confirm it.
7. Click **"पासवर्ड परिवर्तन गर्नुहोस्"**:
   - The password is encrypted and saved in PostgreSQL.
   - The modal automatically fills the login form with your new password.
   - You can now log in with your brand new password!

---

## 🏢 3. How to Test Company Onboarding & Licensing (New Features)

### 📌 Features Implemented:
1. **Full-Width Content Area & 3-Column Responsive Grid (`grid-cols-1 md:grid-cols-3 gap-6`)**: Clean organization into **कम्पनी प्रोफाइल (Company Profile)**, **स्थान तथा ठेगाना (Location & Contact)**, and **एडमिन खाता तथा लाइसेन्स (Admin & Cryptographic License Binding)**.
2. **Mandatory Admin Email**: Required field for credentials delivery, license activation notifications, and desktop download links.
3. **Initial Cryptographic License Auto-Binding**: Every onboarded company is automatically signed and issued an RSA cryptographic license (`TRIAL` 30 days, `STARTER` 365 days, `GROWTH` 365 days, or `ENTERPRISE` 365 days).
4. **Website Demo Request & Waiting List**: Leads who download the demo from the public website (`POST /api/v1/public/demo-request`) land in the **डेमो प्रतिक्षा सूची (Demo Waiting List)** tab. Superadmin can review and onboard them with 1-click.
5. **Direct License Injection / Upgrade**: Superadmin can click **"लाइसेन्स थप्नुहोस् (Inject)"** on any customer row to inject a new license. When the customer opens or restarts their Desktop App, the app checks `/api/v1/licenses/status` and immediately activates!

---

### Step 1: Login as Superadmin
1. Open **[http://localhost:5173/login](http://localhost:5173/login)** in your browser.
2. The login page has pre-filled values:
   - **Company Code:** `_platform`
   - **Username:** `superadmin`
   - **Password:** `ChangeMe#2026`
3. Click **लगइन गर्नुहोस् (Login)**.

---

### Step 2: Test Onboarding Wizard (3-Column Layout & Mandatory Email)
1. In the top navigation bar, go to **Admin Panel** → **ग्राहक संस्था तथा लाइसेन्स (Tenants & Licenses)** ([http://localhost:5173/admin/tenants](http://localhost:5173/admin/tenants)).
2. Click the green **"+ नयाँ ग्राहक / संस्था दर्ता गर्नुहोस् (Onboard Tenant)"** button.
3. Notice the **3-Column Full-Width Responsive Dialog**:
   - **स्तम्भ १ (कम्पनी प्रोफाइल):**
     - Company Name: `Pashupati Retail Mart Pvt Ltd`
     - Nepali Name: `पशुपति खुद्रा मार्ट प्रा.लि.`
     - Tenant Code: `PRM01`
     - PAN / VAT: `601234567`
     - Incorporation: `Private Limited`
   - **स्तम्भ २ (सम्पर्क र ठेगाना):**
     - Phone: `9841234567`
     - Province: `Bagmati Province`
     - District: `Kathmandu`
     - Address: `New Road, Kathmandu`
   - **स्तम्भ ३ (एडमिन खाता र लाइसेन्स योजना):**
     - Full Name: `Rajesh Sharma`
     - Username: `rajesh`
     - **Admin Email (Mandatory):** `rajesh@pashupati.com.np`
     - Password: `Password@123`
     - **लाइसेन्स योजना (Plan):** Select `GROWTH` (1 Year / 365 Days)
4. Click **नयाँ ग्राहक संस्था दर्ता गर्नुहोस् (Complete Onboarding)**.
5. The backend automatically creates the tenant, seeds Nepal Chart of Accounts, sets fiscal year, and **binds an RSA-signed license**.

---

### Step 3: Test License Injection
1. On the **Tenants Hub** table, find `Pashupati Retail Mart`.
2. Click the purple button: **"लाइसेन्स थप्नुहोस् (Inject)"**.
3. Select plan (e.g. `ENTERPRISE`), duration (e.g. `365` days), and max users (e.g. `10`).
4. Click **"लाइसेन्स सुरक्षित रूपमा इन्जेक्ट गर्नुहोस्"**.
5. The RSA license token is instantly signed and stored in the database. When Rajesh opens his Flutter Desktop App or logs in, the app instantly syncs this license!

---

### Step 4: Test Demo Waiting List (Website Downloads)
1. Switch to the tab: **"डेमो प्रतिक्षा सूची (Demo Waiting List)"**.
2. If visitors requested a demo via the website or API (`POST /api/v1/public/demo-request`), they show up here.
3. Test creating a demo lead using cURL:
   ```bash
   curl -X POST http://localhost:8080/api/v1/public/demo-request \
     -H "Content-Type: application/json" \
     -d '{
       "fullName": "Bikash Shrestha",
       "companyName": "Everest Bakers",
       "email": "bikash@everest.com.np",
       "phone": "9801122334",
       "city": "Pokhara"
     }'
   ```
4. Refresh or view the Waiting List tab — `Everest Bakers` will appear in the table with status **प्रतिक्षामा (Waiting)**.
5. Click **"लाइसेन्स दिनुहोस् र अनबोर्ड गर्नुहोस्"**:
   - The onboarding dialog opens automatically **pre-filled** with Bikash's company name, email, phone, city, and a suggested tenant code (`EVERESTB`)!
   - Select the desired License Plan and click Onboard.

---

## 🎭 4. Role-Specific Dashboards (Enterprise Tailored Experience)

The system now automatically tailors the **Dashboard** and **Top Navigation Menu** based on who is logged in:

| Role | Who | What They See on Dashboard & Menu |
| :--- | :--- | :--- |
| **`PLATFORM_ADMIN`** | Superadmin (NextGen Team) | **Platform Operations Hub:**<br>• SaaS Tenant Analytics & Active Licenses<br>• Website Demo Waiting Leads<br>• Engine Health (API • PostgreSQL • SMTP)<br>• Navigation: Only Platform Operations (`Tenants`, `SMTP`, `Audit Logs`) |
| **`ADMIN` / `ACCOUNTANT`** | Business Owner / CA | **Full Financial GAAP Dashboard:**<br>• Today's Revenue, AR/AP Aging Analysis<br>• Bank Accounts Balances & Reconciliation<br>• Nepal IRD VAT Summary (Annex 13)<br>• Navigation: Financial Core, Billing, Stock, Banking, Reports |
| **`CASHIER`** | Billing Counter Operator | **POS Quick Billing Terminal:**<br>• High-visibility CTA: **"[F8] नयाँ बिक्री बिल बनाउनुहोस्"**<br>• Today's Counter Sales & Cash Total<br>• Recent Invoices with Instant Print<br>• Navigation: Only POS Billing & Stock Price Lookups |

---

## 👤 5. How to Test Customer Login & POS Billing

### Step 1: Logout Superadmin
1. Click the top-right user menu → **लगआउट (Logout)**.

### Step 2: Login as the Customer
1. Go to **[http://localhost:5173/login](http://localhost:5173/login)**.
2. Enter:
   - **Company Code:** `PRM01`
   - **Username:** `rajesh`
   - **Password:** `Password@123`
3. Click **लगइन गर्नुहोस् (Login)**.

### Step 3: Verify Customer Experience
- **Dashboard:** Clean, isolated view with zero platform clutter.
- **POS / Sales Billing:** Press `[F8]` or click Sales Invoice.
- **Chart of Accounts:** Pre-seeded standard Nepal GAAP accounts.
- **Security Check:** If the customer tries to visit `/admin/tenants` or `/setup/profile`, they receive a strict `403 Forbidden` error.
