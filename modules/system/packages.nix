{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    vscode
    ghostty
    nemo
    resources
    tela-icon-theme
    catppuccin-kde
    ferdium
  ];
}
