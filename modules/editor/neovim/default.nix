{ username }: args@{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.modules.${username}.editor.neovim;
in
{
  options.modules.${username}.editor.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      imports = [
        ./autocommands.nix
        ./completion.nix
        ./keymappings.nix
        ./options.nix
        ./plugins
      ];

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
  };
}
