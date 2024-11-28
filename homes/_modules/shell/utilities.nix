{
  inputs,
  lib,
  pkgs,
  system,
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
          any-nix-shell
          bat
          doggo
          du-dust
          duf
          eza
          fd
          fzf
          gh
          go-task
          jq
          minijinja
          nodePackages.prettier
          nvd
          pre-commit
          python3
          qrencode
          redis
          restic
          shellcheck
          sops
          unixtools.watch
          wget
          yamllint
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
        fish = {
          shellAliases = {
            dig = "doggo";
          };
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
        inputs.nh.packages.${system}.default
      ];
      programs.atuin.settings.daemon.enabled = "true";
      systemd.user.services.atuind = {
        Install = {
          WantedBy = ["default.target"];
        };
        Unit = {
          After = ["network.target"];
        };
        Service = {
          Environment = "ATUIN_LOG=info";
          ExecStart = "${pkgs.atuin}/bin/atuin daemon";
          # Remove the socket file if the daemon is not running.
          # Unexpected shutdowns may have left this file here.
          ExecStartPre = "/run/current-system/sw/bin/bash -c '! pgrep atuin && /run/current-system/sw/bin/rm -f ~/.local/share/atuin/atuin.sock'";
        };
      };
    })
  ];
}
