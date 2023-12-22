{ pkgs, config, ... }:
{
  imports = [];

  users.users.scotte = {
    group = "scotte";
    hashedPasswordFile = config.sops.secrets.scotte-password.path;

    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.groups.scotte = {};

  sops.secrets.scotte-password = {
    sopsFile = ./nixvm.sops.yaml;
    neededForUsers = true;
  };
}
