{
  description = "Scotte's Nix Configuration";

  inputs = {
    # Nixpkgs and unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # VSCode community extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, ... }@inputs:
    let
      mkSystemLib = import ./lib/mkSystem.nix { inherit inputs; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      perSystem = { config, pkgs, ... }: {
        devShells = import ./shell.nix {
          inherit pkgs;
          config.allowUnfree = true;
        };
        formatter = pkgs.nixpkgs-fmt;
      };

      flake = rec {
        nixosConfigurations = {
          # $ git add . ; sudo nixos-rebuild --flake . switch
          hera = mkSystemLib.mkNixosSystem "x86_64-linux" "hera";
          # $ git add . ; sudo nixos-rebuild --flake . switch
          nixvm = mkSystemLib.mkNixosSystem "aarch64-linux" "nixvm";
        };

        darwinConfigurations = {
          # $ git add . ; darwin-rebuild --flake . switch
          macvm = mkSystemLib.mkDarwinSystem "aarch64-darwin" "macvm";
          # $ git add . ; darwin-rebuild switch --flake .
          odin = mkSystemLib.mkDarwinSystem "aarch64-darwin" "odin";
        };
      };
    };
}
