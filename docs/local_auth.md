# Local Authentication & Session Architecture

## Overview
Sajilo Billing is an offline-first POS designed to run in environments with intermittent or zero internet connectivity. To allow retail shopkeepers and cashiers to secure their store data without requiring internet, Step 5.5 introduces local username/password authentication alongside Google Sign-In.

## Security & Architecture

### 1. Storage & Schema (`local_auth` Table)
Local credentials are stored in SQLite (via Drift schema v5):
- `id`: UUID primary key
- `username`: Lowercased unique shopkeeper/cashier identifier
- `password_hash`: HMAC-SHA256 salted hash
- `password_salt`: Cryptographically secure 32-byte pseudo-random salt generated via `Random.secure()`
- `security_question`: User-selected recovery prompt
- `security_answer_hash`: HMAC-SHA256 salted hash of the normalized answer
- `failed_attempts`: Counter tracking consecutive incorrect credentials
- `locked_until`: UTC timestamp enforcing account lockout
- `display_name`: Optional staff name displayed on bills and UI

### 2. Password Hashing
- HMAC-SHA256 implemented using Dart's pure-Dart `crypto` package (`crypto: ^3.0.3`).
- **Zero Native C/C++ FFI dependencies**: Ensures identical, tamper-proof hashing across Windows, macOS, Linux, and Web (WASM).
- Passwords and security answers are never stored in plaintext.

### 3. Brute-Force Rate Limiting & Lockout
- **Threshold**: 5 consecutive failed login attempts.
- **Lockout Duration**: 5 minutes (`_lockoutDuration = Duration(minutes: 5)`).
- After 5 failed attempts, login is locked until the `locked_until` timestamp expires.
- Successful authentication resets `failed_attempts` back to 0.

### 4. Account Recovery via Security Question
- If a shopkeeper forgets their local password, they can trigger "Forgot Password?" from the login screen.
- The user provides their username, selects their security question, and inputs their secret answer.
- If the salted answer matches `security_answer_hash`, a new password can be configured immediately with a fresh cryptographic salt.

### 5. Persistent Session Management
- Upon successful login (either Local or Google), a cryptographically unique session token is persisted to `SecureTokenStore`.
- On cold launch, `SplashScreen` automatically verifies the persistent session token. If valid, the user directly enters `DesktopAppShell` without needing to re-type credentials.
- Clicking "Logout" in Settings clears the session token and invalidates active credentials.

