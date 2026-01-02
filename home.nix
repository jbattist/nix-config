{ config, pkgs, lib, inputs, dotfiles, username, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./niri.nix
    ./theming.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    # ============================================
    # PACKAGES
    # ============================================
    packages = with pkgs; [
      # Shell
      fastfetch stow
      
      # Desktop
      fuzzel
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
      
      # Apps
      vscode obsidian firefox ferdium
      
      # Utilities
      pavucontrol brightnessctl playerctl networkmanagerapplet imv
    ];

    # ============================================
    # DOTFILES
    # ============================================
    file = {
      ".config/fastfetch" = { source = "${dotfiles}/fastfetch/.config/fastfetch"; recursive = true; };
      ".config/fuzzel" = { source = "${dotfiles}/fuzzel/.config/fuzzel"; recursive = true; };
      ".config/niri" = { source = "${dotfiles}/niri/.config/niri"; recursive = true; };
      ".config/ghostty" = { source = "${dotfiles}/ghostty/.config/ghostty"; recursive = true; };
      ".config/starship.toml".source = "${dotfiles}/starship/.config/starship.toml";
      ".config/mango" = { source = "${dotfiles}/mango/.config/mango"; recursive = true; };
      ".config/noctalia" = { source = "${dotfiles}/noctalia/.config/noctalia"; recursive = true; };
      ".local/share/wallpapers" = { source = "${dotfiles}/wallpapers/.local/share/wallpapers"; recursive = true; };
      ".local/share/icons/jbmenu.svg".source = "${dotfiles}/jbmenu.svg";
      ".local/share/icons/jbmenu-tokyo.svg".source = "${dotfiles}/jbmenu-tokyo.svg";
      ".local/share/icons/Bulb.png".source = "${dotfiles}/Bulb.png";
      
      # TrueNAS symlink
      "TrueNAS".source = config.lib.file.mkOutOfStoreSymlink "/mnt/truenas/home";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
      TERMINAL = "ghostty";
    };
  };

  programs.home-manager.enable = true;

  # ============================================
  # XDG
  # ============================================
  xdg = {
    enable = true;
    userDirs = { enable = true; createDirectories = true; };
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
