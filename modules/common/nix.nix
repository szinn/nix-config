{ inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    # Add nixpkgs input to NIX_PATH
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];

    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };
  };

  # nixpkgs = {
  #   # overlays = builtins.attrValues outputs.overlays;
  #   config = {
  #     allowUnfree = true;
  #     allowUnfreePredicate = (_: true);
  #   };
  # };
}
