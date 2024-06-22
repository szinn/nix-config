{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.dns.cloudflare-dyndns;
in
  with lib; {
    options.modules.services.dns.cloudflare-dyndns = {
      enable = mkEnableOption "cloudflare-dyndns";
      domains = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      apiTokenFile = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    config = mkIf cfg.enable {
      services.cloudflare-dyndns = {
        enable = true;

        inherit (cfg) apiTokenFile domains;
      };

      systemd.services.cloudflare-dyndns = {
        wants = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          RestartSec = 5;
          RestartSteps = 5;
          RestartMaxDelaySec = 30;
        };
      };
    };
  }
