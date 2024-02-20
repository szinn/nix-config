{ inputs, pkgs, ... }:
{
  imports = [
    ./locale.nix
    ./nix.nix
    ./shells.nix
    ../users
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
}
