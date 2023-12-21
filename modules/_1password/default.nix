{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}._1password;
in
{
  options.modules.${username}._1password = {
    enable = mkEnableOption "_1password";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      _1password
    ];
  };
}
