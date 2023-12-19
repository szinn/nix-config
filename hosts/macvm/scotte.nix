{ config, pkgs, ... }:
{
  users.users.scotte = {
    name = "scotte";
    home = "/Users/scotte";
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/users/scotte/ssh.pub) ];
  };

  home-manager.users.scotte = import ../../home/users/scotte/${config.networking.hostName}.nix;

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    sudo chsh -s /run/current-system/sw/bin/fish scotte
  '';
}
