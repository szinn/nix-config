{ config, pkgs, lib, ... }: {
  home-manager.users.${config.user} = {
    home.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };
}
