{username}: {
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.${username}.security.ssh;

  extraConfigDarwin =
    if pkgs.stdenv.isDarwin
    then ''
      UseKeychain yes
      AddKeysToAgent yes
    ''
    else "";
in {
  options.modules.${username}.security.ssh = {
    enable = mkEnableOption "ssh";
    matchBlocks = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.ssh = {
        enable = true;
        extraConfig = extraConfigDarwin;
        # addKeysToAgent = "yes";
        matchBlocks = cfg.matchBlocks;
      };

      # Macs need authorized_keys to be a real, non-symlinked file
      # home.file.".ssh/authorized_keys".source = ./authorized_keys;
    };
  };
}
