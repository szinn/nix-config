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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      inherit lib;
      # templates = import ./templates;

      overlays = { };
      # overlays = import ./overlays { inherit inputs outputs; };

      # packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      # nixosConfigurations = {
      #   atlas =  lib.nixosSystem {
      #     modules = [ ./hosts/atlas ];
      #     specialArgs = { inherit inputs outputs; };
      #   };
      # };

      darwinConfigurations = {
        # $ git add . ; darwin-rebuild switch --flake .#macvm
        macvm = nix-darwin.lib.darwinSystem {
          modules = [ ./hosts/macvm ];
          specialArgs = { inherit inputs outputs; };
        };
        # $ git add . ; darwin-rebuild switch --flake .#odin
        odin = nix-darwin.lib.darwinSystem {
          modules = [ ./hosts/odin ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        # $ git add . ; home-manager switch --flake .#"scotte@macvm"
        "scotte@macvm" = lib.homeManagerConfiguration {
          modules = [ ./home/scotte/macvm.nix ];
          pkgs = pkgsFor.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
        };
        # $ git add . ; home-manager switch --flake .#"scotte@odin"
        "scotte@odin" = lib.homeManagerConfiguration {
          modules = [ ./home/scotte/odin.nix ];
          pkgs = pkgsFor.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
