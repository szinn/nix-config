{ pkgs, config, ... }: {
  users.users.scotte = {
    name = "scotte";
    home = "/Users/scotte";
    shell = pkgs.fish;
  };

  home-manager.users.scotte = import ../../../../home/scotte/${config.networking.hostName}.nix;
}
