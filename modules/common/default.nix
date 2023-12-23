{ inputs, pkgs, ... }:
{
  imports = [
    ./locale.nix
    ./nix.nix
    ./shells.nix
    ./sops.nix
    ../users
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
  };
}
