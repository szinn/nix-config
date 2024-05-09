{config, ...}: {
  imports = [
    ./hyprland
  ];

  home = {
    username = "scotte";
    homeDirectory = "/home/scotte";
    sessionVariables = {
      SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
    };
  };

  modules = {
    editors = {
      neovim.enable = true;
      # vscode.server-enable = true;
    };
    shell = {
      tmux.enable = true;
      alacritty.enable = true;

      shell = {
        starship.enable = true;
      };
    };
    devops.colima = {
      enable = false;
      startService = false;
    };
  };
}
