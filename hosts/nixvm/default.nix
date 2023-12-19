{ pkgs, inputs, ... }: {
  imports = [
    {
      nixpkgs.hostPlatform = "aarch64-linux";
    }
    ./hardware-configuration.nix
    ../common/global
    ../common/nixos
    ./scotte.nix
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

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
