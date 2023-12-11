{ configPath, extensions }: { pkgs, lib, config, inputs, ... }:
with lib;
let
  defaultExtensions =
    let
      vscode = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
      open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
      nixpkgs = pkgs.vscode-extensions;
    in
    [
      vscode.bmalehorn.vscode-fish
      vscode.davidanson.vscode-markdownlint
      vscode.esbenp.prettier-vscode
      vscode.fcrespo82.markdown-table-formatter
      vscode.foxundermoon.shell-format
      vscode.github.vscode-github-actions
      vscode.github.vscode-pull-request-github
      vscode.jnoortheen.nix-ide
      vscode.mhutchie.git-graph
      vscode.ms-vscode-remote.remote-ssh
      vscode.ms-vscode-remote.remote-ssh-edit
      vscode.ms-vscode.remote-explorer
      vscode.oderwat.indent-rainbow
      vscode.pkief.material-icon-theme
      vscode.redhat.vscode-yaml
      vscode.tamasfe.even-better-toml
      vscode.yzhang.markdown-all-in-one
    ];
in
{
  # Point settings.json to configPath
  config.home.file."/Library/Application Support/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink configPath;
  config.programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;

    extensions = mkMerge [
      defaultExtensions
      extensions
    ];
  };
  config.home.packages = with pkgs; [
    nixpkgs-fmt
  ];
}
