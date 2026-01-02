{ config, pkgs, lib, dotfiles, ... }:

{
  # ============================================
  # NIRI ECOSYSTEM PACKAGES
  # ============================================
  home.packages = with pkgs; [
    # Launcher
    fuzzel
    
    # Notifications
    mako
    
    # Lock screen
    swaylock-effects
    swayidle
    
    # Clipboard
    wl-clipboard
    cliphist
    
    # Screenshot
    grim
    slurp
    
    # Display
    wlr-randr
    kanshi
    
    # Wallpaper
    swaybg
    
    # Night light
    wlsunset
  ];

  # ============================================
  # SWAYLOCK
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

  # ============================================
  # SWAYIDLE
  # ============================================
  services.swayidle = {
    enable = true;
    
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
    
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };

  # ============================================
  # KANSHI - Auto display config
  # ============================================
  services.kanshi = {
    enable = true;
    # Add your display profiles in settings
  };

  # ============================================
  # WLSUNSET - Night light
  # ============================================
  services.wlsunset = {
    enable = true;
    latitude = "42.99";   # Manchester, NH
    longitude = "-71.45";
    temperature = {
      day = 6500;
      night = 3500;
    };
  };

  # ============================================
  # MAKO - Notifications
  # ============================================
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
  # WALLPAPER SERVICE
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
