# Google Cloud & Google Drive OAuth 2.0 Setup Guide

This guide walks you through setting up a Google Cloud Project to enable Google Sign-In and Google Drive Backup/Restore for **Sajilo Billing** on Desktop (macOS, Windows, Linux).

---

## 1. Create a Google Cloud Project

1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click the project dropdown in the top bar and click **New Project**.
3. Name your project (e.g. `Sajilo Billing Backup`) and select an organization/folder if applicable.
4. Click **Create** and wait for the project initialization to complete.
5. Ensure the newly created project is selected in the top bar.

---

## 2. Enable the Google Drive API

1. In the Google Cloud Console, open the navigation menu (top-left hamburger icon) and go to **APIs & Services > Library**.
2. In the search box, type `Google Drive API` and select it from the results.
3. Click **Enable**.

---

## 3. Configure the OAuth Consent Screen

Because Sajilo Billing is a client-side application requesting access to store backups in the user's Google Drive:

1. In the navigation menu, go to **APIs & Services > OAuth consent screen**.
2. Select **External** user type (unless your organization uses Google Workspace and you only want internal users) and click **Create**.
3. Fill in the required **App Information**:
   - **App name**: `Sajilo Billing`
   - **User support email**: Your support email address.
   - **Developer contact information**: Your contact email address.
4. Click **Save and Continue**.
5. **Scopes**:
   - Click **Add or Remove Scopes**.
   - Search for and select the following minimal scopes:
     - `https://www.googleapis.com/auth/drive.file` (Per-file access: view and manage Google Drive files and folders that you have opened or created with this app).
     - `openid` (Associate user with Google account).
     - `https://www.googleapis.com/auth/userinfo.email` (View primary email address).
     - `https://www.googleapis.com/auth/userinfo.profile` (View basic profile info).
   > **Important Security Rule**: Do **NOT** select `https://www.googleapis.com/auth/drive` (full Drive access). Sajilo Billing strictly uses `drive.file` so it can only ever read and write files that it created itself in the user's Drive.
6. Click **Update** and then **Save and Continue**.
7. **Test Users**:
   - While the app publishing status is in **Testing**, add the Google accounts (e.g. your personal Gmail) that will test the app.
   - Click **Add Users**, enter test emails, and click **Save and Continue**.
8. Click **Back to Dashboard**.

---

## 4. Create OAuth 2.0 Client ID (Desktop App)

1. Go to **APIs & Services > Credentials**.
2. Click **+ Create Credentials** at the top and select **OAuth client ID**.
3. In the **Application type** dropdown, select **Desktop app**.
   > **Note on Desktop Flow**: For desktop applications, Google authorizes loopback redirect URIs (`http://127.0.0.1:<random_port>`) automatically for the `Desktop app` client type without requiring you to register specific port numbers in advance.
4. Set the **Name** to `Sajilo Billing Desktop Client`.
5. Click **Create**.
6. A dialog will show your **Client ID** and **Client Secret**. Copy both values.

---

## 5. Supplying Credentials to Sajilo Billing

Credentials should **NEVER** be committed into git or hardcoded into the source code repository.

### Option A: Via `--dart-define` (Recommended)

When running or building the app, pass the credentials as compile-time defines:

```bash
# Debug run with OAuth credentials
flutter run -d macos \
  --dart-define=GOOGLE_CLIENT_ID="YOUR_CLIENT_ID.apps.googleusercontent.com" \
  --dart-define=GOOGLE_CLIENT_SECRET="YOUR_CLIENT_SECRET"

# Release build
flutter build macos \
  --dart-define=GOOGLE_CLIENT_ID="YOUR_CLIENT_ID.apps.googleusercontent.com" \
  --dart-define=GOOGLE_CLIENT_SECRET="YOUR_CLIENT_SECRET"
```

### Option B: Local secrets file (`google_secrets.json`)

You can create a local `assets/config/google_secrets.json` (which is included in `.gitignore`):

```json
{
  "client_id": "YOUR_CLIENT_ID.apps.googleusercontent.com",
  "client_secret": "YOUR_CLIENT_SECRET"
}
```

The app's `GoogleAuthService` first checks `--dart-define` values; if omitted, it looks for the local config file, or falls back to prompt mode in Settings.

---

## 6. How OAuth 2.0 with PKCE Works on Desktop

1. **Ephemeral Local Server**: The app binds an HTTP listener on a random loopback port (`http://127.0.0.1:<port>`).
2. **PKCE Security**:
   - Generates a high-entropy cryptographically random `code_verifier` (43–128 characters).
   - Computes `code_challenge = Base64UrlEncode(SHA-256(code_verifier))` with no padding.
3. **Browser Authorization**:
   - Opens the system default browser using `url_launcher` to `https://accounts.google.com/o/oauth2/v2/auth` with `code_challenge_method=S256`.
4. **Authorization Code Callback**:
   - After user consent, Google redirects the browser to `http://127.0.0.1:<port>/?code=...`.
   - The local HTTP server receives the authorization code, displays a polite "Authentication successful. You can close this window." web page to the user, and immediately shuts down the listener.
5. **Token Exchange**:
   - App POSTs to `https://oauth2.googleapis.com/token` with the `code` and original `code_verifier`.
   - Google returns an `access_token` and a `refresh_token`.
6. **Secure Storage**:
   - The `refresh_token` is stored exclusively in OS keychain / encrypted storage via `flutter_secure_storage`.
   - It is never stored in SQLite, log files, or plaintext settings.
   - The `access_token` is kept in volatile in-memory cache and automatically refreshed 5 minutes before expiry.
