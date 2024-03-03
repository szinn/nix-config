{
  inputs,
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
    hostName = "hera";
    hostId = "decaf108";
    useDHCP = true;
    firewall.enable = false;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    regreet = {
      enable = true;
      cageArgs = ["-dsmlast"];
      settings = {
        GTK.applicationprefer_dark_theme = true;

        commands = {
          reboot = ["systemctl" "reboot"];
          poweroff = ["systemctl" "poweroff"];
        };
      };
    };
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
    sopsFile = ../../homes/scotte/hera/secrets.sops.yaml;
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
