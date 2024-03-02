{...}: {
  imports = [
    ./dock-utils.nix
    ./homebrew.nix
    ./nfs
    ./nix.nix
    ./shells.nix
    ./ui-defaults.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 4;
}
