{ inputs, pkgs, ... }:
{
  imports = [
    ./dock-utils.nix
    ./homebrew.nix
    ./nfs
    ./nix.nix
    ./shells.nix
    ./ui-defaults.nix
  ];

  system.stateVersion = 4;
}
