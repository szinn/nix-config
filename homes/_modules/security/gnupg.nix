{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.gnupg;
in {
  options.modules.security.gnupg = {
    enable = mkEnableOption "gnupg";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.gpg = {
        enable = true;
        mutableKeys = true;
        mutableTrust = true;
        settings = {
          default-key = "2D13 FA40 E115 2976 8168  33B3 B2F1 677D B034 8B42";
          default-recipient-self = true;
          use-agent = true;
        };
      };
    })
    (mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
      home.packages = with pkgs; [pinentry_mac];
    })
    (mkIf (cfg.enable && pkgs.stdenv.isLinux) {
      home.packages = with pkgs; [
        pinentry-curses
      ];

      services.gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-curses;
      };

      programs = let
        fixGpg = ''
          gpgconf --launch gpg-agent
        '';
      in {
        bash.profileExtra = fixGpg;
        fish.loginShellInit = fixGpg;
        zsh.loginExtra = fixGpg;
      };
    })
  ];
}
