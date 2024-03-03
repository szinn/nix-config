{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  ignorePatterns = ''
    !.env*
    !.github/
    !.gitignore
    !*.tfvars
    .terraform/
    .target/
    /Library/'';
in {
  config = mkMerge [
    {
      home = {
        packages = with pkgs; [
          age
          alejandra
          bat
          dig
          du-dust
          duf
          eza
          fd
          fzf
          gh
          go-task
          jq
          nvd
          pre-commit
          protobuf
          python3
          qrencode
          redis
          restic
          shellcheck
          sops
          unixtools.watch
          wget
          yq-go
        ];

        file = {
          ".rgignore".text = ignorePatterns;
          ".fdignore".text = ignorePatterns;
          ".digrc".text = "+noall +answer"; # Cleaner dig commands
        };

        # Environment configuration
        sessionVariables = {
          FZF_DEFAULT_COMMAND = "fd -H -E '.git'";
        };
      };

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        lazygit = {
          enable = true;
          settings = {
            gui.paging = {
              colorArg = "always";
              pager = "delta --dark --paging=never --syntax-theme base16-256 --diff-so-fancy";
            };
          };
        };
        atuin = {
          enable = true;
          flags = ["--disable-up-arrow"];
          settings = {
            workspaces = "true";
            ctrl_n_shortcuts = "true";
          };
        };
        ripgrep = {
          enable = true;
          arguments = ["--glob=!vendor" "--hidden" "--line-number" "--no-heading" "--sort=path"];
        };
        zoxide = {
          enable = true;
        };
      };
    }
    (mkIf pkgs.stdenv.isDarwin {
      home.packages = with pkgs; [
        (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "DejaVuSansMono" "DroidSansMono"];})
      ];
    })
    (mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs; [
        nh
      ];
    })
  ];
}
