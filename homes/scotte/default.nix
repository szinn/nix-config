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
  in
    with vscode-marketplace; [
      aaron-bond.better-comments
      alefragnani.bookmarks
      alefragnani.project-manager
      belfz.search-crates-io
      bmalehorn.vscode-fish
      davidanson.vscode-markdownlint
      esbenp.prettier-vscode
      fcrespo82.markdown-table-formatter
      foxundermoon.shell-format
      github.vscode-github-actions
      github.vscode-pull-request-github
      golang.go
      gruntfuggly.todo-tree
      hashicorp.terraform
      ieni.glimpse
      jnoortheen.nix-ide
      kamadorueda.alejandra
      mhutchie.git-graph
      mikestead.dotenv
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode.remote-explorer
      oderwat.indent-rainbow
      pkief.material-icon-theme
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      serayuzgur.crates
      signageos.signageos-vscode-sops
      svelte.svelte-vscode
      tamasfe.even-better-toml
      usernamehw.errorlens
      vadimcn.vscode-lldb
      yinfei.luahelper
      yzhang.markdown-all-in-one
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
