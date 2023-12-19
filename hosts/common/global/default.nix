{ config, inputs, outputs, ... }:
{
  imports = [
    ./nix.nix
    ./shells.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
  };
}
