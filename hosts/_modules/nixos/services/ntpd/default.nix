{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.ntpd;
  format = pkgs.formats.toml {};
in
  with lib; {
    options.modules.services.ntpd = {
      enable = mkEnableOption "ntpd";
      metrics.enable = mkEnableOption "ntpd-rs Prometheus Metrics Exporter";
      package = lib.mkPackageOption pkgs "ntpd-rs" {};
      useNetworkingTimeServers = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Use source time servers from {var}`networking.timeServers` in config.
        '';
      };
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;
        };
        default = {};
        description = ''
          Settings to write to {file}`ntp.toml`

          See <https://docs.ntpd-rs.pendulum-project.org/man/ntp.toml.5>
          for more information about available options.
        '';
      };
    };

    config = mkIf cfg.enable {
      services.ntpd-rs = {
        enable = true;
        metrics.enable = cfg.metrics.enable;
        package = cfg.package;
        useNetworkingTimeServers = cfg.useNetworkingTimeServers;
        settings = cfg.settings;
      };
    };
  }
