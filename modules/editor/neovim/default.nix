{ username }: args@{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.modules.${username}.editor.neovim;
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.rust
    p.toml
    p.yaml
  ]));
in
{
  options.modules.${username}.editor.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        lua-language-server
      ];

      programs.neovim = {
        enable = true;
        coc.enable = false;

        plugins = [
          treesitterWithGrammars
        ];
      };

      home.file."./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };

      # Treesitter is configured as a locally developed module in lazy.nvim
      # we hardcode a symlink here so that we can refer to it in our lazy config
      home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
        recursive = true;
        source = treesitterWithGrammars;
      };
    };
  };
}
