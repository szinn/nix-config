{ inputs, ... }:
  inputs.nix-darwin.lib.darwinSystem {
    modules = [
      {
        networking.hostName = "macvm";
        nixpkgs.hostPlatform = "aarch64-darwin";
      }
      ../../users/scotte_home.nix
      inputs.home-manager.darwinModules.home-manager
      ../../modules/common
      ../../modules/darwin
    ];
    specialArgs = { inherit inputs; };
  }
