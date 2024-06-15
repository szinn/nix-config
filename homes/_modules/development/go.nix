{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.development.go;
in {
  options.modules.development.go = {
    enable = mkEnableOption "go";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      golangci-lint
    ];

    programs.go = {
      enable = true;
      goPath = "go";
      goBin = "go/bin";
    };
  };
}
