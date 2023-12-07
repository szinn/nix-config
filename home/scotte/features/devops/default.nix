{ config, lib, pkgs, ... }: {
  config = {
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
}
