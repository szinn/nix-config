{ config, pkgs, lib, ... }: 
with lib;
let
  cfg = config.modules.gnupg;
in {
  options = {
    modules.gnupg = {
      enable = mkEnableOption "GnuPG";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home-manager.users.${config.user} = {
        programs.gpg = {
          enable = true;
          mutableKeys = true;
          mutableTrust = true;
          publicKeys = [
            { source = ./scotte-keya.asc; trust = 5; }
            { source = ./scotte-keyb.asc; trust = 5; }
            { source = ./charles-keya.asc; trust = 5; }
          ];
          settings = {
            default-key = "2D13 FA40 E115 2976 8168  33B3 B2F1 677D B034 8B42";
            default-recipient-self = true;
            use-agent = false;
          };
        };
      };
      system.activationScripts.postUserActivation.text = ''
        defaults write org.gpgtools.common UseKeychain -bool false
      '';
    })
  ];
}
