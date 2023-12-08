{ config, pkgs, lib, ... }: {
  config = {
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
        "homebrew/cask" # Required for casks
      ];
      casks = [
        "1password" # 1Password packaging on Nix is broken for macOS
      ];
    };
  };
}
