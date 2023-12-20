{ lib, pkgs, config, inputs, ... }:
with lib;
let
  cfg = config.features.sops;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.features.sops = {
    enable = mkEnableOption "sops";
    defaultSopsFile = mkOption {
      type = types.path;
    };
    secrets = mkOption {
      type = types.attrs;
      default = { };
    };
    ageKeyFile = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/age/keys.txt";
    };
  };
  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = cfg.defaultSopsFile;
      age.keyFile = cfg.ageKeyFile;
      secrets = cfg.secrets;
    };
  };
}
