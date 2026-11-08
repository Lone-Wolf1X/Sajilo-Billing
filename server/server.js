const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 8080;

// Configurable CORS origins via ALLOWED_ORIGINS env var
const rawAllowedOrigins = process.env.ALLOWED_ORIGINS || 'http://localhost:8080,http://localhost:3000,http://127.0.0.1:8080';
const allowedOrigins = rawAllowedOrigins.split(',').map(s => s.trim()).filter(Boolean);

app.use(cors({
  origin: (origin, callback) => {
    // Allow non-browser clients (desktop curl/Dart) with no origin
    if (!origin) return callback(null, true);
    if (allowedOrigins.indexOf(origin) !== -1 || allowedOrigins.includes('*')) {
      return callback(null, true);
    }
    return callback(new Error(`CORS blocked for origin: ${origin}`));
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
}));

app.use(express.json({ limit: '25mb' }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', time: new Date().toISOString() });
});

// Sync Push endpoint
app.post('/api/sync/push', (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Missing Authorization header with Google ID token' });
  }

  const { clientTimestamp, tables } = req.body;
  console.log(`[SyncServer] Received push from client at ${clientTimestamp}, ${tables?.length || 0} table batches`);

  return res.json({
    status: 'success',
    appliedCount: 0,
    serverTimestamp: new Date().toISOString(),
  });
});

// Sync Pull endpoint
app.get('/api/sync/pull', (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Missing Authorization header with Google ID token' });
  }

  const since = req.query.since || '1970-01-01T00:00:00Z';
  console.log(`[SyncServer] Pull request since ${since}`);

  return res.json({
    status: 'success',
    serverTimestamp: new Date().toISOString(),
    changes: [],
  });
});

app.listen(PORT, () => {
  console.log(`Sajilo Billing Sync Server listening on port ${PORT}`);
  console.log(`Allowed CORS Origins: ${allowedOrigins.join(', ')}`);
});

