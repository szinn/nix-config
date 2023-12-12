{ config, pkgs, lib, ... }: {
  # Temporary make .config/wezterm/wezterm.lua link to the local copy
  config.xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/nix-config/home/scotte/features/wezterm/wezterm.lua";

  config.programs.fish.shellAliases = {
    newmain = "wezterm cli spawn --workspace main --cwd ~ --new-window";
  };
}
