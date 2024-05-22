{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.podman;
in
  with lib; {
    options.modules.services.podman = {
      enable = mkEnableOption "podman";
    };

    config = mkIf cfg.enable {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          autoPrune = {
            enable = true;
            dates = "weekly";
          };
        };
        oci-containers = {
          backend = "podman";
        };
      };
    };
  }
