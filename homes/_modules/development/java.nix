{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.development.java;
in {
  options.modules.development.java = {
    enable = mkEnableOption "java";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jdk
    ];
  };
}
