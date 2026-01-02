{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Joe Battistello";
        email = "joebattistello@hotmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = { autocrlf = "input"; editor = "nvim"; };
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
      rebase.autoStash = true;
      credential.helper = "store";

      alias = {
        s = "status -sb";
        lg = "log --oneline --graph --decorate";
        co = "checkout";
        br = "branch";
        ci = "commit";
        aa = "add --all";
        unstage = "reset HEAD --";
      };
    };

    ignores = [ ".DS_Store" "*.swp" "*~" ".idea/" ".vscode/" "node_modules/" "result" "result-*" ".direnv/" ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = { navigate = true; side-by-side = true; line-numbers = true; };
  };

  programs.gh = { enable = true; settings.git_protocol = "ssh"; };
  programs.lazygit.enable = true;
}
