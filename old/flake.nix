{
  description = "Scotte's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: 
    let 
      overlays = [];

      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in rec {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macvm
      darwinConfigurations = {
        macvm = import ./hosts/macvm { inherit inputs overlays; };
      };

      # home-manager switch --flake .#"scotte@macvm"
      homeConfigurations = {
        "scotte@macvm" = darwinConfigurations.macvm.config.home-manager.users.scotte.home;
      };

      # Development environments
      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in {
          # Used to run commands and edit files in this repo
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ git age gnupg sops nixfmt shfmt home-manager shellcheck ];
          };
        });
    };
}
