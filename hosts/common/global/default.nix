{ config, inputs, outputs, ... }:
{
  imports = [
    ./nix.nix
    ./shells.nix
  ];

  services.nix-daemon.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
  };
}
