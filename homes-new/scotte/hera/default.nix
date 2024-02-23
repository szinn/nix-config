{
  pkgs,
  config,
  ...
}: let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
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
  };
}
