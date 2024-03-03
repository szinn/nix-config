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

  wayland.windowManager.hyprland.enable = true;
  programs.waybar.enable = true;

  modules = {
    editors = {
      neovim.enable = true;
      vscode.server-enable = true;
    };
  };
}
