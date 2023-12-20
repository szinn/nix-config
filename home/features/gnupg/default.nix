{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.gnupg;
in
{
  options.features.gnupg = {
    enable = mkEnableOption "gnupg";
  };

  config = mkIf cfg.enable {
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
    home.packages = with pkgs; [ pinentry ];
  };
}
