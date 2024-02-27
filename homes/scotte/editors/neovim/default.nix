args @ {
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim;
  neovim-config = import ./config.nix;
in {
  options.modules.editors.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = mkMerge ([
      {
        enable = true;
        defaultEditor = true;
      }
    ] ++ neovim-config);

    # Use Neovim as the editor for git commit messages
    programs.git.extraConfig.core.editor = "nvim";

    # Set Neovim as the default app for text editing and manual pages
    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
