{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "nixvm";
    hostId = "decaf21a";
    useDHCP = true;
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
      minio = {
        enable = true;
        root-credentials = ./minio.sops.yaml;
      };
      nfs = {
        enable = true;
      };
    };

    users.groups = {
      admins = {
        gid = 991;
        members = [ "scotte" ];
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
