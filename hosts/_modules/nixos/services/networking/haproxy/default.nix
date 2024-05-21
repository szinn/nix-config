{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.networking.haproxy;
in
  with lib; {
    options.modules.services.networking.haproxy = {
      enable = mkEnableOption "haproxy";
      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Contents of the HAProxy configuration file,
          {file}`haproxy.conf`.
        '';
      };
    };

    config = mkIf cfg.enable {
      services.haproxy = {
        inherit (cfg) config;
        enable = true;
      };

      systemd.services.haproxy.serviceConfig = {
        RestartSec = 5;
        RestartSteps = 5;
        RestartMaxDelaySec = 30;
      };
    };
  }
