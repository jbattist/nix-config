{ config, pkgs, lib, ... }:

{
  # ============================================
  # GTK - Breeze Dark
  # ============================================
  gtk = {
    enable = true;
    theme = { name = "Breeze-Dark"; package = pkgs.kdePackages.breeze-gtk; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "breeze_cursors"; package = pkgs.kdePackages.breeze; size = 24; };
    font = { name = "Inter"; size = 11; };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # ============================================
  # QT - Breeze Dark
  # ============================================
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = { name = "breeze"; package = pkgs.kdePackages.breeze; };
  };

  # ============================================
  # CURSOR
  # ============================================
  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
    gtk.enable = true;
  };

  home.packages = with pkgs; [ papirus-icon-theme kdePackages.breeze-icons hicolor-icon-theme ];

  # ============================================
  # KDE PLASMA CONFIG
  # ============================================
  xdg.configFile = {
    "kdeglobals".text = ''
      [General]
      ColorScheme=BreezeDark
      Name=Breeze Dark

      [Icons]
      Theme=Papirus-Dark

      [KDE]
      LookAndFeelPackage=org.kde.breezedark.desktop
      widgetStyle=Breeze
    '';

    "plasmarc".text = ''
      [Theme]
      name=breeze-dark
    '';

    "kwinrc".text = ''
      [Compositing]
      Backend=OpenGL
      GLCore=true

      [Desktops]
      Number=4
      Rows=1

      [NightColor]
      Active=false
    '';

    # Power - no timeouts, no locks
    "powermanagementprofilesrc".text = ''
      [AC]
      icon=battery-charging

      [AC][DPMSControl]
      idleTime=0
      lockBeforeTurnOff=0

      [AC][DimDisplay]
      idleTime=0

      [AC][HandleButtonEvents]
      lidAction=0
      powerButtonAction=0
      powerDownAction=0
      triggerLidActionWhenExternalMonitorPresent=false

      [AC][SuspendAndShutdown]
      AutoSuspendAction=0
      AutoSuspendIdleTimeoutSec=0
      PowerButtonAction=0

      [Battery]
      icon=battery-060

      [Battery][DPMSControl]
      idleTime=0
      lockBeforeTurnOff=0

      [Battery][DimDisplay]
      idleTime=0

      [Battery][HandleButtonEvents]
      lidAction=0
      powerButtonAction=0
      powerDownAction=0
      triggerLidActionWhenExternalMonitorPresent=false

      [Battery][SuspendAndShutdown]
      AutoSuspendAction=0
      AutoSuspendIdleTimeoutSec=0
      PowerButtonAction=0

      [LowBattery]
      icon=battery-low

      [LowBattery][DPMSControl]
      idleTime=0
      lockBeforeTurnOff=0

      [LowBattery][DimDisplay]
      idleTime=0

      [LowBattery][HandleButtonEvents]
      lidAction=0
      powerButtonAction=0
      powerDownAction=0

      [LowBattery][SuspendAndShutdown]
      AutoSuspendAction=0
      AutoSuspendIdleTimeoutSec=0
    '';

    # Screen locker disabled
    "kscreenlockerrc".text = ''
      [Daemon]
      Autolock=false
      LockGrace=0
      LockOnResume=false
      Timeout=0
    '';

    "ksmserverrc".text = ''
      [General]
      loginMode=emptySession
    '';

    # NumLock on
    "kcminputrc".text = ''
      [Keyboard]
      NumLock=0
    '';
  };

  # ============================================
  # DCONF
  # ============================================
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Breeze-Dark";
      icon-theme = "Papirus-Dark";
      font-name = "Inter 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
    };
  };
}
