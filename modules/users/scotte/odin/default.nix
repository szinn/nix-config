{ pkgs, config, ... }:
{
  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    sudo chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules.scotte = {
    applications = {
      devonthink.enable = true;
      dosync.enable = true;
    };

    devops = {
      enable = true;
      colima = {
        enable = false;
        startService = false;
      };
    };

    development = {
      go.enable = true;
      postgres.enable = true;
      rust.enable = true;
    };

    editor = {
      vscode = {
        enable = true;
      };
    };

    shell = {
      wezterm = {
        enable = true;
        configPath = "${config.home-manager.users.scotte.home.homeDirectory}/.local/nix-config/modules/users/scotte/shell/wezterm.lua";
      };
    };
  };
}
