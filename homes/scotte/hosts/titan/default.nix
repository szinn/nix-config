{
  pkgs,
  config,
  ...
}: {
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
    };

    shell = {
      starship.enable = true;
    };
  };
}
