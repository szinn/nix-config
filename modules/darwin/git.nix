{ config, pkgs, lib, ... }: {
  config = {
    home-manager.users.${config.user} = {
      programs.git = {
        extraConfig = {
          credential = { helper = "osxkeychain"; };
        };
      };
    };
  };
}
