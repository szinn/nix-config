{
  pkgs,
  config,
  ...
}: let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  networking = {
    hostName = "titan";
    hostId = "10000007";
    useDHCP = true;
    firewall.enable = false;

    vlans = {
      vlan11 = {
        id = 11;
        interface = "enp1s0";
      };
      vlan12 = {
        id = 12;
        interface = "enp1s0";
      };
    };

    interfaces = {
      vlan11.ipv4.addresses = [
        {
          address = "10.11.0.15";
          prefixLength = 16;
        }
      ];
      vlan12.ipv4.addresses = [
        {
          address = "10.12.0.15";
          prefixLength = 16;
        }
      ];
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

  sops = {
    secrets.scotte-password = {
      sopsFile = ../../homes/scotte/hosts/titan/secrets.sops.yaml;
      neededForUsers = true;
    };
    age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
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
          enable = true;
          config = builtins.readFile ./config/dnsdist.conf;
        };

        bind = {
          enable = true;
          config = import ./config/bind.nix {inherit config;};
        };

        blocky = {
          enable = true;
          package = pkgs.blocky;
          config = import ./config/blocky.nix;
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
      impermanence.enable = true;
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
