{ config, lib, pkgs, ... }: {
  config = {
    home.packages = with pkgs; [
      cilium-cli
      cloudflared
      fluxcd
      k9s
      krew
      kubectl
      kubectl-cnpg
      kubernetes-helm
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
