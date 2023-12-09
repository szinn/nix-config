{ config, lib, pkgs, ... }: {
  config = {
    home.packages = with pkgs; [
      fluxcd
      k9s
      krew
      kubectl
      kubectl-cnpg
      kustomize_4
      talosctl
      terraform
    ];

    programs.fish = {
      shellAliases = {
        k = "kubectl";
        tf = "terraform";
      };
      interactiveShellInit = ''
        flux completion fish | source
      '';
    };
  };
}
