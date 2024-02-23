{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  mkNixosSystem = system: hostname: overlays:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
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
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs;
              hostname = hostname;
            };
            users.scotte = ../. + "/homes/scotte";
          };
          nixpkgs.overlays = overlays;
        }
        ../hosts/modules/common
        ../hosts/modules/nixos
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs;
        hostname = hostname;
      };
    };

  mkDarwinSystem = system: hostname: overlays:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
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
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs;
              hostname = hostname;
            };
            users.scotte = ../. + "/homes/scotte";
          };
          nixpkgs.overlays = overlays;
        }
        ../hosts/modules/common
        ../hosts/modules/darwin
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs;
        hostname = hostname;
      };
    };
}
