{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.applications.devonthink;
in
{
  options.modules.${username}.applications.devonthink = {
    enable = mkEnableOption "DEVONthink";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.file."Library/Application Support/DEVONthink 3/Templates.noindex/HiveMind/Note.dtTemplate/English.lproj/Note.md".source = ./Note.dtTemplate/English.lproj/Note.md;
    };
  };
}
