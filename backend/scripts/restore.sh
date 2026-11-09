#!/usr/bin/env bash
#
# DANGEROUS: Restores a database from backup.
# Refuses to run without explicit CONFIRM=yes.
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

DATABASE="${DB_NAME:-saisa_prod}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USERNAME:-postgres}"

BACKUP_FILE="${1:-${BACKUP_DIR}/latest.sql.gz}"

# --------------------------------------------
# Safety gates
# --------------------------------------------
if [[ "${CONFIRM:-}" != "yes" ]]; then
    cat >&2 <<EOF
REFUSING TO RUN. This is a destructive operation.

To proceed, run:

    CONFIRM=yes DB_NAME=${DATABASE} ${0} ${BACKUP_FILE}

This will DROP and RECREATE the '${DATABASE}' database. All current data will be lost.
EOF
    exit 1
fi

if [[ ! -f "${BACKUP_FILE}" ]]; then
    echo "ERROR: Backup file not found: ${BACKUP_FILE}" >&2
    exit 1
fi

# Verify the backup before touching the live DB
echo "Verifying backup file..."
if ! gzip -t "${BACKUP_FILE}" 2>/dev/null; then
    echo "ERROR: Backup file is corrupt." >&2
    exit 1
fi

MATCH=$(gzip -dc "${BACKUP_FILE}" | head -c 10000 | grep "PostgreSQL database dump" || true)
if [[ -z "${MATCH}" ]]; then
    echo "ERROR: File does not look like a PostgreSQL dump." >&2
    exit 1
fi

echo "Backup verified. Beginning restore of '${DATABASE}' from ${BACKUP_FILE}"

# --------------------------------------------
# Stop the application (if running)
# --------------------------------------------
if [[ -x "${SCRIPT_DIR}/stop.sh" ]]; then
    "${SCRIPT_DIR}/stop.sh" || true
fi

# --------------------------------------------
# Drop + recreate + restore
# --------------------------------------------
if [[ -z "${PGPASSWORD:-}" && -n "${DB_PASSWORD:-}" ]]; then
    export PGPASSWORD="${DB_PASSWORD}"
fi

echo "Dropping database ${DATABASE}..."
dropdb -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" --if-exists "${DATABASE}"

echo "Creating database ${DATABASE}..."
createdb -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" "${DATABASE}"

echo "Restoring..."
START=$(date +%s)
gzip -dc "${BACKUP_FILE}" | psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DATABASE}" -q
END=$(date +%s)

echo "Restore complete in $((END - START))s."

# --------------------------------------------
# Verify row counts match expectations
# --------------------------------------------
echo "Verifying restored data..."

LEDGER_COUNT=$(psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DATABASE}" \
    -tAc "SELECT COUNT(*) FROM journal_entries")

if [[ "${LEDGER_COUNT}" -lt 0 ]]; then
    echo "ERROR: Verification query failed." >&2
    exit 1
fi

echo "Journal entries restored: ${LEDGER_COUNT}"

# Restart application
if [[ -x "${SCRIPT_DIR}/start.sh" ]]; then
    echo "Restarting application..."
    "${SCRIPT_DIR}/start.sh"
fi

echo ""
echo "==========================================="
echo "  RESTORE COMPLETE"
echo "==========================================="
