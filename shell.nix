{ config, pkgs, lib, dotfiles, ... }:

{
  # ============================================
  # ZSH
  # ============================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    # Lock in legacy dotdir behavior (home.stateVersion < 26.05)
    dotDir = config.home.homeDirectory;

    initContent = ''
      [[ -f "${dotfiles}/zshrc/.zshrc" ]] && source "${dotfiles}/zshrc/.zshrc"
      eval "$(zoxide init zsh)"
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^R' history-incremental-search-backward
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
    '';

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      lt = "eza --tree --icons --group-directories-first";
      l = "eza -l --icons --group-directories-first";
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      glog = "git log --oneline --graph --decorate";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nix-config#default";
      update = "nix flake update ~/.config/nix-config";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      ff = "fastfetch";
      c = "clear";
      v = "nvim";
      code = "code";
    };
  };

  # ============================================
  # TERMINAL & TOOLS
  # ============================================
  programs.ghostty.enable = true;
  programs.starship = { enable = true; enableZshIntegration = true; };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
  };
  programs.eza = { enable = true; enableZshIntegration = true; icons = "auto"; git = true; };
  programs.zoxide = { enable = true; enableZshIntegration = true; };
  programs.bat = { enable = true; config.theme = "TwoDark"; };
}
