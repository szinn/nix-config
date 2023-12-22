{ pkgs, config, ... }:
{
  imports = [];

  modules.scotte = {
    editor = {
      vscode = {
        enable = true;
        configPath = "${config.home-manager.users.scotte.home.homeDirectory}/.local/nix-config/users/scotte/settings.json";
      };
    };

    shell = {
      alacritty.enable = true;
      tmux.enable = true;
    };
  };
}
