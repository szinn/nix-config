{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.fish;
in
{
  config.programs.fish = mkIf cfg.enable {
    functions = {
      agent = {
        description = "Start SSH agent";
        body = builtins.readFile ./functions/agent.fish;
      };
    };
  };
}
