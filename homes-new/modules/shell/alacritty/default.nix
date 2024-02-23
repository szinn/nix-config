{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.alacritty;
in {
  options.modules.shell.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
    };
    xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
  };
}
