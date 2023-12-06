{ config, pkgs, lib, ... }: {
  imports = [
    ./fish
    ./fonts.nix
    ./git.nix
    ./system.nix
    ./user.nix
  ];

  home-manager.users.${config.user} = { pkgs, ... }: {
    programs = {
      home-manager.enable = true;
    };
    xdg.enable = true;
    # home.packages = with pkgs; [
    # ];
  };
}
