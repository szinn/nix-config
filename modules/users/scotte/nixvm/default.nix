{ pkgs, config, ... }:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

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
