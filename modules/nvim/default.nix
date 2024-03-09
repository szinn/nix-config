{pkgs, ...}: {
  imports = [
    ./bufferlines/barbar.nix
    ./bufferlines/bufferline.nix

    ./colorschemes/tokyonight.nix

    ./completion/cmp.nix
    ./completion/lspkind.nix

    ./filetrees/neo-tree.nix

    ./git/gitsigns.nix

    ./snippets/friendly-snippets.nix
    ./snippets/luasnip.nix

    ./autocommands.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
  ];

  extraConfigLua = builtins.readFile ./lua/init.lua;

  extraPlugins = with pkgs.vimPlugins; [
    telescope-ui-select-nvim
    vim-sleuth
  ];
}
