{ config, ... }: {
  imports = [
    ./user.nix
  ];

  home-manager.users.${config.user} = { pkgs, ... }: {
    programs = {
      home-manager.enable = true;
    };
  };
}
