{ inputs, lib, pkgs, config, outputs, ... }: {
  imports = [
  ];

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # warn-dirty = false;
    };
  };

  home.stateVersion = "23.11";
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
  xdg.enable = true;
}
