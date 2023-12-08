{ config, pkgs, lib, ... }: {
  config.home.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DejaVuSansMono" "DroidSansMono"]; }) ];
}
