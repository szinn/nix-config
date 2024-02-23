args @ {
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = {
    enable = mkEnableOption "neovim";
  };

  imports = [
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
  ];

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;

      highlight.ExtraWhitespace.bg = "red";
      match.ExtraWhitespace = "\\s\\+$";
    };

    # Use Neovim as the editor for git commit messages
    programs.git.extraConfig.core.editor = "nvim";

    # Set Neovim as the default app for text editing and manual pages
    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
