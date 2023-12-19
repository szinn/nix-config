{ config, pkgs, home-manager, ... }:
{
  users.users.scotte = {
    isNormalUser = true;
    name = "scotte";
    home = "/home/scotte";
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/users/scotte/ssh.pub) ];
  };

  home-manager.users.scotte = import ../../home/users/scotte/${config.networking.hostName}.nix;

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';
}
