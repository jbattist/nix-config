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

# --- update flake.nix (append host config if missing) -------------------------

echo "==> Ensuring flake.nix contains nixosConfigurations.\"${TARGET_HOST}\""

if grep -q "nixosConfigurations\\.\"${TARGET_HOST}\"" "${FLAKE}"; then
  echo "==> flake.nix already has host ${TARGET_HOST} (no change)"
else
  # Insert a new nixosConfigurations block right after the first existing one.
  # This assumes your flake has at least one existing nixosConfigurations."<host>" = lib.nixosSystem { ... };
  awk -v host="${TARGET_HOST}" '
    BEGIN { inserted=0 }
    {
      print $0
      if (!inserted && $0 ~ /nixosConfigurations\."[^"]*"\s*=\s*lib\.nixosSystem\s*\{/ ) {
        # After the first host block header, add another sibling host definition
        # by duplicating the same structure but pointing to ./hosts/<host>/default.nix
        print ""
        print "      nixosConfigurations.\"" host "\" = lib.nixosSystem {"
        print "        inherit system;"
        print "        specialArgs = { inherit dotfiles; };"
        print "        modules = ["
        print "          ./hosts/" host "/default.nix"
        print "          home-manager.nixosModules.home-manager"
        print "          {"
        print "            home-manager.useGlobalPkgs = true;"
        print "            home-manager.useUserPackages = true;"
        print "            home-manager.extraSpecialArgs = { inherit dotfiles; };"
        print "            home-manager.users.joe = import ./modules/home/base.nix;"
        print "          }"
        print "        ];"
        print "      };"
        inserted=1
      }
    }
    END {
      if (!inserted) {
        print ""
        print "/*"
        print "ERROR: new-host.sh could not find an existing nixosConfigurations block to copy."
        print "Add at least one nixosConfigurations.\"<host>\" entry first, then rerun."
        print "*/"
      }
    }
  ' "${FLAKE}" > "${FLAKE}.tmp"

  mv "${FLAKE}.tmp" "${FLAKE}"
fi

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
