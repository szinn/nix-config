{ pkgs, inputs, config, lib, ... }:
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
      vscode.golang.go
      vscode.gruntfuggly.todo-tree
      vscode.hashicorp.terraform
      vscode.ieni.glimpse
      vscode.rust-lang.rust-analyzer
      vscode.serayuzgur.crates
      vscode.signageos.signageos-vscode-sops
      vscode.usernamehw.errorlens
      vscode.vadimcn.vscode-lldb
      vscode.yinfei.luahelper
    ];
in
{
  imports = [
    {
      home = {
        username = "scotte";
        homeDirectory = "/Users/scotte";
        sessionPath = [ "$HOME/.local/bin" ];
      };
    }
    ../../global
    ../../features
    ../../darwin
  ];

  features._1password.enable = true;
  features.alacritty.enable = false;
  features.colima = {
    enable = false;
    startService = false;
  };
  features.devonthink.enable = true;
  features.devops.enable = true;
  features.dosync.enable = true;
  features.fish.enable = true;
  features.git = {
    enable = true;
    username = "Scotte Zinn";
    email = "scotte@zinn.ca";
  };
  features.gnupg.enable = true;
  features.go.enable = true;
  features.postgres.enable = true;
  features.rust.enable = true;
  features.ssh.enable = true;
  features.sops = {
    enable = false;
    ageKeyFile = "${config.xdg.configHome}/age/keys.txt";
    defaultSopsFile = ./secrets.sops.yaml;
    secrets = {
      abc = {
        path = "${config.xdg.configHome}/abc";
      };
    };
  };
  features.vscode = {
    enable = true;
    configPath = "${config.home.homeDirectory}/.local/nix-config/home/users/scotte/settings.json";
    extensions = extensions;
  };
  features.wezterm.enable = true;
}
