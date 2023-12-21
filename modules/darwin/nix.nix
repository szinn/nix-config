{ pkgs, ... }:
{
  nix.gc.interval = {
    Hour = 12;
    Minute = 15;
    Day = 1;
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
}
