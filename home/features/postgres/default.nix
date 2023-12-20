{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.postgres;
in
{
  options.features.postgres = {
    enable = mkEnableOption "postgres";
  };

  config = mkIf cfg.enable {
    home.file.".psqlrc".source = ./psqlrc;
  };
}
