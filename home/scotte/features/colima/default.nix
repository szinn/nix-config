{ startService }: { config, lib, pkgs, ... }:
with lib;
{
  config = mkMerge [
    (mkIf (startService) {
      launchd.agents.colima = mkIf {
        enable = true;
        config = {
          EnvironmentVariables = {
            PATH = "/Users/${config.home.username}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
          };
          ProgramArguments = [
            "${pkgs.colima}/bin/colima"
            "start"
            "--foreground"
              "--arch" "aarch64"
              "--vm-type" "vz"
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
  ];
}
