{ inputs, ... }:
  inputs.nix-darwin.lib.darwinSystem {
    modules = [
      {
        networking.hostName = "macvm";
        nixpkgs.hostPlatform = "aarch64-darwin";
        time.timeZone = "America/Toronto";
        user = "scotte";
        fullName = "Scotte Zinn";
        gitName = "Scotte Zinn";
        gitEmail = "scotte@zinn.ca";
      }
      inputs.home-manager.darwinModules.home-manager
      ../../modules/common
      ../../modules/darwin
    ];
  }
