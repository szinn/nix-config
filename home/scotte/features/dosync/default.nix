{ config, lib, ... }:
with lib;
let
  cfg = config.features.dosync;
in
{
  options.features.dosync = {
    enable = mkEnableOption "dosync";
  };

  config = mkIf (cfg.enable) {
    home.file.".local/bin/dosync".source = ./dosync;
    home.file.".local/bin/restore".source = ./restore;
  };
}
