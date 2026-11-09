#!/usr/bin/env bash
#
# Daily database backup with verification, compression, and retention.
#
# Run via cron:
#   0 2 * * * /path/to/saisa-accounting/scripts/backup.sh >> /var/log/saisa/backup.log 2>&1
#
set -euo pipefail

# Ensure standard tools in PATH
export PATH="/usr/local/bin:${PATH}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Load environment file if present
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
if [[ -f "${ENV_FILE}" ]]; then
    set -a
    source "${ENV_FILE}"
    set +a
fi

BACKUP_DIR="${BACKUP_DIR:-${ROOT_DIR}/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DATABASE="${DB_NAME:-saisa_prod}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USERNAME:-postgres}"

# --------------------------------------------
# Pre-flight checks
# --------------------------------------------
if ! command -v pg_dump >/dev/null 2>&1; then
    echo "ERROR: pg_dump not found in PATH" >&2
    exit 1
fi

if ! command -v gzip >/dev/null 2>&1; then
    echo "ERROR: gzip not found in PATH" >&2
    exit 1
fi

mkdir -p "${BACKUP_DIR}"

# Ensure we don't leak the password via command line
if [[ -z "${PGPASSWORD:-}" && -n "${DB_PASSWORD:-}" ]]; then
    export PGPASSWORD="${DB_PASSWORD}"
fi

BACKUP_FILE="${BACKUP_DIR}/saisa-${DATABASE}-${TIMESTAMP}.sql.gz"
TEMP_FILE="${BACKUP_FILE}.partial"

echo "==========================================="
echo "  SAISA Database Backup"
echo "==========================================="
echo "Source:     ${DB_USER}@${DB_HOST}:${DB_PORT}/${DATABASE}"
echo "Target:     ${BACKUP_FILE}"
echo "Retention:  ${RETENTION_DAYS} days"
echo "==========================================="

# --------------------------------------------
# Dump
# --------------------------------------------
echo "Starting dump..."
START_TIME=$(date +%s)

pg_dump \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DATABASE}" \
    --format=plain \
    --no-owner \
    --no-privileges \
    --verbose \
    2> "${BACKUP_DIR}/pg_dump.log" \
    | gzip -9 > "${TEMP_FILE}"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [[ ! -s "${TEMP_FILE}" ]]; then
    echo "ERROR: Backup file is empty. pg_dump failed." >&2
    tail -n 20 "${BACKUP_DIR}/pg_dump.log" >&2
    rm -f "${TEMP_FILE}"
    exit 1
fi

# --------------------------------------------
# Verify: decompress and grep for known content
# --------------------------------------------
echo "Verifying backup integrity..."

if ! gzip -t "${TEMP_FILE}" 2>/dev/null; then
    echo "ERROR: Backup file is corrupt (gzip test failed)." >&2
    rm -f "${TEMP_FILE}"
    exit 1
fi

# A real sanity check: table definitions must be present
MATCH=$(gzip -dc "${TEMP_FILE}" | grep "CREATE TABLE public.journal_entries" || true)
if [[ -z "${MATCH}" ]]; then
    echo "ERROR: Backup missing expected tables. Dump may be incomplete." >&2
    rm -f "${TEMP_FILE}"
    exit 1
fi

# Move completed backup into place (atomic)
mv "${TEMP_FILE}" "${BACKUP_FILE}"

SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
echo ""
echo "==========================================="
echo "  BACKUP SUCCESS"
echo "==========================================="
echo "File:      ${BACKUP_FILE}"
echo "Size:      ${SIZE}"
echo "Duration:  ${DURATION}s"
echo "==========================================="

# --------------------------------------------
# Retention: remove backups older than RETENTION_DAYS
# --------------------------------------------
echo "Pruning backups older than ${RETENTION_DAYS} days..."
REMOVED=$(find "${BACKUP_DIR}" -name 'saisa-*.sql.gz' -type f \
    -mtime +"${RETENTION_DAYS}" -print -delete | wc -l | tr -d ' ')
echo "Pruned ${REMOVED} old backup(s)."

# --------------------------------------------
# Latest backup symlink
# --------------------------------------------
ln -sfn "$(basename "${BACKUP_FILE}")" "${BACKUP_DIR}/latest.sql.gz"

echo ""
echo "Latest:    ${BACKUP_DIR}/latest.sql.gz"
echo "Done."
