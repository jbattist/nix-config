{ config, pkgs, lib, ... }:

{
  # ============================================
  # Wayland session helpers (user scope)
  # ============================================
  home.packages = with pkgs; [
    fuzzel
    mako
    wl-clipboard
    cliphist
    grim
    slurp
    wlr-randr
    kanshi
    swaybg
    wlsunset
  ];

  programs.swaylock.enable = true;

  # ============================================
  # Wallpaper daemon (fallback/default)
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

  # ============================================
  # Noctalia Shell (run as a user service)
  # ============================================
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${config.programs.noctalia-shell.package}/bin/noctalia-shell";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
