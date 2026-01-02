{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "Joe Battistello";
    userEmail = "joebattistello@hotmail.com";  # UPDATE THIS

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = { autocrlf = "input"; editor = "nvim"; };
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
      rebase.autoStash = true;
      credential.helper = "store";
    };

    delta = {
      enable = true;
      options = { navigate = true; side-by-side = true; line-numbers = true; };
    };

    aliases = {
      s = "status -sb";
      lg = "log --oneline --graph --decorate";
      co = "checkout";
      br = "branch";
      ci = "commit";
      aa = "add --all";
      unstage = "reset HEAD --";
    };

    ignores = [ ".DS_Store" "*.swp" "*~" ".idea/" ".vscode/" "node_modules/" "result" "result-*" ".direnv/" ];
  };

  programs.gh = { enable = true; settings.git_protocol = "ssh"; };
  programs.lazygit.enable = true;
}
