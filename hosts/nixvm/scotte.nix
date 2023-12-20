{ config, pkgs, home-manager, ... }:
{
  users.users.scotte = {
    name = "scotte";
    home = "/home/scotte";
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/users/scotte/ssh.pub) ];
    hashedPasswordFile = config.sops.secrets.scotte-password.path;

    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  sops.secrets.scotte-password = {
    sopsFile = ./secrets.sops.yaml;
    neededForUsers = true;
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';
}
