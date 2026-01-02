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
      settings = {
        General.Numlock = "on";
        Theme = {
          CursorTheme = "breeze_cursors";
          Font = "Inter";
        };
      };
    };
    defaultSession = "niri";  # Options: "niri", "plasma"
  };

  # ============================================
  # NIRI
  # ============================================
  programs.niri.enable = true;

  # ============================================
  # KDE PLASMA 6 - Wayland Only
  # ============================================
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  # No X11
  services.xserver.enable = false;

  # ============================================
  # XDG PORTAL
  # ============================================
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-kde ];
    config.common.default = "*";
  };

  # ============================================
  # GRAPHICS
  # ============================================
  hardware.graphics = { enable = true; enable32Bit = true; };

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
  hardware.bluetooth = { enable = true; powerOnBoot = true; };
  services.blueman.enable = true;

  # ============================================
  # INPUT
  # ============================================
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad = { naturalScrolling = true; tapping = true; };
  };

  console.keyMap = "us";

  # ============================================
  # PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    # Wayland
    wayland wayland-utils wl-clipboard wlr-randr grim slurp
    
    # Niri ecosystem
    fuzzel mako swaylock-effects swaybg
    
    # File manager
    nemo nemo-fileroller
    
    # System monitor
    resources
    
    # KDE packages
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
    kdePackages.kde-cli-tools
    kdePackages.kio-extras
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.spectacle
    kdePackages.konsole
    kdePackages.kate
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.plasma-systemmonitor
    kdePackages.kscreen
    kdePackages.powerdevil
    kdePackages.bluedevil
    
    # Theming
    libsForQt5.qt5ct qt6ct papirus-icon-theme
  ];
}
