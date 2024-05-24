{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.one-password;
in {
  options.modules.security.one-password = {
    enable = mkEnableOption "_1password";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password
    ];
  };
}
