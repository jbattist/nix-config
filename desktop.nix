{ config, pkgs, lib, inputs, ... }:

{
  # ============================================
  # DISPLAY MANAGER - SDDM
  # ============================================
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
    };
    defaultSession = "niri";
  };

  # ============================================
  # NIRI - Scrollable Tiling Wayland Compositor
  # ============================================
  programs.niri.enable = true;

  # ============================================
  # XDG PORTAL
  # ============================================
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  # ============================================
  # GRAPHICS
  # ============================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Wayland environment
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # ============================================
  # AUDIO - PipeWire
  # ============================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  hardware.pulseaudio.enable = false;

  # ============================================
  # BLUETOOTH
  # ============================================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
  services.blueman.enable = true;

  # ============================================
  # INPUT
  # ============================================
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad = {
      naturalScrolling = true;
      tapping = true;
    };
  };

  console.keyMap = "us";

  # ============================================
  # DESKTOP PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    wayland-utils
    wl-clipboard
    wlr-randr
    
    # Screenshot
    grim
    slurp
    
    # App launcher - fuzzel
    fuzzel
    
    # File manager - nemo
    nemo
    nemo-fileroller
    
    # System monitor - resources (GNOME)
    resources
    
    # Notifications
    mako
    
    # Screen lock
    swaylock-effects
    swayidle
    
    # Wallpaper
    swaybg
    
    # Theming
    libsForQt5.qt5ct
    qt6ct
    
    # Cursor/icons
    breeze-gtk
    papirus-icon-theme
  ];
}
