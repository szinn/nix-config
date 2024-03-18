{pkgs, ...}: {
  imports = [
    ./bufferlines/barbar.nix
    ./bufferlines/bufferline.nix

    ./colorschemes/tokyonight.nix

    ./completion/cmp.nix
    ./completion/lspkind.nix

    ./filetrees/neo-tree.nix

    ./git/gitsigns.nix
    ./git/neogit.nix

    ./languages/nvim-lint.nix
    ./languages/tagbar.nix
    ./languages/treesitter/treesitter.nix
    ./languages/treesitter/treesitter-context.nix
    ./languages/treesitter/treesitter-refactor.nix
    ./languages/treesitter/ts-autotag.nix
    ./languages/treesitter/ts-context-commentstring.nix

    ./lsp/lsp-format.nix
    ./lsp/lsp.nix
    ./lsp/lspsaga.nix
    ./lsp/trouble.nix

    ./snippets/friendly-snippets.nix
    ./snippets/luasnip.nix

    ./statuslines/lualine.nix

    ./telescope/telescope.nix

    ./ui/dressing-nvim.nix
    ./ui/noice.nix
    ./ui/nui.nix

    ./utils/better-escape.nix
    ./utils/comment-nvim.nix
    ./utils/floaterm.nix
    ./utils/harpoon.nix
    ./utils/indent-blankline.nix
    ./utils/mini.nix
    ./utils/nvim-autopairs.nix
    ./utils/nvim-colorizer.nix
    ./utils/notify.nix
    ./utils/oil.nix
    ./utils/startify.nix
    ./utils/todo-comments.nix
    ./utils/vim-bbye.nix
    ./utils/which-key.nix

    ./autocommands.nix
    ./keymappings.nix
    ./options.nix
  ];

  extraPlugins = with pkgs.vimPlugins; [
    telescope-ui-select-nvim
    vim-sleuth
  ];
}
