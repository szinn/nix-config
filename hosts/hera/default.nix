{
  inputs,
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
    # ./hyprland.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  networking = {
    hostName = "hera";
    hostId = "decaf108";
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
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
      sopsFile = ../../homes/scotte/hosts/hera/secrets.sops.yaml;
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
      security.openssh.enable = true;
    };
    system = {
      impermanence.enable = impermanence;
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
