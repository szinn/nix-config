{
  inputs,
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
with lib; let
  extensions = let
    inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace open-vsx;
  in [
    vscode-marketplace.aaron-bond.better-comments
    vscode-marketplace.alefragnani.bookmarks
    vscode-marketplace.alefragnani.project-manager
    vscode-marketplace.belfz.search-crates-io
    vscode-marketplace.bmalehorn.vscode-fish
    vscode-marketplace.davidanson.vscode-markdownlint
    vscode-marketplace.esbenp.prettier-vscode
    vscode-marketplace.fcrespo82.markdown-table-formatter
    vscode-marketplace.foxundermoon.shell-format
    vscode-marketplace.github.vscode-github-actions
    vscode-marketplace.github.vscode-pull-request-github
    vscode-marketplace.golang.go
    vscode-marketplace.gruntfuggly.todo-tree
    vscode-marketplace.hashicorp.terraform
    vscode-marketplace.ieni.glimpse
    vscode-marketplace.jnoortheen.nix-ide
    vscode-marketplace.kamadorueda.alejandra
    vscode-marketplace.mhutchie.git-graph
    vscode-marketplace.mikestead.dotenv
    vscode-marketplace.ms-kubernetes-tools.vscode-kubernetes-tools
    vscode-marketplace.ms-vscode-remote.remote-ssh
    vscode-marketplace.ms-vscode-remote.remote-ssh-edit
    vscode-marketplace.ms-vscode.remote-explorer
    vscode-marketplace.oderwat.indent-rainbow
    vscode-marketplace.pkief.material-icon-theme
    vscode-marketplace.redhat.vscode-yaml
    vscode-marketplace.rust-lang.rust-analyzer
    vscode-marketplace.serayuzgur.crates
    vscode-marketplace.signageos.signageos-vscode-sops
    vscode-marketplace.tamasfe.even-better-toml
    vscode-marketplace.usernamehw.errorlens
    vscode-marketplace.vadimcn.vscode-lldb
    vscode-marketplace.yinfei.luahelper
    vscode-marketplace.yzhang.markdown-all-in-one
  ];
in {
  imports = [
    ../modules
    ./editors/neovim
    ./${hostname}
  ];

  modules = {
    editors = {
      vscode = {
        inherit extensions;
        configPath = "${config.home.homeDirectory}/.local/nix-config/homes/scotte/editors/vscode/settings.json";
        keybindingsPath = "${config.home.homeDirectory}/.local/nix-config/homes/scotte/editors/vscode/keybindings.json";
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
