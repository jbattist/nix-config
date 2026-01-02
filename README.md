# Joe's NixOS Configuration

NixOS flake with SDDM + Niri + Noctalia shell.

## Packages

### Shell
- git, zsh, starship, fzf
- zsh-autosuggestions, zsh-syntax-highlighting
- eza, zoxide, stow, fastfetch, ghostty

### Desktop
- fuzzel, niri, noctalia-shell
- ttf-jetbrains-mono, ttf-inter, ttf-jetbrains-mono-nerd
- nemo, resources, matugen
- cups (printing)

### Apps
- vscode, obsidian, firefox, ferdium, steam

### Wallpapers
- Loaded from dotfiles repo

## Structure

```
nix-config/
├── flake.nix
├── hosts/default/
│   ├── configuration.nix
│   └── hardware-configuration.nix  # REPLACE WITH YOURS
├── modules/nixos/
│   ├── desktop.nix      # SDDM, Niri, audio, graphics
│   └── gaming.nix       # Steam, gamemode
└── home/
    ├── home.nix         # Apps, dotfiles links
    ├── programs/
    │   ├── shell.nix    # Zsh, starship, fzf, eza, zoxide
    │   └── git.nix
    └── desktop/
        ├── niri.nix     # Lock, idle, notifications
        └── theming.nix  # GTK, Qt, cursors
```

## Install

```bash
# 1. Clone
git clone https://github.com/jbattist/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config

# 2. Generate hardware config
sudo nixos-generate-config --show-hardware-config > hosts/default/hardware-configuration.nix

# 3. Update git email
nano home/programs/git.nix

# 4. Build
sudo nixos-rebuild switch --flake .#default

# 5. Reboot
sudo reboot
```

## NFS Mount

TrueNAS share auto-mounts at `/mnt/truenas/home` (symlinked to `~/TrueNAS`).

Make sure `truenas` resolves to your TrueNAS IP, or edit `hosts/default/configuration.nix` to use the IP directly.

## Noctalia

Noctalia-shell isn't in nixpkgs. Options:
1. Build from source and add as overlay
2. Use your dotfiles config with matugen for color generation
3. Package it yourself

## Daily Use

```bash
rebuild   # Rebuild system
update    # Update flake inputs
clean     # Garbage collect
ff        # fastfetch
```
