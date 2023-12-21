{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.features.vscode;
in
{
  config.home.file = mkIf cfg.enable {
    "Library/Application Support/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink cfg.configPath;
  };

  # config.programs.fish.shellAliases = mkIf config.modules.scotte.fish.enable {
  #   # Prefer to use Homebrew install rather than nix package.
  #   code = "/opt/homebrew/bin/code";
  # };
}
