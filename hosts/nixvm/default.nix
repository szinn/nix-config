{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ( import ../../users/scotte { hostname = "nixvm"; username = "scotte"; homeDirectory = "/home/scotte"; } )
  ];

  modules = {
    filesystems.zfs = {
      enable = true;
      mountPoolsAtBoot = [
        "groucho"
      ];
    };

    services =  {
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
        members = ["scotte"];
      };
    };
  };

  networking = {
    hostName = "nixvm";
    hostId = "decaf21a";
    useDHCP = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
