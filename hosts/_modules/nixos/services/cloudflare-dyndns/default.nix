{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.cloudflare-dyndns;
in
  with lib; {
    options.modules.services.cloudflare-dyndns = {
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
