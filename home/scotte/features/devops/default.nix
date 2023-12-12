{ config, lib, pkgs, ... }: {
  config = {
    home.packages = with pkgs; [
      ansible
      cilium-cli
      cloudflared
      fluxcd
      k9s
      krew
      kubectl
      kubectl-cnpg
      kubernetes-helm
      kustomize_4
      minio-client
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
