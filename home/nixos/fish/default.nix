{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.scotte.fish;
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
