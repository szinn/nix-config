{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.rust;
in
{
  options.features.rust = {
    enable = mkEnableOption "rust";
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      rustup
      sccache
      sea-orm-cli
    ];

    home.file.".cargo/config.toml".source = ./cargo.toml;
  };
}
