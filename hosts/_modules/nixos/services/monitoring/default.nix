{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.services.prometheus;
in {
  options.modules.services.prometheus.enable = mkEnableOption "Prometheus Monitoring";

  config = mkIf cfg.enable {
    services.prometheus.exporters = {
      node = {
        enable = true;
        # enabledCollectors = [
        #   "diskstats"
        #   "filesystem"
        #   "loadavg"
        #   "meminfo"
        #   "netdev"
        #   "stat"
        #   "time"
        #   "uname"
        #   "systemd"
        # ];
      };
      smartctl = {
        enable = true;
      };
    };
  };
}
