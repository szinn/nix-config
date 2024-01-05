{ username }: { config, lib, pkgs, pkgs-unstable, ... }:
with lib;
let
  cfg = config.modules.${username}.devops;
in
{
  imports = [
    (import ./colima { username = username; })
  ];

  options.modules.${username}.devops = {
    enable = mkEnableOption "devops";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        cloudflared
        k9s
        krew
        kubectl
        kubectl-cnpg
        kubernetes-helm
        kustomize_4
        minio-client
        terraform
      ] ++ (with pkgs-unstable; [
        cilium-cli
        fluxcd
        hubble
        talosctl
      ]);

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
  };
}
