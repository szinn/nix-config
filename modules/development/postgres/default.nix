{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.development.postgres;
in
{
  options.modules.${username}.development.postgres = {
    enable = mkEnableOption "postgres";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.file.".psqlrc".source = ./psqlrc;
    };
  };
}
