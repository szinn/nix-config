{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.development.go;
in
{
  options.modules.${username}.development.go = {
    enable = mkEnableOption "go";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        go
      ];
    };
  };
}
