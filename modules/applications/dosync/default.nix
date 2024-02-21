{username}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.${username}.applications.dosync;
  dosync = pkgs.writeShellScriptBin "dosync" (builtins.readFile ./dosync);
  restore = pkgs.writeShellScriptBin "restore" (builtins.readFile ./restore);
in {
  options.modules.${username}.applications.dosync = {
    enable = mkEnableOption "dosync";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [
        dosync
        restore
        pkgs.rsync
      ];
    };
  };
}
