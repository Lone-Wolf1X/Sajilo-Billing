#!/usr/bin/env bash
#
# Graceful shutdown with SIGTERM, fallback to SIGKILL.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${ROOT_DIR}/run/saisa.pid"
GRACE_PERIOD=30

if [[ ! -f "${PID_FILE}" ]]; then
    echo "No PID file found. Nothing to stop."
    exit 0
fi

PID=$(cat "${PID_FILE}")

if ! kill -0 "${PID}" 2>/dev/null; then
    echo "Process ${PID} not running. Removing stale PID file."
    rm -f "${PID_FILE}"
    exit 0
fi

echo "Sending SIGTERM to PID ${PID}..."
kill -TERM "${PID}"

# Wait for graceful exit
WAITED=0
while kill -0 "${PID}" 2>/dev/null && (( WAITED < GRACE_PERIOD )); do
    sleep 1
    WAITED=$((WAITED + 1))
done

if kill -0 "${PID}" 2>/dev/null; then
    echo "WARNING: Process did not exit after ${GRACE_PERIOD}s. Sending SIGKILL..."
    kill -KILL "${PID}"
    sleep 1
fi

rm -f "${PID_FILE}"
echo "Stopped."

