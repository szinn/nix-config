{inputs, pkgs, config, lib, hostname, ...}:
with lib; let
  extensions = let
    vscode = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
    open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
    nixpkgs = pkgs.vscode-extensions;
  in [
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
    vscode.kamadorueda.alejandra
    vscode.mhutchie.git-graph
    vscode.mikestead.dotenv
    vscode.ms-kubernetes-tools.vscode-kubernetes-tools
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
in {
  imports = [
    ../modules
    ./${hostname}
  ];

  modules = {
    editors = {
      vscode = {
        configPath = "${config.home.homeDirectory}/.local/nix-config/homes-new/scotte/editors/vscode/settings.json";
        keybindingsPath = "${config.home.homeDirectory}/.local/nix-config/homes-new/scotte/editors/vscode/keybindings.json";
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
  };
}
