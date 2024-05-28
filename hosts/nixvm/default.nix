{
  pkgs,
  config,
  lib,
  ...
}: let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  impermanence = true;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "nixvm";
    hostId = "decaf21a";
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
      ["wheel"]
      ++ ifGroupsExist [
        "network"
        "samba-users"
      ];
  };
  users.groups.scotte = {
    gid = 1000;
  };

  sops = {
    secrets.scotte-password = {
      sopsFile = ../../homes/scotte/hosts/nixvm/secrets.sops.yaml;
      neededForUsers = true;
    };
    age.sshKeyPaths = lib.mkIf impermanence ["/persist/etc/ssh/ssh_host_ed25519_key"];
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules = {
    # filesystems = {
    #   zfs = {
    #     enable = true;
    #     mountPoolsAtBoot = [
    #       "groucho"
    #     ];
    #   };

    #   nfs = {
    #     enable = true;
    #   };

    #   samba = {
    #     enable = true;
    #     shares = {
    #       homes = {
    #         browseable = "no";
    #         "read only" = "no";
    #         "guest ok" = "no";
    #         "create mask" = "0664";
    #         "directory mask" = "0775";
    #       };
    #       Media = {
    #         path = "/mnt/groucho/media";
    #         "read only" = "no";
    #         "force user" = "media";
    #         "force group" = "media";
    #       };
    #     };
    #   };
    # };

    services = {
      # k3s = {
      #   enable = true;
      #   package = pkgs.k3s_1_29;
      #   # extraFlags = [
      #   #   "--tls_san=${config.networking.hostName}.zinn.tech"
      #   # ];
      # };

      # minio = {
      #   enable = true;
      #   root-credentials = ./minio.sops.yaml;
      #   dataDirs = [
      #     "/mnt/groucho/s3"
      #   ];
      # };

      security.openssh.enable = true;
    };

    # users = {
    #   groups = {
    #     homelab = {
    #       gid = 568;
    #       members = ["scotte"];
    #     };
    #     media = {
    #       gid = 569;
    #       members = ["scotte"];
    #     };
    #   };
    #   additionalUsers = {
    #     homelab = {
    #       uid = 568;
    #       group = "homelab";
    #       isNormalUser = false;
    #     };
    #     media = {
    #       uid = 569;
    #       group = "media";
    #       isNormalUser = false;
    #     };
    #   };
    # };

    system = {
      impermanence.enable = impermanence;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
