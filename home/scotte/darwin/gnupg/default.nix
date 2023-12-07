{ config, pkgs, ... }: {
  config = {
    home.packages = with pkgs; [ pinentry_mac ];
  };
}
