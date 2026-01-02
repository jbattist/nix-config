{ config, pkgs, ... }:

{
  users.users.joe = {
    isNormalUser = true;
    description = "Joe";
    extraGroups = [ "wheel" "networkmanager" "lp" "scanner" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
