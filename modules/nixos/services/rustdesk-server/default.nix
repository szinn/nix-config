{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.services.rustdesk-server;
in
{
  options.modules.services.rustdesk-server = {
    enable = mkEnableOption "rustdesk-server";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rustdesk-server
    ];
  };
}
