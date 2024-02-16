{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  mkNixosSystem = system: hostname: overlays: inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = overlays;
    };
    modules = [
      {
        nixpkgs.hostPlatform = system;
        _module.args = {
          inherit inputs system;
        };
      }
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      ../modules/common
      ../modules/nixos
      ../hosts/${hostname}
    ];
    specialArgs = {
      inherit inputs;
      hostname = hostname;
    };
  };

  mkDarwinSystem = system: hostname: overlays: inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = overlays;
    };
    modules = [
      {
        nixpkgs.hostPlatform = system;
        _module.args = {
          inherit inputs system;
        };
      }
      inputs.home-manager.darwinModules.home-manager
      ../modules/common
      ../modules/darwin
      ../hosts/${hostname}
    ];
    specialArgs = {
      inherit inputs;
      hostname = hostname;
    };
  };
}
