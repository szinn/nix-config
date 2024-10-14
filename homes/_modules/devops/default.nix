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
    ./colima.nix
    ./fluxcd.nix
    ./k9s.nix
    ./krewfile.nix
  ];

  options.modules.devops = {
    enable = mkEnableOption "devops";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cilium-cli
      cloudflared
      hubble
      kubectl
      kubectl-cnpg
      kubernetes-helm
      kustomize_4
      minio-client
      opentofu
      talhelper
      talosctl
      terraform
    ];

    programs = {
      fish = {
        shellAliases = {
          k = "kubectl";
          tf = "terraform";
        };
        functions = {
          kcon = {
            description = "Switch active talos/kubctl environments";
            body = builtins.readFile ./_functions/kcon.fish;
          };
        };
      };
    };
  };
}
