# NixOS Configuration

This repository contains my **NixOS + Home Manager configuration**, organized for:

- reproducibility
- multiple machines (hosts)
- safe, intentional upgrades
- clean separation of concerns
- a separate dotfiles repo managed with `stow`

This repo defines **what my systems are**.  
My dotfiles repo defines **how my apps look and behave**.

---

## Repository Structure

```text
nix-config/
├── flake.nix
├── flake.lock
├── README.md
├── scripts/
│   └── new-host
├── hosts/
│   └── <hostname>/
│       ├── default.nix
│       └── hardware-configuration.nix
└── modules/
    ├── system/
    │   ├── base.nix
    │   ├── desktop.nix
    │   └── gaming.nix
    └── home/
        ├── default.nix
        ├── shell.nix
        ├── git.nix
        ├── niri.nix
        └── theming.nix
```

### Key concepts

- **`hosts/`**  
  One folder per machine. Defines *machine identity* and hardware.

- **`modules/`**  
  Reusable capability blocks (desktop, gaming, shell, compositor, etc).

- **`flake.lock`**  
  Pins exact versions of all inputs for reproducibility.

- **Dotfiles**  
  Live in a separate repo (e.g. `~/dotfiles`) and are applied via `stow`.

---

## Applying the Configuration

### Build and switch (system-wide)

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Example:
```bash
sudo nixos-rebuild switch --flake .#crucible-dev
```

### Home Manager only (optional)

```bash
home-manager switch --flake .#joe
```

---

## Creating a New Machine (Host)

### Option A: Using the helper script (recommended)

```bash
./scripts/new-host crucible-dev
```

This will:
- create `hosts/crucible-dev/`
- scaffold `default.nix`
- create a placeholder `hardware-configuration.nix`
- add the host to `flake.nix`

### Option B: Manual setup

1. Create the host directory:
```bash
mkdir -p hosts/crucible-dev
```

2. Generate hardware config **on that machine**:
```bash
sudo nixos-generate-config --show-hardware-config   > hosts/crucible-dev/hardware-configuration.nix
```

3. Create `hosts/crucible-dev/default.nix`:
```nix
{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ../../modules/system/base.nix
    ../../modules/system/desktop.nix
    ../../modules/system/gaming.nix
    inputs.niri.nixosModules.niri
    ./hardware-configuration.nix
  ];

  networking.hostName = "crucible-dev";
}
```

4. Add the host to `flake.nix`:
```nix
nixosConfigurations = {
  crucible-dev = mkHost "crucible-dev";
};
```

5. Build and switch:
```bash
sudo nixos-rebuild switch --flake .#crucible-dev
```

---

## Where to Make Changes

### Add something to **all machines**
- System-wide packages/services → `modules/system/*.nix`
- User environment → `modules/home/*.nix`

Example:
```nix
environment.systemPackages = with pkgs; [ htop ];
```

### Add something to **one machine**
Edit:
```text
hosts/<hostname>/default.nix
```

Example:
```nix
environment.systemPackages = with pkgs; [ lm_sensors ];
```

### Add user-only packages
Edit:
```text
modules/home/default.nix
```

```nix
home.packages = with pkgs; [ obsidian ];
```

---

## Dotfiles Workflow

Dotfiles are **not stored in this repo**.

Expected setup:
```text
~/dotfiles/
├── zsh/
├── ghostty/
├── starship/
├── niri/
├── wallpapers/
```

Applied via:
```bash
stow zsh ghostty starship niri wallpapers
```

Home Manager handles installing the software; `stow` handles config files.

---

## Updating to Newer Versions

This repo uses **flakes + a committed `flake.lock`**.

Updates are **intentional, reviewable, and reversible**.

---

## Update Cheat Sheet

| What you want | Command | What changes |
|--------------|--------|--------------|
| Update everything | `nix flake update` | All inputs |
| Newer **niri** | `nix flake lock --update-input niri` | Wayland compositor |
| Newer **noctalia-shell** | `nix flake lock --update-input noctalia` | Shell only |
| Newer **Home Manager** | `nix flake lock --update-input home-manager` | HM modules |
| Newer apps (Firefox, Steam, VSCode, etc.) | `nix flake lock --update-input nixpkgs` | Packages |
| Undo a bad update | `git checkout -- flake.lock` | Roll back inputs |
| Roll back system state | `sudo nixos-rebuild switch --rollback` | Previous generation |

---

## Recommended Update Workflow

1. Update what you want:
```bash
nix flake lock --update-input nixpkgs
```

2. Review changes:
```bash
git diff flake.lock
```

3. Rebuild:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

4. Commit if successful:
```bash
git add flake.lock
git commit -m "flake: update nixpkgs"
```

If something breaks:
```bash
git checkout -- flake.lock
sudo nixos-rebuild switch --flake .#<hostname>
```

---

## Which Input Controls What?

- **nixpkgs**
  - Firefox
  - Steam
  - VSCode
  - Obsidian
  - Ferdium
  - System libraries and drivers

- **home-manager**
  - Zsh
  - Starship
  - fzf
  - eza
  - zoxide
  - Ghostty

- **niri**
  - Wayland compositor

- **noctalia**
  - Noctalia shell and UI layer

---

## Git Policy

Committed:
- `hosts/<machine>/default.nix`
- `hosts/<machine>/hardware-configuration.nix`
- `flake.lock`

Ignored (recommended):
```gitignore
result
result-*
.nix-build
hosts/*/local.nix
```

Secrets must be handled via `sops-nix`, `agenix`, or similar.

---

## Philosophy

- This repo defines **systems**
- Dotfiles define **preferences**
- Nothing updates unless explicitly requested
- Every change is reversible
- Every machine is reproducible

If it’s not deterministic, it doesn’t belong here.
