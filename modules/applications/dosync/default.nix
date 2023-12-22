{ username }: { config, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.applications.dosync;
in
{
  options.modules.${username}.applications.dosync = {
    enable = mkEnableOption "dosync";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.file.".local/bin/dosync".source = ./dosync;
      home.file.".local/bin/restore".source = ./restore;
    };
  };
}
