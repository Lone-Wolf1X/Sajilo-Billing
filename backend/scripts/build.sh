#!/usr/bin/env bash
#
# Production build script.
# Produces a single executable JAR in dist/.
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

# Resolve backend directory if scripts is placed at repo root or inside backend
if [[ -d "${ROOT_DIR}/saisa-app" ]]; then
    BACKEND_DIR="${ROOT_DIR}"
elif [[ -d "${ROOT_DIR}/backend/saisa-app" ]]; then
    BACKEND_DIR="${ROOT_DIR}/backend"
else
    BACKEND_DIR="${ROOT_DIR}"
fi

DIST_DIR="${ROOT_DIR}/dist"
VERSION="${VERSION:-$(date +%Y%m%d-%H%M%S)}"

echo "==========================================="
echo "  SAISA Accounting - Production Build"
echo "==========================================="
echo "Root:    ${BACKEND_DIR}"
echo "Version: ${VERSION}"
echo "==========================================="

# Ensure maven is available
if ! command -v mvn >/dev/null 2>&1; then
    echo "ERROR: mvn not found in PATH" >&2
    exit 1
fi

# Ensure JDK 21
JAVA_VERSION=$(java -version 2>&1 | head -n 1 | awk -F'"' '{print $2}' | cut -d'.' -f1)
if [[ "${JAVA_VERSION}" != "21" ]]; then
    echo "ERROR: Java 21 required. Found: ${JAVA_VERSION}" >&2
    exit 1
fi

# Clean and build
cd "${BACKEND_DIR}"
mvn -B clean package -DskipTests

# Find the fat JAR produced by saisa-app
JAR=$(find "${BACKEND_DIR}/saisa-app/target" -maxdepth 1 -name "saisa-app-*.jar" \
    ! -name "*-sources.jar" ! -name "*-javadoc.jar" | head -n 1)

if [[ -z "${JAR}" ]]; then
    echo "ERROR: saisa-app JAR not found in target/" >&2
    exit 1
fi

mkdir -p "${DIST_DIR}"
DEST="${DIST_DIR}/saisa-app-${VERSION}.jar"
cp "${JAR}" "${DEST}"

# Create a stable symlink for start.sh
ln -sfn "$(basename "${DEST}")" "${DIST_DIR}/saisa-app.jar"

JAR_SIZE=$(du -h "${DEST}" | cut -f1)
echo ""
echo "==========================================="
echo "  BUILD SUCCESS"
echo "==========================================="
echo "JAR:       ${DEST}"
echo "Size:      ${JAR_SIZE}"
echo "Symlink:   ${DIST_DIR}/saisa-app.jar"
echo ""
echo "Next step: scripts/start.sh"

