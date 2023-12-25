{ config, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "hera";
    hostId = "decaf108";
    useDHCP = true;
    firewall.enable = false;
  };

  modules = {
    users.scotte = {
      enable = true;
      username = "scotte";
      homeDirectory = "/home/scotte";
    };

    filesystems.zfs = {
      enable = true;
      mountPoolsAtBoot = [
        # "atlas"
      ];
    };

    services = {
      minio = {
        enable = false;
        root-credentials = ./minio.sops.yaml;
        dataDirs = [
          "/mnt/atlas/s3"
        ];
      };

      nfs = {
        enable = true;
        exports = ''
          /mnt/nvme 10.0.0.0/8(rw,insecure,all_squash,anonuid=569,anongid=569,no_subtree_check)
        '';
      };

      openssh.enable = true;

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
          members = [ "scotte" ];
        };
        media = {
          gid = 569;
          members = [ "scotte" ];
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

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
