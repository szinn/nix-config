{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.wezterm;
in
{
  options.features.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  # Temporary make .config/wezterm/wezterm.lua link to the local copy
  config = mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/nix-config/home/features/wezterm/wezterm.lua";

    # programs.fish.shellAliases = mkIf config.modules.scotte.fish.enable {
    #   newmain = "wezterm cli spawn --workspace main --cwd ~ --new-window";
    # };
  };
}
