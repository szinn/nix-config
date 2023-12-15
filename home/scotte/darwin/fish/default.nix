{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.fish;
in
{
  config.programs.fish = mkIf (cfg.enable) {
    functions = {
      flushdns = {
        description = "Flush DNS cache";
        body = builtins.readFile ./functions/flushdns.fish;
      };
    };
  };
}
