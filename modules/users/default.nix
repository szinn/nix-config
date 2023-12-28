{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.modules.users;
in
{
  imports = [
    ./scotte
  ];

  options.modules.users = {
    groups = mkOption {
      type = types.attrs;
      default = { };
    };
    additionalUsers = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = {
    users.groups = cfg.groups;
    users.users = cfg.additionalUsers;
  };
}
