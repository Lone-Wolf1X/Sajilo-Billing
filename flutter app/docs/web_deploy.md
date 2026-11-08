# Sajilo Billing - Flutter Web Deployment Guide

This guide details how to build, containerize, and deploy the Web build of Sajilo Billing.

---

## 1. Production Build with CanvasKit

We mandate the **CanvasKit** web renderer for Sajilo Billing to ensure pixel-perfect rendering of bilingual Devanagari text, tables, and fiscal QR codes identical to the desktop print output.

```bash
flutter build web --release \
  --web-renderer canvaskit \
  --dart-define=GOOGLE_CLIENT_ID_WEB=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com \
  --dart-define=SYNC_BASE_URL=https://sync.yourdomain.com
```

Output directory: `build/web/`

---

## 2. Hosting Options

### Option A: Docker + Nginx (Recommended for Self-Hosting)

Use the pre-configured `web/Dockerfile` and `web/nginx.conf`:

```bash
# Build Docker image
docker build -t sajilo-billing-web \
  -f web/Dockerfile \
  --build-arg GOOGLE_CLIENT_ID_WEB="YOUR_CLIENT_ID" \
  --build-arg SYNC_BASE_URL="https://sync.yourdomain.com" .

# Run container on port 80
docker run -d -p 80:80 --name sajilo-web sajilo-billing-web
```

### Option B: Firebase Hosting

Add COOP/COEP and WASM MIME headers in `firebase.json`:

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "headers": [
      {
        "source": "**",
        "headers": [
          { "key": "Cross-Origin-Opener-Policy", "value": "same-origin" },
          { "key": "Cross-Origin-Embedder-Policy", "value": "require-corp" }
        ]
      },
      {
        "source": "**/*.wasm",
        "headers": [
          { "key": "Content-Type", "value": "application/wasm" }
        ]
      }
    ],
    "rewrites": [
      { "source": "**", "destination": "/index.html" }
    ]
  }
}
```

Deploy with:
```bash
firebase deploy --only hosting
```

### Option C: Netlify

Add a `web/_headers` file:
```text
/*
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Embedder-Policy: require-corp

/*.wasm
  Content-Type: application/wasm
```

---

## 3. Deploy Runbook Checklist

Before going live:
- [ ] Google Cloud Console: Add your production domain to **Authorized JavaScript origins** and **Authorized redirect URIs**.
- [ ] Backend: Set `ALLOWED_ORIGINS` to include your production web domain.
- [ ] Build: Confirm `--web-renderer canvaskit` is passed during build.
- [ ] Smoke test:
  1. Open Web app in browser.
  2. Verify Noto Sans Devanagari font renders smoothly on labels and bills.
  3. Log in with Google Account.
  4. Verify initial sync pulls existing inventory from backend.
  5. Create a test sale and verify bill PDF preview dialog opens.
  6. Verify offline banner appears when network is disconnected and disappears when reconnected.

