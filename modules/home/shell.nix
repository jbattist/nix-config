{ config, pkgs, dotfiles, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Load my dotfiles zsh config
    initContent = ''
      source ${dotfiles}/zshrc/.zshrc
    '';
    
  };

  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    eza
    fastfetch
    git
  ];

# Ghostty
xdg.configFile."ghostty/config".source = dotfiles + "/ghostty/.config/ghostty/config";

# Starship
xdg.configFile."starship.toml".source = dotfiles + "/starship/.config/starship.toml";

# fastfetch
xdg.configFile."fastfetch.jsonc".source = dotfiles + "/fastfetch/.config/fastfetch/config.jsonc";


}
