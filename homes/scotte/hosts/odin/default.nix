{
  pkgs,
  config,
  ...
}: {
  home = {
    username = "scotte";
    homeDirectory = "/Users/scotte";
    sessionVariables = {
      SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
    };
  };

  modules = {
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
      mdbook.enable = true;
      postgres.enable = true;
      rust.enable = true;
    };

    editors = {
      neovim.enable = true;
      vscode.enable = true;
    };

    shell = {
      # starship.enable = true;
      wezterm = {
        enable = true;
        configPath = "${config.home.homeDirectory}/.local/nix-config/homes/scotte/config/shell/wezterm.lua";
      };
    };
  };

  programs.fish.shellAbbrs = {
    zstat = "ssh ragnar -- zstat";
  };

  home.packages = with pkgs; [
    tesla-auth
  ];
}
