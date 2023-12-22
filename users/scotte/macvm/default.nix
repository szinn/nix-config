{ pkgs, config, ... }:
{
  imports = [];

  modules.scotte = {
    editor = {
      vscode = {
        enable = true;
      };
    };

    shell = {
      alacritty.enable = true;
      tmux.enable = true;
    };
  };
}
