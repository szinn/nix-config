{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.filesystems.zfs;
in {
  options.modules.filesystems.zfs = {
    enable = mkEnableOption "zfs";
    mountPoolsAtBoot = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    boot = {
      supportedFilesystems = ["zfs"];
      zfs = {
        forceImportRoot = false;
        extraPools = cfg.mountPoolsAtBoot;
      };
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}
