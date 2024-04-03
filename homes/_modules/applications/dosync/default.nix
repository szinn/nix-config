{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.applications.dosync;
  dosync = pkgs.writeShellScriptBin "dosync" (builtins.readFile ./dosync);
  restore = pkgs.writeShellScriptBin "restore" (builtins.readFile ./restore);
in {
  options.modules.applications.dosync = {
    enable = mkEnableOption "dosync";
  };

  config = mkIf cfg.enable {
    home.packages = [
      dosync
      restore
      pkgs.rsync
    ];
  };
}
