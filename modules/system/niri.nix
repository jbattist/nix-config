{ config, pkgs, lib, ... }:

{
  # Enable Niri (NixOS module)
  programs.niri.enable = true;  # :contentReference[oaicite:4]{index=4}

  # Useful basics for a working Niri session
  environment.systemPackages = with pkgs; [
    fuzzel              # launcher (common in Niri examples) :contentReference[oaicite:5]{index=5}
    xwayland-satellite  # for X11 apps under Wayland (often needed) :contentReference[oaicite:6]{index=6}
    quickshell 
    gpu-screen-recorder 
    brightnessctl
    cliphist
    matugen-git
    cava
    wlsunset
    xdg-desktop-portal
    python3
    evolution-data-server
    polkit-kde-agent
    
  ];
}
