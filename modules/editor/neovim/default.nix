{ username }: args@{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.modules.${username}.editor.neovim;
  neovim = import ./package {
    inherit pkgs;
  };
in
{
  options.modules.${username}.editor.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [
        neovim
      ];

      # Use Neovim as the editor for git commit messages
      programs.git.extraConfig.core.editor = "nvim";
      programs.jujutsu.settings.ui.editor = "nvim";

      # Set Neovim as the default app for text editing and manual pages
      home.sessionVariables = {
        EDITOR = "nvim";
        MANPAGER = "nvim +Man!";
      };
    };
  };
}
