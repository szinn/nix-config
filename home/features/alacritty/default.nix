{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.alacritty;
in
{
  options.features.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config = mkIf (cfg.enable) {
    programs.alacritty = {
      enable = true;
    };
    xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
  };
}
