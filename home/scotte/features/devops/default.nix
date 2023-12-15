{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.devops;
in
{
  options.features.devops = {
    enable = mkEnableOption "devops";
  };

  config = mkIf (cfg.enable) {
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
      functions = {
        flretry = {
          description = "Retry a flux update";
          body = builtins.readFile ./functions/flretry.fish;
        };
        kcon = {
          description = "Switch active talos/kubctl environments";
          body = builtins.readFile ./functions/kcon.fish;
        };
        leases = {
          description = "Show VyOS DHCP leases";
          body = builtins.readFile ./functions/leases.fish;
        };
      };
    };
  };
}
