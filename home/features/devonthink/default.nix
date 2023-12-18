{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.devonthink;
in
{
  options.features.devonthink = {
    enable = mkEnableOption "DEVONthink";
  };
}
