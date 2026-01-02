{ config, pkgs, lib, inputs, username, hostname, ... }:

{
  imports = [
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix
  ];

  # ============================================
  # BOOT & KERNEL
  # ============================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Plymouth for boot splash
    plymouth.enable = true;
    
    # Silent boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # ============================================
  # NETWORKING
  # ============================================
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # ============================================
  # LOCALIZATION
  # ============================================
  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # ============================================
  # USER CONFIGURATION
  # ============================================
  users.users.${username} = {
    isNormalUser = true;
    description = "Joe";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "video" 
      "audio" 
      "input"
      "render"
      "lp"        # Printing
    ];
    shell = pkgs.zsh;
  };

  # ============================================
  # NFS MOUNTS
  # ============================================
  fileSystems."/mnt/truenas/home" = {
    device = "truenas:/home/joe";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "soft"
      "timeo=14"
      "retrans=2"
      "_netdev"
    ];
  };

  services.rpcbind.enable = true;

  # ============================================
  # NIX SETTINGS
  # ============================================
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ============================================
  # PROGRAMS
  # ============================================
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  # ============================================
  # CORE PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    wget
    curl
    vim
    htop
    btop
    tree
    file
    unzip
    zip
    ripgrep
    fd
    jq
    
    # System tools
    pciutils
    usbutils
    nfs-utils
    
    # Stow for dotfiles
    stow
  ];

  # ============================================
  # SECURITY
  # ============================================
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # ============================================
  # FONTS
  # ============================================
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Your specified fonts
      jetbrains-mono
      inter
      nerd-fonts.jetbrains-mono
      
      # Extras for completeness
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
    ];
    
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ============================================
  # PRINTING - CUPS
  # ============================================
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      brlaser
    ];
  };
  
  # Printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ============================================
  # SERVICES
  # ============================================
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.geoclue2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;

  system.stateVersion = "24.11";
}
