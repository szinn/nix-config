{
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.dnsdist;
in
  with lib; {
    options.modules.services.dnsdist = {
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
        enable = true;
        listenAddress = cfg.listenAddress;
        listenPort = cfg.listenPort;
        extraConfig = cfg.config;
      };
    };
  }
