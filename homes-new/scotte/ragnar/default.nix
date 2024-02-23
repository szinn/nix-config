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
      vscode.server-enable = true;
    };

    devops = {
      enable = true;
    };
  };

  programs.fish.functions = {
    zstat = {
      description = "Statistics on atlas zpool";
      body = builtins.readFile ./functions/zstat.fish;
    };
  };
}
