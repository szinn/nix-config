{ config, inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./nfs
    ./ui-defaults.nix
  ];

  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false; # Don't update during rebuild
      cleanup = "zap"; # Uninstall all programs not declared
      upgrade = true;
    };
    global = {
      brewfile = true; # Run brew bundle from anywhere
      lockfiles = false; # Don't save lockfile (since running from anywhere)
    };
    taps = [
    ];
  };
}
