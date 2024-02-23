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
        ../modules/common
        ../modules/nixos
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
        ../modules/common
        ../modules/darwin
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs;
        hostname = hostname;
      };
    };

  mkNewDarwinSystem = system: hostname: overlays:
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
            users.scotte = ../. + "/homes-new/scotte";
          };
          nixpkgs.overlays = overlays;
        }
        ../hosts-new/modules/common
        ../hosts-new/modules/darwin
        ../hosts-new/${hostname}
      ];
      specialArgs = {
        inherit inputs;
        hostname = hostname;
      };
    };

  mkHomeManagerSystem = system: hostname: username: overlays:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
        overlays = overlays;
      };
      modules = [
        ../homes-new/${username}
      ];
      extraSpecialArgs = {
        inherit inputs;
        hostname = hostname;
      };
    };
}
