{ username }: args@{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.git;
in
{
  options.modules.${username}.git = {
    enable = mkEnableOption "git";
    username = mkOption {
      type = types.str;
    };
    email = mkOption {
      type = types.str;
    };
    allowedSigners = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = (mkMerge [
      {
        programs.git = {
          enable = true;
          userName = cfg.username;
          userEmail = cfg.email;
          extraConfig = {
            gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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
            init = { defaultBranch = "main"; };
            commit = { gpgSign = true; };
            user = { signing.key = "B2F1677DB0348B42"; };
            diff = { colorMoved = "default"; };
            fetch = { prune = "true"; };
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

        home.packages = with pkgs; [ delta fzf ];
        home.file.".ssh/allowed_signers".text = cfg.allowedSigners;
      }
      (mkIf pkgs.stdenv.isDarwin {
        programs.git = {
          extraConfig = {
            credential = { helper = "osxkeychain"; };
          };
        };
      })
    ]);
  };
}
