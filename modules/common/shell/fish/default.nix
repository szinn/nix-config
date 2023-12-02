{ config, pkgs, lib, ... }: {
  home-manager.users.${config.user} = {
    programs.fish = {
      enable = true;

      shellAliases = {
        ls = "${pkgs.eza}/bin/eza --group";
      };

      functions = {
        fish_prompt = {
          description = "Set the fish prompt";
          body = builtins.readFile ./functions/fish_prompt.fish;
        };
        fish_right_prompt = {
          description = "Set the right prompt";
          body = builtins.readFile ./functions/fish_right_prompt.fish;
        };
        fish_title = {
          description = "Set the title";
          body = builtins.readFile ./functions/fish_title.fish;
        };
      };

      interactiveShellInit = ''
        # Ensure nix paths are at the head of the list
        fish_add_path '/nix/var/nix/profiles/default/bin'
        fish_add_path '/run/current-system/sw/bin'
        fish_add_path '/etc/profiles/per-user/${config.user}/bin'
        if test -d ${config.homePath}/.nix-profile/bin
          fish_add_path '${config.homePath}/.nix-profile/bin'
        end
      '';

    };

    home.sessionVariables.fish_greeting = "";
  };
}
