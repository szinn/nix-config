{
  description = "Scotte's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake-parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
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

    # VSCode community extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs: let
    mkSystemLib = import ./lib/mkSystem.nix {inherit inputs;};
    overlays = import ./overlays inputs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      imports = [
        ./flake-modules
      ];

      flake = {
        nixosConfigurations = {
          # $ git add . ; sudo nixos-rebuild --flake . switch
          hera = mkSystemLib.mkNixosSystem "x86_64-linux" "hera" overlays;
          # $ git add . ; sudo nixos-rebuild --flake . switch
          nixvm = mkSystemLib.mkNixosSystem "aarch64-linux" "nixvm" overlays;
          # $ git add . ; sudo nixos-rebuild --flake . switch
          ragnar = mkSystemLib.mkNixosSystem "x86_64-linux" "ragnar" overlays;
        };

        darwinConfigurations = {
          # $ git add . ; darwin-rebuild --flake . switch
          macvm = mkSystemLib.mkDarwinSystem "aarch64-darwin" "macvm" overlays;
          # $ git add . ; darwin-rebuild --flake . switch
          odin = mkSystemLib.mkDarwinSystem "aarch64-darwin" "odin" overlays;
        };
      };
    };
}
