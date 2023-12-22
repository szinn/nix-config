{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.security.one-password;
in
{
  options.modules.${username}.security.one-password = {
    enable = mkEnableOption "_1password";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      _1password
    ];
  };
}
