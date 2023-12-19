{ pkgs, ...}:
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
}
