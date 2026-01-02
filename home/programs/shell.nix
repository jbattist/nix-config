{ config, pkgs, lib, dotfiles, ... }:

{
  # ============================================
  # ZSH
  # ============================================
  programs.zsh = {
    enable = true;
    
    enableCompletion = true;
    autosuggestion.enable = true;      # zsh-autosuggestions
    syntaxHighlighting.enable = true;  # zsh-syntax-highlighting
    
    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };
    
    initExtra = ''
      # Load custom zshrc from dotfiles if exists
      [[ -f "${dotfiles}/zshrc/.zshrc" ]] && source "${dotfiles}/zshrc/.zshrc"
      
      # Initialize zoxide
      eval "$(zoxide init zsh)"
      
      # Keybindings
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^R' history-incremental-search-backward
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
    '';
    
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Eza (ls replacement)
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      lt = "eza --tree --icons --group-directories-first";
      l = "eza -l --icons --group-directories-first";
      
      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      glog = "git log --oneline --graph --decorate";
      
      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nix-config#default";
      update = "nix flake update ~/.config/nix-config";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      
      # Quick
      ff = "fastfetch";
      c = "clear";
      v = "nvim";
      code = "code";
    };
  };

  # ============================================
  # GHOSTTY
  # ============================================
  programs.ghostty = {
    enable = true;
    # Config loaded from dotfiles
  };

  # ============================================
  # STARSHIP
  # ============================================
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Config loaded from dotfiles via home.file
  };

  # ============================================
  # FZF
  # ============================================
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
    
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
  };

  # ============================================
  # EZA
  # ============================================
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  # ============================================
  # ZOXIDE
  # ============================================
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================
  # BAT (for fzf preview)
  # ============================================
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };
}
