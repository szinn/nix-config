{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.devops;
in {
  imports = [
    ./colima
    ./fluxcd
    ./k9s
  ];

  options.modules.devops = {
    enable = mkEnableOption "devops";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cilium-cli
      cloudflared
      hubble
      krew
      kubectl
      kubectl-cnpg
      kubernetes-helm
      kustomize_4
      minio-client
      opentofu
      pulumi-bin
      talhelper
      talosctl
      terraform
    ];

    programs.fish = {
      shellAliases = {
        k = "kubectl";
        tf = "terraform";
      };
      functions = {
        kcon = {
          description = "Switch active talos/kubctl environments";
          body = builtins.readFile ./_functions/kcon.fish;
        };
        leases = {
          description = "Show VyOS DHCP leases";
          body = builtins.readFile ./_functions/leases.fish;
        };
      };
    };
  };
}
