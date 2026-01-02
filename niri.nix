{ config, pkgs, lib, dotfiles, ... }:

{
  # ============================================
  # PACKAGES
  # ============================================
  home.packages = with pkgs; [
    fuzzel mako swaylock-effects wl-clipboard cliphist
    grim slurp wlr-randr kanshi swaybg wlsunset
  ];

  # ============================================
  # SWAYLOCK (manual only)
  # ============================================
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = "1a1b26";
      font = "Inter";
      font-size = 24;
      clock = true;
      timestr = "%H:%M";
      datestr = "%A, %B %d";
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      ring-color = "7aa2f7";
      key-hl-color = "7aa2f7";
      text-color = "c0caf5";
      effect-blur = "7x5";
      fade-in = 0.2;
      screenshots = true;
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };

  # No swayidle - no auto-lock

  # ============================================
  # SERVICES
  # ============================================
  services.kanshi.enable = true;

  services.wlsunset = {
    enable = true;
    latitude = "42.99";
    longitude = "-71.45";
    temperature = { day = 6500; night = 3500; };
  };

  services.mako = {
    enable = true;
    font = "Inter 11";
    width = 350;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 10;
    backgroundColor = "#1a1b26";
    textColor = "#c0caf5";
    borderColor = "#7aa2f7";
    defaultTimeout = 5000;
    maxVisible = 5;
    layer = "overlay";
    anchor = "top-right";
    icons = true;
    maxIconSize = 48;
  };

  # ============================================
  # WALLPAPER
  # ============================================
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i %h/.local/share/wallpapers/default.png";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
