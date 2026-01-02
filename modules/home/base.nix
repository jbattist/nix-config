{ config, pkgs, dotfiles, ... }:

{
  imports = [
    ./shell.nix
  ];

  home.username = "joe";
  home.homeDirectory = "/home/joe";

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
