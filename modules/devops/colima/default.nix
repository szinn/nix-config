{ username }: { config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.${username}.devops.colima;
in
{
  options.modules.${username}.devops.colima = {
    enable = mkEnableOption "colima";
    startService = mkEnableOption "colima service";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = (mkMerge [
      (mkIf (cfg.startService) {
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
      {
        home.packages = with pkgs; [
          colima
          docker-buildx
          docker-client
          docker-compose
        ];
      }
    ]);
  };
}
