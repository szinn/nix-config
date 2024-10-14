{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  devops_cfg = config.modules.devops;
in {
  config = mkIf devops_cfg.enable {
    programs.krewfile = {
      enable = true;
      krewPackage = pkgs.krew;
      indexes = {
        netshoot = "https://github.com/nilic/kubectl-netshoot.git";
      };
      plugins = [
        "browse-pvc"
        "rook-ceph"
        "netshoot/netshoot"
      ];
    };
  };
}
