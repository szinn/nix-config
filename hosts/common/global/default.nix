{ inputs, outputs, ... }: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./shell.nix
  ];

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
