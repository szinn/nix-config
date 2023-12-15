{ pkgs, inputs, outputs, config, lib, ... }:
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
    ./global
    ./features
    ./darwin
  ];

  features._1password.enable = true;
  features.alacritty.enable = true;
  features.fish.enable = true;
  features.git = {
    enable = true;
    username = "Scotte Zinn";
    email = "scotte@zinn.ca";
  };
  features.gnupg.enable = true;
  features.ssh.enable = true;
  features.tmux.enable = true;
  features.vscode = {
    enable = true;
    configPath = "${config.home.homeDirectory}/.local/nix-config/home/scotte/settings.json";
    extensions = extensions;
  };
}
