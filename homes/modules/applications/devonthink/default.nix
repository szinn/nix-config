{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.applications.devonthink;
in {
  options.modules.applications.devonthink = {
    enable = mkEnableOption "DEVONthink";
  };

  config = mkIf cfg.enable {
    home.file."Library/Application Support/DEVONthink 3/Templates.noindex/HiveMind/Note.dtTemplate/English.lproj/Note.md".source = ./Note.dtTemplate/English.lproj/Note.md;
  };
}
