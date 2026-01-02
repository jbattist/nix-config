{ inputs, ... }:

{
  imports = [
    ../../modules/system/base.nix
    ../../modules/system/desktop.nix
    # ../../modules/system/gaming.nix

    # Hardware config for this host (generate on the machine):
    ./hardware-configuration.nix

    # Niri NixOS module
    inputs.niri.nixosModules.niri
  ];

  networking.hostName = "crucible-dev";

}
