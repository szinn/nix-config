{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.devops.colima;
in {
  options.modules.devops.colima = {
    enable = mkEnableOption "colima";
    startService = mkEnableOption "colima service";
  };

  config = mkMerge [
    (mkIf (cfg.enable && cfg.startService) {
      launchd.agents.colima = {
        enable = true;
        config = {
          EnvironmentVariables = {
            PATH = "/Users/${config.home.username}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
          };
          ProgramArguments = [
            "${pkgs.colima}/bin/colima"
            "start"
            "--foreground"
            "--arch"
            "aarch64"
            "--vm-type"
            "vz"
            "--vz-rosetta"
          ];
          KeepAlive = {
            Crashed = true;
            SuccessfulExit = false;
          };
          ProcessType = "Interactive";
        };
      };
    })
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        colima
        docker-buildx
        docker-client
        docker-compose
      ];
    })
  ];
}
