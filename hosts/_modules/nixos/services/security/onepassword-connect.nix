{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.security.onepassword-connect;
  # renovate: datasource=docker depName=docker.io/1password/connect-api
  api-version = "1.7.2";
  # renovate: datasource=docker depName=docker.io/1password/connect-sync
  sync-version = "1.7.2";
in
  with lib; {
    options.modules.services.security.onepassword-connect = {
      enable = mkEnableOption "onepassword-connect";
      credentialsFile = mkOption {
        type = types.path;
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/onepassword-connect/data";
      };
      port = mkOption {
        type = types.int;
        default = 8080;
      };
    };

    config = mkIf cfg.enable {
      modules.services.podman.enable = true;

      system.activationScripts.makeOnePasswordConnectDataDir = stringAfter ["var"] ''
        mkdir -p "${cfg.dataDir}"
        chown -R 999:999 ${cfg.dataDir}
      '';

      virtualisation.oci-containers.containers = {
        onepassword-connect-api = {
          image = "docker.io/1password/connect-api:1.7.2";
          autoStart = true;
          ports = ["${builtins.toString cfg.port}:8080"];
          volumes = [
            "${cfg.credentialsFile}:/home/opuser/.op/1password-credentials.json"
            "${cfg.dataDir}:/home/opuser/.op/data"
          ];
        };

        onepassword-connect-sync = {
          image = "docker.io/1password/connect-sync:1.7.2";
          autoStart = true;
          ports = ["${builtins.toString (cfg.port + 1)}:8080"];
          volumes = [
            "${cfg.credentialsFile}:/home/opuser/.op/1password-credentials.json"
            "${cfg.dataDir}:/home/opuser/.op/data"
          ];
        };
      };
      systemd.services = {
        podman-onepassword-connect-api = {
          wants = ["multi-user.target"];
          after = ["multi-user.target"];
          serviceConfig = {
            RestartSec = 5;
            RestartSteps = 5;
            RestartMaxDelaySec = 30;
          };
        };
        podman-onepassword-connect-sync = {
          wants = ["multi-user.target"];
          after = ["multi-user.target"];
          serviceConfig = {
            RestartSec = 5;
            RestartSteps = 5;
            RestartMaxDelaySec = 30;
          };
        };
      };
    };
  }
