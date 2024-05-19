{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.monitoring.gatus;
  appFolder = "/var/lib/gatus";
  user = "gatus";
  group = "gatus";
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
          User = user;
          Group = group;

          AmbientCapabilities = ["CAP_NET_RAW"];
          CapabilityBoundingSet = ["CAP_NET_RAW"];
        };

        environment = {
          GATUS_CONFIG_PATH = "${cfg.configFile}";
        };
      };

      users.users.${user} = {
        inherit (cfg) uid;

        group = group;
        isSystemUser = true;
      };

      users.groups.gatus.gid = cfg.gid;

      environment.persistence."${config.modules.system.impermanence.persistPath}" = lib.mkIf config.modules.system.impermanence.enable {
        directories = [
          {
            directory = appFolder;
            inherit user;
            inherit group;
            mode = "750";
          }
        ];
      };
    };
  }
