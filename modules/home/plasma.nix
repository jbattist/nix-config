{ config, pkgs, dotfiles, ... }:

{
  # KDE/Plasma appearance settings
  xdg.configFile."kdeglobals".source =
    dotfiles + "/plasma/kdeglobals";
  xdg.configFile."kdeglobals".force = true;  # Force overwrite

  #KDE Power settings
    xdg.configFile."powerdevilrc".source =
    dotfiles + "/plasma/powerdevilrc";
  xdg.configFile."powerdevilrc".force = true;  # Force overwrite



  # Wallpapers (XDG data, Plasma-friendly)
  xdg.dataFile."wallpapers".source =
    dotfiles + "/wallpapers/.local/share/wallpapers";
  xdg.dataFile."wallpapers".force = true;  # Force overwrite

  # Optional (usually safe, smaller scope than appletsrc)
  # xdg.configFile."plasmarc".source =
  #   dotfiles + "/kde/config/plasmarc";

  # Avoid unless you want to fully lock panel/widget layout:
  # xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".source =
  #   dotfiles + "/kde/config/plasma-org.kde.plasma.desktop-appletsrc";

}