{ hostname, username, homeDirectory }: { inputs, config, pkgs, ... }:
let
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
    ( import ../../modules { username = "scotte"; } )
    ./${hostname}.nix
  ];

  users.users.scotte = {
    name = username;
    home = homeDirectory;
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ./ssh.pub) ];
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  home-manager.users.scotte.home = {
      username = username;
      homeDirectory = homeDirectory;
      sessionPath = [ "$HOME/.local/bin" ];
      sessionVariables = {
        SOPS_AGE_KEY_FILE = "${config.home-manager.users.scotte.xdg.configHome}/sops/age/keys.txt";
      };
  };

  modules.scotte = {
    editor = {
      vscode = {
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
        allowedSigners = builtins.readFile ./allowed_signers;
      };
    };
  };
}
