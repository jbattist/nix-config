{ config, pkgs, lib, inputs, username, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./niri.nix
    ./theming.nix

    # Noctalia Shell Home Manager module (exposes `programs.noctalia-shell.*`)
    inputs.noctalia.homeModules.default
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    # User-facing apps & utilities that are better as "home" packages.
    # (System-wide things like Plasma, printing, Steam, etc. belong in NixOS modules.)
    packages = with pkgs; [
      # Shell / dotfiles tooling
      fastfetch
      stow

      # Theming
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Apps
      vscode
      obsidian
      firefox
      ferdium
      filen-desktop

      # Utilities you actually use interactively
      pavucontrol
      brightnessctl
      playerctl
      networkmanagerapplet
      imv
    ];

    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "ghostty";
    };

    # TrueNAS symlink (kept as-is; this is explicitly out-of-store)
    file."TrueNAS".source = config.lib.file.mkOutOfStoreSymlink "/mnt/truenas/home";
  };

  # Noctalia Shell (package + app2unit integration come from the module defaults)
  programs.noctalia-shell.enable = true;

  # Stow-based dotfiles repo (2nd repo): clone to ~/dotfiles and keep it editable.
  #
  # Expected layout example:
  #   ~/dotfiles/ghostty/.config/ghostty/...
  #   ~/dotfiles/starship/.config/starship.toml
  #   ~/dotfiles/wallpapers/.local/share/wallpapers/...
  home.activation.stowDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "$HOME/dotfiles" ]; then
      ${pkgs.stow}/bin/stow \
        --dir "$HOME/dotfiles" \
        --target "$HOME" \
        --restow \
        ghostty starship mango noctalia wallpapers niri zsh || true
    fi
  '';

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "inode/directory" = "nemo.desktop";
      };
    };
  };

  services.cliphist.enable = true;
}
