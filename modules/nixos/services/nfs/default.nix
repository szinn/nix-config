{ lib, config, ... }:
with lib;
let
  cfg = config.modules.services.nfs;
in
{
  options.modules.services.nfs = {
    enable = mkEnableOption "nfs";
  };

  config = mkIf cfg.enable {
    services.nfs.server.enable = true;
    networking.firewall.allowedTCPPorts = [ 2049 ];
  };
}
