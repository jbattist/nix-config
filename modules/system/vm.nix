{ config, pkgs, lib, ... }:

{
  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    spice-vdagent
  ];
}