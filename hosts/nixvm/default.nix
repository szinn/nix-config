{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ( import ../../users/scotte { hostname = "nixvm"; username = "scotte"; homeDirectory = "/home/scotte"; } )
  ];

  networking = {
    hostName = "nixvm";
    useDHCP = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
