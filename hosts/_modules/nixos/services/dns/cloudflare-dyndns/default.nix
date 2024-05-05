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
        inherit (cfg) apiTokenFile domains;
        enable = true;
      };
    };
  }
