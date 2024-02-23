{pkgs, config, ...}:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "hera";
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
    openssh.authorizedKeys.keys = [(builtins.readFile ../../homes-new/scotte/ssh/ssh.pub)];
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
    sopsFile = ../../homes-new/scotte/hera/secrets.sops.yaml;
    neededForUsers = true;
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules = {
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
          members = ["scotte"];
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

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
