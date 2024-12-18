{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  impermanence = false;
in {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  networking = {
    hostName = "ragnar";
    hostId = "decaf108";
    useDHCP = true;
    firewall.enable = false;
  };

  users.users.scotte = {
    uid = 1000;
    name = "scotte";
    home = "/home/scotte";
    group = "scotte";
    shell = pkgs.fish;
    packages = [pkgs.home-manager];
    openssh.authorizedKeys.keys = [(builtins.readFile ../../homes/scotte/config/ssh/ssh.pub)];
    hashedPasswordFile = config.sops.secrets.scotte-password.path;
    isNormalUser = true;
    extraGroups =
      [
        "wheel"
        "users"
      ]
      ++ ifGroupsExist [
        "network"
        "samba-users"
      ];
  };
  users.groups.scotte = {
    gid = 1000;
  };

  nix.settings.trusted-users = ["scotte"];

  sops = {
    secrets.scotte-password = {
      sopsFile = ../../homes/scotte/hosts/ragnar/secrets.sops.yaml;
      neededForUsers = true;
    };
    age.sshKeyPaths = lib.mkIf impermanence ["/persist/etc/ssh/ssh_host_ed25519_key"];
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules = {
    filesystems = {
      zfs = {
        enable = true;
        mountPoolsAtBoot = [
          "atlas"
        ];
      };

      nfs = {
        enable = true;
        exports = ''
          /mnt/nvme 10.0.0.0/8(rw,insecure,all_squash,anonuid=65534,anongid=65534,no_subtree_check)
        '';
      };

      samba = {
        enable = true;
      };
    };

    services = {
      minio = {
        enable = true;
        root-credentials = ./minio.sops.yaml;
        dataDirs = [
          "/mnt/atlas/s3"
        ];
      };

      monitoring.prometheus = {
        enable = true;
      };

      security.openssh.enable = true;

      rclone-backup.enable = true;

      zenstate.enable = true;
    };

    users = {
      groups = {
        homelab = {
          gid = 4000;
          members = ["scotte"];
        };
        media = {
          gid = 4001;
          members = ["scotte"];
        };
      };
      additionalUsers = {
        homelab = {
          uid = 4000;
          group = "homelab";
          isSystemUser = true;
        };
        media = {
          uid = 4001;
          group = "media";
          isSystemUser = true;
        };
      };
    };
  };

  fileSystems = {
    "/mnt/hades/media" = {
      device = "hades:/volume1/Media";
      fsType = "nfs";
    };
    "/mnt/hades/backup" = {
      device = "hades:/volume1/Backups";
      fsType = "nfs";
    };
    "/mnt/nvme" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S5H9NC0MC34358R-part1";
      fsType = "ext4";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
