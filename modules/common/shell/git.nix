{ config, pkgs, lib, ... }: {
  options = {
    gitName = lib.mkOption {
      type = lib.types.str;
      description = "Name to use for git commits";
    };
    gitEmail = lib.mkOption {
      type = lib.types.str;
      description = "Email to use for git commits";
    };
  };

  config = {
    home-manager.users.${config.user} = {
      programs.git = {
        enable = true;
        userName = config.gitName;
        userEmail = config.gitEmail;
        extraConfig = {
          color = { ui = "auto"; };
          core = {
            autocrlf = "input";
            editor = "nvim";
            pager = "delta";
          };
          delta = {
            navigate = "true";
            light = "false";
            features = "decorations";
            side-by-side = "true";
          };
          diff = { colorMoved = "default"; };
          fetch = { prune = "true"; };
          init = { defaultBranch = "main"; };
          interactive = { diffFilter = "delta --color-only"; };
          merge = { conflictstyle = "diff3"; };
          pager = { branch = "false"; };
          pull = { rebase = "true"; };
          push = { autoSetupRemote = "true"; };
          rebase = { autoStash = "true"; };
        };
        aliases = {
          br = "branch";
          ci = "commit";
          co = "checkout";
          diffc = "diff --cached";
          lg = "lg1";
          lg1 = "lg1-specific --all";
          lg2 = "lg2-specific --all";
          lg3 = "lg3-specific --all";
          lg1-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
          lg2-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
          lg3-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";
          lsd = "log --graph --decorate --abbrev-commit --pretty=oneline --all";
          mrg = "merge --no-ff --log";
          oops = "commit --amend --no-edit";
          reword = "commit --amend";
          st = "status";
          uncommit = "reset --soft HEAD~1";
          undo = "checkout --";
        };
        ignores = [
          ".direnv/**"
          "result"
        ];
      };

      home.packages = with pkgs; [delta fish fzf bat pinentry];
    };
  };
}
