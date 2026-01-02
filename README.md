# Joe's NixOS Config

SDDM + Niri + KDE Plasma 6 (Wayland only)

## Install

export NIX_CONFIG="experimental-features = nix-command flakes"
git clone https://github.com/jbattist/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
# Edit git.nix with your email
sudo nixos-rebuild switch --flake .#default
sudo reboot

## Sessions

- **Niri** (default) - Scrollable tiling
- **Plasma** - KDE Plasma 6 Wayland

## Aliases

rebuild   # Rebuild system
update    # Update flake
clean     # Garbage collect
ff        # fastfetch

## NFS

TrueNAS mounts at `/mnt/truenas/home` → `~/TrueNAS`
