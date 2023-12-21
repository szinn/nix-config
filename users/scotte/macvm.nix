{ pkgs, ... }:
{
  imports = [];

  modules.scotte = {
    alacritty.enable = true;
    tmux.enable = true;
  };
}
