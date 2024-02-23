{username}: {
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.${username}.shell.alacritty;
in {
  options.modules.${username}.shell.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.alacritty = {
        enable = true;
      };
      xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
    };
  };
}
