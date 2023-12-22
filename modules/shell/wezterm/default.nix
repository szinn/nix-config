{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.shell.wezterm;
in
{
  options.modules.${username}.shell.wezterm = {
    enable = mkEnableOption "wezterm";
    configPath = mkOption {
      type = types.str;
    };
  };

  # Temporary make .config/wezterm/wezterm.lua link to the local copy
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      xdg.configFile."wezterm/wezterm.lua".source = config.home-manager.users.${username}.lib.file.mkOutOfStoreSymlink cfg.configPath;

      programs.fish.shellAliases = mkIf config.modules.${username}.shell.fish.enable {
        newmain = "wezterm cli spawn --workspace main --cwd ~ --new-window";
      };
    };
  };
}
