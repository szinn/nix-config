{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.services.minio;
in {
  options.modules.services.minio = {
    enable = mkEnableOption "minio";
    root-credentials = mkOption {
      type = types.path;
    };
    dataDirs = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      minio-client
    ];

    networking.firewall.allowedTCPPorts = [9000 9001];

    services.minio = {
      enable = true;
      dataDir = cfg.dataDirs;
      rootCredentialsFile = config.sops.secrets.root-credentials.path;
    };

    sops.secrets.root-credentials = {
      sopsFile = cfg.root-credentials;
      restartUnits = ["minio.service"];
    };
  };
}
