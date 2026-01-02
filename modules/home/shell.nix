{ config, pkgs, dotfiles, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
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
xdg.configFile."ghostty/config".source = dotfiles + "/ghostty/config";

# Starship
xdg.configFile."starship.toml".source = dotfiles + "/starship/starship.toml";

# Zsh (either replace .zshrc...)
home.file.".zshrc".source = dotfiles + "/zsh/.zshrc";

# ...or better: source your custom file without replacing .zshrc
# programs.zsh.initExtra = ''
#   source ${dotfiles}/zsh/custom.zsh
# '';


}
