#!/usr/bin/env bash
set -euo pipefail

TARGET_HOST="${1:-$(hostname)}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTS_DIR="${REPO_ROOT}/hosts"
HOST_DIR="${HOSTS_DIR}/${TARGET_HOST}"

echo "==> Repo root: ${REPO_ROOT}"
echo "==> New host:  ${TARGET_HOST}"

# --- hard requirements -------------------------------------------------------

if [[ ! -f "${REPO_ROOT}/flake.nix" ]]; then
  echo "ERROR: flake.nix not found in repo root." >&2
  exit 1
fi

if ! git -C "${REPO_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: This repo must be a git repository." >&2
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
  echo "WARN: ${HW_SRC} not found; creating placeholder."
  cat > "${HW_DST}" <<'EOF'
{ ... }:
{
  # Placeholder.
  # Copy /etc/nixos/hardware-configuration.nix into this file.
}
EOF
fi

# --- create default.nix -------------------------------------------------------

echo "==> Creating default.nix"

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

# --- update flake.nix ---------------------------------------------------------

echo "==> Updating flake.nix (<hostname> -> ${TARGET_HOST})"

sed -i -e "s|<hostname>|${TARGET_HOST}|g" "${REPO_ROOT}/flake.nix"

# --- git add + commit (mandatory) ---------------------------------------------

echo "==> Staging all changes"
git -C "${REPO_ROOT}" add -A

# Ensure something is staged
if git -C "${REPO_ROOT}" diff --cached --quiet; then
  echo "ERROR: No changes staged; refusing to continue." >&2
  exit 1
fi

echo "==> Committing changes"
git -C "${REPO_ROOT}" commit -m "Add host ${TARGET_HOST}"

# --- rebuild -----------------------------------------------------------------

echo
echo "==> Rebuilding system"
sudo nixos-rebuild switch --flake "${REPO_ROOT}#${TARGET_HOST}"
