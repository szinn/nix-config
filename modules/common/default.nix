{ inputs, pkgs, ... }:
{
  imports = [
    ./locale.nix
    ./nix.nix
    ./shells.nix
    ../../users
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
  };
}
