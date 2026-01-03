# 🧊 NixOS Configuration — Battistello Workspace

This repository contains my **modular, flake-based NixOS configuration**, designed to be:

- reproducible
- layered by responsibility
- safe to extend (V2, V3…)
- friendly to experimentation without breaking the base

It is intentionally split into **system**, **home**, and **dotfiles** concerns.

---

## 🧭 Repository Philosophy

> **System defines capabilities.  
> Home defines behavior.  
> Dotfiles define taste.**

---

## 📁 Repository Structure

```
.
├── flake.nix
├── flake.lock
├── new-host.sh
├── hosts/
│   └── <hostname>/
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system/
│   │   ├── base.nix
│   │   ├── plasma.nix
│   │   └── packages.nix
│   └── home/
│       ├── base.nix
│       ├── shell.nix
│       └── plasma.nix
└── README.md
```

---

## 🧱 What Goes Where

### hosts/<hostname>/
Host-specific configuration only:
- hostname
- bootloader
- hardware configuration

---

### modules/system/
Machine-wide capabilities:
- bootloader
- kernel & drivers
- display managers / DEs
- fonts (installed)
- printing
- system packages

---

### modules/home/
User behavior and preferences:
- shell & prompt
- terminal config
- Plasma appearance
- wallpapers
- dotfiles wiring

---

## 🆕 Creating a New Host

```
./new-host.sh <hostname>
```

If no hostname is provided, the current hostname is used.

The script:
- creates a new host directory
- copies hardware configuration
- commits changes
- rebuilds the system

---

## 🧪 Command Cheat Sheet

Rebuild system:
```
sudo nixos-rebuild switch --flake .#<hostname>
```

Update all inputs:
```
nix flake update
```

Update dotfiles only:
```
nix flake lock --update-input dotfiles
```

Restart Plasma:
```
kquitapp6 plasmashell
plasmashell &
```

---

## 🔒 Important Notes

- Flake inputs are **locked**
- Local dotfiles changes require updating the lock file
- For rapid iteration, switch dotfiles input to a local path and rebuild with `--impure`

---

## 🏷 Versioning

- v1: KDE + shell baseline
- v2: Niri + Noctalia

Tag releases once stable.

---

**Once tagged, V1 is immutable.**
