{ config, pkgs, ... }:
{
  imports = [
    {
      home = {
        username = "scotte";
        homeDirectory = "/home/scotte";
        sessionPath = [ "$HOME/.local/bin" ];
      };
    }
    ../../global
    ../../features
    ../../nixos
  ];

  features._1password.enable = true;
  features.fish.enable = true;
  features.git = {
    enable = true;
    username = "Scotte Zinn";
    email = "scotte@zinn.ca";
  };
  features.gnupg.enable = true;
  features.ssh.enable = true;

  features.sops = {
    enable = false;
    ageKeyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets.sops.yaml;
    secrets = {
      abcd.path = "${config.xdg.configHome}/abcdef";
    };
  };

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
  };
}
