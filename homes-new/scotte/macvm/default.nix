{config, ...}: {
  home = {
    username = "scotte";
    homeDirectory = "/Users/scotte";
    sessionVariables = {
      SOPS_AGE_KEY_FILE = "${config.xdg.configHome}/sops/age/keys.txt";
    };
  };

  modules = {
    editors.vscode.enable = true;

    shell = {
      alacritty.enable = true;
      tmux.enable = true;
    };
  };
}
