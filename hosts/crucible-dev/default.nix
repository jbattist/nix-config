{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/base.nix
    ../../modules/system/plasma.nix
    ../../modules/system/packages.nix

    ../../users/joe.nix
  ];

  networking.hostName = "crucible-dev";
  system.stateVersion = "25.11";
}
