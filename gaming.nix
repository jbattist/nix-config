{ config, pkgs, lib, ... }:

{
  # ============================================
  # STEAM
  # ============================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    
    # Compatibility tools
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # GameMode for performance optimization
  programs.gamemode.enable = true;

  # ============================================
  # GAMING PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    # Proton/Wine
    protonup-qt
    
    # Game utilities
    mangohud
    gamemode
    
    # Controllers
    game-devices-udev-rules
  ];

  # Better gaming performance
  boot.kernel.sysctl = {
    # Increase max map count for some games
    "vm.max_map_count" = 2147483642;
  };
}
