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
    sudo chsh -s /run/current-system/sw/bin/fish scotte
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
    _1password.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      username = "Scotte Zinn";
      email = "scotte@zinn.ca";
      allowedSigners = builtins.readFile ./allowed_signers;
    };
  };
}
