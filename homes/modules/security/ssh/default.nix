{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.ssh;

  extraConfigDarwin =
    if pkgs.stdenv.isDarwin
    then ''
      UseKeychain yes
      AddKeysToAgent yes
    ''
    else "";
in {
  options.modules.security.ssh = {
    enable = mkEnableOption "ssh";
    matchBlocks = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = extraConfigDarwin;
      addKeysToAgent = "yes";
      matchBlocks = cfg.matchBlocks;
    };
  };
}
