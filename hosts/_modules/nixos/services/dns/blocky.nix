{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.services.dns.blocky;
  yamlFormat = pkgs.formats.yaml {};
  configFile = yamlFormat.generate "config.yaml" cfg.config;
in
  with lib; {
    options.modules.services.dns.blocky = {
      enable = mkEnableOption "blocky";
      package = mkPackageOption pkgs "blocky" {};
      config = mkOption {
        inherit (yamlFormat) type;
        default = {};
      };
    };

    config = mkIf cfg.enable {
      systemd.services.blocky = {
        description = "A DNS proxy and ad-blocker for the local network";
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${cfg.package}/bin/blocky --config ${configFile}";
          Restart = "on-failure";

          AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
          CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
        };
      };
    };
  }
