{ config, pkgs, lib, ... }: {
  config.programs.alacritty = {
    enable = true;
  };
  config.xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
}
