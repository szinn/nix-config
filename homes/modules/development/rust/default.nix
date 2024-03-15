{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.development.rust;
in {
  options.modules.development.rust = {
    enable = mkEnableOption "rust";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo-machete
      git-cliff
      rustup
      sccache
      sea-orm-cli
    ];

    home.file.".cargo/config.toml".source = ./cargo.toml;
  };
}
