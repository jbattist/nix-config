{ config, pkgs, lib, ... }:

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
    };

    initExtra = ''
      # Quality-of-life defaults
      setopt AUTO_CD
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt SHARE_HISTORY
      setopt INC_APPEND_HISTORY
      bindkey -e
    '';
  };

  # ============================================
  # TERMINAL & TOOLS
  # ============================================
  programs.ghostty.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height" "40%" "--layout=reverse" "--border" ];
    # Requires `fd` (provided below).
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  # Minimal mandatory deps to support config above.
  home.packages = with pkgs; [
    fd
    ripgrep
  ];
}
