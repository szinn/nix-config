{ config, pkgs, lib, ... }: {
  home-manager.users.${config.user} = {
    programs.fish = {
      functions = {
        flushdns = {
          description = "Flush DNS cache";
          body = builtins.readFile ./functions/flushdns.fish;
        };
      };
    };
  };
}
