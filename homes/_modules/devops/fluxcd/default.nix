{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.devops;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fluxcd
    ];

    programs.fish = {
      interactiveShellInit = ''
        # ${pkgs.fluxcd}/bin/flux completion fish > ${config.home.homeDirectory}/.config/fish/completions/flux.fish
        eval (${pkgs.fluxcd}/bin/flux completion fish)
      '';
      functions = {
        flretry = {
          description = "Retry a flux update";
          body = builtins.readFile ./_functions/flretry.fish;
        };
      };
    };
  };
}
