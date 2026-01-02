{ inputs, ... }:

{
  imports = [
    ../../modules/system/base.nix
    ../../modules/system/desktop.nix
    ../../modules/system/gaming.nix

    # Prefer vendoring this into the repo per-host, but keep this as a fallback:
    /etc/nixos/hardware-configuration.nix

    # Niri NixOS module
    inputs.niri.nixosModules.niri
  ];
}
