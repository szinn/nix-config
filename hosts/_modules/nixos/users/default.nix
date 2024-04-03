{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.users;
in {
  options.modules.users = {
    groups = mkOption {
      type = types.attrs;
      default = {};
    };
    additionalUsers = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config.users = {
    inherit (cfg) groups;
    mutableUsers = false;
    users = cfg.additionalUsers;
  };
}
