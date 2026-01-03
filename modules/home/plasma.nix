{ config, pkgs, dotfiles, ... }:

{
  # KDE/Plasma user-level appearance settings.
  # Recommended: keep this limited to theme/colors/fonts at first.

  xdg.configFile."kdeglobals".source =
    dotfiles + "/plasma/kdeglobals";

  # Optional (usually safe, smaller scope than appletsrc)
  # xdg.configFile."plasmarc".source =
  #   dotfiles + "/kde/config/plasmarc";

  # Avoid unless you want to fully lock panel/widget layout:
  # xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".source =
  #   dotfiles + "/kde/config/plasma-org.kde.plasma.desktop-appletsrc";

  # Wallpapers (XDG data, Plasma-friendly)
  xdg.dataFile."wallpapers".source =
    dotfiles + "/wallpapers/.local/share/wallpapers";

}