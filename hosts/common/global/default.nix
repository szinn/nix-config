{ config, inputs, ... }:
{
  imports = [
    ./nix.nix
    ./shells.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
  };
}
