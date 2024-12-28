{
  description = "Scotte's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    # impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # deploy-rs
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nh from the source
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode community extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust toolchain overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };

    # Krewfile
    krewfile = {
      url = "github:brumhard/krewfile";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust via Fenix
    # fenix = {
    #   url = "github:nix-community/fenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Talhelper
    talhelper = {
      url = "github:budimanjojo/talhelper";
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs: let
    mkPkgsWithSystem = system:
      import inputs.nixpkgs {
        inherit system;

        overlays = import ./overlays inputs;
        config.allowUnfree = true;
      };
    mkSystemLib = import ./lib/mkSystem.nix {inherit inputs mkPkgsWithSystem;};
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem = {
        system,
        inputs',
        pkgs,
        ...
      }: {
        # override pkgs used by everything in `perSystem` to have my overlays
        _module.args.pkgs = mkPkgsWithSystem system;
        # accessible via `nix build .#<name>`
        packages = import ./pkgs {inherit pkgs inputs;};
      };

      imports = [
        ./flake-modules
      ];

      flake = let
        flake-packages = self.packages;
      in
        {
          nixosConfigurations = {
            # $ git add . ; sudo nixos-rebuild --flake . switch
            hera = mkSystemLib.mkNixosSystem "x86_64-linux" "hera" flake-packages;
            # $ git add . ; sudo nixos-rebuild --flake . switch
            nixvm = mkSystemLib.mkNixosSystem "aarch64-linux" "nixvm" flake-packages;
            # $ git add . ; sudo nixos-rebuild --flake . switch
            # ragnar = mkSystemLib.mkNixosSystem "x86_64-linux" "ragnar" flake-packages;
            # $ git add . ; sudo nixos-rebuild --flake . switch
            titan = mkSystemLib.mkNixosSystem "x86_64-linux" "titan" flake-packages;
          };

          darwinConfigurations = {
            # $ git add . ; darwin-rebuild --flake . switch
            # macvm = mkSystemLib.mkDarwinSystem "aarch64-darwin" "macvm" flake-packages;
            # $ git add . ; darwin-rebuild --flake . switch
            # odin = mkSystemLib.mkDarwinSystem "aarch64-darwin" "odin" flake-packages;
          };

          # Convenience output that aggregates the outputs for home, nixos.
          # Also used in ci to build targets generally.
          ciSystems = let
            nixos =
              inputs.nixpkgs.lib.genAttrs
              (builtins.attrNames self.nixosConfigurations)
              (attr: self.nixosConfigurations.${attr}.config.system.build.toplevel);
            darwin =
              inputs.nixpkgs.lib.genAttrs
              (builtins.attrNames self.darwinConfigurations)
              (attr: self.darwinConfigurations.${attr}.system);
          in
            nixos // darwin;
        }
        // import ./deploy.nix inputs;
    };
}
