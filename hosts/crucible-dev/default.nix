{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base.nix
    ../../modules/system/plasma.nix
    ../../modules/system/packages.nix

    ../../users/joe.nix

     ../../modules/system/vm.nix   # 👈 VM-only
  ];

  networking.hostName = "crucible-dev";
  system.stateVersion = "25.11";

  # ---- bootloader (BIOS / legacy) ----
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
}
