{
  pkgs,
  lib,
  config,
  system,
  flake-packages,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.packages = [
      flake-packages.${system}.nvim
    ];

    # Use Neovim as the editor for git commit messages
    programs.git.extraConfig.core.editor = "nvim";

    # Set Neovim as the default app for text editing and manual pages
    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
