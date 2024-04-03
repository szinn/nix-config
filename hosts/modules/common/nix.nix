{
  inputs,
  lib,
  ...
}: {
  nix = {
    settings = {
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];

      warn-dirty = false;

      extra-substituters = [
        "https://szinn.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "szinn.cachix.org-1:9gbZrHCd1BYMUuMCinvG2fTu98Jubp8y8tLE3jipABM="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # The default at 10 is rarely enough.
      log-lines = lib.mkDefault 25;

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;
    };

    # Add nixpkgs input to NIX_PATH
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];

    # garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };
  };
}
