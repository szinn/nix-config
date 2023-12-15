{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features._1password;
in
{
  options.features._1password = {
    enable = mkEnableOption "_1password";
  };
  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      _1password
    ];
  };
}
