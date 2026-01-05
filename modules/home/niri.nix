{ config, pkgs, lib, inputs, dotfiles, ... }:

let
  system = pkgs.system;

  # Noctalia package from flake.
  # If the attribute name differs, run: `nix flake show github:noctalia-dev/noctalia-shell`
  # and swap `.default` accordingly.
  noctaliaPkg = inputs.noctalia.packages.${system}.default;
in
{
  home.packages = [
    noctaliaPkg
  ];

  # --- Niri config from your dotfiles ---
  # Niri's default config location is $XDG_CONFIG_HOME/niri/config.kdl :contentReference[oaicite:9]{index=9}
  xdg.configFile."niri/config.kdl".source =
    dotfiles + "/niri/.config/niri/config.kdl";
  xdg.configFile."niri/config.kdl".force = true;

  # --- Noctalia / Quickshell config from your dotfiles ---
  # Noctalia is built on Quickshell :contentReference[oaicite:10]{index=10}
  # Common location is ~/.config/quickshell/...
  # xdg.configFile."quickshell".source =
  #  dotfiles + "/quickshell/.config/quickshell";
  # xdg.configFile."quickshell".force = true;

  # OPTIONAL: if you prefer to only link Noctalia’s subdir, use this instead:
  # xdg.configFile."quickshell/noctalia-shell".source =
  #   dotfiles + "/noctalia-shell/.config/quickshell/noctalia-shell";
  # xdg.configFile."quickshell/noctalia-shell".force = true;
}
