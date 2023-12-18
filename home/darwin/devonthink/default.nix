{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.devonthink;
in
{
  config = mkIf (cfg.enable) {
    home.file."Library/Application Support/DEVONthink 3/Templates.noindex/HiveMind/Note.dtTemplate/English.lproj/Note.md".source = ./Note.dtTemplate/English.lproj/Note.md;
  };
}
