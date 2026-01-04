{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base.nix
    ../../modules/system/plasma.nix
    ../../modules/system/packages.nix

    ../../users/joe.nix
  ];

  networking.hostName = "crucible";
  system.stateVersion = "25.11";

  # ---- bootloader (UEFI) ----
  boot.loader.grub.enable = false;            # prevent GRUB assertion
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
