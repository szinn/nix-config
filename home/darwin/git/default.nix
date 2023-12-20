{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.git;
in
{
  config.programs.git = mkIf cfg.enable {
    extraConfig = {
      credential = { helper = "osxkeychain"; };
    };
  };
}
