{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.rclone-backup;
in {
  options.modules.services.rclone-backup = {
    enable = mkEnableOption "rclone-backup";
  };

  config = mkIf cfg.enable {
    # List all timers
    #   systemctl list-timers
    systemd.timers."rclone-backup" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "60m";
        OnUnitActiveSec = "240m";
        Unit = "rclone-backup.service";
      };
    };

    # Trigger manual run
    # systemctl start rclone-backup
    systemd.services."rclone-backup" = {
      script = ''
        set -eu
        ${pkgs.coreutils}/bin/date >> /var/log/rclone.log
        ${pkgs.rclone}/bin/rclone -v --check-first --copy-links --transfers 10 --stats-log-level NOTICE --stats 30m sync /mnt/atlas/backup/ /mnt/hades/backup/backup/ >> /var/log/rclone.log 2>&1
        ${pkgs.rclone}/bin/rclone -v --check-first --copy-links --transfers 10 --stats-log-level NOTICE --stats 30m sync /mnt/atlas/k8s/ /mnt/hades/backup/k8s/ >> /var/log/rclone.log 2>&1
        ${pkgs.rclone}/bin/rclone -v --check-first --transfers 10 --stats-log-level NOTICE --stats 30m sync /mnt/atlas/media/ /mnt/hades/media/ >> /var/log/rclone.log 2>&1
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
