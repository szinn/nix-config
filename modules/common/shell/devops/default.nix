{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.devops;
in {
  options = {
    modules.devops = {
      enable = mkEnableOption "DevOps";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home-manager.users.${config.user} = {
        home.packages = with pkgs; [
          fluxcd
          kubectl
        ];

        programs.fish = {
          shellAliases = {
            k = "kubectl";
          };
          interactiveShellInit = ''
            flux completion fish | source
          '';
        };
      };
    })
  ];
}
