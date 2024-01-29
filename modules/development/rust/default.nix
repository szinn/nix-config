{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.development.rust;
in
{
  options.modules.${username}.development.rust = {
    enable = mkEnableOption "rust";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        cargo-machete
        rustup
        sccache
        sea-orm-cli
      ];

      home.file.".cargo/config.toml".source = ./cargo.toml;
    };
  };
}
