{
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
    ./secrets.nix
  ];

  networking = {
    hostName = "titan";
    hostId = "10000007";
    useDHCP = lib.mkDefault false;
    firewall.enable = false;
  };

  services.resolved.enable = false;

  systemd = {
    network = {
      enable = true;
      networks = {
        "00-vlan" = {
          matchConfig.Name = "enp1s0";
          networkConfig = {
            DHCP = "yes";
          };
          linkConfig = {
            RequiredForOnline = "routable";
          };
        };
        "11-vlan" = {
          matchConfig.Name = "enp2s0";
          networkConfig = {
            DHCP = "no";
            IPv4ProxyARP = true;
          };
          address = [
            "10.11.0.15/16"
          ];
          routes = [
            {
              Gateway = "10.11.0.1";
            }
          ];
          linkConfig = {
            RequiredForOnline = "routable";
          };
        };
        "12-vlan" = {
          matchConfig.Name = "enp3s0";
          DHCP = "no";
          networkConfig = {
            DHCP = "no";
            IPv4ProxyARP = true;
          };
          address = [
            "10.12.0.15/16"
          ];
          routes = [
            {
              Gateway = "10.12.0.1";
            }
          ];
          linkConfig = {
            RequiredForOnline = "routable";
          };
        };
      };
    };

    services.sshd = {
      wants = ["network-online.target"];
      after = ["network-online.target"];
    };
    services.haproxy = {
      wants = ["multi-user.target"];
      after = ["multi-user.target"];
    };
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
      sopsFile = ../../homes/scotte/hosts/titan/secrets.sops.yaml;
      neededForUsers = true;
    };
    age.sshKeyPaths = lib.mkIf impermanence ["/persist/etc/ssh/ssh_host_ed25519_key"];
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules = {
    services = {
      monitoring = {
        prometheus.enable = true;
        gatus = {
          enable = true;
          configFile = config.sops.secrets."gatus/config.yaml".path;
        };
      };

      ntp.chrony = {
        enable = true;
        servers = [
          "0.ca.pool.ntp.org"
          "1.ca.pool.ntp.org"
          "2.ca.pool.ntp.org"
          "3.ca.pool.ntp.org"
        ];
      };

      dns = {
        cloudflare-dyndns = {
          enable = true;
          apiTokenFile = config.sops.secrets."networking/cloudflare/api-token".path;
          domains = ["zinn.tech" "vpn.zinn.tech"];
        };

        dnsdist = {
          enable = false;
          config = builtins.readFile ./config/dnsdist.conf;
        };

        bind = {
          enable = false;
          config = import ./config/bind.nix {inherit config;};
        };

        blocky = {
          enable = false;
          package = pkgs.blocky;
          config = import ./config/blocky.nix;
        };

        adguardhome = {
          enable = true;
          host = "10.0.0.7";
          port = 3000;
          mutableSettings = false;
          passwordPath = config.sops.secrets.adguardhome-password.path;
          settings = import ./config/adguardhome.nix {inherit lib;};
        };
      };

      networking = {
        haproxy = {
          enable = true;
          config = builtins.readFile ./config/haproxy.cfg;
        };
      };

      security = {
        openssh.enable = true;
        onepassword-connect = {
          enable = true;
          credentialsFile = config.sops.secrets.onepassword-credentials.path;
          port = 8438;
        };
      };
    };

    system = {
      impermanence.enable = impermanence;
    };

    # users = {
    #   groups = {
    #   };
    #   additionalUsers = {
    #   };
    # };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
