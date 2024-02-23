{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.wezterm;
in {
  options.modules.shell.wezterm = {
    enable = mkEnableOption "wezterm";
    configPath = mkOption {
      type = types.str;
    };
  };

  # Temporary make .config/wezterm/wezterm.lua link to the local copy
  config = mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink cfg.configPath;

    programs.fish.shellAliases = {
      newmain = "wezterm cli spawn --workspace main --cwd ~ --new-window";
    };
  };
}
