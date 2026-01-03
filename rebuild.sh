#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-$(hostname)}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Repo: $REPO_ROOT"
echo "==> Host: $HOST"

cd "$REPO_ROOT"

# --- sanity checks ------------------------------------------------------------

if [[ ! -f flake.nix ]]; then
  echo "ERROR: flake.nix not found in repo root" >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: repo is not a git repository" >&2
  exit 1
fi

# --- update flake locks -------------------------------------------------------

echo "==> Updating flake inputs (including dotfiles)"
sudo nix flake update 

# Stage lockfile if it changed
git add flake.lock || true

if ! git diff --cached --quiet; then
  echo "==> Committing updated flake.lock"
  git commit -m "Update flake inputs"
else
  echo "==> No flake.lock changes"
fi

# --- rebuild -----------------------------------------------------------------

echo "==> Rebuilding system"
sudo nixos-rebuild switch --flake ".#${HOST}"

echo "==> Done"
