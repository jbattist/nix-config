{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Plasma-default fontconfig defaults (we'll override for different DEs later) - or move to base for systemwide
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Inter" ];
    monospace = [ "JetBrains Mono" ];
    serif = [ "Inter" ];
  };

}
