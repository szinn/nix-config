{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.gnupg;
in
{
  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      pinentry-curses
    ];

    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "curses";
    };

    programs =
      let 
        fixGpg = ''
          gpgconf --launch gpg-agent
        '';
      in
      {
        bash.profileExtra = fixGpg;
        fish.loginShellInit = fixGpg;
        zsh.loginExtra = fixGpg;
      };
  };
}
