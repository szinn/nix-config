{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.filesystems.nfs;
in {
  options.modules.filesystems.nfs = {
    enable = mkEnableOption "nfs";
    exports = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    services.nfs.server.enable = true;
    services.nfs.server.exports = cfg.exports;
    networking.firewall.allowedTCPPorts = [2049];
  };
}
