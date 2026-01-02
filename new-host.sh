#!/usr/bin/env bash
set -euo pipefail

TARGET_HOST="${1:-$(hostname)}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTS_DIR="${REPO_ROOT}/hosts"
HOST_DIR="${HOSTS_DIR}/${TARGET_HOST}"
FLAKE="${REPO_ROOT}/flake.nix"

echo "==> Repo root: ${REPO_ROOT}"
echo "==> New host:  ${TARGET_HOST}"

# --- hard requirements -------------------------------------------------------

if [[ ! -f "${FLAKE}" ]]; then
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

# --- determine boot mode ------------------------------------------------------

BOOT_MODE="UEFI"
if [[ ! -d /sys/firmware/efi ]]; then
  BOOT_MODE="BIOS"
fi
echo "==> Detected boot mode: ${BOOT_MODE}"

# For BIOS installs, we MUST know the disk for GRUB.
# Best-effort: pick the parent disk of the root filesystem device.
GRUB_DEVICE="/dev/sda"
if [[ "${BOOT_MODE}" == "BIOS" ]]; then
  ROOT_SRC="$(findmnt -n -o SOURCE / || true)"
  if [[ -n "${ROOT_SRC}" ]]; then
    # e.g. /dev/nvme0n1p2 -> /dev/nvme0n1 ; /dev/sda2 -> /dev/sda
    PARENT="$(lsblk -no PKNAME "${ROOT_SRC}" 2>/dev/null || true)"
    if [[ -n "${PARENT}" ]]; then
      GRUB_DEVICE="/dev/${PARENT}"
    fi
  fi
  echo "==> BIOS mode: using GRUB device guess: ${GRUB_DEVICE}"
fi

# --- create default.nix -------------------------------------------------------

echo "==> Creating default.nix"

if [[ "${BOOT_MODE}" == "UEFI" ]]; then
  BOOT_BLOCK=$(cat <<'EOF'
  # ---- bootloader (UEFI) ----
  boot.loader.grub.enable = false;            # prevent GRUB assertion
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
EOF
)
else
  BOOT_BLOCK=$(cat <<EOF
  # ---- bootloader (BIOS / legacy) ----
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "${GRUB_DEVICE}";
EOF
)
fi

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

${BOOT_BLOCK}
}
EOF

# --- git add + commit (mandatory) ---------------------------------------------

echo "==> Staging all changes"
git -C "${REPO_ROOT}" add -A

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
