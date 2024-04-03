{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.development.rust;
  rustc = pkgs.rust-bin.stable.latest.default.override {
    extensions = ["rust-src"];
  };
in {
  options.modules.development.rust = {
    enable = mkEnableOption "rust";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        cargo-machete
        git-cliff
        sccache
        sea-orm-cli
      ]
      ++ [rustc];

    home.file.".cargo/config.toml".source = ./cargo.toml;
  };
}
