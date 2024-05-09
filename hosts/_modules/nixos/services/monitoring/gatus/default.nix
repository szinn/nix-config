{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.monitoring.gatus;
in
  with lib; {
    options.modules.services.monitoring.gatus = {
      enable = mkEnableOption "gatus";
      package = mkPackageOption pkgs "gatus" {};
      configFile = mkOption {
        description = "Path to configuration file";
        type = types.path;
      };
      uid = mkOption {
        type = types.int;
        default = 32000;
      };
      gid = mkOption {
        type = types.int;
        default = 32000;
      };
    };
    config = mkIf cfg.enable {
      systemd.services.gatus = {
        description = "Gatus Monitoring Daemon";
        wantedBy = ["multi-user.target"];
        wants = ["network-online.target"];
        after = ["network-online.target"];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/gatus";
          Type = "simple";
          User = "gatus";
          Group = "gatus";

          AmbientCapabilities = ["CAP_NET_RAW"];
          CapabilityBoundingSet = ["CAP_NET_RAW"];
        };

        environment = {
          GATUS_CONFIG_PATH = "${cfg.configFile}";
        };
      };

      users.users.gatus = {
        inherit (cfg) uid;

        group = "gatus";
        isSystemUser = true;
      };

      users.groups.gatus.gid = cfg.gid;
    };
  }
