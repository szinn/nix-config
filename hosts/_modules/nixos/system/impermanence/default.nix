{
  lib,
  config,
  ...
}: let
  cfg = config.modules.system.impermanence;
in
  with lib; {
    options.modules.system.impermanence = {
      enable = mkEnableOption "system impermanence";

      # Rollback the root filesystem on boot to a blank snapshot
      rollback = mkOption {
        type = types.bool;
        default = true;
      };
      rootBlankSnapshotName = mkOption {
        type = types.str;
        default = "blank";
      };
      rootPoolName = mkOption {
        type = types.str;
        default = "rpool/local/root";
      };
      persistPath = mkOption {
        type = types.str;
        default = "/persist";
      };
    };

    config = mkIf cfg.enable {
      # move ssh keys

      boot = mkIf cfg.rollback {
        # bind a initrd command to rollback to blank root after boot
        initrd.postDeviceCommands = mkAfter ''
          zfs rollback -r ${cfg.rootPoolName}@${cfg.rootBlankSnapshotName}
        '';
        kernelParams = ["elevator=none"];
      };

      fileSystems."${cfg.persistPath}".neededForBoot = true;

      systemd.tmpfiles.rules = mkIf config.services.openssh.enable [
        "d /etc/ 0755 root root -" # The - disables automatic cleanup, so the file wont be removed after a period
        "d /etc/ssh/ 0755 root root -" # The - disables automatic cleanup, so the file wont be removed after a period
        "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth" # Save bluetooth connections
      ];

      environment.persistence."${cfg.persistPath}" = {
        hideMounts = true;
        directories = [
          # persist logs between reboots for debugging
          "/var/log"
          # cache files (restic, nginx, containers
          # "/var/lib/cache"
          # nixos state
          "/var/lib/nixos"
          # Network connections
          "/etc/NetworkManager/system-connections"
        ];
        files = [
          "/etc/machine-id"
          "/etc/adjtime"
          # ssh keys
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
    };
  }
