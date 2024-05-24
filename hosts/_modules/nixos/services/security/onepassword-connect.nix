{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.security.onepassword-connect;
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
    };
  }
