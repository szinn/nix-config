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

    (import ./features/vscode {
      configPath = "${config.home.homeDirectory}/.local/nix-config/home/scotte/settings.json";
      extensions = extensions;
    })
    # Uncomment if using sops secrets
    # (import ./features/sops {
    #   ageFile = "${config.xdg.configHome}/age/keys.txt";
    #   sopsFile = ./secrets.sops.yaml;
    #   secrets = {
    #     abc = {
    #       path = "${config.xdg.configHome}/abc";
    #     };
    #   };
    # })
    ./features/_1password
    ./features/alacritty
    ./features/devops
    ./features/fish
    (import ./features/git {
      name = "Scotte Zinn";
      email = "scotte@zinn.ca";
    })
    ./features/gnupg
    ./features/rust
    ./features/ssh
    ./features/tmux
    ./features/utilities

    # Can't do this since it needs to install in /Applications  
    # ./darwin/_1password
    ./darwin/fish
    ./darwin/fonts
    ./darwin/gnupg
    ./darwin/git
  ];
}
