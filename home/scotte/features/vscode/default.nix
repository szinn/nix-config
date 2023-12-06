{configPath, extensions}: { pkgs, lib, config, ... }:
with lib;
let
  defaultExtensions = with pkgs.vscode-extensions; [
    tamasfe.even-better-toml
  ];
in {
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
}
