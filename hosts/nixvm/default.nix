{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "nixvm";
    hostId = "decaf21a";
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
        "groucho"
      ];
    };

    services = {
      k3s = {
        enable = true;
        package = pkgs.k3s_1_29;
        # extraFlags = [
        #   "--tls_san=${config.networking.hostName}.zinn.tech"
        # ];
      };

      minio = {
        enable = true;
        root-credentials = ./minio.sops.yaml;
        dataDirs = [
          "/mnt/groucho/s3"
        ];
      };

      nfs = {
        enable = true;
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
          Media = {
            path = "/mnt/groucho/media";
            "read only" = "no";
            "force user" = "media";
            "force group" = "media";
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
