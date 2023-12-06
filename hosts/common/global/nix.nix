{ inputs, lib, ... }: {
  services.nix-daemon.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };

    # Add nixpkgs input to NIX_PATH
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };
}
