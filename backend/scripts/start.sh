#!/usr/bin/env bash
#
# Start SAISA in production mode.
# Uses nohup + PID file for background operation.
# For systemd-based deployments, prefer systemctl start saisa.
#
set -euo pipefail

# Ensure standard tools and Java 21 in PATH
export PATH="/usr/local/bin:${PATH}"
if [[ -z "${JAVA_HOME:-}" && -d "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home" ]]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
    export PATH="${JAVA_HOME}/bin:${PATH}"
elif [[ -n "${JAVA_HOME:-}" && ":${PATH}:" != *":${JAVA_HOME}/bin:"* ]]; then
    export PATH="${JAVA_HOME}/bin:${PATH}"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

JAR="${ROOT_DIR}/dist/saisa-app.jar"
PID_FILE="${ROOT_DIR}/run/saisa.pid"
LOG_DIR="${LOG_DIR:-${ROOT_DIR}/logs}"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
HEAP_MB="${HEAP_MB:-1024}"

# --------------------------------------------
# Pre-flight checks
# --------------------------------------------
if [[ ! -f "${JAR}" ]]; then
    echo "ERROR: ${JAR} not found. Run scripts/build.sh first." >&2
    exit 1
fi

mkdir -p "$(dirname "${PID_FILE}")" "${LOG_DIR}"

if [[ -f "${PID_FILE}" ]]; then
    PID=$(cat "${PID_FILE}")
    if kill -0 "${PID}" 2>/dev/null; then
        echo "ERROR: SAISA already running (PID ${PID}). Use stop.sh first." >&2
        exit 1
    fi
    echo "Removing stale PID file"
    rm -f "${PID_FILE}"
fi

# Load environment file if present
if [[ -f "${ENV_FILE}" ]]; then
    echo "Loading env from ${ENV_FILE}"
    set -a
    source "${ENV_FILE}"
    set +a
fi

# Required env vars
: "${SPRING_PROFILES_ACTIVE:=prod}"
export SPRING_PROFILES_ACTIVE

if [[ -z "${DB_URL:-}" ]]; then
    echo "ERROR: DB_URL not set. Provide in .env or environment." >&2
    exit 1
fi
if [[ -z "${DB_USERNAME:-}" ]]; then
    echo "ERROR: DB_USERNAME not set." >&2
    exit 1
fi
if [[ -z "${JWT_SECRET:-}" ]]; then
    echo "ERROR: JWT_SECRET not set." >&2
    exit 1
fi

# Derived
export LOG_DIR
export LOGGING_FILE_NAME="${LOG_DIR}/saisa-app.log"
export SPRING_DATASOURCE_URL="${DB_URL}"
export SPRING_DATASOURCE_USERNAME="${DB_USERNAME}"
export SPRING_DATASOURCE_PASSWORD="${DB_PASSWORD:-}"

# --------------------------------------------
# Start JVM
# --------------------------------------------
JAVA_OPTS=(
    "-Xms${HEAP_MB}m"
    "-Xmx${HEAP_MB}m"
    "-XX:+UseG1GC"
    "-XX:MaxGCPauseMillis=200"
    "-XX:+HeapDumpOnOutOfMemoryError"
    "-XX:HeapDumpPath=${LOG_DIR}"
    "-Djava.security.egd=file:/dev/./urandom"
    "-Duser.timezone=UTC"
    "-Dfile.encoding=UTF-8"
)

echo "==========================================="
echo "  Starting SAISA"
echo "==========================================="
echo "JAR:      ${JAR}"
echo "Logs:     ${LOGGING_FILE_NAME}"
echo "Heap:     ${HEAP_MB} MB"
echo "Profile:  ${SPRING_PROFILES_ACTIVE}"
echo "PID file: ${PID_FILE}"
echo "==========================================="

nohup java "${JAVA_OPTS[@]}" -jar "${JAR}" \
    > "${LOG_DIR}/stdout.log" 2>&1 &

NEW_PID=$!
echo "${NEW_PID}" > "${PID_FILE}"

# --------------------------------------------
# Wait for startup
# --------------------------------------------
echo "Waiting for startup (PID ${NEW_PID})..."
MAX_WAIT=60
WAITED=0
while (( WAITED < MAX_WAIT )); do
    if ! kill -0 "${NEW_PID}" 2>/dev/null; then
        echo "ERROR: Process died during startup. Last 50 lines of stdout.log:" >&2
        tail -n 50 "${LOG_DIR}/stdout.log" >&2
        rm -f "${PID_FILE}"
        exit 1
    fi

    if curl -sf -o /dev/null "http://localhost:${SERVER_PORT:-8080}/actuator/health/readiness"; then
        echo "Application is READY (took ${WAITED}s)"
        exit 0
    fi

    sleep 2
    WAITED=$((WAITED + 2))
done

echo "WARNING: Application did not become ready within ${MAX_WAIT}s." >&2
echo "Check logs: tail -f ${LOGGING_FILE_NAME}" >&2
exit 1

