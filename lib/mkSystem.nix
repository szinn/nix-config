{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  mkNixosSystem = system: hostname: inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };

      # overlays = [
      #   (import ../packages/overlay.nix {inherit inputs system;})
      # ];
    };
    modules = [
      {
        nixpkgs.hostPlatform = system;
        _module.args = {
          inherit inputs system;
        };
      }
      inputs.home-manager.nixosModules.home-manager
      ../modules/common
      ../modules/nixos
      ../hosts/${hostname}
    ];
    specialArgs = {
      inherit inputs;
      hostname = hostname;
    };
  };

  mkDarwinSystem = system: hostname: inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      # overlays = [
      #   (import ../packages/overlay.nix {inherit inputs system;})
      # ];
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
