{ config, pkgs, lib, ... }: {
  config = {
    home-manager.users.${config.user} = {
      programs.alacritty = {
        enable = true;
      };
      xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
    };
  };
}
