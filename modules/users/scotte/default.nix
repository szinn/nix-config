args@{ inputs, config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.users.scotte;

  extensions =
    let
      vscode = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
      open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
      nixpkgs = pkgs.vscode-extensions;
    in
    [
      vscode.aaron-bond.better-comments
      vscode.alefragnani.bookmarks
      vscode.alefragnani.project-manager
      vscode.belfz.search-crates-io
      vscode.bmalehorn.vscode-fish
      vscode.davidanson.vscode-markdownlint
      vscode.esbenp.prettier-vscode
      vscode.fcrespo82.markdown-table-formatter
      vscode.foxundermoon.shell-format
      vscode.github.vscode-github-actions
      vscode.github.vscode-pull-request-github
      vscode.golang.go
      vscode.gruntfuggly.todo-tree
      vscode.hashicorp.terraform
      vscode.ieni.glimpse
      vscode.jnoortheen.nix-ide
      vscode.mhutchie.git-graph
      vscode.mikestead.dotenv
      vscode.ms-vscode-remote.remote-ssh
      vscode.ms-vscode-remote.remote-ssh-edit
      vscode.ms-vscode.remote-explorer
      vscode.oderwat.indent-rainbow
      vscode.pkief.material-icon-theme
      vscode.redhat.vscode-yaml
      vscode.rust-lang.rust-analyzer
      vscode.serayuzgur.crates
      vscode.signageos.signageos-vscode-sops
      vscode.tamasfe.even-better-toml
      vscode.usernamehw.errorlens
      vscode.vadimcn.vscode-lldb
      vscode.yinfei.luahelper
      vscode.yzhang.markdown-all-in-one
    ];
in
{
  imports = [
    (import ../../home-manager.nix { username = "scotte"; })
  ];

  options.modules.users.scotte = {
    enable = mkEnableOption "scotte";
    username = mkOption {
      type = types.str;
    };
    homeDirectory = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (config.networking.hostName == "odin") (import ./odin args))
    (mkIf (config.networking.hostName == "macvm") (import ./macvm args))
    (mkIf (config.networking.hostName == "hera") (import ./hera args))
    (mkIf (config.networking.hostName == "nixvm") (import ./nixvm args))
    (mkIf (config.networking.hostName == "ragnar") (import ./ragnar args))
    {
      users.users.scotte = {
        name = cfg.username;
        home = cfg.homeDirectory;
        shell = pkgs.fish;
        packages = [ pkgs.home-manager ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ./ssh/ssh.pub) ];
      };

      home-manager.users.scotte.home = {
        username = cfg.username;
        homeDirectory = cfg.homeDirectory;
        sessionPath = [ "$HOME/.local/bin" ];
        sessionVariables = {
          SOPS_AGE_KEY_FILE = "${config.home-manager.users.scotte.xdg.configHome}/sops/age/keys.txt";
        };
      };

      modules.scotte = {
        editor = {
          vscode = {
            configPath = "${config.home-manager.users.scotte.home.homeDirectory}/.local/nix-config/modules/users/scotte/editor/settings.json";
            keybindingsPath = "${config.home-manager.users.scotte.home.homeDirectory}/.local/nix-config/modules/users/scotte/editor/keybindings.json";
            extensions = extensions;
          };
        };

        security = {
          one-password.enable = true;
          gnupg.enable = true;
          ssh = {
            enable = true;
            matchBlocks = {
              gateway = {
                hostname = "gateway.zinn.tech";
                port = 22;
                user = "vyos";
                identityFile = "~/.ssh/id_ed25519";
              };
              ragnar = {
                hostname = "ragnar.zinn.tech";
                port = 22;
                user = "scotte";
                identityFile = "~/.ssh/id_ed25519";
              };
              octo = {
                hostname = "octo.zinn.tech";
                port = 22;
                user = "pi";
                identityFile = "~/.ssh/id_ed25519";
              };
              pione = {
                hostname = "pione.zinn.tech";
                port = 22;
                user = "pi";
                identityFile = "~/.ssh/id_ed25519";
              };
              zeus = {
                hostname = "zeus.zinn.tech";
                port = 22;
                user = "root";
                identityFile = "~/.ssh/id_ed25519";
              };
              "github.com" = {
                hostname = "ssh.github.com";
                port = 443;
                user = "git";
                identityFile = "~/.ssh/id_ed25519";
              };
              "github-magized" = {
                hostname = "ssh.github.com";
                port = 443;
                user = "git";
                identityFile = "~/.ssh/id_magized";
              };
              pikvm = {
                hostname = "pikvm.zinn.tech";
                port = 22;
                user = "root";
                identityFile = "~/.ssh/id_ed25519";
              };
              ares = {
                hostname = "ares.zinn.tech";
                port = 22;
                user = "root";
                identityFile = "~/.ssh/id_ed25519";
              };
              "magized.com" = {
                port = 22;
                user = "mailu";
                identityFile = "~/.ssh/id_ed25519";
              };
            };
          };
        };

        shell = {
          fish.enable = true;
          git = {
            enable = true;
            username = "Scotte Zinn";
            email = "scotte@zinn.ca";
            allowedSigners = builtins.readFile ./ssh/allowed_signers;
          };
        };
      };
    }
  ]);
}
