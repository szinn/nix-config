{
  description = "Scotte's Nix Configuration";

  inputs = {
    # Nixpkgs and unstable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
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
    
    # Convert Nix to Neovim config
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      mkSystemLib = import ./lib/mkSystem.nix { inherit inputs; };
      lib = nixpkgs.lib // home-manager.lib;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });

      overlays = import ./lib/generateOverlays.nix inputs;
    in
    {
      inherit lib;

      templates = import ./templates;
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs:
        import ./shell.nix {
          inherit pkgs;
          buildInputs = with pkgs; [
          ];
        });
      formatter = forEachSystem (pkgs:
        pkgs.nixpkgs-fmt
      );

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
        # $ git add . ; darwin-rebuild switch --flake .
        odin = mkSystemLib.mkDarwinSystem "aarch64-darwin" "odin" overlays;
      };
    };
}
