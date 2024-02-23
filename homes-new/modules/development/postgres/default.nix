{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.development.postgres;
in {
  options.modules.development.postgres = {
    enable = mkEnableOption "postgres";
  };

  config = mkIf cfg.enable {
    home.file.".psqlrc".source = ./psqlrc;
  };
}
