{ config, pkgs, home-manager, ... }:
{
  users.users.scotte = {
    name = "scotte";
    home = "/home/scotte";
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
    openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/users/scotte/ssh.pub) ];

    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';
}
