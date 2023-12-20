{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.go;
in
{
  options.features.go = {
    enable = mkEnableOption "go";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}
