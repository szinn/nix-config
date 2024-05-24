{
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.dns.dnsdist;
in
  with lib; {
    options.modules.services.dns.dnsdist = {
      enable = mkEnableOption "dnsdist";
      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
      };
      listenPort = mkOption {
        type = types.int;
        default = 53;
      };
      config = mkOption {
        type = types.lines;
        default = "";
      };
    };

    config = mkIf cfg.enable {
      services.dnsdist = {
        inherit (cfg) listenAddress listenPort;
        enable = true;
        extraConfig = cfg.config;
      };
    };
  }
