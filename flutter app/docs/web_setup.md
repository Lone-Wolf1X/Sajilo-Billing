# Sajilo Billing - Flutter Web Setup Guide

This guide describes how to configure, develop, and build **Sajilo Billing** for the Web platform.

---

## 1. Web Architecture Overview

Sajilo Billing Web is a **secondary client** designed for shopkeepers to view and manage bills from any modern browser.
- **Desktop (macOS/Windows/Linux)**: Primary offline-first workstation with native SQLite FFI and Google Drive backup.
- **Web**: Offline-tolerant client running SQLite inside WebAssembly (`drift/wasm`), persisting data to browser `IndexedDB` or OPFS (Origin Private File System).

> **Important Storage Caveat:** Browser storage can be cleared at any time by the user or browser storage eviction policies. Therefore, the Web app must **sync frequently** and treats the sync backend as the ultimate source of truth for persisted business records.

---

## 2. Drift WASM Artifacts (`sqlite3.wasm` & `drift_worker.js`)

Drift on Web requires two files located in the `web/` directory:
1. `web/sqlite3.wasm`: The compiled SQLite WebAssembly binary with virtual filesystem support.
2. `web/drift_worker.js`: The dedicated Web Worker handling database queries off the UI thread.

### How to generate or download:
- **`sqlite3.wasm`**: Download from [sqlite3.dart releases](https://github.com/simolus3/sqlite3.dart/releases) or use the build shipped with drift devtools.
- **`drift_worker.js`**: Compile using Dart 3:
  ```bash
  # Create a worker entrypoint bin/drift_worker.dart
  echo "import 'package:drift/wasm.dart'; void main() => WasmDatabase.workerMainForOpen();" > bin/drift_worker.dart
  dart compile js -O2 bin/drift_worker.dart -o web/drift_worker.js
  ```

---

## 3. Google OAuth 2.0 Client IDs

Two distinct Google OAuth Client IDs are required in Google Cloud Console:
1. **Desktop Client ID** (`GOOGLE_CLIENT_ID_DESKTOP`):
   - Application Type: **Desktop app**
   - Redirect URI: `http://127.0.0.1:<port>` (loopback)
2. **Web Client ID** (`GOOGLE_CLIENT_ID_WEB`):
   - Application Type: **Web application**
   - Authorized JavaScript origins: `http://localhost:8080`, `https://billing.yourdomain.com`
   - Authorized redirect URIs: `http://localhost:8080/`, `https://billing.yourdomain.com/`

---

## 4. Local Development

Run the sync server and Flutter Web locally:

### Terminal 1: Run Sync Backend
```bash
cd server
npm install
ALLOWED_ORIGINS="http://localhost:8080,http://127.0.0.1:8080" npm start
```

### Terminal 2: Run Flutter Web on Chrome
```bash
flutter run -d chrome \
  --web-port=8080 \
  --dart-define=GOOGLE_CLIENT_ID_WEB=612120463137-ft0pdu8j2d00tef1birjtb0r3djlfdpg.apps.googleusercontent.com \
  --dart-define=SYNC_BASE_URL=http://localhost:8080
```

---

## 5. Security & Browser Headers

Drift's WebAssembly worker utilizes `SharedArrayBuffer` for synchronous filesystem emulation. Modern browsers require these headers:
- `Cross-Origin-Opener-Policy: same-origin`
- `Cross-Origin-Embedder-Policy: require-corp`

Ensure your web server or hosting provider provides these headers (already pre-configured in `web/nginx.conf`).

