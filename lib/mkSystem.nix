{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  mkNixosSystem = system: hostname: overlays:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          # nixpkgs.overlays = overlays;
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
              inherit inputs hostname;
            };
            users.scotte = ../. + "/homes/scotte";
          };
        }
        ../hosts/modules/common
        ../hosts/modules/nixos
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs hostname;
      };
    };

  mkDarwinSystem = system: hostname: overlays:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          # nixpkgs.overlays = overlays;
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
              inherit inputs hostname;
            };
            users.scotte = ../. + "/homes/scotte";
          };
        }
        ../hosts/modules/common
        ../hosts/modules/darwin
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs hostname;
      };
    };
}
