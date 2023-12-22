{ pkgs, config, ... }:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [];

  users.users.scotte = {
    uid = 1000;
    group = "scotte";
    hashedPasswordFile = config.sops.secrets.scotte-password.path;

    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ ifGroupsExist [
      "network"
      "samba-users"
    ];
  };

  users.groups.scotte = {
    gid = 1000;
  };

  sops.secrets.scotte-password = {
    sopsFile = ./secrets.sops.yaml;
    neededForUsers = true;
  };
}
