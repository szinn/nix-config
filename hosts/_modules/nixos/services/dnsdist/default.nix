{
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.dnsdist;
in {
  options.modules.services.dnsdist = {
    enable = lib.mkEnableOption "dnsdist";
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
    };
    listenPort = lib.mkOption {
      type = lib.types.int;
      default = 53;
    };
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dnsdist = {
      enable = true;
      listenAddress = cfg.listenAddress;
      listenPort = cfg.listenPort;
      extraConfig = cfg.config;
    };
  };
}
