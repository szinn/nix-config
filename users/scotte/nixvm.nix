{ pkgs, ... }:
{
  imports = [];

  users.users.scotte = {    
    hashedPasswordFile = config.sops.secrets.scotte-password.path;

    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  sops.secrets.scotte-password = {
    sopsFile = ./nixvm.sops.yaml;
    neededForUsers = true;
  };
}
