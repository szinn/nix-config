{
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
    hostName = "titan";
    hostId = "10000008";
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

  sops.secrets.scotte-password = {
    sopsFile = ../../homes/scotte/hosts/titan/secrets.sops.yaml;
    neededForUsers = true;
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules = {
    services = {
      openssh.enable = true;
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
