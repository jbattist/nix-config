#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./new-host.sh
#   ./new-host.sh myhostname
#   ./new-host.sh --no-rebuild
#   ./new-host.sh myhostname --no-rebuild

NO_REBUILD=0
TARGET_HOST=""

for arg in "$@"; do
  case "$arg" in
    --no-rebuild) NO_REBUILD=1 ;;
    *) TARGET_HOST="$arg" ;;
  esac
done

if [[ -z "${TARGET_HOST}" ]]; then
  TARGET_HOST="$(hostname)"
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTS_DIR="${REPO_ROOT}/hosts"
TEMPLATE_DIR="${HOSTS_DIR}/<hostname>"
NEW_DIR="${HOSTS_DIR}/${TARGET_HOST}"

echo "==> Repo: ${REPO_ROOT}"
echo "==> Target host: ${TARGET_HOST}"

if [[ ! -d "${HOSTS_DIR}" ]]; then
  echo "ERROR: hosts/ directory not found at: ${HOSTS_DIR}" >&2
  exit 1
fi

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
  echo "ERROR: template host directory not found: ${TEMPLATE_DIR}" >&2
  echo "Expected: hosts/<hostname> to exist." >&2
  exit 1
fi

if [[ -d "${NEW_DIR}" ]]; then
  echo "ERROR: host directory already exists: ${NEW_DIR}" >&2
  exit 1
fi

echo "==> Creating new host directory..."
cp -a "${TEMPLATE_DIR}" "${NEW_DIR}"

# Try to populate hardware config from a fresh install
HW_SRC="/etc/nixos/hardware-configuration.nix"
HW_DST="${NEW_DIR}/hardware-configuration.nix"

if [[ -f "${HW_SRC}" ]]; then
  echo "==> Copying hardware-configuration.nix from ${HW_SRC}"
  cp -f "${HW_SRC}" "${HW_DST}"
else
  echo "WARN: ${HW_SRC} not found. Leaving template hardware-configuration.nix as-is (if present)."
fi

echo "==> Replacing <hostname> placeholders..."
# Replace in flake.nix
if [[ -f "${REPO_ROOT}/flake.nix" ]]; then
  sed -i "s/<hostname>/${TARGET_HOST}/g" "${REPO_ROOT}/flake.nix"
else
  echo "ERROR: flake.nix not found at repo root." >&2
  exit 1
fi

# Replace in host default.nix
if [[ -f "${NEW_DIR}/default.nix" ]]; then
  sed -i "s/<hostname>/${TARGET_HOST}/g" "${NEW_DIR}/default.nix"
else
  echo "ERROR: ${NEW_DIR}/default.nix not found." >&2
  exit 1
fi

echo "==> Done. New host created at: ${NEW_DIR}"
echo "==> Now you can build with:"
echo "    sudo nixos-rebuild switch --flake .#${TARGET_HOST}"

if [[ "${NO_REBUILD}" -eq 0 ]]; then
  echo "==> Running nixos-rebuild switch..."
  sudo nixos-rebuild switch --flake "${REPO_ROOT}#${TARGET_HOST}"
else
  echo "==> Skipping rebuild (--no-rebuild)."
fi
