{ config, pkgs, lib, ... }:

{
  # ============================================
  # STEAM
  # ============================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  # ============================================
  # PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    protonup-qt mangohud gamemode game-devices-udev-rules
  ];

  boot.kernel.sysctl = { "vm.max_map_count" = 2147483642; };
}
