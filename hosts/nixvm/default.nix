{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/nixos
    ./scotte.nix
  ];

  networking = {
    hostName = "nixvm";
    useDHCP = true;
  };

  home-manager.users.scotte = import ../../home/users/scotte/${config.networking.hostName}.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "23.11";
}
