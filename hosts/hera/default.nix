{ config, pkgs, ... }: {
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

    services = {
      minio = {
        enable = true;
        root-credentials = ./minio.sops.yaml;
        dataDirs = [
          "/mnt/atlas/s3"
        ];
      };

      nfs = {
        enable = true;
        exports = ''
          /mnt/atlas/k8s  10.0.0.0/8(rw,insecure,no_subtree_check,all_squash,anonuid=568,anongid=568)
          /mnt/atlas/media  10.0.0.0/8(rw,insecure,no_subtree_check,all_squash,anonuid=568,anongid=568)
        '';
      };

      openssh.enable = true;
    };

    users = {
      groups = {
        homelab = {
          gid = 568;
          members = [ "scotte" ];
        };
      };
      additionalUsers = {
        homelab = {
          uid = 568;
          group = "homelab";
          isNormalUser = false;
        };
      };
    };
  };

  sops.secrets.scotte-password = {
    sopsFile = ../../modules/users/scotte/hera/secrets.sops.yaml;
    neededForUsers = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
