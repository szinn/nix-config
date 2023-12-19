{ config, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.gc.dates = "weekly";
}
