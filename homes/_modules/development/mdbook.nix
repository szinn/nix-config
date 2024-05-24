{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.development.mdbook;
in {
  options.modules.development.mdbook = {
    enable = mkEnableOption "mdbook";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mdbook
      mdbook-admonish
      mdbook-linkcheck
      mdbook-toc
    ];
  };
}
