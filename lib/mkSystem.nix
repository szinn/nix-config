{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  mkNixosSystem = system: hostname: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      {
        _module.args = {
          inherit inputs system;
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            # overlays = [ (import ../packages/overlay.nix {inherit inputs system;}) ];
          };
        };
      }
      ../hosts/${hostname}
    ];
    specialArgs = { inherit inputs; };
  };

  mkDarwinSystem = system: hostname: inputs.nix-darwin.lib.darwinSystem {
    modules = [
      {
        _module.args = {
          inherit inputs system;
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            # overlays = [ (import ../packages/overlay.nix {inherit inputs system;}) ];
          };
        };
      }
      ../hosts/${hostname}
    ];
    specialArgs = { inherit inputs; };
  };
}
