#!/usr/bin/env bash
set -euo pipefail

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
HOST_DIR="${HOSTS_DIR}/${TARGET_HOST}"

echo "==> Repo root: ${REPO_ROOT}"
echo "==> New host:  ${TARGET_HOST}"

# --- sanity checks ------------------------------------------------------------

if [[ ! -f "${REPO_ROOT}/flake.nix" ]]; then
  echo "ERROR: flake.nix not found in repo root." >&2
  exit 1
fi

if [[ -d "${HOST_DIR}" ]]; then
  echo "ERROR: host directory already exists: ${HOST_DIR}" >&2
  exit 1
fi

# --- create directories -------------------------------------------------------

echo "==> Creating hosts directory (if needed)"
mkdir -p "${HOSTS_DIR}"

echo "==> Creating host directory: ${HOST_DIR}"
mkdir -p "${HOST_DIR}"

# --- hardware configuration ---------------------------------------------------

HW_SRC="/etc/nixos/hardware-configuration.nix"
HW_DST="${HOST_DIR}/hardware-configuration.nix"

if [[ -f "${HW_SRC}" ]]; then
  echo "==> Copying hardware-configuration.nix"
  cp -f "${HW_SRC}" "${HW_DST}"
else
  echo "WARN: ${HW_SRC} not found. You must supply hardware-configuration.nix manually."
fi

# --- create default.nix -------------------------------------------------------

echo "==> Creating ${HOST_DIR}/default.nix"

cat > "${HOST_DIR}/default.nix" <<EOF
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base.nix
    ../../modules/system/plasma.nix
    ../../modules/system/packages.nix

    ../../users/joe.nix
  ];

  networking.hostName = "${TARGET_HOST}";
  system.stateVersion = "25.11";
}
EOF

# --- update flake.nix ----------------------------------------------------------

echo "==> Updating flake.nix nixosConfigurations entry"

# Remove any existing <hostname> placeholder safely
sed -i \
  -e "s|<hostname>|${TARGET_HOST}|g" \
  "${REPO_ROOT}/flake.nix"

# --- done ---------------------------------------------------------------------

echo
echo "✅ Host created successfully:"
echo "   ${HOST_DIR}"
echo
echo "Next build command:"
echo "   sudo nixos-rebuild switch --flake .#${TARGET_HOST}"

if [[ "${NO_REBUILD}" -eq 0 ]]; then
  echo
  echo "==> Running nixos-rebuild..."
  sudo nixos-rebuild switch --flake "${REPO_ROOT}#${TARGET_HOST}"
else
  echo
  echo "==> Skipping rebuild (--no-rebuild)"
fi
