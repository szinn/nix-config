{ inputs, pkgs, ... }:
{
  imports = [
    ./locale.nix
    ./nix.nix
    ./shells.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
  };
}
