{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.ntp.chrony;
in
  with lib; {
    options.modules.services.ntp.chrony = {
      enable = mkEnableOption "chrony";
      servers = mkOption {
        default = config.networking.timeServers;
        defaultText = literalExpression "config.networking.timeServers";
        type = types.listOf types.str;
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };
    };

    config = mkIf cfg.enable {
      services.chrony = {
        inherit (cfg) servers;
        enable = true;
        # enableNTS = true;
        extraConfig = ''
          allow all
          bindaddress 0.0.0.0
        '';
      };
    };
  }
