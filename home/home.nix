{ config, pkgs, lib, inputs, dotfiles, username, ... }:

{
  imports = [
    ./programs/shell.nix
    ./programs/git.nix
    ./desktop/niri.nix
    ./desktop/theming.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    # ============================================
    # USER PACKAGES
    # ============================================
    packages = with pkgs; [
      # === SHELL ===
      fastfetch
      stow
      
      # === DESKTOP ===
      fuzzel
      # noctalia-shell - install from your dotfiles/AUR
      inputs.matugen.packages.${pkgs.system}.default
      
      # === APPS ===
      vscode
      obsidian
      firefox
      ferdium
      
      # === UTILITIES ===
      pavucontrol      # Audio control
      brightnessctl    # Brightness
      playerctl        # Media controls
      networkmanagerapplet
      
      # Image viewer
      imv
    ];

    # ============================================
    # DOTFILES FROM REPO
    # ============================================
    file = {
      # Fastfetch
      ".config/fastfetch" = {
        source = "${dotfiles}/fastfetch/.config/fastfetch";
        recursive = true;
      };
      
      # Fuzzel
      ".config/fuzzel" = {
        source = "${dotfiles}/fuzzel/.config/fuzzel";
        recursive = true;
      };
      
      # Niri
      ".config/niri" = {
        source = "${dotfiles}/niri/.config/niri";
        recursive = true;
      };
      
      # Ghostty
      ".config/ghostty" = {
        source = "${dotfiles}/ghostty/.config/ghostty";
        recursive = true;
      };
      
      # Starship
      ".config/starship.toml" = {
        source = "${dotfiles}/starship/.config/starship.toml";
      };
      
      # Mango
      ".config/mango" = {
        source = "${dotfiles}/mango/.config/mango";
        recursive = true;
      };
      
      # Noctalia
      ".config/noctalia" = {
        source = "${dotfiles}/noctalia/.config/noctalia";
        recursive = true;
      };
      
      # Wallpapers
      ".local/share/wallpapers" = {
        source = "${dotfiles}/wallpapers/.local/share/wallpapers";
        recursive = true;
      };
      
      # Custom icons
      ".local/share/icons/jbmenu.svg".source = "${dotfiles}/jbmenu.svg";
      ".local/share/icons/jbmenu-tokyo.svg".source = "${dotfiles}/jbmenu-tokyo.svg";
      ".local/share/icons/Bulb.png".source = "${dotfiles}/Bulb.png";
    };

    # ============================================
    # SESSION VARIABLES
    # ============================================
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
      TERMINAL = "ghostty";
    };

    # ============================================
    # SYMLINKS
    # ============================================
    file."TrueNAS".source = config.lib.file.mkOutOfStoreSymlink "/mnt/truenas/home";
  };

  programs.home-manager.enable = true;

  # ============================================
  # XDG
  # ============================================
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

  # ============================================
  # SERVICES
  # ============================================
  services = {
    mako = {
      enable = true;
      defaultTimeout = 5000;
      borderRadius = 8;
      borderSize = 2;
    };
    
    cliphist.enable = true;
  };
}
