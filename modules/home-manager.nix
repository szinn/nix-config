{ username }: { pkgs, lib, ... }:
{
  imports = [
    (import ./applications { username = username; })
    (import ./development { username = username; })
    (import ./devops { username = username; })
    (import ./editor { username = username; })
    (import ./security { username = username; })
    (import ./shell { username = username; })
  ];

  home-manager.users.${username} = {
    home.stateVersion = "23.11";

    programs = {
      home-manager.enable = true;
      git.enable = true;
    };

    xdg.enable = true;
  };
}
