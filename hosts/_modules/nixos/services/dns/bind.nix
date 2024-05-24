{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.services.dns.bind;
in
  with lib; {
    options.modules.services.dns.bind = {
      enable = mkEnableOption "bind";
      package = mkPackageOption pkgs "bind" {};
      config = mkOption {
        type = types.str;
        default = "";
      };
    };

    config = mkIf cfg.enable {
      networking.resolvconf.useLocalResolver = mkForce false;

      # Clean up journal files
      systemd.services.bind = {
        preStart = mkAfter ''
          rm -rf ${config.services.bind.directory}/*.jnl
        '';
      };

      services.bind = {
        inherit (cfg) package;
        enable = true;
        ipv4Only = true;
        configFile = pkgs.writeText "bind.cfg" cfg.config;
      };
    };
  }
