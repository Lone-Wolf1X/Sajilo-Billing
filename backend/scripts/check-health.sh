#!/usr/bin/env bash
#
# Quick health check for monitoring (Nagios, Zabbix, cron alerting).
# Exit 0 = healthy, exit 1 = unhealthy.
#
set -uo pipefail

BASE="${BASE_URL:-http://localhost:8080}"
TIMEOUT="${TIMEOUT:-5}"

fail() {
    echo "UNHEALTHY: $1" >&2
    exit 1
}

# 1. Readiness
READY=$(curl -sf --max-time "${TIMEOUT}" "${BASE}/actuator/health/readiness" 2>/dev/null || echo "")
if ! echo "${READY}" | grep -q '"status":"UP"'; then
    fail "readiness failed: ${READY:-<no response>}"
fi

# 2. Deep DB health
DB=$(curl -sf --max-time "${TIMEOUT}" "${BASE}/actuator/health/dbSchema" 2>/dev/null || curl -sf --max-time "${TIMEOUT}" "${BASE}/actuator/health" 2>/dev/null || echo "")
if ! echo "${DB}" | grep -q '"status":"UP"'; then
    fail "dbSchema failed: ${DB:-<no response>}"
fi

# 3. Response time
if date +%N 2>/dev/null | grep -vq "N"; then
    START=$(date +%s%N)
    curl -sf --max-time "${TIMEOUT}" -o /dev/null "${BASE}/actuator/health" || fail "health basic"
    END=$(date +%s%N)
    MS=$(( (END - START) / 1000000 ))
else
    # macOS fallback
    START_MS=$(perl -MTime::HiRes=time -e 'printf "%d\n", time * 1000')
    curl -sf --max-time "${TIMEOUT}" -o /dev/null "${BASE}/actuator/health" || fail "health basic"
    END_MS=$(perl -MTime::HiRes=time -e 'printf "%d\n", time * 1000')
    MS=$(( END_MS - START_MS ))
fi

if [[ ${MS} -gt 2000 ]]; then
    echo "WARN: health endpoint took ${MS}ms (threshold: 2000ms)" >&2
    exit 1
fi

echo "HEALTHY (response: ${MS}ms)"
exit 0
