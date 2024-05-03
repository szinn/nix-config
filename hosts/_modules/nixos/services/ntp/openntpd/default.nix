{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.ntp.openntpd;
in
  with lib; {
    options.modules.services.ntp.openntpd = {
      enable = mkEnableOption "openntpd";
      servers = mkOption {
        default = config.services.ntp.servers;
        defaultText = literalExpression "config.services.ntp.servers";
        type = types.listOf types.str;
        inherit (options.services.ntp.servers) description;
      };
      extraConfig = mkOption {
        type = with types; lines;
        default = "";
        example = ''
          listen on 127.0.0.1
          listen on ::1
        '';
        description = ''
          Additional text appended to {file}`openntpd.conf`.
        '';
      };

      extraOptions = mkOption {
        type = with types; separatedString " ";
        default = "";
        example = "-s";
        description = ''
          Extra options used when launching openntpd.
        '';
      };
    };

    config = mkIf cfg.enable {
      services.openntpd = {
        inherit (cfg) servers extraConfig extraOptions;
        enable = true;
      };
    };
  }
