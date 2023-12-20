{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.gnupg;
in
{
  config.home = mkIf cfg.enable {
    packages = with pkgs; [ pinentry_mac ];
  };
}
