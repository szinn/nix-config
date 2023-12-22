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
  ];
}
