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
    ../../features
    ../../darwin
  ];

  features.gnupg.enable = true;
  features.ssh.enable = true;
  features.tmux.enable = true;
  features.vscode = {
    enable = true;
    configPath = "${config.home.homeDirectory}/.local/nix-config/home/users/scotte/settings.json";
    extensions = extensions;
  };
}
