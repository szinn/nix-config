{
  pkgs,
  config,
  ...
}: let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    ./hardware-configuration.nix
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
    openssh.authorizedKeys.keys = [(builtins.readFile ../../homes/scotte/ssh/ssh.pub)];
    hashedPasswordFile = config.sops.secrets.scotte-password.path;
    isNormalUser = true;
    extraGroups =
      ["wheel"]
      ++ ifGroupsExist [
        "network"
        "samba-users"
      ];
  };
  users.groups.scotte = {
    gid = 1000;
  };

  sops.secrets.scotte-password = {
    sopsFile = ../../homes/scotte/ragnar/secrets.sops.yaml;
    neededForUsers = true;
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
    };

    services = {
      k3s = {
        enable = true;
        package = pkgs.k3s_1_29;
        extraFlags = [
          "--tls-san=nas.zinn.ca"
        ];
      };

      minio = {
        enable = true;
        root-credentials = ./minio.sops.yaml;
        dataDirs = [
          "/mnt/atlas/s3"
        ];
      };

      prometheus = {
        enable = true;
      };

      nfs = {
        enable = true;
        exports = ''
          /mnt/nvme 10.0.0.0/8(rw,insecure,all_squash,anonuid=65534,anongid=65534,no_subtree_check)
        '';
      };

      openssh.enable = true;

      rclone-backup.enable = true;

      samba = {
        enable = true;
        shares = {
          homes = {
            browseable = "no";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0664";
            "directory mask" = "0775";
          };
        };
      };
    };

    users = {
      groups = {
        homelab = {
          gid = 568;
          members = ["scotte"];
        };
        media = {
          gid = 569;
          members = ["scotte"];
        };
      };
      additionalUsers = {
        homelab = {
          uid = 568;
          group = "homelab";
          isNormalUser = false;
        };
        media = {
          uid = 569;
          group = "media";
          isNormalUser = false;
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
